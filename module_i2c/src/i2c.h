// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>
#ifndef _i2c_h_
#define _i2c_h_
#include <stddef.h>
#include <stdint.h>

#ifdef __i2c_conf_h_exists__
#include "i2c_conf.h"
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
  void rx(uint8_t device_addr, uint8_t buf[n], size_t n);

  /** Write data to an I2C bus.
   *
   *  \param buf   the buffer containing data to write
   *  \param n     the number of bytes to write
   */
  i2c_write_res_t tx(uint8_t device_addr, uint8_t buf[n], size_t n);
} i2c_master_if;

extends client interface i2c_master_if : {
  inline void read_reg_n_m(client interface i2c_master_if i,
                           uint8_t device_addr,
                           uint8_t reg[m],
                           size_t m,
                           uint8_t data[n],
                           size_t n)
  {
    i.tx(device_addr, reg, m);
    i.rx(device_addr, data, n);
  }

  inline uint8_t read_reg_8_8(client interface i2c_master_if i,
                              uint8_t device_addr, uint8_t reg) {
    uint8_t a_reg[1] = {reg};
    uint8_t data[1];
    i.read_reg_n_m(device_addr, a_reg, 1, data, 1);
    return data[0];
  }

  inline uint8_t read_reg(client interface i2c_master_if i,
                       uint8_t device_addr, uint8_t reg) {
    return i.read_reg_8_8(device_addr, reg);
  }

  inline void write_reg_n_m(client interface i2c_master_if i,
                           uint8_t device_addr,
                           uint8_t reg[m],
                           size_t m,
                           uint8_t data[n],
                           size_t n)
  {
    i.tx(device_addr, reg, m);
    i.tx(device_addr, data, n);
  }

  inline void write_reg_8_8(client interface i2c_master_if i,
                               uint8_t device_addr, uint8_t reg, uint8_t data) {
    uint8_t a_reg[1] = {reg};
    uint8_t a_data[1] = {data};
    i.write_reg_n_m(device_addr, a_reg, 1, a_data, 1);
  }

  inline void write_reg(client interface i2c_master_if i,
                        uint8_t device_addr, uint8_t reg, uint8_t data) {
    i.write_reg_8_8(device_addr, reg, data);
  }


}


/** Implements I2C on the i2c_master_if interface using two ports.
 *
 *  \param  c      An array of server interface connections for clients to
 *                 connect to
 *  \param  n      The number of clients connected
 *  \param  p_scl  The SCL port of the I2C bus
 *  \param  p_sda  The SDA port of the I2C bus
 *  \param  kbits_per_second The speed of the I2C bus
 **/
[[distributable]] void i2c_master(server interface i2c_master_if c[n],
                                  size_t n,
                                  port p_scl, port p_sda,
                                  unsigned kbits_per_second);

/** Implements I2C on a single multi-bit port.
 *
 *  **Note that reading from the bus is not supported in this implementation**
 *
 *  \param  c      An array of server interface connections for clients to
 *                 connect to
 *  \param  n      The number of clients connected
 *  \param  p_i2c  The multi-bit port containing both SCL and SDA.
 *                 You will need to set the relevant defines in i2c_conf.h in
 *                 you application to say which bits of the port are used
 *  \param  kbits_per_second The speed of the I2C bus
 *  \param  sda_bit_position The bit position of the SDA line on the port
 *  \param  scl_bit_position The bit position of the SCL line on the port
 *  \param  other_bits_mask  The mask for the other bits of the port to use
 *                           when driving it.  Note that, on occassions,
 *                           the other bits are left to float, so external
 *                           resistors shall be used to reinforce the default
 *                           value
 */
[[distributable]]
void i2c_master_single_port(server interface i2c_master_if c[n], size_t n,
                            port p_i2c, unsigned kbits_per_second,
                            unsigned sda_bit_position,
                            unsigned scl_bit_position,
                            unsigned other_bits_mask);


#endif
