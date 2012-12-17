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

/** Struct that holds the data for instantiating the I2C module - it just
 * comprises two ports (the clock port and the data port), and the speed of
 * the bus which is a compile time define.
 */
typedef struct r_i2c {
    port scl;      /**< Port on which clock wire is attached. Must be on bit 0 */
    port sda;      /**< Port on which data wire is attached. Must be on bit 0 */
    unsigned int clockTicks; /**< Number of reference clocks per I2C clock,
                              *   set to 1000 for 100 Khz. */
}  r_i2c;

/**Function that initialises the ports on an I2C device.
 *
 * \param i2c_master struct containing the clock and data ports. Both
 *                   should be declared as unbuffered bidirectional ports.
 */
void i2c_master_init(REFERENCE_PARAM(struct r_i2c,i2c_master));

#ifndef I2C_TI_COMPATIBILITY

/**Function that reads data from an I2C device.
 *
 * \param device     Bus address of device, even number between 0x00 and 0xFE.
 * 
 * \param data       Array where data is stored.
 *
 * \param nbytes     Number of bytes to read and store in data.
 *
 * \param i2c        struct containing the clock and data ports. Both
 *                   should be declared as unbuffered bidirectional ports.
 */
int i2c_master_rx(int device, unsigned char data[], int nbytes,
                  REFERENCE_PARAM(struct r_i2c,i2c));

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
 * \param nbytes     Number of bytes to read and store in data.
 *
 * \param i2c_master struct containing the clock and data ports. Both
 *                   should be declared as unbuffered bidirectional ports.
 */
int i2c_master_read_reg(int device, int reg_addr,
                        unsigned char data[],
                        int nbytes,
                        REFERENCE_PARAM(struct r_i2c, i2c_master));

/**Function that reads a register from an I2C device.
 *
 * Note that this function uses the same interface as module_i2c but that
 * the fields master_num and clock_mul are ignored by this function.
 *
 * \param device     Bus address of device, even number between 0x00 and 0xFE.
 *
 * \param reg_addr   Address of register to read, value between 0x0000 and 0xFFFF.
 *
 * \param data       Array where data is stored.
 *
 * \param nbytes     Number of bytes to read and store in data.
 *
 * \param i2c_master struct containing the clock and data ports. Both
 *                   should be declared as unbuffered bidirectional ports.
 */
int i2c_master_16bit_read_reg(int device, unsigned int reg_addr,
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
 * \param nbytes     Number of bytes to read and store in data.
 *
 * \param i2c_master struct containing the clock and data ports. Both
 *                   should be declared as unbuffered bidirectional ports.
 */
int i2c_master_write_reg(int device, int reg_addr,
                         unsigned char data[],
                         int nbytes,
                         REFERENCE_PARAM(struct r_i2c, i2c_master));

/**Function that writes to a register on an I2C device.
 *
 * Note that this function uses the same interface as module_i2c but that
 * the fields master_num and clock_mul are ignored by this function.
 *
 * \param device     Bus address of device, even number between 0x00 and 0xFE.
 *
 * \param reg_addr   Address of register to write to, value between 0x0000 and 0xFFFF.
 *
 * \param data       Array where data is stored.
 *
 * \param nbytes     Number of bytes to read and store in data.
 *
 * \param i2c_master struct containing the clock and data ports. Both
 *                   should be declared as unbuffered bidirectional ports.
 */
int i2c_master_16bit_write_reg(int device, unsigned int reg_addr,
                         unsigned char data[],
                         int nbytes,
                         REFERENCE_PARAM(struct r_i2c, i2c_master));

#endif
