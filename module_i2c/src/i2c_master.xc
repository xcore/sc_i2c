///////////////////////////////////////////////////////////////////////////////
//
// I2C master

#include <xs1.h>
#include <platform.h>
#include <stdio.h>
#include "i2c.h"

#ifndef I2C_TI_COMPATIBILITY

int i2c_master_rx(int device, int sub_addr, struct i2c_data_info &i2c_data, struct r_i2c &i2c_master)
{
  //   int result;
   int Temp, CtlAdrsData, i,j;
   int deviceAddr;
   // three device ACK
   int ack;
   int data_rx;
   int sda_high;
   unsigned int scl_high;
   unsigned int clock_mul;

   set_port_pull_up(i2c_master.scl);
   set_port_pull_up(i2c_master.sda);

   clock_mul = i2c_data.clock_mul;
   i2c_master.scl :> scl_high;
   i2c_master.sda :> sda_high;
   sync(i2c_master.sda);

   wait_func(2,1,i2c_master.sda,1);

   i2c_master.scl :> scl_high;
   i2c_master.sda  <: 0;

   wait_func(2,1,i2c_master.sda,1);

   i2c_master.scl <: 0;
   // shift 7bits of address and 1bit R/W (fixed to write).
   // Sending Device ID
   for (i = 0; i < 8; ++i)
   {
      Temp = (device >> (7 - i)) & 0x1;
      if(Temp ==0) i2c_master.sda <: Temp;
      else i2c_master.sda :> sda_high;

      wait_func(2,clock_mul,i2c_master.scl,0);
      i2c_master.scl :> scl_high;
      i2c_master.scl when pinseq(1) :> void;
      if(Temp){
    	  i2c_master.sda :> sda_high;
    	  if(!sda_high) {
    		  printf("Master num = %d\n",i2c_data.master_num);
    		  return(0);
    	  }
      }

      wait_func(2,clock_mul,i2c_master.scl,1);
      i2c_master.scl <: 0;
   }
   // turn the data to input
   i2c_master.sda :> Temp;

   wait_func(2,clock_mul,i2c_master.scl,0);
   i2c_master.scl :> scl_high;
   i2c_master.scl when pinseq(1) :> void;

   // sample first ACK.
   i2c_master.sda :> ack;
   if(ack) return (0);

   wait_func(2,clock_mul,i2c_master.scl,1);
   i2c_master.scl <: 0;

   CtlAdrsData = (sub_addr & 0xFF);

   // shift first 8 bits.
   for (i = 0; i < 8; i += 1)
   {
      Temp = (CtlAdrsData >> (7 - i)) & 0x1;
      if(Temp ==0) i2c_master.sda <: Temp;
      else i2c_master.sda :> sda_high;

      wait_func(2,clock_mul,i2c_master.scl,0);
      i2c_master.scl :> scl_high;
      i2c_master.scl when pinseq(1) :> void;

      if(Temp){
    	  i2c_master.sda :> sda_high;
    	  if(!sda_high) return(0);
      }

      wait_func(2,clock_mul,i2c_master.scl,1);
      i2c_master.scl <: 0;
   }
   // turn the data to input
   i2c_master.sda :> Temp;
   wait_func(2,clock_mul,i2c_master.scl,0);
   i2c_master.scl :> scl_high;
   i2c_master.scl when pinseq(1) :> void;

   // sample second ACK.
   i2c_master.sda :> ack;
   if(ack) return (0);

   wait_func(2,clock_mul,i2c_master.scl,1);
   i2c_master.scl <: 0;
   i2c_master.sda :> sda_high;

   wait_func(2,clock_mul,i2c_master.scl,0);
   i2c_master.scl :> scl_high;
   i2c_master.scl when pinseq(1) :> void;

   wait_func(4,clock_mul,i2c_master.scl,1);
   // start bit on SDI
   i2c_master.sda <:0;

   wait_func(4,clock_mul,i2c_master.scl,1);
   i2c_master.scl <: 0;

   // send address and read
   // shift 7bits of address and 1bit R/W (fixed to write).
   // WARNING: Assume MSB first.
   deviceAddr = device | 1;
   for (i = 0; i < 8; i += 1)
   {
      Temp = (deviceAddr >> (7 - i)) & 0x1;
      i2c_master.sda <: Temp;
      wait_func(2,clock_mul,i2c_master.scl,0);
      i2c_master.scl :> scl_high;
      i2c_master.scl when pinseq(1) :> void;
      ///////////

      if(Temp){
    	  i2c_master.sda :> sda_high;
    	  if(!sda_high) return(0);
      }
      /////////

      wait_func(2,clock_mul,i2c_master.scl,1);
      i2c_master.scl <: 0;
   }
   // turn the data to input
   i2c_master.sda :> Temp;
   wait_func(2,clock_mul,i2c_master.scl,0);
   i2c_master.scl :> scl_high;
   i2c_master.scl when pinseq(1) :> void;
   // sample first ACK.
   i2c_master.sda :> ack;
   if(ack) return (0);

   // shift second 8 bits.
   for(i=0; i < i2c_data.data_len;++i){
	   data_rx = 0;
	   wait_func(2,clock_mul,i2c_master.scl,1);
	   i2c_master.scl <: 0;
	   i2c_master.sda :> sda_high;

	   wait_func(2,clock_mul,i2c_master.scl,0);
	   i2c_master.scl :> scl_high;
	   i2c_master.scl when pinseq(1) :> void;

	   for(j=7; j >= 0;--j){
		   i2c_master.sda :> Temp;
		   data_rx = ((Temp << j) | data_rx);

		   wait_func(2,clock_mul,i2c_master.scl,1);
		   i2c_master.scl <: 0;

		   if(j ==0)
			   i2c_master.sda <: 0;

			wait_func(2,clock_mul,i2c_master.scl,0);
			i2c_master.scl :> scl_high;
			i2c_master.scl when pinseq(1) :> void;
	   }
	   i2c_data.data[i] = data_rx;

   }

   //Send Stop
   wait_func(4,clock_mul,i2c_master.scl,1);
   i2c_master.sda <: 1;
   wait_func(2,clock_mul,i2c_master.scl,1);
   return (1);
}
#endif

