module_i2c_simple
'''''''''''''''''

The S/PDIF receive module comprises a single thread that parses data as it
arrives on a one-bit port and that outputs words of data onto a streaming
channel end. Each word of data carries 24 bits of data and 4 bits of
channel information.

This modules requires the reference clock to be exactly 100 Mhz.


Symbolic constants
==================

.. doxygendefine:: I2C_BIT_TIME

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
declared. Neither should be configured .In this example, the SCL is
connected to the lowest bit of port 4C, and SDA is connected to port 1G:

.. literalinclude:: app_i2c_simple_demo/src/main.xc
  :start-after: //::declaration
  :end-before: //::

The main program calls ``_read_reg`` and ``_write_reg`` as appropriate:

.. literalinclude:: app_i2c_simple_demo/src/main.xc
  :start-after: //::main program
  :end-before: //::
