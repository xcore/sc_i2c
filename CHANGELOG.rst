I2C Components Change Log
=========================

2.3.0
-----

  * module_i2c_simple fixed to ACK correctly during multi-byte reads (all but the final byte will be now be ACKd)
  * module_i2c_simple can now be built with support to send repeated starts and retry reads and writes NACKd by slave
  * module_i2c_shared added to allow multiple logical cores to safely share a single I2C bus
  * Removed readreg() function from single_port module since it was not safe
  * module_i2c_simple updated such that device addresse is now 7bit to match other modules (i.e. does not inclue read/write bit)

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

  * Previous version on xmos.com
