// main.cpp
// Include files to use the PYLON API.
#include <pylon/PylonIncludes.h>
#ifdef PYLON_WIN_BUILD
#    include <pylon/PylonGUI.h>
#endif

#include "BCONInput.h"
#include "GenICamModel.h"
#include "VIPMixerII.h"
#include "Filter2D.h"
#include "FrameBufferII.h"

#include <termios.h>
#include <unistd.h>
#include <fcntl.h>

// Namespace for using pylon objects.
using namespace Pylon;
using namespace GenApi;

// Namespace for using cout.
using namespace std;

// Number of images to be grabbed.
static const uint32_t c_countOfImagesToGrab = 100;

static const unsigned int VIPMixerRegsAddr = 0xFF201000;
static const unsigned int BCONInputRegsAddr = 0xFF202000;
static const unsigned int PLLRegsAddr = 0xFF203000;
static const unsigned int Filter2DRegsAddr = 0xFF204000;
static const unsigned int FrameBufferRegsAddr = 0xFF205000;
static const char* PLL_FileName = "pll_reconfig_table.txt";

void DumpFrame(int w, int h)
{
	// mem-map in the frame buffer
	int fd;
	int len = w * h * 3;

	/* map in the addresses */
	if ((fd = open("/dev/mem", O_RDWR)) < 0)
	{
		perror("/dev/mem");
		return;
	}
	else
	{
		void *lpmem = mmap(0, len, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0x20000000);
		close(fd);
		if (lpmem == MAP_FAILED)
		{
			perror("mmap");
			return;
		}
		FILE* fid = fopen("/tmp/image.bin","wb");
		fwrite(lpmem, 1, len, fid);
		fclose(fid);

		// clean up
		munmap(lpmem, len);
	}
}

#define TEXT_FILE_LINES		5
#define TEXT_LINE_HEIGHT	150
#define TEXT_FILE_WIDTH		1920
#define TEXT_FILE_HEIGHT	(TEXT_LINE_HEIGHT*TEXT_FILE_LINES)

void ShowText(tcFrameBufferII* apBuffer, uint8_t* mem, int offset)
{
	uint8_t* buf = apBuffer->NextBuffer();
	int blocksize = TEXT_LINE_HEIGHT*TEXT_FILE_WIDTH*3;
	memcpy(buf, &mem[offset*blocksize], blocksize);
	apBuffer->SwapBuffers();
}

void SlideImages(tcVIPMixerII* apMixer)
{
	static bool blend = false;
	blend = !blend;
	if (blend)
	{
		apMixer->EnableChannel(0, true, tcVIPMixerII::eeNone);
		apMixer->EnableChannel(1, true, tcVIPMixerII::eeStatic);
		for (int i = 0; i <= 480; i += 1)
		{
			usleep(1000);
			apMixer->SetChannelOffset(0, i, 100);
			apMixer->SetChannelOffset(1, 960-i, 100);
		}
	}
	else
	{
		for (int i = 480; i >= 0; i -= 1)
		{
			usleep(1000);
			apMixer->SetChannelOffset(0, i, 100);
			apMixer->SetChannelOffset(1, 960-i, 100);
		}
		apMixer->EnableChannel(0, true, tcVIPMixerII::eeNone);
		apMixer->EnableChannel(1, true, tcVIPMixerII::eeNone);
	}
}

int kbhit(void)
{
	struct termios oldt, newt;
	int ch;
	int oldf;

	tcgetattr(STDIN_FILENO, &oldt);
	newt = oldt;
	newt.c_lflag &= ~(ICANON | ECHO);
	tcsetattr(STDIN_FILENO, TCSANOW, &newt);
	oldf = fcntl(STDIN_FILENO, F_GETFL, 0);
	fcntl(STDIN_FILENO, F_SETFL, oldf | O_NONBLOCK);

	ch = getchar();

	tcsetattr(STDIN_FILENO, TCSANOW, &oldt);
	fcntl(STDIN_FILENO, F_SETFL, oldf);

	if(ch != EOF)
	{
		ungetc(ch, stdin);
		return 1;
	}

	return 0;
}

void DemoLoop(uint8_t* TextMem, tcFrameBufferII* apFB, tcVIPMixerII* apMixer)
{
	int state = 0;

	while(!kbhit())
	{
		int delay = 5000*1000;
		ShowText(apFB, TextMem, state);
		switch(state)
		{
		case 0:
			state = 1;
			break;
		case 1:
			SlideImages(apMixer);
			delay -= 1000*480;
			state = 2;
			break;
		case 2:
			SlideImages(apMixer);
			delay -= 1000*480;
			state = 3;
			break;
		case 3:
			state = 4;
			break;
		case 4:
		default:
			state = 0;
			break;
		}
		usleep(delay);
	}
}

