///////////////////////////////////////////////////////////////////////////////
//
// Test bench for I2C master
// XAI audio board connected to a XS1-G dev kit
//
// xdk_xai_test.xc
//
// Copyright (C) 2009, XMOS Ltd
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
// * Redistributions of source code must retain the above copyright
//   notice, this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the
//   documentation and/or other materials provided with the distribution.
// * Neither the name of the XMOS Ltd nor the names of its contributors may
//   be used to endorse or promote products derived from this software
//   without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY XMOS LTD ''AS IS'' AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL <copyright holder> BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
// OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
// HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
// ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//

#include <platform.h>
#include <print.h>
#include <stdio.h>
#include "i2c.h"

on stdcore[1] : struct r_i2c i2c = { XS1_PORT_4B, XS1_PORT_4A };
struct i2c_data_info i2c_data;
int main()
{
	//struct i2c_data_info i2c_data;
	//i2c_data.data[0]=0;
	par {
		on stdcore[1] : {
			//printstrln("NOTE connect XAI to core 1");
			//printstrln("NOTE crossover cable required");
			//printstrln("NOTE set 4-th DIP switch bank to OFF ON OFF ON");

			//printstrln("I2C device 0x9C");

			// read device ID
			//printstr("reading register 1 (device ID): ");
			//printint(i2c_rd(0x01, 0x9C, i2c));
			printstrln(" (expected 6)");

			// write multiplier value
			i2c_data.data[0]=0x80;
			i2c_data.data[1]=0x01;
			i2c_data.data[2]=0x55;
			i2c_data.data_len=3;
			i2c_wr(0x06, 0x12, i2c_data, i2c);
			printf("Done");
			/*printstrln("writing 0x12 to register 6");
			i2c_wr(0x06, 0x12, 0x9C, i2c);
			printstrln("writing 0x34 to register 7");
			i2c_wr(0x07, 0x34, 0x9C, i2c);
			printstrln("writing 0x56 to register 8");
			i2c_wr(0x08, 0x56, 0x9C, i2c);

			// read back
			printstr("reading register 6: 0x");
			printhexln(i2c_rd(0x06, 0x9C, i2c));
			printstr("reading register 7: 0x");
			printhexln(i2c_rd(0x07, 0x9C, i2c));
			printstr("reading register 8: 0x");
			printhexln(i2c_rd(0x08, 0x9C, i2c));*/
		}
	}
  return 0;
}