//int i2c_wr(int sub_addr, int data, int device, struct r_i2c &i2c)
int i2c_master_tx(int device, int sub_addr, struct i2c_data_info &i2c_data, struct r_i2c &i2c_master)
{
   int Temp, CtlAdrsData, i;
   // three device ACK
   int ack;
   unsigned int data;
   unsigned int j;
   unsigned int sda_high;
   unsigned int scl_high;
   unsigned int clock_mul;
   set_port_pull_up(i2c_master.scl);
   set_port_pull_up(i2c_master.sda);
   // initial values.
   clock_mul = i2c_data.clock_mul;
   i2c_master.scl :> scl_high;
   i2c_master.sda :> sda_high;
   sync(i2c_master.sda);

   i2c_master.scl :> scl_high;
   wait_func(2,clock_mul,i2c_master.scl,1);

   // start bit on SDI
   i2c_master.scl :> scl_high;
   i2c_master.sda  <: 0;
   wait_func(2,clock_mul,i2c_master.scl,1);
   i2c_master.scl <: 0;

   // shift 7bits of address and 1bit R/W (fixed to write).
   // Sending Device ID
   for (i = 0; i < 8; ++i)
   {
      Temp = (device >> (7 - i)) & 0x1;
      if(!Temp) i2c_master.sda <: Temp;
      else i2c_master.sda :> sda_high;
      wait_func(2,clock_mul,i2c_master.scl,0);
      //i2c_master.scl <: 1;
      i2c_master.scl :> scl_high;
      i2c_master.scl when pinseq(1) :> void;
      // Checking for bit(Arbitration)
      if(Temp){
    	  i2c_master.sda :> sda_high;
    	  if(!sda_high){
    		  return(0);
    	  }
      }
      //i2c_master.scl :> Temp;
      wait_func(2,clock_mul,i2c_master.scl,1);
      i2c_master.scl <: 0;
   }

   // turn the data to input
   i2c_master.sda :> Temp;
   wait_func(2,clock_mul,i2c_master.scl,0);
   //i2c_master.scl <: 1;
   i2c_master.scl :> scl_high;
   i2c_master.scl when pinseq(1) :> void;

   // sample first ACK.
   i2c_master.sda :> ack;
   if(ack) return (0);

   wait_func(2,clock_mul,i2c_master.scl,1);
   i2c_master.scl <: 0;
   i2c_master.sda <: 0;

   CtlAdrsData = (sub_addr & 0xFF);

   // shift first 8 bits.
   //Sending Address
   for (i = 0; i < 8; i += 1)
   {
      Temp = (CtlAdrsData >> (7 - i)) & 0x1;
      if(!Temp) i2c_master.sda <: Temp;
      else i2c_master.sda :> sda_high;
      wait_func(2,clock_mul,i2c_master.scl,0);
      //i2c_master.scl <: 1;
      i2c_master.scl :> scl_high;
      i2c_master.scl when pinseq(1) :> void;
      // Checking for bit(Arbitration)
      if(Temp){
    	  i2c_master.sda :> sda_high;
    	  if(!sda_high){
    		  return(0);
    	  }
      }
      wait_func(2,clock_mul,i2c_master.scl,1);
      i2c_master.scl <: 0;
   }
   // turn the data to input
   i2c_master.sda :> Temp;
   wait_func(2,clock_mul,i2c_master.scl,0);
   //i2c_master.scl <: 1;
   i2c_master.scl :> scl_high;
   i2c_master.scl when pinseq(1) :> void;
   // sample second ACK.
   i2c_master.sda :> ack;
   if(ack) return(0);

   wait_func(2,clock_mul,i2c_master.scl,1);
   i2c_master.scl <: 0;
   i2c_master.sda <: 0;

   CtlAdrsData = (data & 0xFF);

   // shift second 8 bits.
   //Sending Data
   for(j=0; j < i2c_data.data_len; j++){
	   CtlAdrsData = (i2c_data.data[j] & 0xFF);
	   for (i = 0; i < 8; ++i)
	   {
		   Temp = (CtlAdrsData >> (7 - i)) & 0x1;
		   if(Temp == 0) i2c_master.sda <: Temp;
		   else i2c_master.sda :> sda_high;

		   wait_func(2,clock_mul,i2c_master.scl,0);
		   //i2c_master.scl <: 1;
		   i2c_master.scl :> scl_high;
		   i2c_master.scl when pinseq(1) :> void;
		   // Checking for bit(Arbitration)
		   if(Temp){
			   i2c_master.sda :> sda_high;
			   if(!sda_high){
				   return(0);
			   }
		   }
		   wait_func(2,clock_mul,i2c_master.scl,1);
		   i2c_master.scl <: 0;
	   }
	   // turn the data to input
	   i2c_master.sda :> Temp;
	   wait_func(2,clock_mul,i2c_master.scl,0);
	   //i2c_master.scl <: 1;
	   i2c_master.scl :> scl_high;
	   i2c_master.scl when pinseq(1) :> void;
	   // sample second ACK.
	   i2c_master.sda :> ack;
	   if(ack) return(0);

	   wait_func(2,clock_mul,i2c_master.scl,1);
	   i2c_master.scl <: 0;
	   //ack[2]=0;
	   //i2c_master.sda <: 0;
   }
   i2c_master.sda <: 0;
   wait_func(2,clock_mul,i2c_master.scl,0);
   //i2c_master.scl <: 1;
   i2c_master.scl :> scl_high;
   i2c_master.scl when pinseq(1) :> void;
   // put the data to a good value for next round.
   wait_func(4,clock_mul,i2c_master.scl,1);
   i2c_master.sda :> sda_high;
   //printf("\n Value of ack = %d\n", ack[2]);
   return (1);
}

void wait_func(int div_factor, unsigned int clock_mul,port scl,int edge){
	unsigned int time;
	timer gt;
	int i;
	gt :> time;
	time += ((I2C_BIT_TIME / div_factor)* clock_mul);
	if(edge){
		select {
		case scl when pinseq(0) :> void :
			i=0;
			break;
		case gt when timerafter(time) :> void :
			i=1;
			break;
		}
	} else gt when timerafter(time) :> void;
}
