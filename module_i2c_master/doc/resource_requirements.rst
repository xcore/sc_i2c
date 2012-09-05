Resource Requirements
---------------------

The following resources on the XCore Tile are used:

Resources
+++++++++

.. list-table::
    :header-rows: 1

    * - Operation
      - Resource Type
      - Number required
      - Notes
    * - I2C master SCL
      - 1 bit port (output)
      - 1
      - I2C master clock, needs external pull-up
    * - I2C Master SDA
      - 1 bit port
      - 1
      - data line, needs external pull-up
    * - I2C IO timing
      - timers
      - 2 
      -

Memory
++++++
  
The whole library uses approximately 1500 Bytes.

      




