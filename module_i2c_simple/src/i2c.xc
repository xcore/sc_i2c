// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

// I2C master

#include <xs1.h>
#include <xclib.h>
#include "i2c.h"

void i2c_master_init(struct r_i2c &i2c_master) {
	i2c_master.scl :> void;
    i2c_master.sda :> void;
}

static void waitQuarter(void) {
    timer gt;
    int time;

    gt :> time;
    time += (I2C_BIT_TIME + 3) / 4;
    gt when timerafter(time) :> int _;
}

static void waitHalf(void) {
    waitQuarter();
    waitQuarter();
}

static void waitAfterNACK(port i2c_scl) {
    timer gt;
    int time;

    gt :> time;
    time += (I2C_REPEATED_START_DELAY * XS1_TIMER_MHZ); // I2C_REPEATED_START_DELAY in us
    gt when timerafter(time) :> int _;

    i2c_scl :> void; // Allow SCL to float high ahead of repeated start bit
}

static int highPulseSample(port i2c_scl, port ?i2c_sda) {
    int temp;
    if (!isnull(i2c_sda)) {
        i2c_sda :> int _;
    }
    waitQuarter();
    i2c_scl :> void;
    waitQuarter();
    if (!isnull(i2c_sda)) {
        i2c_sda :> temp;
    }
    waitQuarter();
    i2c_scl <: 0;
    waitQuarter();
    return temp;
}

static void highPulse(port i2c_scl) {
    highPulseSample(i2c_scl, null);
}

static void startBit(port i2c_scl, port i2c_sda) {
    waitQuarter();
    i2c_sda  <: 0;
    waitHalf();
    i2c_scl  <: 0;
    waitQuarter();
}

static void stopBit(port i2c_scl, port i2c_sda) {
    i2c_sda <: 0;
    waitQuarter();
    i2c_scl :> void;
    waitHalf();
    i2c_sda :> void;
    waitQuarter();
}

static int tx8(port i2c_scl, port i2c_sda, unsigned data) {
    unsigned CtlAdrsData = ((unsigned) bitrev(data)) >> 24;
    for (int i = 8; i != 0; i--) {
        //i2c_sda <: >> CtlAdrsData;
        i2c_sda <: CtlAdrsData & 1;
        CtlAdrsData >>= 1;
        highPulse(i2c_scl);
    }
    return highPulseSample(i2c_scl, i2c_sda);
}

#ifndef I2C_TI_COMPATIBILITY
int i2c_master_rx(int device, unsigned char data[], int nbytes, struct r_i2c &i2c) {
   int i;
   int rdData = 0;
   int temp = 0;
   if (I2C_REPEATED_START_ON_NACK) {
      int nacks = I2C_REPEATED_START_MAX_RETRIES;

      while (nacks) {
         startBit(i2c.scl, i2c.sda);
         if (!tx8(i2c.scl, i2c.sda, (device<<1) | 1)) {
            break;
         }
         waitAfterNACK(i2c.scl);
         nacks--;
      }
      if (!nacks) {
         stopBit(i2c.scl, i2c.sda);
         return 0;
      }
   } else {
      startBit(i2c.scl, i2c.sda);
      tx8(i2c.scl, i2c.sda, (device<<1) | 1);
   }

   for(int j = 0; j< nbytes; j++)
   {
       rdData = 0;
       for (i = 8; i != 0; i--) {
         temp = highPulseSample(i2c.scl, i2c.sda);
         rdData = (rdData << 1);
         if(temp) {
             rdData |= 1;
         }
      }
      data[j]= rdData;
      if(j != nbytes -1){
        i2c.sda <: 0; // Send an ACK
          (void) highPulse(i2c.scl);
      } else {
        (void) highPulseSample(i2c.scl, i2c.sda);
      }
   }
   stopBit(i2c.scl, i2c.sda);
   return 1;
}

int i2c_master_read_reg(int device, int addr, unsigned char data[], int nbytes, struct r_i2c &i2c) {
   if (I2C_REPEATED_START_ON_NACK) {
      int nacks = I2C_REPEATED_START_MAX_RETRIES;

      while (nacks) {
         startBit(i2c.scl, i2c.sda);
         if (!tx8(i2c.scl, i2c.sda, device<<1)) {
            break;
         }
         waitAfterNACK(i2c.scl);
         nacks--;
      }
      if (!nacks) {
         stopBit(i2c.scl, i2c.sda);
         return 0;
      }
   } else {
      startBit(i2c.scl, i2c.sda);
      tx8(i2c.scl, i2c.sda, device<<1);
   }
   tx8(i2c.scl, i2c.sda, addr);
   stopBit(i2c.scl, i2c.sda);
   return i2c_master_rx(device, data, nbytes, i2c);
}
#endif

int i2c_master_write_reg(int device, int addr, unsigned char s_data[], int nbytes, struct r_i2c &i2c) {
   int data = s_data[0];
   int ack;
   if (I2C_REPEATED_START_ON_NACK) {
      int nacks = I2C_REPEATED_START_MAX_RETRIES;

      while (nacks) {
         startBit(i2c.scl, i2c.sda);
         if (!(ack = tx8(i2c.scl, i2c.sda, device<<1))) {
            break;
         }
         waitAfterNACK(i2c.scl);
         nacks--;
      }
      if (!nacks) {
         stopBit(i2c.scl, i2c.sda);
         return 0;
      }
   } else {
      startBit(i2c.scl, i2c.sda);
      ack = tx8(i2c.scl, i2c.sda, device<<1);
   }
#ifdef I2C_TI_COMPATIBILITY
   ack |= tx8(i2c.scl, i2c.sda, addr << 1 | (data >> 8) & 1);
#else
   ack |= tx8(i2c.scl, i2c.sda, addr);
#endif
   for(int i = 0; i<nbytes; i++)
   {
      data = s_data[i];
      ack |= tx8(i2c.scl, i2c.sda, data);
   }

   stopBit(i2c.scl, i2c.sda);
   return ack == 0;
}
