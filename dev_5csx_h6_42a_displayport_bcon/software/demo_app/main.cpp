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

int main(int argc, char* argv[])
{

    tcBCONInput* lpBCONInput = new tcBCONInput(BCONInputRegsAddr,
					  50000000,
					  new tcPllReconfig(PLLRegsAddr,3),
					  PLL_FileName);
    lpBCONInput->reset(false);
    lpBCONInput->resetPLL(false);

    tcVIPMixerII* lpVIPMixerII = new tcVIPMixerII(VIPMixerRegsAddr, 3);

    tcFilter2D* lpFilter2D = new tcFilter2D(Filter2DRegsAddr, 5, true, true, 1, 5);

    //int coes[6] = {0, 0, 0, 0, 0, 2};
    int coes[6] = {-2, -2, -2, -2, -2, 48};
    lpFilter2D->SetCoefs(coes);
    lpFilter2D->Enable(true);

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
	model.SetParam("AutoTargetBrightness", "0.6");

	lpVIPMixerII->EnableMixer(true);
	lpVIPMixerII->SetChannelOffset(0, 0, 100);
	lpVIPMixerII->SetChannelOffset(1, 960, 100);
	lpVIPMixerII->SetChannelLayer(0, 0);
	lpVIPMixerII->SetChannelLayer(1, 1);
	lpVIPMixerII->EnableChannel(0, true);
	lpVIPMixerII->EnableChannel(1, true);
	lpVIPMixerII->SetChannelAlpha(0, 0xFF);
	lpVIPMixerII->SetChannelAlpha(1, 0x80);

	bool blend = false;


        // Camera.StopGrabbing() is called automatically by the RetrieveResult() method
        // when c_countOfImagesToGrab images have been retrieved.
	cout << "hit q to quit:" << endl;
	char c;
	bool done = false;
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

    // Releases all pylon resources. 
    PylonTerminate();  

    delete lpBCONInput;

    return exitCode;
}
