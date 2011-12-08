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
#endif

struct r_i2c {
    port scl;
    port sda;
};

/**Function that initialises the ports on an I2C device.
 *
 * \param i2c_master struct containing the clock and data ports. Both
 *                   should be declared as unbuffered bidirectional ports.
 */
void i2c_master_init(REFERENCE_PARAM(struct r_i2c,i2c_master));

#ifndef I2C_TI_COMPATIBILITY
/**Function that reads a register from an I2C device.
 * 
 * Note that this function uses the same interface as module_i2c but that
 * the fields master_num and clock_mul are ignored by this function.
 *
 * \param device     Bus address of device, even number between 0x00 and 0xFE.
 * 
 * \param reg_addr   Address of register to read, value between 0x00 and 0x7F.
 * 
 * \param data       Array where data is stored.
 *
 * \param nbytes     Number of bytes to read and store in data. This parameter
 *                   must be set to '1' and is ignored in this module.
 *                   This parameter is provided for compatibililty with module_i2c_complete.
 *
 * \param i2c_master struct containing the clock and data ports. Both
 *                   should be declared as unbuffered bidirectional ports.
 */
int i2c_master_rx(int device, int reg_addr,
                  unsigned char data[],
                  int nbytes,
                  REFERENCE_PARAM(struct r_i2c, i2c_master));
#endif

/**Function that writes to a register on an I2C device.
 * 
 * Note that this function uses the same interface as module_i2c but that
 * the fields master_num and clock_mul are ignored by this function.
 *
 * \param device     Bus address of device, even number between 0x00 and 0xFE.
 * 
 * \param reg_addr   Address of register to write to, value between 0x00 and 0x7F.
 * 
 * \param data       Array where data is stored.
 *
 * \param nbytes     Number of bytes to read and store in data. This parameter
 *                   must be set to '1' and is ignored in this module.
 *                   This parameter is provided for compatibililty with module_i2c_complete.
 *
 * \param i2c_master struct containing the clock and data ports. Both
 *                   should be declared as unbuffered bidirectional ports.
 */
int i2c_master_tx(int device, int reg_addr,
                  unsigned char data[],
                  int nbytes,
                  REFERENCE_PARAM(struct r_i2c, i2c_master));

#endif
