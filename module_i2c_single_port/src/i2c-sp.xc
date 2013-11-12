// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

// I2C master

#include <xs1.h>
#include <xclib.h>
#include <stdio.h>
#include "i2c.h"

#define SDA_LOW     0
#define SCL_LOW     0

void i2c_master_init(port i2c) {
    i2c :> void;    // Drive all high
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

static void highPulseDrive(port i2c, int sdaValue) {
    if (sdaValue) {
        i2c <: SDA_HIGH | SCL_LOW | S_REST;
        waitQuarter();
        i2c :> void;
        waitHalf();
        i2c <: SDA_HIGH | SCL_LOW | S_REST;
        waitQuarter();
    } else {
        i2c <: SDA_LOW | SCL_LOW | S_REST;
        waitQuarter();
        i2c <: SDA_LOW | SCL_HIGH | S_REST;
        waitHalf();
        i2c <: SDA_LOW | SCL_LOW | S_REST;
        waitQuarter();
    }
}

static int highPulseSample(port i2c, int expectedSDA) {
    i2c <: (expectedSDA ? SDA_HIGH : 0) | SCL_LOW | S_REST;
    waitQuarter();
    i2c :> void;
    waitQuarter();
    expectedSDA = peek(i2c) & SDA_HIGH;
    waitQuarter();
    i2c <: expectedSDA | SCL_LOW | S_REST;
    waitQuarter();
    return expectedSDA;
}

static void startBit(port i2c) {
    waitQuarter();
    i2c <: SDA_LOW | SCL_HIGH | S_REST;
    waitHalf();
    i2c <: SDA_LOW | SCL_LOW | S_REST;
    waitQuarter();
}

static void stopBit(port i2c) {
    i2c <: SDA_LOW | SCL_LOW | S_REST;
    waitQuarter();
    i2c <: SDA_LOW | SCL_HIGH | S_REST;
    waitHalf();
    i2c :> void;
    waitQuarter();
}

static int tx8(port i2c, unsigned data) {
    int ack;
    unsigned CtlAdrsData = ((unsigned) bitrev(data)) >> 24;
    for (int i = 8; i != 0; i--) {
        highPulseDrive(i2c, CtlAdrsData & 1);
        CtlAdrsData >>= 1;
    }
    ack = highPulseSample(i2c, 0);
    return ack != 0;
}

int i2c_master_write_reg(int device, int addr, unsigned char s_data[], int nbytes, port i2c) {
   int data;
   int ack;

   startBit(i2c);
   ack = tx8(i2c, device);
#ifdef I2C_TI_COMPATIBILITY
   ack |= tx8(i2c, addr << 1 | (data >> 8) & 1);
#else
   ack |= tx8(i2c, addr);
#endif
   for(int i = 0; i< nbytes; i++) {
      data = s_data[i];
      ack |= tx8(i2c, data);
   }
   stopBit(i2c);
   return ack == 0;
}
