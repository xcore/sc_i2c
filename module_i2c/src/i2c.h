///////////////////////////////////////////////////////////////////////////////
//
// I2C master
// Version 1.0
// 8 Dec 2009
//
// i2c.h
//
// Limitations: ACK not returned


#ifndef _i2c_master_h_
#define _i2c_master_h_

#include <xs1.h>
#include <platform.h>
// I2C clock frequency is fref/I2C_BIT_TIME
// where fref defaults to 100MHz
#ifndef I2C_BIT_TIME
#define I2C_BIT_TIME 1000
#endif



struct r_i2c {
	port scl;
	port sda;
};


struct i2c_data_info {
	unsigned int data[100];
	unsigned int data_len;
};

int i2c_master_rx(int addr, int device, struct i2c_data_info &i2c_data,struct r_i2c &i2c_master);
int i2c_master_tx(int addr, int device, struct i2c_data_info &i2c_data, struct r_i2c &i2c_master);
int i2c_slave_rx(int dev_addr, struct i2c_data_info &i2c_data_slave, struct r_i2c &i2c_slave,out port st_det);

#endif
