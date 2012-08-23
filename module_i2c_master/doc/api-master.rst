.. _sec_api:

Programming Guide
=================

The module can be instantiated with different bus speeds with each instantiation, and comprises four functions that implement I2C master.

Structure
---------

All of the files required for operation are located in the ``module_i2c_master/src`` directory. The files that are need to be included for use of this component in an application are:

.. list-table::
    :header-rows: 1
    
    * - File
      - Description
    * - ``i2c.h``
      - Header file for simplified I2C master module and API interfaces.
    * - ``i2c-mm.xc``
      - Module function library


Types
-----

.. doxygenstruct:: r_i2c

API
---

.. doxygenfunction:: i2c_master_init

.. doxygenfunction:: i2c_master_rx

.. doxygenfunction:: i2c_master_read_reg

.. doxygenfunction:: i2c_master_write_reg


Example Usage
-------------

**Sethu, insert example code from sw_gpio_examples here**
