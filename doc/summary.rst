I2C interface
=============

I2C is the Philips 2 wire interface, used to configure many digital chips.

Important characteristics of S/PDIF software are the following:

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

+---------------------------+-----------------------+------------------------+
| Functionality provided    | Resources required    | Status                 | 
|                           +-----------+-----------+                        |
|                           | ports     | Memory    |                        |
+---------------------------+-----------+-----------+------------------------+
| Single master             | 2         | 460 bytes | Implemented            |
+---------------------------+-----------+-----------+------------------------+

The interface comprises four functions, init, rx, reg_read, and reg_write
that are called when required. No separate thread is required.

module_i2c_master
-----------------

This module will support must master, at 100 or 400, 1000 kbit/s with clock
stretching on multiple I2C busses. It provides virtually the same interface as
module_i2c_simple.

+---------------------------+------------------------+------------------------+
| Functionality provided    | Resources required     | Status                 | 
|                           +-----------+------------+                        |
|                           | ports     | Memory     |                        |
+---------------------------+-----------+------------+------------------------+
| Multi master              | 2         | 900 bytes  | Implemented            |
+---------------------------+-----------+------------+------------------------+

The interface comprises four functions, init, rx, reg_read, and reg_write
that are called when required. No separate thread is required.


module_i2c_slave
----------------

To be provided.

module_i2c_single_port
----------------------

This module supports single master, at 100 or 400, 1000 kbit/s without clock
stretching, where both SCL and SDA are shared on a single port (4, 8, 16,
or 32 bits wide).

+---------------------------+-----------------------+------------------------+
| Functionality provided    | Resources required    | Status                 | 
|                           +-----------+-----------+                        |
|                           | ports     | Memory    |                        |
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

