/*
 * BCONInput.cpp
 *
 *  Created on: Jan 18, 2017
 *      Author: mikew
 */

#include "BCONInput.h"

#include <fstream>
#include <string>
#include <cstdlib>
#include <iostream>
using namespace std;

#define CSR_OFFSET			(1)
#define FRAME_SIZE_OFFSET	(2)
#define ROI_START_OFFSET	(3)

#define SIZE_BITMASK		(0xFFF)

#define RESET_BIT			(1 << 0)
#define RESET_PLL_BIT		(1 << 1)
#define PLL_LOCKED_BIT		(1 << 2)
#define LANES_LOCKED_BIT			(1 << 4)
#define LANES_UNLOCKED_STICKY_BIT	(1 << 5)	//Write 1 to clear.
#define FIFO_OVERFLOW_STICKY_BIT	(1 << 6)	//Write 1 to clear.

#define BCON_MODE_SHIFT	(8)
#define BCON_MODE_MASK	(0xF << BCON_MODE_SHIFT)

tcBCONInput::tcBCONInput(int32_t anAddress, uint32_t anTrigClockHz, tcPllReconfig *apPllReconfig, const char *apFilename)
:mcRegisters(anAddress, 0x20)
//,mcTrigger(mcRegisters, anTrigClockHz)
,mpPllReconfig(apPllReconfig)
{
	setPixelMode(ee8x1);

	tcBCONInput::tsPllReconfigTableEntry entry;
	string burn;
    double speed;
    int nextChar;
    ifstream file(apFilename);

    while (file.good()) {
        nextChar = file.peek();
        if (file.good() && nextChar != '#') {
            // Try to extract the temperature and voltage
            file >> burn;
            speed = atof(burn.c_str());
            cout << "Entry: " << speed << std::hex;

    		//CCounter, phaseShift, mcount, ncount, vcodiv, loop_res, charge_pump
            for(int i = 0; i < 3; i++) {
            	file >> burn;
            	entry.CCounter[i] = strtol(burn.c_str(),NULL,0);
            	cout << " " << entry.CCounter[i];
            }
            for(int i = 0; i < 3; i++) {
            	file >> burn;
            	entry.phaseShift[i] = strtol(burn.c_str(),NULL,0);
            	cout << " " << entry.phaseShift[i];
            }
        	file >> burn; entry.mcount = strtol(burn.c_str(),NULL,0); cout << " " << entry.mcount;
        	file >> burn; entry.ncount = strtol(burn.c_str(),NULL,0); cout << " " << entry.ncount;
        	file >> burn; entry.vcodiv = strtol(burn.c_str(),NULL,0); cout << " " << entry.vcodiv;
        	file >> burn; entry.loop_resistance = strtol(burn.c_str(),NULL,0); cout << " " << entry.loop_resistance;
        	file >> burn; entry.charge_pump = strtol(burn.c_str(),NULL,0); cout << " " << entry.charge_pump << endl;

        	cout << std::dec;

            if(file.good() || (!file.good() && file.eof())) {
                //If all is good, put them in the lists.
                mcSpeeds.push_back(speed);
                mcReconfigEntries.push_back(entry);
            } else if(!file.eof()) {
                //If something went wrong but we have more lines to scan, just ignore the issue.
                file.clear();
            }
        } else {
            //If the line is a comment, burn the line; we dont care about its contents.
            getline(file, burn);
        }
    }
}

tcBCONInput::~tcBCONInput()
{
	if(mpPllReconfig) {
		delete mpPllReconfig;
		mpPllReconfig = NULL;
	}
}

bool tcBCONInput::initialized()
{
	return mcRegisters.initialized();
}

void tcBCONInput::reset(bool abSet)
{
	if (abSet) {
		mcRegisters[CSR_OFFSET] |= RESET_BIT;
	} else {
		mcRegisters[CSR_OFFSET] &= ~RESET_BIT;
	}
}


void tcBCONInput::resetPLL(bool abSet)
{
	if (abSet) {
		mcRegisters[CSR_OFFSET] |= RESET_PLL_BIT;
	} else {
		mcRegisters[CSR_OFFSET] &= ~RESET_PLL_BIT;
	}
}

void tcBCONInput::enable(bool abSet)
{
	if (abSet) {
		mcRegisters[CSR_OFFSET] |= 0x80000000;
	} else {
		mcRegisters[CSR_OFFSET] &= ~0x80000000;
	}
}

bool tcBCONInput::inputClockLocked()
{
	return (mcRegisters[CSR_OFFSET] & PLL_LOCKED_BIT) == PLL_LOCKED_BIT;
}

bool tcBCONInput::inputLanesLocked()
{
	return (mcRegisters[CSR_OFFSET] & LANES_LOCKED_BIT) == LANES_LOCKED_BIT;
}

