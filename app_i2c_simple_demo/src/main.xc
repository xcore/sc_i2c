//:: declaration
#include <stdio.h>
#include <xs1.h>
#include "i2c.h"

struct r_i2c i2cPorts = {
    XS1_PORT_4C,
    XS1_PORT_1G,
};
//::

port p32a = XS1_PORT_32A;

//::main program
int main(void) {
    unsigned char data[1];
    timer t; int time;

    p32a <: 0;
    t :> time;
    t when timerafter(time+1000) :> void;
    p32a <: ~0;
    i2c_master_init(i2cPorts);
    for(int i = 0; i < 10; i++) {
        i2c_master_read_reg(0x90, i, data, 1, i2cPorts);
        printf("%d: %02x\n", i, data[0]);
    }
    data[0] = 0x12;
    i2c_master_write_reg(0x90, 0x07, data, 1, i2cPorts);
    data[0] = 0x78;
    i2c_master_write_reg(0x90, 0x08, data, 1, i2cPorts);
    i2c_master_read_reg(0x90, 0x07, data, 1, i2cPorts);
    printf("0x%02x (should be 0x12)\n", data[0]);
    return 0;
}
//::
