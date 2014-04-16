sc_i2c Change Log
=================

2.4.1
-----
  * module_i2c_simple header-file comments updated to correctly reflect API

  * Changes to dependencies:

    - sc_util: 1.0.4rc0 -> 1.0.3rc0

      + Remove module_slicekit_support (moved to sc_slicekit_support)
      + Update mutual_thread_comm library to avoid communication race conditions
      + Fix module_slicekit_support to work with L16 target
      + Fix to module_logging to remove excess warning and avoid compiler reserved _msg
      + Minor fixes and code tidying to lock module
      + Initial Version

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
