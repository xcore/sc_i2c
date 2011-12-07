// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

///////////////////////////////////////////////////////////////////////////////
//
// I2C master
// Version 1.0
// 8 Dec 2009
//
// i2c.h
//
// Limitations: ACK not returned


#ifndef _i2c_h_
#define _i2c_h_

#include <xs1.h>
#include <xccompat.h>

// I2C clock frequency is fref/I2C_BIT_TIME
// where fref defaults to 100MHz
#ifndef I2C_BIT_TIME
#define I2C_BIT_TIME 1000
#else
#error blah
#endif
#ifndef I2C_MAX_DATA
#define I2C_MAX_DATA 1
#endif

struct r_i2c {
  out port scl;
  port sda;
};

struct i2c_data_info {              // TODO: remove structure, make two reference parameters.
	unsigned int data[I2C_MAX_DATA];
	unsigned int data_len;
	unsigned int master_num;        // Value not used.
	unsigned int clock_mul;         // Value not used.
};

void i2c_master_init(REFERENCE_PARAM(struct r_i2c,i2c_master));

#ifndef I2C_TI_COMPATIBILITY
int i2c_master_rx(int device, int sub_addr,
                  REFERENCE_PARAM(struct i2c_data_info, i2c_data),
                  REFERENCE_PARAM(struct r_i2c, i2c_master));
#endif

int i2c_master_tx(int device, int sub_addr,
                  REFERENCE_PARAM(struct i2c_data_info, i2c_data),
                  REFERENCE_PARAM(struct r_i2c, i2c_master));

//int i2c_rd(int addr, int device, struct r_i2c &i2c);
//int i2c_wr(int addr, int data, int device, struct r_i2c &i2c);

#endif
