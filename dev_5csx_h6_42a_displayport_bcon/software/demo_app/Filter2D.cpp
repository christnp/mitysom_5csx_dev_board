#include "Filter2D.h"

#define COEF_OFFSET	2
#define CONTROL_OFFSET	0


tcFilter2D::tcFilter2D(uint32_t anBaseAddr, int size, bool symmetric, bool isSigned, int FracBits, int WholeBits)
: mhRegs(anBaseAddr, 32+size*size)
, mnSize(size)
, mbSymmetric(symmetric)
{
	
}

tcFilter2D::~tcFilter2D(void)
{
}

void tcFilter2D::Enable(bool enable)
{
	mhRegs[CONTROL_OFFSET] = enable ? 1 : 0;
}

bool tcFilter2D::SetCoefs(float* Coes)
{
	bool rv = true;
	if (mbSymmetric)
	{
		int index = 0;
		for (int row = 0; row < (mnSize+1) / 2; ++row)
		{
			for (int col = row; col < (mnSize+1) / 2; ++col)
			{
				mhRegs[row*mnSize + col + COEF_OFFSET] = Coes[index++];
			}
		}
	}
	else
	{
		int N = mnSize*mnSize;
		for (int index = 0; index < mnSize; ++index)
		{
			mhRegs[index+COEF_OFFSET] = Coes[index];
		}
	}
	return rv;
}

bool tcFilter2D::SetCoefs(int* Coes)
{
	bool rv = true;
	if (mbSymmetric)
	{
		int index = 0;
		for (int row = 0; row < (mnSize+1) / 2; ++row)
		{
			for (int col = row; col < (mnSize+1) / 2; ++col)
			{
				mhRegs[row*mnSize + col + COEF_OFFSET] = Coes[index++];
			}
		}
	}
	else
	{
		int N = mnSize*mnSize;
		for (int index = 0; index < mnSize; ++index)
		{
			mhRegs[index+COEF_OFFSET] = Coes[index];
		}
	}
	return rv;
}

