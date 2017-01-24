#ifndef FPGAREGISTER_H
#define FPGAREGISTER_H

#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <cstdio>
#include <stdint.h>

template<class type>
class tcFPGARegister
{
public:
	tcFPGARegister(uint32_t anBaseAddr, uint32_t anLength)
		:mpRegister(NULL)
		, mnLength(anLength)
	{
		mbSuccess = true;
		int fd;

		/* map in the addresses */
		if ((fd = open("/dev/mem", O_RDWR)) < 0)
			{
			perror("/dev/mem");
			mbSuccess = false;
		}
		else
		{
			void *lpmem = mmap(0, mnLength * sizeof(type),
			PROT_READ | PROT_WRITE, MAP_SHARED, fd,
				anBaseAddr);
			close(fd);
			if (lpmem == MAP_FAILED)
			{
				perror("mmap");
				mbSuccess = false;
			}
			else
			{
				mpRegister = (volatile type *) lpmem;
			}
		}
	}
	~tcFPGARegister()
	{
		munmap((void *) mpRegister, mnLength);
	}

	/**
	 * Tests if the register was created successfully.
	 *
	 * @return true if the register was maped successfully. false otherwise
	 */
	bool initialized()
	{
		return mbSuccess;
	}

	/**
	 * Used to write arrays of data into the location; this is useful for
	 * filling RAMs. Bounds checking is not performed
	 *
	 * @param values - the array of data to write.
	 * @param length - the length of the array to write.
	 * @param offset - the offset to start at on the base in 32 bit words.
	 *        (ie: offset of 1 is 32 bits away from base)
	 */
	void write(const type *values, uint32_t length, uint32_t offset = 0)
	{
		for (uint32_t i = 0; i < length; i++) {
			mpRegister[offset++] = values[i];
		}
	}

	/**
	 * Writes a single value to the offset specified.
	 *
	 * @param value - the value to write
	 * @param offset - the offset to write to
	 */
	void write(uint32_t offset, type value)
	{
		mpRegister[offset] = value;
	}

	/**
	 * Reads the register at offset and returns the value
	 *
	 * @param offset - the offset to read from base.
	 * @return the uint32_t representation of the register contents.
	 */
	type read(uint32_t offset)
	{
		return mpRegister[offset];
	}

	/**
	 * Indexes into the registers for reading/writing.
	 *
	 * @param offset - the offset from the base address for the register.
	 * @return a reference to the uint32_t at this offset.
	 */
	volatile type& operator[](uint32_t offset)
	{
		return mpRegister[offset];
	}

private:
	volatile type *mpRegister;
	uint32_t mnLength;

	bool mbSuccess;
};

#endif // FPGAREGISTER_H
