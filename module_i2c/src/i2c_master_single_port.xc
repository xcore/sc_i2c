// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#include "i2c.h"
#include <xs1.h>
#include <xclib.h>
#include <stdio.h>
#include "xassert.h"

#define SDA_LOW     0
#define SCL_LOW     0

static void wait_quarter(void) {
    timer gt;
    int time;

    gt :> time;
    time += (I2C_BIT_TIME + 3) / 4;
    gt when timerafter(time) :> int _;
}

static void wait_half(void) {
    wait_quarter();
    wait_quarter();
}

static void high_pulse_drive(port p_i2c, int sdaValue) {
    if (sdaValue) {
        p_i2c <: SDA_HIGH | SCL_LOW | S_REST;
        wait_quarter();
        p_i2c :> void;
        wait_half();
        p_i2c <: SDA_HIGH | SCL_LOW | S_REST;
        wait_quarter();
    } else {
        p_i2c <: SDA_LOW | SCL_LOW | S_REST;
        wait_quarter();
        p_i2c <: SDA_LOW | SCL_HIGH | S_REST;
        wait_half();
        p_i2c <: SDA_LOW | SCL_LOW | S_REST;
        wait_quarter();
    }
}

static int high_pulse_sample(port p_i2c, int expectedSDA) {
    p_i2c <: (expectedSDA ? SDA_HIGH : 0) | SCL_LOW | S_REST;
    wait_quarter();
    p_i2c :> void;
    wait_quarter();
    expectedSDA = peek(p_i2c) & SDA_HIGH;
    wait_quarter();
    p_i2c <: expectedSDA | SCL_LOW | S_REST;
    wait_quarter();
    return expectedSDA;
}

static void start_bit(port p_i2c) {
    wait_quarter();
    p_i2c <: SDA_LOW | SCL_HIGH | S_REST;
    wait_half();
    p_i2c <: SDA_LOW | SCL_LOW | S_REST;
    wait_quarter();
}

static void stop_bit(port p_i2c) {
    p_i2c <: SDA_LOW | SCL_LOW | S_REST;
    wait_quarter();
    p_i2c <: SDA_LOW | SCL_HIGH | S_REST;
    wait_half();
    p_i2c :> void;
    wait_quarter();
}

static int tx8(port p_i2c, unsigned data) {
    int ack;
    unsigned CtlAdrsData = ((unsigned) bitrev(data)) >> 24;
    for (int i = 8; i != 0; i--) {
        high_pulse_drive(p_i2c, CtlAdrsData & 1);
        CtlAdrsData >>= 1;
    }
    ack = high_pulse_sample(p_i2c, 0);
    return ack != 0;
}

[[distributable]]
void i2c_master_single_port(server interface i2c_master_if c[n], unsigned n,
                            port p_i2c) {
  p_i2c :> void;    // Drive all high
  while (1) {
    select {
    case c[int i].rx(unsigned device, unsigned char buf[n], unsigned n):
      fail("error: single port version of i2c does not support read operations");
      break;
    case c[int i].read_reg(unsigned device, unsigned addr) -> char data:
      fail("error: single port version of i2c does not support read operations");     break;

    case c[int i].tx(unsigned char buf[n], unsigned n) -> i2c_write_res_t result:
      int ack = 0;
      start_bit(p_i2c);
      for (int j = 0; j < n; j++)
        ack |= tx8(p_i2c, buf[j]);
      stop_bit(p_i2c);
      result = (ack == 0) ? I2C_WRITE_ACK_SUCCEEDED : I2C_WRITE_ACK_FAILED;
      break;

    case c[int i].write_reg(unsigned device,
                            unsigned addr,
                            char data)        -> i2c_write_res_t result:
      start_bit(p_i2c);
      int ack;
      ack = tx8(p_i2c, device);
      ack |= tx8(p_i2c, addr);
      ack |= tx8(p_i2c, data);
      stop_bit(p_i2c);
      result = (ack == 0) ? I2C_WRITE_ACK_SUCCEEDED : I2C_WRITE_ACK_FAILED;
      break;
    }
  }
}
