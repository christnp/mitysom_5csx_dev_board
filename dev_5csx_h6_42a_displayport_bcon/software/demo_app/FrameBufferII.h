#ifndef FRAMEBUFFERII_H
#define FRAMEBUFFERII_H

#include "FPGARegister.h"

class tcFrameBufferII
{
public:
	tcFrameBufferII(uint32_t RegsOffset, uint32_t FrameBufferAddr, uint32_t MaxFrameSize);
	virtual ~tcFrameBufferII(void);

	uint8_t* ActiveBuffer(void);
	uint8_t* NextBuffer(void);
	void SwapBuffers(void);
	void SetFrameSize(int w, int h);
	void Enable(bool enable);

protected:
	tcFPGARegister<uint32_t> mhRegs;
	tcFPGARegister<uint8_t>  mhBuffer;
	int mnWidth;
	int mnHeight;
	int mnActiveBuffer;
};

#endif
