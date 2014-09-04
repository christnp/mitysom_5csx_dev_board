/**
 * \file main.cpp 
 *
 * \description main entry point for Application.
 *
 *
 * \copyright Critical Link LLC 2013
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>

#define FPGA_DDR_OFFSET	0xC0000000
#define FPGA_DDR_SIZE	0xFFFFFFF			

int main(int argc, char* argv[])
{
	int fd;
	void *fpgaMem = NULL;
	/* map in the FPGA DDR */
	if ((fd = open("/dev/mem", O_RDWR)) < 0)
	{
		perror("/dev/mem");
		return 1;
	}
	else
	{
	 	fpgaMem = mmap(0, FPGA_DDR_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, FPGA_DDR_OFFSET);
		if (fpgaMem == MAP_FAILED)
		{
			perror("mmap fpga mem");
			close(fd);
			return 1;
		}
	}

	if(fpgaMem)
	{
		/* Write a counting pattern to the FPGA DDR */
		printf("Writing counting pattern to FPGA DDR\n");
		unsigned int count = 0;
		for(int i = 0; i < FPGA_DDR_SIZE/sizeof(unsigned int); i+=sizeof(unsigned int))
		{
			/* Write to FPGA DDR */
			memcpy((unsigned int*)(fpgaMem+i), &count, sizeof(unsigned int));
			count++;
		}
		printf("Writing done\n\n");

		printf("Reading and validating counting pattern from FPGA DDR\n");
		count = 0;
		int missMatchCnt = 0;
		int correctCnt = 0;
		for(int i = 0; i < FPGA_DDR_SIZE/sizeof(unsigned int); i+=sizeof(unsigned int))
		{
			unsigned int tmp;
			/* Read from FPGA DDR */
			memcpy(&tmp, (unsigned int*)(fpgaMem+i), sizeof(unsigned int));

			/* Validate counting pattern */	
			if(count != tmp)
			{ 
				missMatchCnt++;
			}
			else
			{
				correctCnt++;
			}

			count++;
		}

		printf("Read done\n");
		printf("Correct: %d, Miss Match: %d\n", correctCnt, missMatchCnt);

		/* Cleanup */
		munmap(fpgaMem, FPGA_DDR_SIZE);
		close(fd);
	}

	return 0;
}
