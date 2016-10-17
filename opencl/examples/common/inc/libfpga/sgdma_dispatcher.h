/**
 * \file sgdma_dispatcher.h
 *
 * \brief Class definition for user space driver for Altera SGDMA cores.
 *
 * \copyright Critical Link LLC 2013-2014
 *
 */
#ifndef SGDMA_DISPATCHER_H
#define SGDMA_DISPATCHER_H
#include "stdio.h"
#include "sgdma_dispatcher_regs.h"
#include <list>

/**
 *  The tcSDGMADispatcher class wraps a user space control class around the 
 *  Scatter Gather DMA master Avalon core.  This is the external SGDMA core
 *  found on the Altera wiki site, not the SGDMA core provide by default in 
 *  Qsys from the legacy NIOS and Quartus 8.0.
 */
class tcSGDMADispatcher
{
public:
	tcSGDMADispatcher(unsigned int CtrlRegsAddr, unsigned int DescRegsAddr,
		          unsigned int RespRegsAddr, bool EnhancedMode);
	~tcSGDMADispatcher(void);

	/** Perform a MM->ST transfer */
	int TransferFromRAM(unsigned int SrcAddr, unsigned int Length, bool park=false); 

	/** Perform a ST->MM transfer */
	int TransferToRAM(unsigned int DestAddr, unsigned int Length, bool park=false); 

	/** Perform a MM->MM transfer */
	int DualTransfer(unsigned int SrcAddr, unsigned int DestAddr, unsigned int Length);

	int NextReadBuffer(unsigned int *pAddr = NULL);
	int NumTransfersQueued(void);

	int Reset(void);
	int EnablePackets(bool enable) { mbGenPackets = enable; return 0; }

	/* not needed unless StopDesc() is explicitly called */
	void StartDesc(void);
	void StopDesc(bool Wait=true);

protected:
	int WriteDescriptor(tsSGDMADescriptor& descriptor);

	tuSgdmaStatus GetStatusReg();
	int SetControlReg(const tuSgdmaCtrl& control);

	/* THESE OFFSETS ARE BYTEWISE FROM THE sgdma_dispatcher_regs.h */
	unsigned int	ReadCtrlReg(int offset)
	{
		volatile unsigned int* preg = (volatile unsigned int*)((unsigned int)mpRegMapMM+offset);
		return *preg;
	}

	/* THESE OFFSETS ARE BYTEWISE FROM THE sgdma_dispatcher_regs.h */
	void WriteCtrlReg(int offset, unsigned int value)
	{
		volatile unsigned int* preg = (volatile unsigned int*)((unsigned int)mpRegMapMM+offset);
		*preg = value;
	}

	void	WriteDescriptorReg(int offset, unsigned int data)
	{
		volatile unsigned int* preg = (volatile unsigned int*)((unsigned int)mpDescriptors+offset);
		*preg = data;
	}

	unsigned int	ReadRespReg(int offset)
	{
		volatile unsigned int* preg = (volatile unsigned int*)((unsigned int)mpRespRegs+offset);
		return *preg;
	}

	typedef struct desc {
		unsigned int addr;
		unsigned int length;
		bool parked;
	} tsDesc;

	bool		mbEnhanced; //!< when true, use enhanced descriptors
	void		*mpRegMapMM;  //!< memory mapped pointer to registers
	void		*mpDescriptors;  //!< memory mapped pointer to descriptors area
	void		*mpRespRegs; //!< memory mapped pointer to response registers
	bool		mbGenPackets; //!< when true, will request SOP/EOPs by default

	std::list<tsDesc> mhWriteList;

};

#endif
