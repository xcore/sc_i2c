// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

                                   
///////////////////////////////////////////////////////////////////////////////
//
// I2C master

#include <xs1.h>
#include "i2c.h"

void i2c_master_init(struct r_i2c &i2c_master)
{
	// Set the ports into idle
	i2c_master.scl <: 1;
	i2c_master.sda <: 1;
}

#ifndef I2C_TI_COMPATIBILITY
int i2c_master_rx(int addr, int device, struct i2c_data_info &data, struct r_i2c &i2c)
{
  //   int result;
   timer gt;
   unsigned time;
   int Temp, CtlAdrsData, i;
   // three device ACK
   int ack[3];
   int rdData;



   // initial values.
   i2c.scl <: 1;
   i2c.sda  <: 1;
   sync(i2c.sda);
   gt :> time;
   time += I2C_BIT_TIME;
   gt when timerafter(time) :> int _;
   // start bit on SDI
   i2c.scl <: 1;
   i2c.sda  <: 0;
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> int _;
   i2c.scl <: 0;
   // shift 7bits of address and 1bit R/W (fixed to write).
   // WARNING: Assume MSB first.
   for (i = 0; i < 8; i += 1)
   {
      Temp = (device >> (7 - i)) & 0x1;
      i2c.sda <: Temp;
      gt :> time;
      time += (I2C_BIT_TIME / 2);
      gt when timerafter(time) :> int _;
      i2c.scl <: 1;
      gt :> time;
      time += (I2C_BIT_TIME / 2);
      gt when timerafter(time) :> int _;
      i2c.scl <: 0;
   }
   // turn the data to input
   i2c.sda :> Temp;
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> int _;
   i2c.scl <: 1;
   // sample first ACK.
   i2c.sda :> ack[0];
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> int _;
   i2c.scl <: 0;

   CtlAdrsData = (addr & 0xFF);

   // shift first 8 bits.
   for (i = 0; i < 8; i += 1)
   {
      Temp = (CtlAdrsData >> (7 - i)) & 0x1;
      i2c.sda <: Temp;
      gt :> time;
      time += (I2C_BIT_TIME / 2);
      gt when timerafter(time) :> int _;
      i2c.scl <: 1;
      gt :> time;
      time += (I2C_BIT_TIME / 2);
      gt when timerafter(time) :> int _;
      i2c.scl <: 0;
   }
   // turn the data to input
   i2c.sda :> Temp;
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> int _;
   i2c.scl <: 1;
   // sample second ACK.
   i2c.sda :> ack[1];
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> int _;
   i2c.scl <: 0;


   // stop bit
   gt :> time;
   time += I2C_BIT_TIME;
   gt when timerafter(time) :> int _;
   // start bit on SDI
   i2c.scl <: 1;
   i2c.sda  <: 1;
   time += I2C_BIT_TIME;
   gt when timerafter(time) :> int _;
   i2c.scl <: 0;
   time += I2C_BIT_TIME;
   gt when timerafter(time) :> int _;


   // send address and read
   i2c.scl <: 1;
   i2c.sda  <: 1;
   sync(i2c.sda);
   gt :> time;
   time += I2C_BIT_TIME;
   gt when timerafter(time) :> int _;
   // start bit on SDI
   i2c.scl <: 1;
   i2c.sda  <: 0;
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> int _;
   i2c.scl <: 0;
   // shift 7bits of address and 1bit R/W (fixed to write).
   // WARNING: Assume MSB first.
   for (i = 0; i < 8; i += 1)
   {
      int deviceAddr = device | 1;
      Temp = (deviceAddr >> (7 - i)) & 0x1;
      i2c.sda <: Temp;
      gt :> time;
      time += (I2C_BIT_TIME / 2);
      gt when timerafter(time) :> int _;
      i2c.scl <: 1;
      gt :> time;
      time += (I2C_BIT_TIME / 2);
      gt when timerafter(time) :> int _;
      i2c.scl <: 0;
   }
   // turn the data to input
   i2c.sda :> Temp;
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> int _;
   i2c.scl <: 1;
   // sample first ACK.
   i2c.sda :> ack[0];
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> int _;
   i2c.scl <: 0;


   rdData = 0;
   // shift second 8 bits.
   for (i = 0; i < 8; i += 1)
   {

      gt :> time;
      time += (I2C_BIT_TIME / 2);
      gt when timerafter(time) :> int _;
      i2c.scl <: 1;

      i2c.sda :> Temp;
      rdData = (rdData << 1) | (Temp & 1);

      gt :> time;
      time += (I2C_BIT_TIME / 2);
      gt when timerafter(time) :> int _;
      i2c.scl <: 0;
   }

   // turn the data to input
   i2c.sda :> Temp;
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> int _;
   i2c.scl <: 1;
   // sample second ACK.
   i2c.sda :> ack[2];
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> int _;
   i2c.scl <: 0;
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> int _;
   i2c.scl <: 1;
   // put the data to a good value for next round.
   i2c.sda  <: 1;
   // validate all items are ACK properly.
   //Result = 0;
   //for (i = 0; i < 3; i += 1)
   //{
      //if ((ack[i]&1) != 0)
      //{
         //Result = Result | (1 << i);
      //}
   //}
   data.data[0] = rdData;
   data.data_len = 8;
   return 1;
}
#endif

