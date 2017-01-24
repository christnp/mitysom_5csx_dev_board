#ifndef FILTER2D_H
#define FILTER2D_H

#include "FPGARegister.h"

class tcFilter2D
{
public:
	tcFilter2D(uint32_t anBaseAddr, int size, bool symmetric, bool isSigned, int FracBits, int WholeBits);
	virtual ~tcFilter2D(void);

	bool SetCoefs(float* Coes);
	bool SetCoefs(int* Coes);
	void Enable(bool enable);

protected:
	tcFPGARegister<uint32_t> mhRegs;
	int mnSize;
	bool mbSymmetric;

};
#endif
