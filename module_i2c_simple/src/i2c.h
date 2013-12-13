// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#ifndef _i2c_h_
#define _i2c_h_

#include <xs1.h>
#include <xccompat.h>

#ifdef __i2c_conf_h_exists__
#include "i2c_conf.h"
#endif

#ifndef I2C_BIT_TIME

/** This constant defines the time in clock ticks between successive bits.
 * By default set to 1000 for 100 Kbit devices, but it can be overridden to
 * 250 for 400 Kbit devices.
 */
#define I2C_BIT_TIME 1000

#endif

#ifndef SDA_HIGH

/** This constant defines the bit value of a high data bit on the I2C SDA port. The
 * default value is 1, meaning that this is on bit 0 of the port. Set to 2,
 * 4, 8, ... for other bits of the port.
 */
#define SDA_HIGH    1

#endif

#ifndef I2C_REPEATED_START_ON_NACK

/** This constant defines the I2C masters behaviour on receipt of a NACK from a busy
 * slave device. By default the issuing of a repeated start is disabled, and the
 * module will ignore NACKs when reading from the device.
 */
#define I2C_REPEATED_START_ON_NACK 0

#endif

#ifndef  I2C_REPEATED_START_MAX_RETRIES

/** This constant defines the maximum number of times the I2C master should issue a
 * repeated start on receipt of a NACK.
 */
#define I2C_REPEATED_START_MAX_RETRIES 10

#endif

#ifndef  I2C_REPEATED_START_DELAY

/** This constant defines the delay in microseconds (us) that the I2C master must wait following
 * the receipt of a NACK before issuing a repeated start.
 */
#define I2C_REPEATED_START_DELAY 500

#endif

/** Struct that holds the data for instantiating the I2C module - it just
 * comprises two ports (the clock port and the data port), the only other
 * settable parameter is the speed of the bus which is a compile time
 * define.
 */
struct r_i2c {
    port scl;      /**< Port on which clock wire is attached. Must be on bit 0 */
    port sda;      /**< Port on which data wire is attached. Must be on bit 0 */
};

/**Function that initialises the ports on an I2C device.
 *
 * \param i2c_master struct containing the clock and data ports. Both
 *                   should be declared as unbuffered bidirectional ports.
 */
void i2c_master_init(REFERENCE_PARAM(struct r_i2c,i2c));

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
 * \param data       Array containing data to be written.
 *
 * \param nbytes     Number of bytes to write from data.
 *
 * \param i2c_master struct containing the clock and data ports. Both
 *                   should be declared as unbuffered bidirectional ports.
 */
int i2c_master_write_reg(int device, int reg_addr,
                         unsigned char data[],
                         int nbytes,
                         REFERENCE_PARAM(struct r_i2c, i2c_master));

#endif
