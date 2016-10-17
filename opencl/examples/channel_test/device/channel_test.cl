#pragma OPENCL EXTENSION cl_altera_channels : enable

channel ushort4 data_in_IO __attribute__((depth(0))) __attribute__((io("data_in")));

// ACL kernel for streaming channel data to RAM
__kernel void stream_to_ram_kernel(__global ushort4 * restrict dst, int size)
{
    for (int i = 0; i < size; i++)
    {
	ushort4 tmp_in;
	ushort4 tmp_out;
	ushort4 mask1 = { 0xFF00, 0xFF00, 0xFF00, 0xFF00 };
	ushort4 mask2 = { 0x00FF, 0x00FF, 0x00FF, 0x00FF };

	// read the data off the channel
	tmp_in = read_channel_altera(data_in_IO);

	// Altera Avalon Streams are bit-ordered big endian.

	// fix word endian issue
	tmp_out = rotate(tmp_in & mask1, -8) | rotate(tmp_in & mask2, 8);

	// fix word ordering and write to RAM
    	dst[i] = tmp_out.wzyx;
    }
}

