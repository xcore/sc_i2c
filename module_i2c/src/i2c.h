// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>
#ifndef _i2c_h_
#define _i2c_h_

#ifdef __i2c_conf_h_exists__
#include "i2c_conf.h"
#endif

#ifndef I2C_BIT_TIME
/** This constant defines the time in clock ticks between successive bits.
 * By default set to 1000 for 100 Kbit devices, but it can be overriden to
 * 250 for 400 Kbit devices.
 */
#define I2C_BIT_TIME 1000
#endif

typedef enum {
  I2C_WRITE_ACK_SUCCEEDED,
  I2C_WRITE_ACK_FAILED
} i2c_write_res_t;

/** This interface is used to communication with an I2C master component.
 *  It provides facilities for reading and writing to the bus.
 *
 */
typedef interface i2c_master_if {

  /** Read data from an I2C bus.
   *
   *  \param buf  the buffer to fill with data
   *  \param n    the number of bytes to read
   */
  void rx(unsigned device_addr, unsigned char buf[n], unsigned n);

  /** Write data to an I2C bus.
   *
   *  \param buf   the buffer containing data to write
   *  \param n     the number of bytes to write
   */
  i2c_write_res_t tx(unsigned char buf[n], unsigned n);

  /** Read a register value from an I2C device.
   *
   * \param device_addr  Bus address of device, even number between 0x00 and 0xFE.
   *
   * \param reg_addr     Address of register to read, value between 0x00 and 0x7F.
   *
   * \returns            The data read from the bus.
   */
  unsigned char read_reg(unsigned device_addr, unsigned reg_addr);

  /** Set a register value on an I2C device.
   *
   * \param device_addr  Bus address of device, even number between 0x00 and 0xFE.
   *
   * \param reg_addr     Address of register to read, value between 0x00 and 0x7F.
   *
   * \param data         The data to write to the bus.
   **/
  i2c_write_res_t write_reg(unsigned device_addr, unsigned reg_addr, unsigned char data);
} i2c_master_if;


/** Implements I2C on the i2c_master_if interface using two ports.
 *
 *  \param  c      An array of server interface connections for clients to
 *                 connect to
 *  \param  n      The number of clients connected
 *  \param  p_scl  The SCL port of the I2C bus
 *  \param  p_sda  The SDA port of the I2C bus
 **/
[[distributable]] void i2c_master(server interface i2c_master_if c[n],
                                  unsigned n,
                                  port p_scl, port p_sda);


// Single Port Variant defines

#ifndef SDA_HIGH

/** If using the single port implementation, this constant defines
 *  the bit value of a high data bit on the I2C port. The
 *  default value is 1, meaning that this is on bit 0 of the port. Set to 2,
 *  4, 8, ... for other bits of the port.
 */
#define SDA_HIGH    1

#endif


#ifndef SCL_HIGH

/** If using the single port implementation, this constant defines the
 *  bit value of a high clock on the I2C port. The
 *  default value is 2, meaning that this is on bit 1 of the port. Set to 1,
 *  4, 8, ... for other bits of the port.
 */
#define SCL_HIGH    2

#endif


#ifndef S_REST

/** If using the single port implementation, this constant defines the
 *  bit value of the other bits of the I2C port.
 *  The default value is 0xC, meaning that bits 2 and 3 are kept high. Note
 *  that on occassions the other bits are left to float, so external
 *  resistors shall be used to reinforce the default value
 */
#define S_REST        0xC

#endif

/** Implements I2C on a single multi-bit port.
 *
 *  \param  c      An array of server interface connections for clients to
 *                 connect to
 *  \param  n      The number of clients connected
 *  \param  p_i2c  The multi-bit port containing both SCL and SDA.
 *                 You will need to set the relevant defines in i2c_conf.h in
 *                 you application to say which bits of the port are used.
 */
[[distributable]]
void i2c_master_single_port(server interface i2c_master_if c[n], unsigned n,
                            port p_i2c);

#endif
