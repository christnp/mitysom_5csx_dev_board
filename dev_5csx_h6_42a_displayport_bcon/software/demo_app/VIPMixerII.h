#ifndef VIPMIXERII_H
#define VIPMIXERII_H

#include "FPGARegister.h"

class tcVIPMixerII
{
public:
	typedef enum {
		eeNone = 0,
		eeStatic = 1,
		eeStream = 2
	} teAlphaMode;

	tcVIPMixerII(unsigned int baseaddr, int numports);
	virtual ~tcVIPMixerII(void);

	void EnableMixer(bool enable);

	void EnableChannel(int chan, bool enable, teAlphaMode = eeNone);

	void SetChannelOffset(int chan, unsigned int X, unsigned int Y);

	void SetChannelLayer(int chan, unsigned int Layer);

	void SetChannelAlpha(int chan, unsigned int Alpha);
protected:
	tcFPGARegister<uint32_t> mhRegs;
};
#endif
