Programmers guide to module_i2c_simple
''''''''''''''''''''''''''''''''''''''

This I2C module comprises four functions that implement I2C master. It is a
small and simple version of the protocol with limitations (described
below), a full version with a compatible interface is available in
``module_i2c_master``, but is has a bigger memory footprint.

The three restrictions of this module are:

#. It does not implement clock-stretching: it should only be used when
   slaves do not attempt to stretch the clock.

#. It does not implement multi-master: it should only be used when the
   XCore is the only master on the I2C bus.

#. The speed of the bus is defined using a compile-time define
   (``I2C_BIT_TIME``), and when using this module with multiple I2C busses
   they will all run at the same speed.

Symbolic constants
==================

.. doxygendefine:: I2C_BIT_TIME

.. doxygendefine:: I2C_REPEATED_START_ON_NACK

.. doxygendefine:: I2C_REPEATED_START_MAX_RETRIES

.. doxygendefine:: I2C_REPEATED_START_DELAY

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
connected to the lowest bit of port 4C, and SDA is connected to port 1G:

.. literalinclude:: app_i2c_simple_demo/src/main.xc
  :start-after: //::declaration
  :end-before: //::

The main program calls ``_read_reg`` and ``_write_reg`` as appropriate:

.. literalinclude:: app_i2c_simple_demo/src/main.xc
  :start-after: //::main program
  :end-before: //::
