///////////////////////////////////////////////////////////////////////////////
//
// I2C master

#include <xs1.h>
#include <platform.h>
#include <stdio.h>
#include "i2c.h"

#ifndef I2C_TI_COMPATIBILITY

int i2c_master_rd(int addr, int device, struct i2c_data_info &i2c_data, struct r_i2c &i2c_master)
{
   timer gt;
   unsigned time;
   int Temp, CtlAdrsData, i,j;
   // three device ACK
   int ack[3];
   int rdData;
   int high_state;

   //set_port_pull_up(i2c.scl);
   //set_port_pull_up(i2c.sda);
   set_port_pull_up(i2c_master.scl);
   set_port_pull_up(i2c_master.sda);
   // initial values.
   i2c_master.scl <: 1;
   //i2c_master.sda  <: 1;
   i2c_master.sda :> high_state;
   sync(i2c_master.sda);
   gt :> time;
   time += I2C_BIT_TIME;
   gt when timerafter(time) :> int _;
   // start bit on SDI
   i2c_master.scl <: 1;
   i2c_master.sda  <: 0;
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> int _;
   i2c_master.scl <: 0;
   // shift 7bits of address and 1bit R/W (fixed to write).
   // WARNING: Assume MSB first.
   for (i = 0; i < 8; i += 1)
   {
      Temp = (device >> (7 - i)) & 0x1;
      if(Temp ==0) i2c_master.sda <: Temp;
      else i2c_master.sda :> high_state;
      gt :> time;
      time += (I2C_BIT_TIME / 2);
      gt when timerafter(time) :> int _;
      i2c_master.scl <: 1;
      gt :> time;
      time += (I2C_BIT_TIME / 2);
      gt when timerafter(time) :> int _;
      i2c_master.scl <: 0;
   }
   // turn the data to input
   i2c_master.sda :> Temp;
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> int _;
   i2c_master.scl <: 1;
   // sample first ACK.
   i2c_master.sda :> ack[0];
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> int _;
   i2c_master.scl <: 0;

   CtlAdrsData = (addr & 0xFF);

   // shift first 8 bits.
   for (i = 0; i < 8; i += 1)
   {
      Temp = (CtlAdrsData >> (7 - i)) & 0x1;
      if(Temp ==0) i2c_master.sda <: Temp;
      else i2c_master.sda :> high_state;
      gt :> time;
      time += (I2C_BIT_TIME / 2);
      gt when timerafter(time) :> int _;
      i2c_master.scl <: 1;
      gt :> time;
      time += (I2C_BIT_TIME / 2);
      gt when timerafter(time) :> int _;
      i2c_master.scl <: 0;
   }
   // turn the data to input
   i2c_master.sda :> Temp;
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> int _;
   i2c_master.scl <: 1;
   // sample second ACK.
   i2c_master.sda :> ack[1];
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> int _;
   i2c_master.scl <: 0;


   // stop bit
   gt :> time;
   time += I2C_BIT_TIME;
   gt when timerafter(time) :> int _;
   // start bit on SDI
   i2c_master.scl <: 1;
   i2c_master.sda :> high_state;
   time += I2C_BIT_TIME;
   gt when timerafter(time) :> int _;
   i2c_master.scl <: 0;
   time += I2C_BIT_TIME;
   gt when timerafter(time) :> int _;


   // send address and read
   i2c_master.scl <: 1;
   i2c_master.sda :> high_state;
   sync(i2c_master.sda);
   gt :> time;
   time += I2C_BIT_TIME;
   gt when timerafter(time) :> int _;
   // start bit on SDI
   i2c_master.scl <: 1;
   i2c_master.sda  <: 0;
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> int _;
   i2c_master.scl <: 0;
   // shift 7bits of address and 1bit R/W (fixed to write).
   // WARNING: Assume MSB first.
   for (i = 0; i < 8; i += 1)
   {
      int deviceAddr = device | 1;
      Temp = (deviceAddr >> (7 - i)) & 0x1;
      i2c_master.sda <: Temp;
      gt :> time;
      time += (I2C_BIT_TIME / 2);
      gt when timerafter(time) :> int _;
      i2c_master.scl <: 1;
      gt :> time;
      time += (I2C_BIT_TIME / 2);
      gt when timerafter(time) :> int _;
      i2c_master.scl <: 0;
   }
   // turn the data to input
   i2c_master.sda :> Temp;
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> int _;
   i2c_master.scl <: 1;
   // sample first ACK.
   i2c_master.sda :> ack[0];
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> int _;
   i2c_master.scl <: 0;


   rdData = 0;
   // shift second 8 bits.
   for (j=0; j < i2c_data.data_len; j++){
	   for (i = 0; i < 8; i += 1)
	   {
		   gt :> time;
		   time += (I2C_BIT_TIME / 2);
		   gt when timerafter(time) :> int _;
		   i2c_master.scl <: 1;

		   i2c_master.sda :> Temp;
		   rdData = (rdData << 1) | (Temp & 1);

		   gt :> time;
		   time += (I2C_BIT_TIME / 2);
		   gt when timerafter(time) :> int _;
		   i2c_master.scl <: 0;

		   //Send ACK
		   if(j <(i2c_data.data_len-1)){
			   i2c_master.sda <: 0;

			   gt :> time;
			   time += (I2C_BIT_TIME / 2);
			   gt when timerafter(time) :> int _;
			   i2c_master.scl <: 1;

			   gt :> time;
			   time += (I2C_BIT_TIME / 2);
			   gt when timerafter(time) :> int _;
			   i2c_master.scl <: 0;
		   }
	   }
	   i2c_data.data[j]=rdData;
   }

   //Send Stop
   i2c_master.sda <: 0;

   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> int _;
   i2c_master.scl <: 1;

   gt :> time;
   time += (I2C_BIT_TIME / 4);
   gt when timerafter(time) :> int _;
   i2c_master.sda :> high_state;


   return rdData;
}
#endif

