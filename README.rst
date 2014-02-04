XCORE.com I2C Master Component
..............................

:Latest release: 2.3.0beta1
:Maintainer: djpwilk
:Description: I2C Software Component


:Maintainer:  Dan Wilkinson (github: djpwilk)

The I2C Component provides the ability to write and read the I2C Compatible Slave devices.

Key Features
============

module_i2c:
 
* Works at 100 Kbps and 400 Kbps
* Supports Clock stretching
* Supports Multi master capability.
* Supports Clock synchronization.

module_i2c_simple / module_i2c_single_port:

* Small footprint 
* Works at 100 Kbps and 400 Kbps
* Single system-wide I2C bus with XCore acting as the single master.
* SDA and SCL can be on a single wide port (module_i2c_single_port)

module_i2c_master:

* Works at 100 Kbps and 400 Kbps
* Multiple I2C busses
* Supports Clock stretching
* Support for Multi master capability.
* Support for Clock synchronization.

Firmware Overview
=================

The Component is in the form of a function library and can be called in a thread.

Module_i2c is meant to be deprecated, once module_i2c_master is completed,
and once the slave part has been moved to module_i2c_slave.

Note: Both 7- or 8-bit versions of I2C addresses are used in data-sheets. 7 bits identify the device, and the eighth bit 
determines if it's being written to or read from. The modules in this repo use 7 bit addresses throughout. 
If you encounter a datasheet that lists an 8 bit address, reove the the low bit (i.e. shift the value one bit to the right), 
this giving an address between 0 and 127.

Known Issues
============

 * does not support 10 bit addressing
 * does not support CBUS capability.
 * does not support HS-Mode.

Instructions for Building Project and running the simulation.
================================
The Software Components for I2C are built using XMOS Development Environment (XDE) Version: 10.4.2 (build 1752) or later.
The module can be simulated using test bench.
Following steps is to followed to run the simulation
      #. import the xcommon and xmos_i2c folders into XMOS Development Environment.
	#. open run configuration.
      #. In Main tab select simulator in Device options.
	#. Select simulator Tab.
	#. Tick enable tracing.
	#. Tick Pads.
	#. In Local Tracing options click on ADD button and select stdcore[1] and ports.
	#. Select Pins tab.
	#. Enable Pin connections
	#. Click on Add Button.
      #. Select stdcore[1].
	#. Connect Port XS1_PORT_1B to XS1_PORT_1F.
	#. Connect Port XS1_PORT_1A to XS1_PORT_1E.
	#. Connect Port XS1_PORT_1B to XS1_PORT_1D.
	#. Connect Port XS1_PORT_1A to XS1_PORT_1C.
	#. Connect Port XS1_PORT_1B to XS1_PORT_1G
	#. Connect Port XS1_PORT_1A to XS1_PORT_1H.
	#. Connect Port XS1_PORT_1F to XS1_PORT_1D
	#. Connect Port XS1_PORT_1E to XS1_PORT_1C.
	#. Connect Port XS1_PORT_1F to XS1_PORT_1G.
	#. Connect Port XS1_PORT_1E to XS1_PORT_1H.
	#. Connect Port XS1_PORT_1D to XS1_PORT_1G.
	#. Connect Port XS1_PORT_1C to XS1_PORT_1H.
      #. Apply the changes and run.
	#. In i2c_test_def.h keep MASTER_TX uncommenting for master transmit and slave receive.
	#. For Comment MASTER_TX for slave transmit and master receive.
        #. For single master and single slave comment MASTER2 and SLAVE2 or comment MASTER1 and SLAVE1.
        #. for single slave and two masters select MASTER1 and MASTER2 comment SLAVE1 or SLAVE2.
        #. for two slaves and single master select SLAVE1 and SLAVE2 comment MASTER1 or MASTER2.
        #. for two master and two slaves select both  MASTER1 and MASTER2, and SLAVE1 and SLAVE2.
        #. run the simulation. Check for valid data on the console window.
      
Support
=======

Issues may be submitted via the Issues tab in this github repo. Response to any issues submitted as at the discretion of the maintainer for this line.

Required software (dependencies)
================================

  * sc_util (git://github.com/xcore/sc_util)

