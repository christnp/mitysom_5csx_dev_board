/*
 * BCONInput.h
 *
 *  Created on: Jan 18, 2017
 *      Author: mikew
 */

#ifndef BCONINPUT_H_
#define BCONINPUT_H_

#include <list>

#include <stdint.h>
#include "FPGARegister.h"
//#include "TriggerGenerator.h"
#include <pll_reconfig.h>

struct AoiConfiguration {
	uint32_t m_left;
	uint32_t m_top;
	uint32_t m_width;
	uint32_t m_height;
};

class tcBCONInput {
public:
	tcBCONInput(int32_t anAddress, uint32_t anTrigClockHz, tcPllReconfig *apPllReconfig, const char *apFilename = "pll_reconfig_table.txt");
	virtual ~tcBCONInput();

	typedef struct {
		unsigned int CCounter[3];
		unsigned int phaseShift[3];
		unsigned int mcount, ncount;
		unsigned int vcodiv, loop_resistance, charge_pump;
	} tsPllReconfigTableEntry;

	/**
	 * Returns true if the object is initialized and ready to go.
	 * @return true if initialized; false otherwise
	 */
	bool initialized();

	/**
	 * Reset bit of the CSR
	 * @param abSet - true to reset the core; false to take out of reset.
	 */
	void reset(bool abSet);

	/**
	 * PLL reset bit of the CSR
	 * @param abSet - true to reset the PLL; false to take out of reset.
	 */
	void resetPLL(bool abSet);

	/**
	 * Enable bit of the CSR.
	 * @param abSet - true to enable the core to capture; false to disable the core.
	 */
	void enable(bool abSet);

	/**
	 * When enabled, the frame grabber is "live"
	 * @return true if the frame grabber is capturing frame data.
	 */
	bool isEnabled();

	/**
	 * Set the input frequency of the camera link connection. This is the speed of the serializer
	 * link.
	 *
	 * This will configure the PLL to expect that frequency.
	 *
	 * This must be at least 5MHz (limitation of Altera PLL).
	 * This must not exceed 85MHz (Camera Link specification).
	 *
	 * @param inputFreqMHz - the input frequency of the serializer in MHz.
	 */
	bool setInputClockSpeed(double anInputFreqMHz);

	/**
	 * The state of the recovered CLK (locked = true)
	 * @return true if the clock is locked; false otherwise.
	 */
	bool inputClockLocked();

	/**
	 * The state of the bitslip logic.
	 * @return true if the lanes are locked; false otherwise.
	 */
	bool inputLanesLocked();

	/**
	 * Set the AOI configuration of the camera link input. The incoming frame
	 * should be as large or larger than this configured size.
	 * @param asConfig - the configuration to set.
	 */
	void setAoiConfiguration(AoiConfiguration asConfig);

	/**
	 * Clears the sticky which, when high, says the lanes fell out of lock.
	 */
	void clearNotLockedSticky();

	/**
	 * True if the bit slip logic has ever fallen low.
	 * @return true if the lanes unlocked.; false otherwise.
	 */
	bool inputLanesUnlockedSticky();

	/**
	 * True if the FIFO full bit has been detected going high.
	 * @return true if the fifo has overflown; false otherwise.
	 */
	bool fifoOverflowSticky();

	/**
	 * Clears the sticky which indicates the FIFO has overflown.
	 */
	void clearFifoOverflowSticky();

	typedef enum {
		ee24rgb = 7,
		ee16xYCrCb422 = 6,
		ee12x2_packed = 5,
		ee12x2 = 4,
		ee12x1_packed = 3,
		ee12x1 = 2,
		ee8x2 = 1,
		ee8x1 = 0
	} teBCONPixelMode;

	/**
	 * Set the input mode to expect.
	 * @param aeMode - the mode the data will be coming in as.
	 */
	void setPixelMode(teBCONPixelMode aeMode);

	/**
	 * Returns the trigger generator in this core.
	 * @return the trigger generator in this core.
	 */
//	tcTriggerGenerator *getTriggerGenerator();

private:
	/**
	 * Returns the number of pixels per clock being input. This normalizes the start/size registers.
	 */
	int getPixPerClock();

	/**
	 * Based on the input frequency, select the entry in the reconfig table.
	 */
	tsPllReconfigTableEntry getPllReconfigEntry(double anInputFreqMHz);

	AoiConfiguration msAoi;

	teBCONPixelMode meMode;

	tcFPGARegister<uint32_t> mcRegisters;

	// tcTriggerGenerator mcTrigger;

	tcPllReconfig *mpPllReconfig;

	std::list<double> mcSpeeds;
	std::list<tsPllReconfigTableEntry> mcReconfigEntries;
};

#endif /* BCONINPUT_H_ */
