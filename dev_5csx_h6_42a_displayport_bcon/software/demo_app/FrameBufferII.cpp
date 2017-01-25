#include "FrameBufferII.h"

#define REG_CONTROL_OFFSET	0
#define REG_STATUS_OFFSET	1
#define REG_FRAMEINFO_OFFSET	5
#define REG_FRAMESTARTADDR_OFFSET	6

tcFrameBufferII::tcFrameBufferII(uint32_t RegsOffset, uint32_t FrameBufferAddr, uint32_t MaxFrameSize)
: mhRegs(RegsOffset, 128)
, mhBuffer(FrameBufferAddr, MaxFrameSize*2)
, mnWidth(640)
, mnHeight(480)
, mnActiveBuffer(0)
{
}

void tcFrameBufferII::Enable(bool enable)
{
	mhRegs[REG_CONTROL_OFFSET] = enable ? 1 : 0;
}

tcFrameBufferII::~tcFrameBufferII(void)
{
}

uint8_t* tcFrameBufferII::ActiveBuffer(void)
{
	uint8_t* buf = (uint8_t*)mhBuffer.GetMappedAddr();
	return buf+(mnActiveBuffer*mnWidth*mnHeight*3);
}

uint8_t* tcFrameBufferII::NextBuffer(void)
{
	uint8_t* buf = (uint8_t*)mhBuffer.GetMappedAddr();
	int nextbuf = mnActiveBuffer ^ 1;
	return buf+(nextbuf*mnWidth*mnHeight*3);
}

void tcFrameBufferII::SwapBuffers(void)
{
	mhRegs[REG_FRAMEINFO_OFFSET] = (mnWidth << 13) | (mnHeight);
	uint32_t buf = mhBuffer.GetPhysAddr();
	int nextbuf = mnActiveBuffer ^ 1;
	buf += nextbuf*mnWidth*mnHeight*3;
	mhRegs[REG_FRAMESTARTADDR_OFFSET] = buf;
	mnActiveBuffer = nextbuf;
}

void tcFrameBufferII::SetFrameSize(int w, int h)
{
	mnWidth = w;
	mnHeight = h;
}
