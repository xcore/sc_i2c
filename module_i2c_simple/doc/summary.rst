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


module_i2c_simple
-----------------

This module supports single master, at 100 or 400, 1000 kbit/s without clock
stretching. If multiple I2C busses are required, they should use the same
bit rate.

.. table::
 :class: vertical-borders horizontal-borders

 +---------------------------+-----------------------+------------------------+
 | Functionality provided    | Resources required    | Status                 | 
 |                           +-----------+-----------+                        |
 |                           | Ports     | Memory    |                        |
 +---------------------------+-----------+-----------+------------------------+
 | Single master             | 2         | 460 bytes | Implemented            |
 +---------------------------+-----------+-----------+------------------------+

The interface comprises four functions, init, rx, reg_read, and reg_write
that are called when required. No separate thread is required.

