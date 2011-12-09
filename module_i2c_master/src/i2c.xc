// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

// I2C master, complete.

#include <xs1.h>
#include <xclib.h>
#include "i2c.h"

void i2c_master_init(struct r_i2c &i2c_master) {
	i2c_master.scl :> void;
    i2c_master.sda :> void;
}

static void waitQuarter(struct r_i2c &i2c) {
    timer gt;
    int time;

    gt :> time;
    time += i2c.clockTicks >> 2;
    gt when timerafter(time) :> int _;
}

static void waitHalf(struct r_i2c &i2c) {
    waitQuarter(i2c);
    waitQuarter(i2c);
}

static int highPulse(struct r_i2c &i2c, int doSample) {
    int temp;
    if (doSample) {
        i2c.sda :> int _;
    }
    waitQuarter(i2c);
    i2c.scl when pinseq(1) :> void;
    waitQuarter(i2c);
    if (doSample) {
        i2c.sda :> temp;
    }
    waitQuarter(i2c);
    i2c.scl <: 0;
    waitQuarter(i2c);
    return temp;
}

static void startBit(struct r_i2c &i2c) {
    waitQuarter(i2c);
    i2c.sda  <: 0;
    waitHalf(i2c);
    i2c.scl  <: 0;
    waitQuarter(i2c);
}

static void stopBit(struct r_i2c &i2c) {
    i2c.sda <: 0;
    waitQuarter(i2c);
    i2c.scl when pinseq(1) :> void;
    waitHalf(i2c);
    i2c.sda :> void;
    waitQuarter(i2c);
}

static int tx8(struct r_i2c &i2c, unsigned data) {
    unsigned CtlAdrsData = ((unsigned) bitrev(data)) >> 24;
    for (int i = 8; i != 0; i--) {
        if (CtlAdrsData & 1) {
           // High, let float
           i2c.sda :> void;
           CtlAdrsData >>= 1;
        } else {
           // Low, drive
           i2c.sda <: >> CtlAdrsData;
        }
        highPulse(i2c, 0);
    }
    return highPulse(i2c, 1);
}

// TODO: use I2C_MASTER_NUM

#ifndef I2C_TI_COMPATIBILITY
int i2c_master_rx(int device, unsigned char data[], int nbytes, struct r_i2c &i2c) {
   int i;
   int rdData = 0;

   startBit(i2c);
   tx8(i2c, device | 1);
   for(int j = 0; j < nbytes; j++) {
       for (i = 8; i != 0; i--) {
           int temp = highPulse(i2c, 1);
           rdData = (rdData << 1) | temp;
       }
       if (j != nbytes - 1) {
           i2c.sda <: 0;
           highPulse(i2c, 0);
       } else {
           highPulse(i2c, 1);
       }
       data[j] = rdData;
   }
   stopBit(i2c);
   return 1;
}

int i2c_master_read_reg(int device, int addr, unsigned char data[], int nbytes, struct r_i2c &i2c) {
   int i;
   int rdData = 0;

   startBit(i2c);
   tx8(i2c, device);
   tx8(i2c, addr);
   stopBit(i2c);   
   return i2c_master_rx(device, data, nbytes, i2c);
}

#endif

int i2c_master_write_reg(int device, int addr, unsigned char s_data[], int nbytes, struct r_i2c &i2c) {
   int data = s_data[0];
   int ack;

   startBit(i2c);
   ack = tx8(i2c, device);
#ifdef I2C_TI_COMPATIBILITY
   ack |= tx8(i2c, addr << 1 | (data >> 8) & 1);
#else
   ack |= tx8(i2c, addr);
#endif
   for(int j = 0; j < nbytes; j++) {
       ack |= tx8(i2c, s_data[j]);
   }
   stopBit(i2c);
   return ack == 0;
}
