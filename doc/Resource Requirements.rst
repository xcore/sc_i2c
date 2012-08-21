Resource Requirements
=====================

This section provides an overview of the required resources of the component so that the application designer can operate within these constraints accordingly.

XCORE Ports
+++++++++++

The following ports are required for each of the receive and transmit functions - 

.. list-table::
    :header-rows: 1
    
    * - Operation
      - Port Type
      - Number required
      - Direction
      - Port purpose / Notes
    * - SCL
      - 1 bit port
      - 1
      - Output
      - I2C Clock
    * - SDA
      - 1 bit port
      - 1
      - Input/Output
      - I2C Data port

xCore Logical Processors
++++++++++++++++++++++++

.. list-table::
    :header-rows: 1
    
    * - Operation
      - Logical Processors Count
      - Notes
    * - Multimaster
      - 1
      - Single thread (Logical Processor) 

Memory
++++++++++

The following is a summary of memory usage of the component for all functionality utilised by the master test application. 

.. list-table::
    :header-rows: 1
    
    * - Operation
      - Code (bytes)
      - Data (bytes)
   
    * - **Total**
      - **1564**
      - **21484**
   
      
Channel Usage
+++++++++++++++

.. list-table::
    :header-rows: 1
    
    * - Operation
      - Channel Usage & Type
    * - NOne
      - None

Timers Usage
+++++++++++++++

.. list-table::
    :header-rows: 1
    
    * - Operation
      - No of Timers USed
    * - xTime
      - 2




