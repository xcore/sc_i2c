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

Example usage of Module I2C Master is shown below:

::

  void app_manager()
  {
	unsigned button_press_1,button_press_2,time;
	int button =1;
	timer t;
	unsigned char data[1]={0x13};
	unsigned char data1[2];
	int adc_value;
	unsigned led_value=0x0E;
	p_PORT_BUT_1:> button_press_1;
	set_port_drive_low(p_PORT_BUT_1);
	i2c_master_write_reg(0x28, 0x00, data, 1, i2cOne); //Write configuration information to ADC
	t:>time;
	printstrln("** WELCOME TO SIMPLE GPIO DEMO **");
	while(1)
	{
		select
		{
			case button => p_PORT_BUT_1 when pinsneq(button_press_1):> button_press_1: //checks if any button is pressed
				button=0;
				t:>time;
				break;

			case !button => t when timerafter(time+debounce_time):>void: //waits for 20ms and checks if the same button is pressed or not
				p_PORT_BUT_1:> button_press_2;
				if(button_press_1==button_press_2)
				if(button_press_1 == BUTTON_PRESS_VALUE) //Button 1 is pressed
				{
					printstrln("Button 1 Pressed");
					p_led<:(led_value);
					led_value=led_value<<1;
					led_value|=0x01;
					led_value=led_value & 0x0F;
					if(led_value == 15)
					{
						led_value=0x0E;
					}
				}
				if(button_press_1 == BUTTON_PRESS_VALUE-1) //Button 2 is pressed
				{
					data1[0]=0;data1[1]=0;
					i2c_master_rx(0x28, data1, 2, i2cOne); //Read ADC value using I2C read 
					printstrln("Reading Temperature value....");
					data1[0]=data1[0]&0x0F;
					adc_value=(data1[0]<<6)|(data1[1]>>2);
					printstr("Temperature is :");
					printintln(linear_interpolation(adc_value));
				}

				button=1;
				break;
		}
	}
  }

