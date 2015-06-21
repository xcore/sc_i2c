sc_i2c Change Log
=================

3.0.0
-----
  * Read support added to module_i2c_single_port (xCORE 200 only)
  * Retry on NACK added to module_i2c_single_port (matches module_i2c_simple)
  * module_i2c_single_port functions now takes struct for port resources (matches module_i2c_simple)
  * module_i2c_simple removed from module_i2c_shared dependancies. Allows use with other i2c modules.
    It is now the applications responsibilty to include the desired i2c module as a depenancy.
  * Data arrays passed to write_reg functions now marked const

  * Changes to dependencies:

    - sc_util: 1.0.4rc0 -> 1.0.5rc0

      + xCORE-200 Compatiblity fixes to module_locks

2.4.1
-----
  * module_i2c_simple header-file comments updated to correctly reflect API

2.4.0
-----
  * i2c_shared functions now take i2cPorts structure as param (rather than externed). This allows for
    multiple i2c buses

  * Changes to dependencies:

    - sc_util: 1.0.3rc0 -> 1.0.4rc0

      + module_logging now compiled at -Os
      + debug_printf in module_logging uses a buffer to deliver messages unfragmented
      + Fix thread local storage calculation bug in libtrycatch
      + Fix debug_printf itoa to work for unsigned values > 0x80000000

2.3.0
-----
  * module_i2c_simple fixed to ACK correctly during multi-byte reads (all but the final byte will be now be ACKd)
  * module_i2c_simple can now be built with support to send repeated starts and retry reads and writes NACKd by slave
  * module_i2c_shared added to allow multiple logical cores to safely share a single I2C bus
  * Removed readreg() function from single_port module since it was not safe

2.2.1
-----
  * Documentation fixes

2.2.0
-----
  * Added I2C read/write functions with support of 16bit addresses
  * reg_read and reg_write now use nbytes params to allow multiple byte register access
  * Added support for i2c simple SDA on a 4 bit port
  * data[0] is no longer overwritten in module_i2c_simple read

2.1.0
-----
  * Updated documents for xSOFTip requirements
  * Added metainfo and XPD items

2.0.0
-----
  * Initial Version
  * Previous version on xmos.com
