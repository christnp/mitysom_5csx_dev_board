/**
 * \file data_pattern_check.h
 *
 * \brief Class definition for Altera Data Pattern Check FPGA core controller
 *
 * \copyright Critical Link LLC 2013-2014
 */
#ifndef DATA_PATTERN_CHECK_H
#define DATA_PATTERN_CHECK_H

#include "csr_map.h"

/**
 * This class manages an Altera FPGA based Data Pattern checker core.
 */
class tcDataPatternCheck : protected tcCSRMap
{
public:
	tcDataPatternCheck(unsigned int BaseAddrPhys);
	~tcDataPatternCheck(void);

	typedef enum {
		eePRBS7,
		eePRBS15,
		eePRBS23,
		eePRBS31,
		eeHF,
		eeLF
	} tePattern;

	typedef struct stats {
		uint64_t bits_transferred;
		uint64_t num_errors;
	} tsStats;

	int Enable(bool Enable);
	int SetPattern(tePattern Pattern);
	int GetStats(tsStats &stats, bool clear);

protected:

};

#endif

