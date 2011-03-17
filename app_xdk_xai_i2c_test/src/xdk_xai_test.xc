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

on stdcore[1] : struct r_i2c i2c_master = { XS1_PORT_1B, XS1_PORT_1A };
on stdcore[1] : struct r_i2c i2c_slave  = { XS1_PORT_1D, XS1_PORT_1C };
on stdcore[1] : out port st_det = XS1_PORT_1H;

struct i2c_data_info i2c_data;
struct i2c_data_info i2c_slave_data;

//i2c_data.data_len = 1;
//i2c_data.data[0] = 0x55;

unsigned int i;
int main()
{
	//struct i2c_data_info i2c_data;
	//i2c_data.data[0]=0;
	par {
		on stdcore[1] : {
			i2c_slave_rd(0x12,i2c_slave_data,i2c_slave,st_det);
			printf("Data Len = %d\n",i2c_slave_data.data_len);
			for(i=0; i < i2c_slave_data.data_len; i++ ){
				printf("Data = %x \n",i2c_slave_data.data[i]);
			}
		}
		on stdcore[1] : {
			i2c_data.data_len = 4;
			i2c_data.data[0] = 0x89;
			i2c_data.data[1] = 0x51;
			i2c_data.data[2] = 0x21;
			i2c_data.data[3] = 0xA1;
			i2c_master_wr(0x06, 0x12, i2c_data, i2c_master);
		}
	}
  return 0;
}
