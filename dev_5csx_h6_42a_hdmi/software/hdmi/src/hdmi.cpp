/*
 * Copyright (C) Your copyright notice.
 *
 * Author: dvincelette
 *
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the PG_ORGANIZATION nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY	THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS-IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 */

#include <iostream>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <stdint.h>
#include "i2c-dev.h"
#include <stdio.h>
#include "config_hdmi.h"
#include <unistd.h>

using namespace std;

int main(void) {

	int fd;

	cout << "Setting up HDMI Transmitter" << endl;

	fd = open("/dev/i2c-2", O_RDWR);
	int ret = ioctl(fd, I2C_SLAVE, 0x39);
	if(ret < 0)
	{
		cerr << "Failed to set slave" << endl;
		return 1;
	}

	cout << "Writing Config" << endl;
	int i = 0;
	while( !( tx_conf_main[i]==0 && tx_conf_main[i+1]==0 && tx_conf_main[i+2]==0 && tx_conf_main[i+3]==0) )
	{
		i2c_smbus_write_byte_data(fd, tx_conf_main[i], tx_conf_main[i+1]);
#ifdef DEBUG
		printf("Reg %x val %x\n", tx_conf_main[i], tx_conf_main[i+1]);
#endif
		i += 2;
	}
	cout << "Done Writing Config" << endl;

	return 0;
}