//int i2c_wr(int addr, int data, int device, struct r_i2c &i2c)
int i2c_master_wr(int addr, int device, struct i2c_data_info &i2c_data, struct r_i2c &i2c_master)
{
   timer gt;
   unsigned time;
   int Temp, CtlAdrsData, i;
   // three device ACK
   int ack[3];
   unsigned int data;
   unsigned int j;
   unsigned int temp;
   int high_state;
   set_port_pull_up(i2c_master.scl);
   set_port_pull_up(i2c_master.sda);

   // initial values.
   i2c_master.scl <: 1;
   i2c_master.sda :> high_state;
   sync(i2c_master.sda);
   i2c_master.scl <: 1;
   gt :> time;
   time += I2C_BIT_TIME;
   gt when timerafter(time) :> void;

   // start bit on SDI
   i2c_master.scl <: 1;
   i2c_master.sda  <: 0;
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> void;
   i2c_master.scl <: 0;

   // shift 7bits of address and 1bit R/W (fixed to write).
   // WARNING: Assume MSB first.
   for (i = 0; i < 8; ++i)
   {
      Temp = (device >> (7 - i)) & 0x1;
      if(!Temp) i2c_master.sda <: Temp;
      else i2c_master.sda :> high_state;
      gt :> time;
      time += (I2C_BIT_TIME / 2);
      gt when timerafter(time) :> void;
      i2c_master.scl <: 1;
      //i2c_master.scl :> Temp;
      i2c_master.scl when pinseq(1) :> void;
      gt :> time;
      time += (I2C_BIT_TIME / 2);
      gt when timerafter(time) :> void;
      i2c_master.scl <: 0;
   }

   // turn the data to input
   i2c_master.sda :> Temp;
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> void;
   i2c_master.scl <: 1;

   // sample first ACK.
   i2c_master.sda :> ack[0];
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> void;
   i2c_master.scl <: 0;
   i2c_master.sda <: 0;

#ifdef I2C_TI_COMPATIBILITY
   CtlAdrsData = ((addr & 0x7F) << 9) | (data & 0x1FF);
#else
   CtlAdrsData = (addr & 0xFF);
#endif

   // shift first 8 bits.
   for (i = 0; i < 8; i += 1)
   {
#ifdef I2C_TI_COMPATIBILITY
      Temp = (CtlAdrsData >> (15 - i)) & 0x1;
#else
      Temp = (CtlAdrsData >> (7 - i)) & 0x1;
#endif
      if(!Temp) i2c_master.sda <: Temp;
      else i2c_master.sda :> high_state;
      gt :> time;
      time += (I2C_BIT_TIME / 2);
      gt when timerafter(time) :> void;
      i2c_master.scl <: 1;
      gt :> time;
      time += (I2C_BIT_TIME / 2);
      gt when timerafter(time) :> void;
      i2c_master.scl <: 0;
   }
   // turn the data to input
   i2c_master.sda :> Temp;
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> void;
   i2c_master.scl <: 1;
   // sample second ACK.
   i2c_master.sda :> ack[1];
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> void;
   i2c_master.scl <: 0;
   i2c_master.sda <: 0;

#ifdef I2C_TI_COMPATIBILITY

#else
   CtlAdrsData = (data & 0xFF);
#endif
   // shift second 8 bits.
   for(j=0; j < i2c_data.data_len; j++){
	   CtlAdrsData = (i2c_data.data[j] & 0xFF);
	   for (i = 0; i < 8; ++i)
	   {
		   Temp = (CtlAdrsData >> (7 - i)) & 0x1;
		   if(!Temp) i2c_master.sda <: Temp;
		   else i2c_master.sda :> high_state;
		   gt :> time;
		   time += (I2C_BIT_TIME / 2);
		   gt when timerafter(time) :> void;
		   i2c_master.scl <: 1;
		   gt :> time;
		   time += (I2C_BIT_TIME / 2);
		   gt when timerafter(time) :> void;
		   i2c_master.scl <: 0;
	   }
	   // turn the data to input
	   i2c_master.sda :> Temp;
	   gt :> time;
	   time += (I2C_BIT_TIME / 2);
	   gt when timerafter(time) :> void;
	   i2c_master.scl <: 1;
	   // sample second ACK.
	   i2c_master.sda :> ack[2];
	   gt :> time;
	   time += (I2C_BIT_TIME / 2);
	   gt when timerafter(time) :> void;
	   i2c_master.scl <: 0;
	   //ack[2]=0;
	   //i2c_master.sda <: 0;
	   if(ack[2] == 1)
		   break;
   }
   i2c_master.sda <: 0;
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> void;
   i2c_master.scl <: 1;
   // put the data to a good value for next round.
   time += (I2C_BIT_TIME / 4);
   gt when timerafter(time) :> void;
   i2c_master.sda :> high_state;
   //printf("\n Value of ack = %d\n", ack[2]);
   return ((ack[0]==0) && (ack[1]==0) && (ack[2]==0));   
}