bool tcBCONInput::inputLanesUnlockedSticky()
{
	return (mcRegisters[CSR_OFFSET] & LANES_UNLOCKED_STICKY_BIT) == LANES_UNLOCKED_STICKY_BIT;
}

bool tcBCONInput::isEnabled()
{
	// If we are not in reset, we are enabled.
	return (mcRegisters[CSR_OFFSET] & RESET_BIT) != (uint32_t)RESET_BIT;
}

void tcBCONInput::setAoiConfiguration(AoiConfiguration asConfig)
{
	uint32_t size = 0, start = 0;

	size = ((asConfig.m_height & SIZE_BITMASK) << 16) | ((asConfig.m_width) & SIZE_BITMASK);
	start = ((asConfig.m_top & SIZE_BITMASK) << 16) | ((asConfig.m_left) & SIZE_BITMASK);

	mcRegisters[FRAME_SIZE_OFFSET] = size;
	mcRegisters[ROI_START_OFFSET] = start;

	msAoi = asConfig;
}

void tcBCONInput::setPixelMode(teBCONPixelMode aeMode)
{
	uint32_t reg = mcRegisters[CSR_OFFSET];
	reg &= ~BCON_MODE_MASK;
	reg |= aeMode << BCON_MODE_SHIFT;
	mcRegisters[CSR_OFFSET] = reg;

	meMode = aeMode;

	setAoiConfiguration(msAoi);
}

tcBCONInput::tsPllReconfigTableEntry pll_table[3] = {
		//CCounter                           , phaseShift    , mcount    , ncount    , vcodiv    , loop_res  , charge_pump
		{{0x00010000, 0x00040106, 0x000a0403}, {8, 80, 104}  , 0x00020403, 0x00010000, 0x00000001, 0x00000007, 0x00000002}, // 45MHz-85MHz (Fvco = 630-1190)
		{{0x00000101, 0x0004020C, 0x00080707}, {16, 160, 208}, 0x00000707, 0x00010000, 0x00000001, 0x00000007, 0x00000002}, // 30MHz-45MHz (Fvco = 840-1260)
		{{0x00000000, 0x00000000, 0x00000000}, {0, 0, 0}     , 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000}  // TODO: 20-30MHz (Fvco = 840-1260)
};

tcBCONInput::tsPllReconfigTableEntry tcBCONInput::getPllReconfigEntry(
		double anInputFreqMHz)
{
	// List must be in descending order.
	list<tsPllReconfigTableEntry>::iterator entry = mcReconfigEntries.begin();
	tsPllReconfigTableEntry e = *entry;
	for(list<double>::iterator it = mcSpeeds.begin(); it != mcSpeeds.end(); it++, entry++) {
		cout << "Comparing " << anInputFreqMHz << " >= " << *it << " (result: " << (anInputFreqMHz >= *it) << ")" << endl;
		if (anInputFreqMHz >= *it) {
			cout << "Found entry using speed: " << (*it) << endl;
			e = *entry;
			break;
		}
	}

	return e;
}

bool tcBCONInput::setInputClockSpeed(double anInputFreqMHz)
{
	bool ret = false;

	if (true) {
		tsPllReconfigTableEntry e = getPllReconfigEntry(anInputFreqMHz);

		ret = mpPllReconfig->reconfigure(e.ncount, e.mcount, e.CCounter, e.vcodiv, e.loop_resistance, e.charge_pump);
		for (int i = 0; i < 3; i++) {
			mpPllReconfig->addPhase(i, e.phaseShift[i], true);
		}
	}

	return ret;
}

void tcBCONInput::clearNotLockedSticky()
{
	mcRegisters[CSR_OFFSET] |= LANES_UNLOCKED_STICKY_BIT;
}

bool tcBCONInput::fifoOverflowSticky()
{
	return (mcRegisters[CSR_OFFSET] & FIFO_OVERFLOW_STICKY_BIT) == FIFO_OVERFLOW_STICKY_BIT;
}

void tcBCONInput::clearFifoOverflowSticky()
{
	mcRegisters[CSR_OFFSET] |= FIFO_OVERFLOW_STICKY_BIT;
}

//tcTriggerGenerator* tcBCONInput::getTriggerGenerator()
//{
//	return &mcTrigger;
//}

int tcBCONInput::getPixPerClock()
{
	int rv = 1;

	switch(meMode) {
	default:
	case ee24rgb:
	case ee12x1_packed:
	case ee12x1:
	case ee8x1:
		rv = 1;
		break;
	case ee16xYCrCb422:
	case ee12x2_packed:
	case ee12x2:
	case ee8x2:
		rv = 2;
		break;
	}


	return rv;
}
