I2C interface
=============

I2C is the philips 2 wire interface, used to configure many digital chips.

Important characteristics of S/PDIF software are the following:

* Whether we are a *master* or a *slave*. Devices that are configured are
  slaves, the master configures other devices. 

* The speed supported. Normal speeds are 100 Kb/s and 400 Kb/s. 

* Whether there is a single master or multiple masters.

* Whether clock stretching is supported.


module_i2c_simple
-----------------

This module supports single master, at 100 or 400 kb/s without clock
stretching.

+---------------------------+-----------------------+------------------------+
| Functionality provided    | Resources required    | Status                 | 
|                           +-----------+-----------+                        |
|                           | ports     | Memory    |                        |
+---------------------------+-----------+-----------+------------------------+
| Single master             | 2         | 400 bytes | Implemented            |
+---------------------------+-----------+-----------+------------------------+

The interface comprises three functions, init, rx, and tx that are called
when required.

module_i2c_master
-----------------

This module will support single master, at 100 or 400 kb/s with clock
stretching. It will provide the same interface as module_i2c_simple.

+---------------------------+-----------------------+------------------------+
| Functionality provided    | Resources required    | Status                 | 
|                           +-----------+-----------+                        |
|                           | ports     | Memory    |                        |
+---------------------------+-----------+-----------+------------------------+
| Multi master              | 2         | ??? bytes | To be implemented      |
+---------------------------+-----------+-----------+------------------------+

The interface comprises three functions, init, rx, and tx that are called
when required.


module_i2c
----------

This module will no longer be maintained, and new users are encouraged to
use the new interface.

