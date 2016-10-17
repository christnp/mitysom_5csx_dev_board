/**
 * \file sgdma_dispatcher.h
 *
 * \brief User space driver class definition for Altera SGDMA core.
 *
 * \copyright Critical Link LLC 2013-2014
 */
#include "libfpga/sgdma_dispatcher.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdint.h>

/**  Constructor
 *
 *   \param CtrlRegsAddr physical address of control register slave port
 *   \param DescRegsAddr physical address of descriptor slave port
 *   \param RespRegsAddr physical address of ST->MM Response slave port (set to zero if not used)
 *   \param EnhanceMode set to true to use enhanced descriptors.
 */
tcSGDMADispatcher::tcSGDMADispatcher(unsigned int CtrlRegsAddr,
				     unsigned int DescRegsAddr,
				     unsigned int RespRegsAddr,
				     bool EnhancedMode)
: mbEnhanced(EnhancedMode)
, mpRegMapMM(NULL)
, mpDescriptors(NULL)
, mpRespRegs(NULL)
, mbGenPackets(true)
{
	int fd;
	/* map in the register maps for control and descriptors */
	/* map in the buffer area */
	/* map in the optional response descriptors area */
	if ((fd = open("/dev/mem", O_RDWR)) < 0)
	{
		perror("/dev/mem");
	}
	else
	{
		void *lpmem = mmap(0, 4096, PROT_READ | PROT_WRITE, MAP_SHARED, fd, CtrlRegsAddr);
		if (lpmem == MAP_FAILED)
		{
			perror("mmap control");
			close(fd);
			return;
		}
		mpRegMapMM = lpmem;

		if(DescRegsAddr)
		{
			lpmem = mmap(0, 4096, PROT_READ | PROT_WRITE, MAP_SHARED, fd, DescRegsAddr);
			if (lpmem == MAP_FAILED)
			{
				perror("mmap desc");
				close(fd);
				return;
			}
			mpDescriptors = lpmem;
		}

		if (RespRegsAddr)
		{
			lpmem = mmap(0, 4096, PROT_READ | PROT_WRITE, MAP_SHARED, fd, RespRegsAddr);
			if (lpmem == MAP_FAILED)
			{
				perror("resp desc");
				close(fd);
				return;
			}
			mpRespRegs = lpmem;
		}
		close(fd);
	}

	Reset();

}

/**
 *   Destructor.
 */
tcSGDMADispatcher::~tcSGDMADispatcher(void)
{
	if (mpRegMapMM)
		munmap(mpRegMapMM, 4096);
	if (mpDescriptors)
		munmap(mpDescriptors, 4096);
	if (mpRespRegs)
		munmap(mpRespRegs, 4096);
}

/**
 *  Queue / Initiate a MM->ST transfer cycle.
 *
 *  \param SrcAddr physical RAM address for transfer start
 *  \param Length  number of bytes to transfer
 *
 *  \return zero on success (transfer was queued)
 */
int tcSGDMADispatcher::TransferFromRAM(unsigned int SrcAddr,
				       unsigned int Length,
				       bool park)
{
	unsigned int ctrl;

	/* configure the descriptor and send it */
	WriteDescriptorReg(DESCRIPTOR_READ_ADDRESS_REG, SrcAddr);
	WriteDescriptorReg(DESCRIPTOR_WRITE_ADDRESS_REG, 0);
	WriteDescriptorReg(DESCRIPTOR_LENGTH_REG, Length);

	ctrl = 0;
	if (mbGenPackets)
	{
		ctrl |= DESCRIPTOR_CONTROL_GENERATE_SOP_MASK;
		ctrl |= DESCRIPTOR_CONTROL_GENERATE_EOP_MASK;
	}
	if (park)
	{
		ctrl |= DESCRIPTOR_CONTROL_PARK_READS_MASK;
	}
	ctrl |= DESCRIPTOR_CONTROL_GO_MASK;

	/* build control word */
	if (!mbEnhanced)
	{
		WriteDescriptorReg(DESCRIPTOR_CONTROL_STANDARD_REG, ctrl);
	}
	else
	{
		WriteDescriptorReg(DESCRIPTOR_SEQUENCE_NUMBER_REG, 0);
		WriteDescriptorReg(DESCRIPTOR_READ_STRIDE_REG, (1<<16) | (1));
		WriteDescriptorReg(DESCRIPTOR_READ_ADDRESS_HIGH_REG, 0);
		WriteDescriptorReg(DESCRIPTOR_WRITE_ADDRESS_HIGH_REG, 0);
		WriteDescriptorReg(DESCRIPTOR_CONTROL_ENHANCED_REG, ctrl);
	}

	return 0;
}

/** 
 *   Queue / Initiate a ST->MM transfer (transfer to RAM).
 *
 *   \param DestAddr physical address in RAM to start transfer
 *   \param Length number of bytes to transfer.  If SOP/EOP is used
 *          the maximum transfer size should be used.
 *
 *   \return zero on success (request was successfully queued)
 */