int main(int argc, char* argv[])
{

    tcBCONInput* lpBCONInput = new tcBCONInput(BCONInputRegsAddr,
					  50000000,
					  new tcPllReconfig(PLLRegsAddr,3),
					  PLL_FileName);
    lpBCONInput->reset(true);
    usleep(200000);
    lpBCONInput->reset(false);
    usleep(200000);
    lpBCONInput->resetPLL(true);
    usleep(200000);
    lpBCONInput->resetPLL(false);

    tcVIPMixerII* lpVIPMixerII = new tcVIPMixerII(VIPMixerRegsAddr, 3);
    lpVIPMixerII->EnableMixer(false);

    tcFilter2D* lpFilter2D = new tcFilter2D(Filter2DRegsAddr, 5, true, true, 1, 5);
    lpFilter2D->Enable(false);

    tcFrameBufferII* lpFrameBufferII = new tcFrameBufferII(FrameBufferRegsAddr, 0x24000000, 1920*1080*3);
    lpFrameBufferII->Enable(false);

    uint8_t* lpTextBlock = new uint8_t[TEXT_FILE_WIDTH*TEXT_FILE_HEIGHT*3];
    FILE* fid = fopen("/home/root/bcon_adapter/bin/DemoText.raw","rb");
    if (fid)
    {
	    fread(lpTextBlock, 1, TEXT_FILE_WIDTH*TEXT_FILE_HEIGHT*3, fid);
	    fclose(fid);
	    uint8_t *red, *blue;
	    red = &lpTextBlock[0];
	    blue = &lpTextBlock[2];
	    for (int i = 0; i < TEXT_FILE_WIDTH*TEXT_FILE_HEIGHT; i++)
	    {
	    	uint8_t tmp = *red;
		*red = *blue;
		*blue = tmp;
		red += 3;
		blue += 3;
	    }
    }
    else
    {
    	cerr << "Could not open Text Data File" << endl;
    }

    //int coes[6] = {0, 0, 0, 0, 0, 2};
    int coes[6] = {-2, -2, -2, -2, -2, 48}; // Edge Detection
    lpFilter2D->SetCoefs(coes);

    // The exit code of the sample application.
    int exitCode = 0;

    // Before using any pylon methods, the pylon runtime must be initialized. 
    PylonInitialize();

    try
    {
        // Create an instant camera object with the camera device found first.
        CInstantCamera camera( CTlFactory::GetInstance().CreateFirstDevice());

        // Print the model name of the camera.
        cout << "Using device " << camera.GetDeviceInfo().GetModelName() << endl;

	camera.Open();

	INodeMap &control = camera.GetNodeMap();

	// pixel format = RGB8
	const CEnumerationPtr pf = control.GetNode("PixelFormat");
	IEnumEntry *f = pf->GetEntryByName("RGB8");
	pf->SetIntValue(f->GetValue());

	// height & Width (800x600)
	const CFloatPtr rate = control.GetNode("AcquisitionFrameRate");
	rate->SetValue(30.0f);

	const CBooleanPtr revY = control.GetNode("ReverseY");
	revY->SetValue(true);

	const CBooleanPtr revX = control.GetNode("ReverseX");
	revX->SetValue(true);

	uint32_t w = 960;
	uint32_t h = 800;
	const CIntegerPtr width = control.GetNode("Width");
	const CIntegerPtr height = control.GetNode("Height");
	const CIntegerPtr startX = control.GetNode("OffsetX");
	const CIntegerPtr startY = control.GetNode("OffsetY");
	startX->SetValue(0, true);
	startY->SetValue(0, true);
	width->SetValue(w, true);
	height->SetValue(h, true);
	AoiConfiguration Config;
	Config.m_height = h;
	Config.m_width = w;
	Config.m_left = 0;
	Config.m_top = 0;
	lpBCONInput->setAoiConfiguration(Config);

	// prep BCON input core to go
	lpBCONInput->reset(false);
	lpBCONInput->resetPLL(false);
	cout << "resetting PLL..." << endl;
	while(!lpBCONInput->inputClockLocked()) {
	}
	cout << "... done" << endl;

	// start camera up
	const CCommandPtr start = control.GetNode("AcquisitionStart");
	start->Execute(true);

	tcGenICamModel model(control);

	model.SetParam("BslColorSpaceMode", "RGB");
	model.SetParam("LightSourcePreset", "Off");
	model.SetParam("AutoTargetBrightness", "0.3");
	model.SetParam("AcquisitionFrameRate", "50");

	int line = 0;
	lpFrameBufferII->SetFrameSize(TEXT_FILE_WIDTH, TEXT_LINE_HEIGHT);
	lpFrameBufferII->Enable(true);
	ShowText(lpFrameBufferII, lpTextBlock, line);
	lpFrameBufferII->SwapBuffers();

	lpVIPMixerII->EnableMixer(true);
	lpVIPMixerII->SetChannelOffset(0, 0, 100);
	lpVIPMixerII->SetChannelOffset(1, 960, 100);
	lpVIPMixerII->SetChannelOffset(2, 0, 910);
	lpVIPMixerII->SetChannelLayer(0, 0);
	lpVIPMixerII->SetChannelLayer(1, 1);
	lpVIPMixerII->SetChannelLayer(2, 2);
	lpVIPMixerII->EnableChannel(0, true);
	lpVIPMixerII->EnableChannel(1, true);
	lpVIPMixerII->EnableChannel(2, true);
	lpVIPMixerII->SetChannelAlpha(0, 0xFF);
	lpVIPMixerII->SetChannelAlpha(1, 0x80);
	lpVIPMixerII->SetChannelAlpha(2, 0xFF);

	lpFilter2D->Enable(true);


	bool blend = false;


        // Camera.StopGrabbing() is called automatically by the RetrieveResult() method
        // when c_countOfImagesToGrab images have been retrieved.
	cout << "hit q to quit:" << endl;
	char c;
	bool done = false;
	DemoLoop(lpTextBlock, lpFrameBufferII, lpVIPMixerII);
	cin >> c;
        while ( !done )
        {
	    cin.ignore(INT_MAX, '\n');
	    switch (c)
	    {
	    case 'd':
	    	model.Dump();
		break;
	    case 's':
	    {
		string param = "";
		string value = "";
	    	cout << "Enter the Parameter Name" << endl;
		getline(cin,param);
		cout << "Enter the Value" << endl;
		getline(cin,value);
		model.SetParam(param, value);
	    }
	    break;
	    case 'q':
	    	done = true;
	        break;
	    case 'e':
	    	DemoLoop(lpTextBlock, lpFrameBufferII, lpVIPMixerII);
	    	break;
	    case 'c':
	    {
		const CCommandPtr stop = control.GetNode("AcquisitionStop");
		stop->Execute(true);
		usleep(100);
		const CIntegerPtr width = control.GetNode("Width");
		const CIntegerPtr height = control.GetNode("Height");
	    	DumpFrame(width->GetValue(),height->GetValue());
		const CCommandPtr start = control.GetNode("AcquisitionStart");
		start->Execute(true);
	    }
	    break;
	    case 'b':
		blend = !blend;
		if (blend)
		{
			lpVIPMixerII->EnableChannel(0, true, tcVIPMixerII::eeNone);
			lpVIPMixerII->EnableChannel(1, true, tcVIPMixerII::eeStatic);
			for (int i = 0; i <= 480; i += 1)
			{
				usleep(1000);
				lpVIPMixerII->SetChannelOffset(0, i, 100);
				lpVIPMixerII->SetChannelOffset(1, 960-i, 100);
			}
		}
		else
		{
			for (int i = 480; i >= 0; i -= 1)
			{
				usleep(1000);
				lpVIPMixerII->SetChannelOffset(0, i, 100);
				lpVIPMixerII->SetChannelOffset(1, 960-i, 100);
			}
			lpVIPMixerII->EnableChannel(0, true, tcVIPMixerII::eeNone);
			lpVIPMixerII->EnableChannel(1, true, tcVIPMixerII::eeNone);
		}
		break;
	    default:
	        break;
	    }
	    if (!done)
	    {
		    printf("hit q to quit:\n");
		    cin >> c;
	    }
        }
	cout << "Quitting" << endl;

	const CCommandPtr stop = control.GetNode("AcquisitionStop");
	stop->Execute(true);

	camera.Close();
    }
    catch (const GenericException &e)
    {
        // Error handling.
        cerr << "An exception occurred." << endl
        << e.GetDescription() << endl;
        exitCode = 1;
    }

    delete lpTextBlock;

    delete lpVIPMixerII;

    // Releases all pylon resources. 
    PylonTerminate();  

    delete lpBCONInput;

    return exitCode;
}
