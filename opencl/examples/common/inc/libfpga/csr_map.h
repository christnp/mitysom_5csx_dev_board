/**
 * \file csr_map.h 
 *
 * \description Generic class for CSR memory mapping.
 *
 * \copyright Critical Link LLC 2013-2014
 */
#ifndef CSR_MAP_H
#define CSR_MAP_H

#include <stdint.h>

/**
 *  This class provides a generic abstraction for memory mapped
 *  registers.
 */
class tcCSRMap 
{
public:
	tcCSRMap(unsigned int PhysBaseAddr, unsigned int SizeBytes = 0);
	virtual ~tcCSRMap(void);

	/**
	 *  Read a control register at a 32-bit offset location.
	 *  \param offset offset in 32-bit words
	 *  \return value of register.
	 */
	unsigned int ReadCtrlReg(int offset)
	{
		volatile unsigned int* preg = (volatile unsigned int*)((unsigned int)mpRegMapMM);
		return preg[offset];
	}

	/**
	 *  Write a control register at a 32-bit offset location.
	 *  \param offset offset in 32-bit words
	 *  \return value of register.
	 */
	void WriteCtrlReg(int offset, unsigned int value)
	{
		volatile unsigned int* preg = (volatile unsigned int*)((unsigned int)mpRegMapMM);
		preg[offset] = value;
	}

	void	*mpRegMapMM;  //!< memory mapped pointer to registers
	unsigned int mnMappedSize;
};

#endif