int tcSGDMADispatcher::TransferToRAM(unsigned int DestAddr,
				     unsigned int Length,
				     bool park)
{
	unsigned int ctrl;

	/* configure the descriptor and send it */
	WriteDescriptorReg(DESCRIPTOR_READ_ADDRESS_REG, 0);
	WriteDescriptorReg(DESCRIPTOR_WRITE_ADDRESS_REG, DestAddr);
	WriteDescriptorReg(DESCRIPTOR_LENGTH_REG, Length);

	ctrl = 0;
	if (mbGenPackets)
	{
		ctrl |= DESCRIPTOR_CONTROL_END_ON_EOP_MASK;
	}
	if (park)
	{
		ctrl |= DESCRIPTOR_CONTROL_PARK_WRITES_MASK;
	}
	ctrl |= DESCRIPTOR_CONTROL_GO_MASK;

	/* build control word */
	if (!mbEnhanced)
	{
		WriteDescriptorReg(DESCRIPTOR_CONTROL_STANDARD_REG, ctrl);
	}
	else
	{
		WriteDescriptorReg(DESCRIPTOR_SEQUENCE_NUMBER_REG, 0);
		WriteDescriptorReg(DESCRIPTOR_READ_STRIDE_REG, (1<<16) | (1));
		WriteDescriptorReg(DESCRIPTOR_READ_ADDRESS_HIGH_REG, 0);
		WriteDescriptorReg(DESCRIPTOR_WRITE_ADDRESS_HIGH_REG, 0);
		WriteDescriptorReg(DESCRIPTOR_CONTROL_ENHANCED_REG, ctrl);
	}
	tsDesc desc;
	desc.addr = DestAddr;
	desc.length = Length;
	desc.parked = park;
	mhWriteList.push_back(desc);

	return 0;
}

/** 
 *   Queue / Initiate a MM->MM transfer (transfer from RAM, to RAM).
 *
 *   \param SrcAddr physical address in RAM to start transfer
 *   \param DestAddr physical address in RAM to start transfer
 *   \param Length number of bytes to transfer.  If SOP/EOP is used
 *          the maximum transfer size should be used.
 *
 *   \return zero on success (request was successfully queued)
 */
int tcSGDMADispatcher::DualTransfer(unsigned int SrcAddr, unsigned int DestAddr,
				    unsigned int Length)
{
	unsigned int ctrl;

	/* configure the descriptor and send it */
	WriteDescriptorReg(DESCRIPTOR_READ_ADDRESS_REG, SrcAddr);
	WriteDescriptorReg(DESCRIPTOR_WRITE_ADDRESS_REG, DestAddr);
	WriteDescriptorReg(DESCRIPTOR_LENGTH_REG, Length);

	ctrl = 0;
	if (mbGenPackets)
	{
		ctrl |= DESCRIPTOR_CONTROL_GENERATE_SOP_MASK;
		ctrl |= DESCRIPTOR_CONTROL_GENERATE_EOP_MASK;
		ctrl |= DESCRIPTOR_CONTROL_END_ON_EOP_MASK;
	}
	ctrl |= DESCRIPTOR_CONTROL_GO_MASK;

	/* build control word */
	if (!mbEnhanced)
	{
		WriteDescriptorReg(DESCRIPTOR_CONTROL_STANDARD_REG, ctrl);
	}
	else
	{
		WriteDescriptorReg(DESCRIPTOR_SEQUENCE_NUMBER_REG, 0);
		WriteDescriptorReg(DESCRIPTOR_READ_STRIDE_REG, (1<<16) | (1));
		WriteDescriptorReg(DESCRIPTOR_SEQUENCE_NUMBER_REG, 0);
		WriteDescriptorReg(DESCRIPTOR_READ_ADDRESS_HIGH_REG, 0);
		WriteDescriptorReg(DESCRIPTOR_WRITE_ADDRESS_HIGH_REG, 0);
		WriteDescriptorReg(DESCRIPTOR_CONTROL_ENHANCED_REG, ctrl);
	}
	tsDesc desc;
	desc.addr = DestAddr;
	desc.length = Length;
	desc.parked = 0;
	mhWriteList.push_back(desc);
	return 0;
}

/**
 *  reset the SGDMA state machine.
 *
 *  \return non-zero on error.
 */
int tcSGDMADispatcher::Reset(void)
{
	/* issue a reset, just to be sure */
	WriteCtrlReg(CSR_CONTROL_REG, CSR_RESET_MASK);
	do
	{
		usleep(1000);
	} while (ReadCtrlReg(CSR_STATUS_REG) & CSR_RESET_STATE_MASK);
	return 0;
}

/**
 *  Start descriptors (while in stopped state).
 */
