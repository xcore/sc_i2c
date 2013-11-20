#ifndef _I2C_SLAVE_REG_H_
#define _I2C_SLAVE_REG_H_

//XMOS USB Audio I2C slave device definitions
#define XMOS_SLAVE_ADDR 0x42    //Device address

//Register functions and addresses.
//All registers are byte wide and are READ ONLY.
//Writes will not be ACKEd
#define XMOS_DEVICE_ID  0x00    //ID register, contains 0xed
#define SAMP_FREQ_3     0x01    //Sample frequency MSB
#define SAMP_FREQ_2     0x02    //Sample frequency byte 2
#define SAMP_FREQ_1     0x03    //Sample frequency byte 1
#define SAMP_FREQ_0     0x04    //Sample frequency LSB
#define DEV_STREAMING   0x05    //Is device streaming? 1=yes or 0=no
#define NUM_CHAN_IN     0x06    //Number of audio channels in
#define NUM_CHAN_OUT    0x07    //Number of audio channels out
#define DSD_MODE        0x08    //DSD mode? 0 = PCM, 1 = DoP, 2 = Native
#define FW_REV_2        0x09    //Firmware major rev no
#define FW_REV_1        0x0a    //Firmware minor rev no
#define FW_REV_0        0x0b    //Firmware patch no

#endif
