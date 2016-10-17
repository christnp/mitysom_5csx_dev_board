/**
 * \file data_pattern_gen.cpp
 *
 * \brief Class implementation of data pattern generator controller
 *
 * \copyright Critical Link LLC 2013-2014
 *
 */
#include "libfpga/data_pattern_gen.h"
#include "libfpga/data_pattern_gen_regs.h"

/**
 *  Constructor.
 *
 *  \param[in] PHysBaseAddr physical address of core base
 */
tcDataPatternGen::tcDataPatternGen(unsigned int PhysBaseAddr)
: tcCSRMap(PhysBaseAddr)
{
	Enable(false);
}

/**
 *  Destructor.
 */
tcDataPatternGen::~tcDataPatternGen(void)
{
}

/**
 *  Enable/Disablet the data pattern generator.
 *
 * \param[in] Enable set to true to enable generation.
 *
 * \return 0
 */
int tcDataPatternGen::Enable(bool Enable)
{
	if (Enable)
		WriteCtrlReg(OFFSET_ENABLE, REG_ENABLE_ENABLE);
	else
		WriteCtrlReg(OFFSET_ENABLE, 0);
	return 0;
}

/**
 *  Inject an error into the data pattern.  Should be called 
 *  which pattern generator is enabled.
 *
 *  \return 0
 */
int tcDataPatternGen::InjectError(void)
{
	WriteCtrlReg(OFFSET_INJECT_ERR, REG_INJECT_ERR);
	return 0;
}

/**
 *  Set Pattern to generate.
 *
 *  \param Pattern the data pattern type to generate.
 *
 *  \return 0
 */
int tcDataPatternGen::SetPattern(tePattern Pattern)
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

