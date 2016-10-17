/**
 * \file data_pattern_check.cpp
 *
 * \brief Utility class managing Altera's Data Pattern checker.
 *
 * \copyright Critical Link LLC 2013-2014
 *
 */
#include "libfpga/data_pattern_check.h"
#include "libfpga/data_pattern_check_regs.h"

#include <stdio.h>

/**
 *  Constructor.
 *
 *  \param[in] PhysBaseAddr physical address of core base in FPGA
 */
tcDataPatternCheck::tcDataPatternCheck(unsigned int PhysBaseAddr)
: tcCSRMap(PhysBaseAddr)
{
	Enable(false);
}

/**
 *  Destructor.
 */
tcDataPatternCheck::~tcDataPatternCheck(void)
{
}

/**
 *  Enable/Disable the Pattern Checker
 *
 *  \param[in] Enable when true will enable the core.
 *
 *  \return 0
 */
int tcDataPatternCheck::Enable(bool Enable)
{
	if (Enable)
		WriteCtrlReg(OFFSET_ENABLE, REG_ENABLE_ENABLE);
	else
		WriteCtrlReg(OFFSET_ENABLE, 0);
	return 0;
}

/**
 * Set data Pattern to check
 *
 * \param[in] Pattern the pattern type to check
 * 
 * \return 0
 */
int tcDataPatternCheck::SetPattern(tePattern Pattern)
{
	int val = 0;
	switch(Pattern)
	{
	case eePRBS7:
		val = REG_PATTERN_SEL_PRBS7;
		break;
	case eePRBS15:
		val = REG_PATTERN_SEL_PRBS15;
		break;
	case eePRBS23:
		val = REG_PATTERN_SEL_PRBS23;
		break;
	case eePRBS31:
		val = REG_PATTERN_SEL_PRBS31;
		break;
	case eeHF:
		val = REG_PATTERN_SEL_HF;
		break;
	case eeLF:
	default:
		val = REG_PATTERN_SEL_LF;
		break;
	}
	WriteCtrlReg(OFFSET_PATTERN_SEL, val);
	return 0;
}

/**
 * Get Pattern check stats
 *
 * \param[out] stats the statistics to fill in
 *
 * \param[in] clear when true will reset the stats
 * 
 * \return 0 on success
 */
int tcDataPatternCheck::GetStats(tsStats &stats, bool clear)
{
	int temp;

	if (clear)
		temp = REG_COUNTER_CTRL_CLEAR;
	else
		temp = REG_COUNTER_CTRL_SNAP;

	WriteCtrlReg(OFFSET_COUNTER_CTRL, temp);

	temp = ReadCtrlReg(OFFSET_COUNTER_CTRL);

	if (temp & REG_COUNTER_CTRL_VALID)
	{
		stats.bits_transferred = ReadCtrlReg(OFFSET_NUM_BITS_HIGH);
		stats.bits_transferred <<= 32;
		stats.bits_transferred |= ReadCtrlReg(OFFSET_NUM_BITS_LOW);

		stats.num_errors = ReadCtrlReg(OFFSET_NUM_ERROR_HIGH);
		stats.num_errors <<= 32;
		stats.num_errors |= ReadCtrlReg(OFFSET_NUM_ERROR_LOW);
		return 0;
	}
	else
	{
		return -1;
	}

}

