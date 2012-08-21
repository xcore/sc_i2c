Programmers guide to module_i2c_single_port
-------------------------------------------

This I2C module comprises four functions that implement I2C master. It is a
small and simple version of the protocol with limitations (described
below), and expects SCL and SDA on the same port.

The three restrictions of this module are:

#. It does not implement clock-stretching: it should only be used when
   slaves do not attempt to stretch the clock.

#. It does not implement multi-master: it should only be used when the
   XCore is the only master on the I2C bus.

#. The speed of the bus is defined using a compile-time define
   (``I2C_BIT_TIME``).

Note that on a single port it is impossible to implement clock stretching
or multi-master.

Any constants that are to be overridden should be defined in an include
file ``i2c_conf.h``.

Symbolic constants
==================

.. doxygendefine:: I2C_BIT_TIME

.. doxygendefine:: SCL_HIGH

.. doxygendefine:: SDA_HIGH

.. doxygendefine:: S_REST

API
===

.. doxygenfunction:: i2c_master_init

.. doxygenfunction:: i2c_master_rx

.. doxygenfunction:: i2c_master_read_reg

.. doxygenfunction:: i2c_master_write_reg


Example
=======


An example program is shown below. Two unbuffered undirectional ports must be
declared. Neither should be configured. In this example, SDA and SCL are
connected to the lowest two bits of port 4A:

.. literalinclude:: app_i2c_single_port_demo/src/main.xc
  :start-after: //::declaration
  :end-before: //::

The main program calls ``_read_reg`` and ``_write_reg`` as appropriate:

.. literalinclude:: app_i2c_single_port_demo/src/main.xc
  :start-after: //::main program
  :end-before: //::
