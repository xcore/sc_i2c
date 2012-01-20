//::declaration
#include <stdio.h>
#include <xs1.h>
#include "i2c.h"

port i2cPort = XS1_PORT_4A;
//::

//::main program
int main(void) {
    unsigned char data[10];
    int device;
    
    i2c_master_init(i2cPort);
    for(int i = 0; i < 256; i+=2) {
        i2c_master_read_reg(i, 0, data, 1, i2cPort);
        if (data[0] != 0xff) {
            printf("Device %02x: value %02x\n", i, data[0]);
        }
    }
    device = 0xC0;
    for(int i = 0; i < 20; i++) {
        printf("%02x: ", i);
        i2c_master_read_reg(device, i, data, 1, i2cPort);
        printf("%02x\n", data[0]);
    }
    for(int i = 0; i < 20; i++) {
        data[0] = 0x12;
        i2c_master_write_reg(device, i, data, 1, i2cPort);
    }
    data[0] = 0x12;
    i2c_master_write_reg(device, 0x07, data, 1, i2cPort);
    data[0] = 0x78;
    i2c_master_write_reg(device, 0x08, data, 1, i2cPort);
    i2c_master_read_reg(device, 0x07, data, 1, i2cPort);
    printf("0x%02x (should be 0x12)\n", data[0]);
    for(int i = 0; i < 20; i++) {
        printf("%02x: ", i);
        i2c_master_read_reg(device, i, data, 1, i2cPort);
        printf("%02x\n", data[0]);
    }
    return 0;
}
//::
