#include <xs1.h>
#include <stdio.h>
#include <stdlib.h>
#include <syscall.h>
#include "i2c.h"

int i2c_slave_rd(int dev_addr, struct i2c_data_info &i2c_slave_data, struct r_i2c &i2c_slave,out port st_det)
{
	unsigned int clk;
	unsigned int rx_addr;
	unsigned int rx_data;
	unsigned int stop_det;
	unsigned int temp;
	int x,i;
	unsigned int while_break;
	//out port test;
	set_port_pull_up(i2c_slave.scl);
	set_port_pull_up(i2c_slave.sda);
	temp=0;
	st_det <: 0;
	i2c_slave.sda :> temp;
	while(1){
		//Start Detect
		while(1){
			i2c_slave.sda when pinseq(0) :> void;
			i2c_slave.scl :> clk;
			if(clk == 1){
				st_det <: 1;
				break;
			}
			else
				i2c_slave.sda when pinseq(1) :> void;
		}
		i2c_slave.scl when pinseq(0) :> void;
		st_det <: 0;
		//address read
		rx_addr =0;
		for(i=7; i >= 0; --i){
			//i2c_slave.scl :> clk;
			i2c_slave.scl when pinseq(1) :> void;
			i2c_slave.sda :> temp;
			rx_addr = rx_addr | (temp << i);
			i2c_slave.scl when pinseq(0) :> void;
		}

		if((rx_addr & 0xFE) != dev_addr){
			st_det <: 1;
			break;
		}
		else if((rx_addr & 0x01) == 1){
			st_det <: 1;
			break;
		}
		i2c_slave.sda <: 0;
		i2c_slave.scl when pinseq(1) :> void;
		i2c_slave.scl when pinseq(0) :> void;
		i2c_slave.sda :> temp;
		stop_det = 0;
		while_break = 0;
		x=0;
		//For data Read
		while(!stop_det){
			rx_data=0;
			for(i=7; i >= 0; --i){
				i2c_slave.scl when pinseq(1) :> void;
				i2c_slave.sda :> temp;
				rx_data = rx_data | (temp << i);
				if(i == 7) while_break = 0;
				while(!while_break && i == 7){
				select {
					case i2c_slave.scl when pinseq(0) :> void:
						while_break = 1;
						break;

					case i2c_slave.sda when pinseq(1) :> void:
						if(temp == 0) {
							stop_det = 1;
							while_break = 1;
						}
						break;
					}
				}
				if(stop_det == 0) i2c_slave.scl when pinseq(0) :> void;
				else break;
			}
			if(!stop_det) {
				i2c_slave.sda <: 0;
				i2c_slave.scl when pinseq(1) :> void;
				i2c_slave_data.data_len++;
				i2c_slave_data.data[x] = rx_data;
				x++;
				i2c_slave.scl when pinseq(0) :> void;
				i2c_slave.sda :> temp;
			}
			else {
				printf("STOP \n");
				return;
			}
		}
		//return;
	}
}
