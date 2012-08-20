I2C interface summary
=====================

I2C is the Philips 2 wire interface, used to configure many digital chips.
I2C software has the following options:

* Whether we are a *master* or a *slave*. Devices that are configured are
  slaves, the master configures other devices. 

* The speed supported. Normal speeds are 100 Kb/s and 400 Kb/s. 

* Whether there is a single I2C bus or multiple I2C busses.

* Whether there is a single master or multiple masters.

* Whether clock stretching is supported.

module_i2c
----------

This module will no longer be maintained, and new users are encouraged to
use the new interface on module_i2c_simple, module_i2c_master, and/or
module_i2c_slave.

