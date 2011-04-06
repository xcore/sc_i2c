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
#include <syscall.h>
#include <stdlib.h>
#include "i2c_info.h"
#include "i2c_test_def.h"

unsigned int i,j,ret_m1,ret_m2,ret_sl1,ret_sl2;
unsigned int ret_1,ret_2;
int main()
{
	//struct i2c_data_info i2c_data;
	//i2c_data.data[0]=0;
	par {
	#ifdef MASTER_TX
		#ifdef SLAVE1
			on stdcore[1] : {
				ret_sl1 = i2c_slave_rx(0x10,i2c_slave_data1,i2c_slave1);
				if(ret_sl1) {
					printf("Data Len = %d\n",i2c_slave_data1.data_len);
					for(i=0; i < i2c_slave_data1.data_len; i++ ){
						printf("Data = %x \n",i2c_slave_data1.data[i]);
					}
					exit(0);
				}
			}
		#endif
		#ifdef SLAVE2
			on stdcore[1] : {
				ret_sl2 = i2c_slave_rx(0x12,i2c_slave_data2,i2c_slave2);
				if(ret_sl2) {
					printf("Data Len = %d\n",i2c_slave_data2.data_len);
					for(j=0; j < i2c_slave_data2.data_len; j++ ){
						printf("Data = %x \n",i2c_slave_data2.data[j]);
					}
					exit(0);
				}
			}
		#endif
		#ifdef MASTER1
			on stdcore[1] : {
				i2c_data1.data_len = 5;
				i2c_data1.data[0] = 0x81;
				i2c_data1.data[1] = 0x40;
				i2c_data1.data[2] = 0x81;
				i2c_data1.data[3] = 0xA1;
				i2c_data1.data[4] = 0x55;
				i2c_data1.clock_mul=1;
				ret_1=i2c_master_tx(0x10, 0x06, i2c_data1, i2c_master1);
				printf("Return Master 1  = %d\n",ret_1);
			}
		#endif
		#ifdef MASTER2
			on stdcore[1] : {
				i2c_data2.data_len = 4;
				i2c_data2.data[0] = 0x80;
				i2c_data2.data[1] = 0x40;
				i2c_data2.data[2] = 0x81;
				i2c_data2.data[3] = 0xA0;
				i2c_data2.clock_mul=4;
				ret_2=i2c_master_tx(0x12, 0x06, i2c_data2, i2c_master2);
				printf("Return Master 2  = %d\n",ret_2);
			}
		#endif
	#else
		#ifdef MASTER1
			on stdcore[1] : {
				i2c_data1.data_len = 10;
				i2c_data1.master_num=1;
				i2c_data1.clock_mul=4;
				ret_m1=i2c_master_rx(0x02, 0x06, i2c_data1, i2c_master1);
				printf("ret m1 = %d\n",ret_m1);
				if(ret_m1){
					for(i=0;i < i2c_data1.data_len;++i){
						printf("Data1 = %x \n",i2c_data1.data[i]);
					}
					exit(0);
				}
				//exit(0);
			}
		#endif
		#ifdef MASTER2
			on stdcore[1] : {
				i2c_data2.data_len = 4;
				i2c_data2.master_num=2;
				i2c_data2.clock_mul=1;
				ret_m2=i2c_master_rx(0x10, 0x06, i2c_data2, i2c_master2);
				printf("ret m2 = %d\n",ret_m2);
				if(ret_m2){
					for(j=0;j < i2c_data2.data_len;++j){
						printf("Data2 = %x \n",i2c_data2.data[j]);
					}
					exit(0);
				}
				//exit(0);
			}
		#endif
		#ifdef SLAVE1
			on stdcore[1] : {
				i2c_slave_data1.data[0] = 0x81;
				i2c_slave_data1.data[1] = 0x55;
				i2c_slave_data1.data[2] = 0x21;
				i2c_slave_data1.data[3] = 0x55;
				i2c_slave_data1.data[4] = 0x81;
				i2c_slave_data1.data[5] = 0x55;
				i2c_slave_data1.data[6] = 0x81;
				i2c_slave_data1.data[7] = 0x98;
				i2c_slave_data1.data[8] = 0x81;
				i2c_slave_data1.data[9] = 0x01;
				i2c_slave_data1.data_len = 10;
				i2c_slave_data1.master_num=1;
				ret_sl1=i2c_slave_tx(0x02, 0x06, i2c_slave_data1, i2c_slave1, st_det1);
			}
		#endif
		#ifdef SLAVE2
			on stdcore[1] : {
				i2c_slave_data2.data[0] = 0x81;
				i2c_slave_data2.data[1] = 0x55;
				i2c_slave_data2.data[2] = 0x21;
				i2c_slave_data2.data[3] = 0x55;
				i2c_slave_data2.data_len = 4;
				i2c_slave_data2.master_num=2;
				ret_sl2=i2c_slave_tx(0x10, 0x06, i2c_slave_data2, i2c_slave2, st_det2);
			}
		#endif
#endif
	}
  return 0;
}
