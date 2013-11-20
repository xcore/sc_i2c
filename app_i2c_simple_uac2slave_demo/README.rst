app_i2c_master_uac2slave_test
=============================

:scope: Example
:description: I2C Master test app for USB Audio with I2C slave
:keywords: i2c master test demo uac2
:boards: startKIT

Application that uses I2C master (currently I2C master simple) to read the device registers in an I2C slave. This example assumes the slave is a build of USB Audio 2.0 reference design with the I2C slave component added, which allows various parameters to be read out such as stream info and version numbers.
Uses a single logical core only.
