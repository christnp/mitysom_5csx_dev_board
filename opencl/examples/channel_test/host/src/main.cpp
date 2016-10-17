///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include "CL/opencl.h"
#include "AOCLUtils/aocl_utils.h"
#include "libfpga/sgdma_dispatcher.h"

using namespace aocl_utils;

// OpenCL runtime configuration
cl_platform_id platform = NULL;
unsigned num_devices = 0;
scoped_array<cl_device_id> device; // num_devices elements
cl_context context = NULL;
scoped_array<cl_command_queue> queue; // num_devices elements
cl_program program = NULL;
scoped_array<cl_kernel> kernel; // num_devices elements
scoped_array<cl_mem> output_buf; // output buffer from channel stream

// Parameters
unsigned N = 10240; // number of unsigned shorts to receive
scoped_array<scoped_aligned_ptr<uint16_t> > output; // num_devices elements
scoped_array<unsigned> n_per_device; // num_devices elements

// side-channel SGDMA to Stream Interface (simulates Avalon-ST from External Source)
#define DISPATCHER_ADDR_CTRLREGS	(0xFF200000 + 0x10000 + 0x0000)
#define DISPATCHER_ADDR_DESCREGS	(0xFF200000 + 0x10000 + 0x1000)
#define DISPATCHER_ADDR_RESPREGS	(0)
#define SGDMA_TRANSFER_AREA		(768*1024*1024)

uint16_t* input_buffer = 0;
tcSGDMADispatcher* pSGDMADispatcher = 0;
int mmap_fd = -1;
int mmap_size = 0;

// Function prototypes
bool init_opencl();
void init_problem();
void run();
void cleanup();

// Entry point.
int main(int argc, char **argv) {
  Options options(argc, argv);

  // Optional argument to specify the problem size.
  if(options.has("n")) {
    N = options.get<unsigned>("n");
  }

  // Initialize OpenCL.
  if(!init_opencl()) {
    return -1;
  }

  // Initialize the problem data.
  // Requires the number of devices to be known.
  init_problem();

  // Run the kernel.
  run();

  // Free the resources allocated
  cleanup();

  return 0;
}

// Initializes the OpenCL objects.
bool init_opencl() {
  cl_int status;

  printf("Initializing OpenCL\n");

  if(!setCwdToExeDir()) {
    return false;
  }

  pSGDMADispatcher = new tcSGDMADispatcher(DISPATCHER_ADDR_CTRLREGS,
    DISPATCHER_ADDR_DESCREGS, DISPATCHER_ADDR_RESPREGS, true);
  pSGDMADispatcher->EnablePackets(false);

  /* map in the raw image buffer area */
  if ((mmap_fd = open("/dev/mem", O_RDWR)) < 0)
  {
    perror("/dev/mem");
    return false;
  }
  else
  {
    void *lpmem;

    mmap_size = N * sizeof(uint16_t);
    /* Force minimum of 1 page) */
    if (mmap_size < 4096)
      mmap_size = 4096;
    /* make sure page aligned */
    if (mmap_size & (4096-1))
    {
        mmap_size += 4096;
        mmap_size &= ~(4096-1);
    }

    lpmem = mmap(0, mmap_size, PROT_READ|PROT_WRITE, MAP_SHARED, mmap_fd, SGDMA_TRANSFER_AREA);
    if (lpmem == MAP_FAILED)
    {
       perror("mmap register buffers");
       close(mmap_fd);
       return false;
    }
    input_buffer = (uint16_t*)lpmem;
  }

  // Get the OpenCL platform.
  platform = findPlatform("Altera");
  if(platform == NULL) {
    printf("ERROR: Unable to find Altera OpenCL platform.\n");
    return false;
  }

  // Query the available OpenCL device.
  device.reset(getDevices(platform, CL_DEVICE_TYPE_ALL, &num_devices));
  printf("Platform: %s\n", getPlatformName(platform).c_str());
  printf("Using %d device(s)\n", num_devices);
  for(unsigned i = 0; i < num_devices; ++i) {
    printf("  %s\n", getDeviceName(device[i]).c_str());
  }

  // Create the context.
  context = clCreateContext(NULL, num_devices, device, &oclContextCallback, NULL, &status);
  checkError(status, "Failed to create context");

  // Create the program for all device. Use the first device as the
  // representative device (assuming all device are of the same type).
  std::string binary_file = getBoardBinaryFile("channel_test", device[0]);
  printf("Using AOCX: %s\n", binary_file.c_str());
  program = createProgramFromBinary(context, binary_file.c_str(), device, num_devices);

  // Build the program that was just created.
  status = clBuildProgram(program, 0, NULL, "", NULL, NULL);
  checkError(status, "Failed to build program");

  // Create per-device objects.
  queue.reset(num_devices);
  kernel.reset(num_devices);
  n_per_device.reset(num_devices);
  output_buf.reset(num_devices);

  // num_devices should be one...
  printf("num_devices is %d\n", num_devices);

  for(unsigned i = 0; i < num_devices; ++i) {
    // Command queue.
    queue[i] = clCreateCommandQueue(context, device[i], CL_QUEUE_PROFILING_ENABLE, &status);
    checkError(status, "Failed to create command queue");

    // Kernel.
    const char *kernel_name = "stream_to_ram_kernel";
    kernel[i] = clCreateKernel(program, kernel_name, &status);
    checkError(status, "Failed to create kernel");

    // Determine the number of elements processed by this device.
    n_per_device[i] = N / num_devices; // number of elements handled by this device

    // Spread out the remainder of the elements over the first
    // N % num_devices.
    if(i < (N % num_devices)) {
      n_per_device[i]++;
    }

    // Output buffer.  This is the data from opencl channel IO
    output_buf[i] = clCreateBuffer(context, CL_MEM_WRITE_ONLY, 
        n_per_device[i] * sizeof(uint16_t), NULL, &status);
    checkError(status, "Failed to create buffer for output");
  }

  printf("created kernel objects\n");

  return true;
}

