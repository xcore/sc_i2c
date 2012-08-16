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



module_i2c_single_port
----------------------

This module supports single master, at 100 or 400, 1000 kbit/s without clock
stretching, where both SCL and SDA are shared on a single port (4, 8, 16,
or 32 bits wide).

.. table::
 :class: vertical-borders horizontal-borders

 +---------------------------+-----------------------+------------------------+
 | Functionality provided    | Resources required    | Status                 | 
 |                           +-----------+-----------+                        |
 |                           | Ports     | Memory    |                        |
 +---------------------------+-----------+-----------+------------------------+
 | Single master             | 1         | 360 bytes | Implemented            |
 +---------------------------+-----------+-----------+------------------------+

The interface comprises four functions, init, rx, reg_read, and reg_write
that are called when required. No separate thread is required.

Note that this module is not extensively tested.

module_i2c
----------

This module will no longer be maintained, and new users are encouraged to
use the new interface on module_i2c_simple, module_i2c_master, and/or
module_i2c_slave.

