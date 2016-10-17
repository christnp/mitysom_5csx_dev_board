/**
 * \file data_pattern_gen.h
 *
 * \brief Class Definition for Altera Data Pattern Generator core controller
 *
 * \copyright Critical Link LLC 2013-2014
 */
#ifndef DATA_PATTERN_GEN_H
#define DATA_PATTERN_GEN_H

#include "csr_map.h"

/**
 * This class provides a user space controller for Altera's Data Pattern
 * Generator Core.
 */
class tcDataPatternGen : protected tcCSRMap
{
public:
	tcDataPatternGen(unsigned int BaseAddrPhys);
	~tcDataPatternGen(void);

	typedef enum {
		eePRBS7,
		eePRBS15,
		eePRBS23,
		eePRBS31,
		eeHF,
		eeLF
	} tePattern;

	int Enable(bool Enable);
	int InjectError(void);
	int SetPattern(tePattern Pattern);

protected:

};

#endif