// Initialize the data for the problem. Requires num_devices to be known.
void init_problem() {
  if(num_devices == 0) {
    checkError(-1, "No devices");
  }

  output.reset(num_devices);

  uint16_t* data = input_buffer;
  printf("num_devices = %d, n_per_device[0] = %d\n", num_devices, n_per_device[0]);
  for(unsigned i = 0; i < num_devices; ++i) {
    output[i].reset(n_per_device[i]);

    for(unsigned j = 0; j < n_per_device[i]; ++j) {
      *data = j;
      data++;
    }
  }
  printf("init_problem done\n");
}

cl_int n;

void run() {
  cl_int status;

  const double start_time = getCurrentTimestamp();

  // Launch the problem for each device.
  scoped_array<cl_event> kernel_event(num_devices);
  scoped_array<cl_event> finish_event(num_devices);

  for(unsigned i = 0; i < num_devices; ++i) {

    // Set kernel arguments.
    unsigned argi = 0;

    status = clSetKernelArg(kernel[i], argi++, sizeof(cl_mem), &output_buf[i]);
    checkError(status, "Failed to set argument %d", argi - 1);

    // 
    int n = N / 4;
    status = clSetKernelArg(kernel[i], argi++, sizeof(n), &n);
    checkError(status, "Failed to set argument %d", argi - 1);

    // Enqueue kernel.
    // Use a global work size corresponding to the number of elements to add
    // for this device.
    // 
    // We don't specify a local work size and let the runtime choose
    // (it'll choose to use one work-group with the same size as the global
    // work-size).
    // const size_t global_work_size = n_per_device[i];
    const size_t global_work_size = 1;
    printf("Launching for device %d (%d elements)\n", i, global_work_size);

    status = clEnqueueNDRangeKernel(queue[i], kernel[i], 1, NULL,
        &global_work_size, NULL, 0, NULL, &kernel_event[i]);
    checkError(status, "Failed to launch kernel");

    // Read the result. This the final operation.
    status = clEnqueueReadBuffer(queue[i], output_buf[i], CL_FALSE,
        0, n_per_device[i] * sizeof(uint16_t), output[i], 1, &kernel_event[i], &finish_event[i]);

  }

  printf("starting SGDMA\n");

  // start the stream up (could this be done ahead of time?)
  pSGDMADispatcher->TransferFromRAM(SGDMA_TRANSFER_AREA, N * sizeof(uint16_t));

  printf("Waiting for Events\n");

  // Wait for all devices to finish.
  clWaitForEvents(num_devices, finish_event);

  printf("Done Waiting for Events\n");

  const double end_time = getCurrentTimestamp();

  // Wall-clock time taken.
  printf("\nTime: %0.3f ms\n", (end_time - start_time) * 1e3);

  // Get kernel times using the OpenCL event profiling API.
  for(unsigned i = 0; i < num_devices; ++i) {
    cl_ulong time_ns = getStartEndTime(kernel_event[i]);
    printf("Kernel time (device %d): %0.3f ms\n", i, double(time_ns) * 1e-6);
  }

  // Release all events.
  for(unsigned i = 0; i < num_devices; ++i) {
    clReleaseEvent(kernel_event[i]);
    clReleaseEvent(finish_event[i]);
  }

  // Verify results.
  bool pass = true;
  uint16_t* data = input_buffer;
  for(unsigned i = 0; i < num_devices && pass; ++i) {
    for(unsigned j = 0; j < n_per_device[i] && pass; ++j, ++data) {
      if(output[i][j] - *data) {
        printf("Failed verification @ device %d, index %d\nOutput: %d\nReference: %d\n",
            i, j, output[i][j], *data);
        pass = false;
      }
    }
  }

  printf("\nVerification: %s\n", pass ? "PASS" : "FAIL");
}

// Free the resources allocated during initialization
void cleanup() {
  for(unsigned i = 0; i < num_devices; ++i) {
    if(kernel && kernel[i]) {
      clReleaseKernel(kernel[i]);
    }
    if(queue && queue[i]) {
      clReleaseCommandQueue(queue[i]);
    }
    if(output_buf && output_buf[i]) {
      clReleaseMemObject(output_buf[i]);
    }
  }

  if(program) {
    clReleaseProgram(program);
  }
  if(context) {
    clReleaseContext(context);
  }

  if (pSGDMADispatcher) {
     delete pSGDMADispatcher;
  }
  if (input_buffer)
     munmap(input_buffer, mmap_size);
  if (mmap_fd > 0)
     close(mmap_fd);
}