int i2c_master_tx(int addr, int device, struct i2c_data_info &s_data, struct r_i2c &i2c)
{
   timer gt;
   int data = s_data.data[0];
   unsigned time;
   int Temp, CtlAdrsData, i;
   // three device ACK
   int ack[3];

   // initial values.
   i2c.scl <: 1;
   i2c.sda  <: 1;
   sync(i2c.sda);

   gt :> time;
   time += I2C_BIT_TIME;
   gt when timerafter(time) :> void;

   // start bit on SDI
   i2c.scl <: 1;
   i2c.sda  <: 0;
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> void;
   i2c.scl <: 0;

   // shift 7bits of address and 1bit R/W (fixed to write).
   // WARNING: Assume MSB first.
   for (i = 0; i < 8; i += 1)
   {
      Temp = (device >> (7 - i)) & 0x1;
      i2c.sda <: Temp;
      gt :> time;
      time += (I2C_BIT_TIME / 2);
      gt when timerafter(time) :> void;
      i2c.scl <: 1;
      gt :> time;
      time += (I2C_BIT_TIME / 2);
      gt when timerafter(time) :> void;
      i2c.scl <: 0;
   }

   // turn the data to input
   i2c.sda :> Temp;
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> void;
   i2c.scl <: 1;

   // sample first ACK.
   i2c.sda :> ack[0];
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> void;
   i2c.scl <: 0;

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
      i2c.sda <: Temp;
      gt :> time;
      time += (I2C_BIT_TIME / 2);
      gt when timerafter(time) :> void;
      i2c.scl <: 1;
      gt :> time;
      time += (I2C_BIT_TIME / 2);
      gt when timerafter(time) :> void;
      i2c.scl <: 0;
   }
   // turn the data to input
   i2c.sda :> Temp;
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> void;
   i2c.scl <: 1;
   // sample second ACK.
   i2c.sda :> ack[1];
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> void;
   i2c.scl <: 0;

#ifdef I2C_TI_COMPATIBILITY

#else
   CtlAdrsData = (data & 0xFF);
#endif
   // shift second 8 bits.
   for (i = 0; i < 8; i += 1)
   {
      Temp = (CtlAdrsData >> (7 - i)) & 0x1;
      i2c.sda <: Temp;
      gt :> time;
      time += (I2C_BIT_TIME / 2);
      gt when timerafter(time) :> void;
      i2c.scl <: 1;
      gt :> time;
      time += (I2C_BIT_TIME / 2);
      gt when timerafter(time) :> void;
      i2c.scl <: 0;
   }
   // turn the data to input
   i2c.sda :> Temp;
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> void;
   i2c.scl <: 1;
   // sample second ACK.
   i2c.sda :> ack[2];
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> void;
   i2c.scl <: 0;
   gt :> time;
   time += (I2C_BIT_TIME / 2);
   gt when timerafter(time) :> void;
   i2c.scl <: 1;
   // put the data to a good value for next round.
   i2c.sda  <: 1;

   return ((ack[0]==0) && (ack[1]==0) && (ack[2]==0));   
}
