Programmers guide to module_i2c_master
''''''''''''''''''''''''''''''''''''''

This module implements multi-master I2C, and can be instantiated with
different bus speeds for each instantiation.

This I2C module comprises four functions that implement I2C master. A
simpler restrictive version is available in the module
``module_i2c_simple``.

Types
=====

.. doxygenstruct:: r_i2c

API
===

.. doxygenfunction:: i2c_master_init

.. doxygenfunction:: i2c_master_rx

.. doxygenfunction:: i2c_master_read_reg

.. doxygenfunction:: i2c_master_write_reg


Example
=======


An example program is shown below. Two unbuffered undirectional ports must be
declared. Neither should be configured. In this example, SCL is
connected to the lowest bit of port 4C, and SDA is connected to port 1G.
Note that in comparison with ``module_i2c_simple`` the clock speed is
defined as part of the I2C bus-declaration:

.. literalinclude:: app_i2c_master_demo/src/main.xc
  :start-after: //::declaration
  :end-before: //::

The main program calls ``_read_reg`` and ``_write_reg`` as appropriate:

.. literalinclude:: app_i2c_master_demo/src/main.xc
  :start-after: //::main program
  :end-before: //::
