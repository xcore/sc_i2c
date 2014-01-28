// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#include "i2c.h"
#include <xs1.h>
#include <xclib.h>
#include <stdio.h>
#include <timer.h>
#include "xassert.h"

#define SDA_LOW     0
#define SCL_LOW     0

static inline void wait_quarter(unsigned bit_time) {
    delay_ticks((bit_time + 3)/4);
}

static inline void wait_half(unsigned bit_time) {
    delay_ticks((bit_time + 3)/2);
    wait_quarter(bit_time);
    wait_quarter(bit_time);
}

static void high_pulse_drive(port p_i2c, int sdaValue, unsigned bit_time,
                             unsigned SDA_HIGH, unsigned SCL_HIGH,
                             unsigned S_REST) {
    if (sdaValue) {
        p_i2c <: SDA_HIGH | SCL_LOW | S_REST;
        wait_quarter(bit_time);
        p_i2c :> void;
        wait_half(bit_time);
        p_i2c <: SDA_HIGH | SCL_LOW | S_REST;
        wait_quarter(bit_time);
    } else {
        p_i2c <: SDA_LOW | SCL_LOW | S_REST;
        wait_quarter(bit_time);
        p_i2c <: SDA_LOW | SCL_HIGH | S_REST;
        wait_half(bit_time);
        p_i2c <: SDA_LOW | SCL_LOW | S_REST;
        wait_quarter(bit_time);
    }
}

static int high_pulse_sample(port p_i2c, int expectedSDA, unsigned bit_time,
                             unsigned SDA_HIGH, unsigned SCL_HIGH,
                             unsigned S_REST) {
    p_i2c <: (expectedSDA ? SDA_HIGH : 0) | SCL_LOW | S_REST;
    wait_quarter(bit_time);
    p_i2c :> void;
    wait_quarter(bit_time);
    expectedSDA = peek(p_i2c) & SDA_HIGH;
    wait_quarter(bit_time);
    p_i2c <: expectedSDA | SCL_LOW | S_REST;
    wait_quarter(bit_time);
    return expectedSDA;
}

static void start_bit(port p_i2c, unsigned bit_time,
                      unsigned SDA_HIGH, unsigned SCL_HIGH,
                      unsigned S_REST) {
    wait_quarter(bit_time);
    p_i2c <: SDA_LOW | SCL_HIGH | S_REST;
    wait_half(bit_time);
    p_i2c <: SDA_LOW | SCL_LOW | S_REST;
    wait_quarter(bit_time);
}

static void stop_bit(port p_i2c, unsigned bit_time,
                     unsigned SDA_HIGH, unsigned SCL_HIGH,
                     unsigned S_REST) {
    p_i2c <: SDA_LOW | SCL_LOW | S_REST;
    wait_quarter(bit_time);
    p_i2c <: SDA_LOW | SCL_HIGH | S_REST;
    wait_half(bit_time);
    p_i2c :> void;
    wait_quarter(bit_time);
}

static int tx8(port p_i2c, unsigned data, unsigned bit_time,
               unsigned SDA_HIGH, unsigned SCL_HIGH,
               unsigned S_REST) {
    int ack;
    unsigned CtlAdrsData = ((unsigned) bitrev(data)) >> 24;
    for (int i = 8; i != 0; i--) {
      high_pulse_drive(p_i2c, CtlAdrsData & 1,
                       bit_time, SDA_HIGH, SCL_LOW, S_REST);
      CtlAdrsData >>= 1;
    }
    ack = high_pulse_sample(p_i2c, 0,
                            bit_time, SDA_HIGH, SCL_LOW, S_REST);
    return ack != 0;
}

[[distributable]]
void i2c_master_single_port(server interface i2c_master_if c[n], unsigned n,
                            port p_i2c,
                            unsigned kbits_per_second,
                            unsigned sda_bit_position,
                            unsigned scl_bit_position,
                            unsigned other_bits_mask) {
  unsigned bit_time = (XS1_TIMER_MHZ * 1000) / kbits_per_second;
  unsigned SDA_HIGH = (1 << sda_bit_position);
  unsigned SCL_HIGH = (1 << scl_bit_position);
  p_i2c :> void;    // Drive all high
  while (1) {
    select {
    case c[int i].rx(uint8_t device, uint8_t buf[n], size_t n):
      fail("error: single port version of i2c does not support read operations");
      break;
    case c[int i].tx(uint8_t device, uint8_t buf[n], size_t n)
                                                    -> i2c_write_res_t result:
      start_bit(p_i2c, bit_time, SDA_HIGH, SCL_HIGH, other_bits_mask);
      int ack;
      ack = tx8(p_i2c, device, bit_time, SDA_HIGH, SCL_HIGH, other_bits_mask);
      for (int j = 0; j < n; j++) {
        ack |= tx8(p_i2c, buf[j], bit_time,
                   SDA_HIGH, SCL_HIGH, other_bits_mask);
      }

      stop_bit(p_i2c, bit_time, SDA_HIGH, SCL_HIGH, other_bits_mask);
      result = (ack == 0) ? I2C_WRITE_ACK_SUCCEEDED : I2C_WRITE_ACK_FAILED;
      break;
    }
  }
}