void tcSGDMADispatcher::StartDesc(void)
{
	uint32_t reg;
	
	reg = ReadCtrlReg(CSR_CONTROL_REG);
	reg &= ~CSR_STOP_DESCRIPTORS_MASK;
	WriteCtrlReg(CSR_CONTROL_REG, reg);
}

/**
 *  Stop the descriptors from running.  Useful while 
 *  in a parked descriptor.
 *
 *  \param[in] wait if true will stall until descriptors are 
 *             complete and stopped.
 */
void tcSGDMADispatcher::StopDesc(bool Wait)
{
	uint32_t reg;
	
	reg = ReadCtrlReg(CSR_CONTROL_REG);
	reg |= CSR_STOP_DESCRIPTORS_MASK;
	WriteCtrlReg(CSR_CONTROL_REG, reg);
	if (Wait)
	{
		int cnt = 0;
		while (!(ReadCtrlReg(CSR_STATUS_REG) & CSR_STOP_STATE_MASK))
		{
			usleep(1000);
			if (++cnt > 1000)
			{
				printf("%s: could not stop??? 0x%08X\n", __func__, ReadCtrlReg(CSR_STATUS_REG));
				break;
			}
		};
	}
}

/**
 *  Get the number of DMA descriptors / transfers queued.
 *
 *  \return number queued.
 */
int tcSGDMADispatcher::NumTransfersQueued(void)
{
	uint32_t rv = 0;
	uint32_t reg;

	reg = ReadCtrlReg(CSR_DESCRIPTOR_FILL_LEVEL_REG);

	rv = (reg >> 16);

	if ((reg & 0x0FFFF) > rv)
		rv = (reg & 0x0FFFF);
	
	return rv;
}

/**
 *   This routine checks the response buffer for ST->MM (read) 
 *   transactions and, if there is a completed transfer, pops
 *   the information from the SGDMA response queue.
 *
 *   If not buffer ready (no transfer has completed), then 
 *   the return value is false.
 *
 *   \param[in] pAddr pointer to buffer read
 *
 *   \return zero if no buffer is available.  Number of bytes
 *           actually transferred if completed.  < 0 if there
 *           was an error on transfer.
 */
int tcSGDMADispatcher::NextReadBuffer(unsigned int *pAddr)
{
	int ret = 0;
	unsigned int reg;

	/* check if response buffer is not empty */
	reg = ReadCtrlReg(CSR_STATUS_REG);

	if (!(reg & CSR_RESPONSE_BUFFER_EMPTY_MASK))
	{
		/* pop the next reponse buffer */

		/* if packet support is enabled, then the
		   ACTUAL_BYTES_TRANSFERRED_REG is valid, otherwise
		   you need to know what you asked for.... */

		if (!mhWriteList.empty())
		{
			tsDesc desc = mhWriteList.front();
			ret = desc.length;
			if (pAddr)
			{
				*pAddr = desc.addr;
			}
			if (!desc.parked)
			{
				mhWriteList.pop_front();
			}
		}
		else
		{
			printf("%s: Uh-Oh....\n", __func__);
			ret = -1;
		}
		if (mbGenPackets)
			ret = ReadRespReg(RESPONSE_ACTUAL_BYTES_TRANSFERRED_REG);
		reg = ReadRespReg(RESPONSE_ERRORS_REG);
		if (reg & RESPONSE_ERROR_MASK)
			ret = -(reg & RESPONSE_ERROR_MASK);
	}
	return ret;
	
}

/**
 *  Write descriptor directly to SGDMA controller core.  It is not 
 *  recommended that this method be used.
 *
 *  \param[in] descriptor descriptor to write.
 *
 *  \return 0
 *
 *  \note this will onyl work properly if in Enhanced mode
 */
int tcSGDMADispatcher::WriteDescriptor(tsSGDMADescriptor& descriptor)
{
	/* configure the descriptor and send it */
	/* TODO - this is only correct if mbEnhance is false */
	WriteDescriptorReg(DESCRIPTOR_READ_ADDRESS_REG, descriptor.read_addr);	
	WriteDescriptorReg(DESCRIPTOR_WRITE_ADDRESS_REG, descriptor.write_addr);
	WriteDescriptorReg(DESCRIPTOR_LENGTH_REG, descriptor.length);
	WriteDescriptorReg(DESCRIPTOR_CONTROL_STANDARD_REG, descriptor.control.mnWord);

	return 0;
}

/**
 *  Get SGDMA controller status register
 *
 *  \return the status register contents
 */
tuSgdmaStatus tcSGDMADispatcher::GetStatusReg()
{
	tuSgdmaStatus status;
	status.mnWord = ReadCtrlReg(CSR_STATUS_REG);
	return status;
}

/**
 *  Set SGDMA controller status register
 *
 *  \param[in] control the register contents to write.
 *
 *  \return the status register contents
 */
int tcSGDMADispatcher::SetControlReg(const tuSgdmaCtrl& control)
{
	WriteCtrlReg(CSR_CONTROL_REG, control.mnWord);

	return 0;
}
