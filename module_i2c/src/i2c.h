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
#define I2C_BIT_TIME 250
#define I2C_MASTER_TX
#endif



struct r_i2c {
	port scl;
	port sda;
};


struct i2c_data_info {
	unsigned int data[100];
	unsigned int data_len;
	unsigned int master_num;
	unsigned int clock_mul;
};

void i2c_master_init(struct r_i2c &i2c_master);
int i2c_master_rx(int device, int sub_addr, struct i2c_data_info &i2c_data,struct r_i2c &i2c_master);
int i2c_master_tx(int device, int sub_addr, struct i2c_data_info &i2c_data, struct r_i2c &i2c_master);

void i2c_slave_init(struct r_i2c &i2c_slave);
int i2c_slave_rx(int dev_addr, struct i2c_data_info &i2c_data_slave, struct r_i2c &i2c_slave);
int i2c_slave_tx(int dev_addr, int sub_addr, struct i2c_data_info &i2c_slave_data, struct r_i2c &i2c_slave);

void wait_func(int div_factor, unsigned int clock_mul,port scl,int edge);

#endif
