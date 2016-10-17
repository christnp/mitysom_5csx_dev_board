/**
 * \file csr_map.cpp 
 *
 * \description Implementation file for generic register mapping.
 *
 * \copyright Critical Link LLC 2013
 */
#include "libfpga/csr_map.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>

/**
 * Constructor.
 *
 * \param[in] RegsAddr physical address of registers to map
 *
 * \param[in] SizeBytes number of bytes (address space) to map
 *
 * \note the address space will be PAGE aligned
 */
tcCSRMap::tcCSRMap(unsigned int RegsAddr, unsigned int SizeBytes)
: mpRegMapMM(NULL)
, mnMappedSize(SizeBytes)
{
	int fd;

	/* Force minimum of 1 page) */
	if (mnMappedSize < 4096)
		mnMappedSize = 4096;
	/* make sure page aligned */
	if (mnMappedSize & (4096-1))
	{
		mnMappedSize += 4096;
		mnMappedSize &= ~(4096-1);
	}

	/* map in the raw image buffer area */
	if ((fd = open("/dev/mem", O_RDWR)) < 0)
	{
		perror("/dev/mem");
	}
	else
	{
		void *lpmem;

		lpmem = mmap(0, mnMappedSize, PROT_READ|PROT_WRITE, MAP_SHARED, fd, RegsAddr);
		if (lpmem == MAP_FAILED)
		{
			perror("mmap register buffers");
			close(fd);
			return;
		}
		mpRegMapMM = lpmem;
	}
}

/**
 *  Destructor
 */
tcCSRMap::~tcCSRMap(void)
{
	if (mpRegMapMM)
		munmap(mpRegMapMM, mnMappedSize);
}
