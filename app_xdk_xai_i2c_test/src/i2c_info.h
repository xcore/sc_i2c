/*
 * i2c_info.h
 *
 *  Created on: Apr 5, 2011
 *      Author: m1003889
 */

#ifndef I2C_INFO_H_
#define I2C_INFO_H_

#include "i2c.h"
#include "i2c_test_def.h"

#ifdef MASTER1
	on stdcore[1] : struct r_i2c i2c_master1 = { XS1_PORT_1B, XS1_PORT_1A };
	struct i2c_data_info i2c_data1;
#endif

#ifdef MASTER2
	on stdcore[1] : struct r_i2c i2c_master2 = { XS1_PORT_1F, XS1_PORT_1E };
	struct i2c_data_info i2c_data2;
#endif

#ifdef SLAVE1
	on stdcore[1] : struct r_i2c i2c_slave1  = { XS1_PORT_1D, XS1_PORT_1C };
	struct i2c_data_info i2c_slave_data1;
#endif

#ifdef SLAVE2
	on stdcore[1] : struct r_i2c i2c_slave2  = { XS1_PORT_1G, XS1_PORT_1H };
	struct i2c_data_info i2c_slave_data2;
#endif

#endif /* I2C_INFO_H_ */
