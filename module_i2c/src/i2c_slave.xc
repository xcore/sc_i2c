#include <xs1.h>
#include <stdio.h>
#include <stdlib.h>
#include <syscall.h>
#include "i2c.h"

int i2c_slave_rx(int dev_addr, struct i2c_data_info &i2c_slave_data, struct r_i2c &i2c_slave,out port st_det)
{
	unsigned int clk;
	unsigned int rx_addr;
	unsigned int rx_data;
	unsigned int stop_det;
	unsigned int temp;
	unsigned int time;
	timer t;
	int x,i;
	unsigned int while_break;
	unsigned int rpt_start_det;
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
			printf("rx_addr = %h",rx_addr);
			break;
		}
		else if((rx_addr & 0x01) == 1){
			st_det <: 1;
			break;
		}
		i2c_slave.scl <: 0;
		t:> time;
		time = time + (3*I2C_BIT_TIME);
		t when timerafter (time) :> void;

		i2c_slave.sda <: 0;
		t:> time;
		time = time + (3*I2C_BIT_TIME);
		t when timerafter (time) :> void;

		i2c_slave.scl :> temp;
		i2c_slave.scl when pinseq(1) :> void;
		i2c_slave.scl when pinseq(0) :> void;
		i2c_slave.sda :> temp;
		stop_det = 0;
		while_break = 0;
		rpt_start_det = 0;
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
				if(x > 0){
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
				else
					if(temp)
					{
						select {
							case i2c_slave.scl when pinseq(0) :> void:
								while_break = 1;
								break;
							case i2c_slave.sda when pinseq(0) :> void:
								if(temp) {
									rpt_start_det = 1;
									while_break = 1;
								}
								break;
							}
						}
					else
						while_break = 1;
				}

				//if(rpt_start_det) return 0;
				if(stop_det == 0) i2c_slave.scl when pinseq(0) :> void;
				else break;
			}
			if(!stop_det) {
				i2c_slave.scl <: 0;
				t:> time;
				time = time + (3*I2C_BIT_TIME);
				t when timerafter (time) :> void;

				i2c_slave.sda <: 0;
				t:> time;
				time = time + (3*I2C_BIT_TIME);
				t when timerafter (time) :> void;

				i2c_slave.scl :> temp;
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
	return 0;
}


int i2c_slave_tx(int dev_addr, int sub_addr, struct i2c_data_info &i2c_slave_data, struct r_i2c &i2c_slave,out port st_det)
{
	unsigned int clk;
	unsigned int rx_addr;
	unsigned int rx_data;
	unsigned int stop_det;
	unsigned int Temp;
	unsigned int time;
	unsigned int sda_high;
	timer t;
	int i,j;
	unsigned int while_break;
	unsigned int nack,start_det;
	//out port test;
	set_port_pull_up(i2c_slave.scl);
	set_port_pull_up(i2c_slave.sda);
	Temp=0;
	st_det <: 0;
	i2c_slave.sda :> Temp;
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
			i2c_slave.sda :> Temp;
			rx_addr = (rx_addr | (Temp << i));
			i2c_slave.scl when pinseq(0) :> void;
		}

		if((rx_addr & 0xFE) != dev_addr){
			st_det <: 1;
			printf("dev addr %x.. Slave num = %d\n",rx_addr,i2c_slave_data.master_num);
			return 0;
			break;
		}
		else if((rx_addr & 0x01) == 1){
			st_det <: 1;
			break;
		}

		i2c_slave.sda <: 0;
		i2c_slave.scl when pinseq(1) :> void;
		i2c_slave.scl when pinseq(0) :> void;
		rx_addr = 0;
		for(i=7; i >= 0; --i){
			//i2c_slave.scl :> clk;
			i2c_slave.scl when pinseq(1) :> void;
			i2c_slave.sda :> Temp;
			rx_addr = rx_addr | (Temp << i);
			i2c_slave.scl when pinseq(0) :> void;
		}

		if((rx_addr) != sub_addr){
			st_det <: 1;
			break;
		}
		i2c_slave.sda <: 0;
		i2c_slave.scl when pinseq(1) :> void;
		i2c_slave.scl when pinseq(0) :> void;
		i2c_slave.sda :> sda_high;
		i2c_slave.scl when pinseq(1) :> void;

		i2c_slave.sda :> Temp;
		start_det = 0;

		select {
		case i2c_slave.sda when pinseq(0) :> void:
			{
				if(Temp == 1)
					start_det =1;
				break;
			}
		case i2c_slave.scl when pinseq(0) :> void:
			{
				start_det = 0;
				break;
			}
		}
		if(!start_det) return 0;
		i2c_slave.scl when pinseq(0) :> void;

		rx_addr=0;

		for(i=7; i >= 0; --i){
			i2c_slave.scl when pinseq(1) :> void;
			i2c_slave.sda :> Temp;
			rx_addr = ((Temp << i) | rx_addr);
			i2c_slave.scl when pinseq(0) :> void;
		}
		if(((rx_addr & 0xFE) == dev_addr) && ((rx_addr & 0x1) == 1)){
			i2c_slave.sda <: 0;
		}
		else return 0;

		i2c_slave.scl when pinseq(1) :> void;
		i2c_slave.scl when pinseq(0) :> void;
		nack = 0;
		j=0;
		while(!nack){
			rx_data = i2c_slave_data.data[j];
			j++;
			for(i=7; i >=0 ;--i){
				Temp = (rx_data >> i) & 0x01;
				i2c_slave.sda <: Temp;
				i2c_slave.scl when pinseq(1) :> void ;
				i2c_slave.scl when pinseq(0) :> void ;
			}
			i2c_slave.scl when pinseq(1) :> void ;
			i2c_slave.sda :> nack;
			i2c_slave.scl when pinseq(0) :> void ;
		}
	}
	return 0;
}

