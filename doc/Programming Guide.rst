Programming Guide
==================

This section discusses the programming aspects of the I2c master component and typical implementation and usage of the API.

Structure
~~~~~~~~~~

This is an overview of the key header files that are required, as well as the thread structure and information regarding the requirements for the component.

Source Code
++++++++++++

All of the files required for operation are located in the ``module_i2c_master`` directory. The files that are need to be included for use of this component in an application are:

.. list-table::
    :header-rows: 1
    
    * - File
      - Description
    * - ``i2c.h``
      - Header file for simplified I2C master module and API interfaces.
    
Programmers guide to module_i2c_master
--------------------------------------

This module implements multi-master I2C, and can be instantiated with
different bus speeds for each instantiation.

This I2C module comprises four functions that implement I2C master.
