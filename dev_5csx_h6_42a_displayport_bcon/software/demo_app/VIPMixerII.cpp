#include "VIPMixerII.h"

#define REG_OFFSET_CONTROL	0
#define REG_LAYERX_OFFSET(CHAN) (8 + CHAN*5)
#define REG_LAYERY_OFFSET(CHAN) (9 + CHAN*5)
#define REG_CONTROL_OFFSET(CHAN) (10 + CHAN*5)
#define REG_LAYER_OFFSET(CHAN) (11 + CHAN*5)
#define REG_ALPHA_OFFSET(CHAN) (12 + CHAN*5)

tcVIPMixerII::tcVIPMixerII(unsigned int baseaddr, int numports)
: mhRegs(baseaddr, 64)
{
}

tcVIPMixerII::~tcVIPMixerII(void)
{
}

void tcVIPMixerII::EnableMixer(bool enable)
{
	mhRegs[REG_OFFSET_CONTROL] = enable ? 1 : 0;
}

void tcVIPMixerII::EnableChannel(int chan, bool enable, teAlphaMode mode)
{
	int mask = enable ? 1 : 0;
	switch(mode)
	{
	case eeStatic:
		mask |= 4;
		break;
	case eeStream:
		mask |= 8;
		break;
	case eeNone:
	default:
		break;
	}
	mhRegs[REG_CONTROL_OFFSET(chan)] = mask;
}

void tcVIPMixerII::SetChannelOffset(int chan, unsigned int X, unsigned int Y)
{
	mhRegs[REG_LAYERX_OFFSET(chan)] = X;
	mhRegs[REG_LAYERY_OFFSET(chan)] = Y;
}

void tcVIPMixerII::SetChannelLayer(int chan, unsigned int Layer)
{
	mhRegs[REG_LAYER_OFFSET(chan)] = Layer;
}

void tcVIPMixerII::SetChannelAlpha(int chan, unsigned int Alpha)
{
	mhRegs[REG_ALPHA_OFFSET(chan)] = Alpha;
}
