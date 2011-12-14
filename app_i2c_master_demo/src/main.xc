//::declaration
#include <stdio.h>
#include <xs1.h>
#include "i2c.h"

struct r_i2c i2cOne = {
    XS1_PORT_1B,
    XS1_PORT_1A,
    1008,
};

struct r_i2c i2cTwo = {
    XS1_PORT_1F,
    XS1_PORT_1E,
    1000,
};
//::

#if 0
port p32a = XS1_PORT_32A;

// We do not really need to init - this part resets the codec on the test
// board instead, but it shouldn't go into the documentation.

#define i2c_master_init xxx

void i2c_master_init(struct r_i2c &x) {
    timer t; int time;

    p32a <: 0;
    t :> time;
    t when timerafter(time+1000) :> void;
    p32a <: ~0;
}
#endif

//::main program
void beMaster(int id, int device, struct r_i2c &i2cPorts, streaming chanend sync) {
    unsigned char data[10];
    timer t; unsigned t0, t1, time[10];

    i2c_master_init(i2cPorts);
    for(int i = 0; i < 10; i++) {
        sync <: 1;
        sync :> int _;
        t :> t0;
        if (i2c_master_read_reg(device, 0x0, data, 1, i2cPorts)) {
            t :> t1;
            if (data[0] != 0xff) {
//                printf("%d %3d: %02x\n", id, i, data[0]);
            }                                   
            time[i] = t1-t0;
        } else {
            printf("%d: Fail\n", id);
        }
    }
    for(int i = 0; i < 10; i++) {
        printf("%d: %d\n", id, time[i]);
    }
}

int main(void) {
    streaming chan sync;
    unsigned char data[1];
    par {
        beMaster(0, 82, i2cOne, sync);
        beMaster(1, 82, i2cTwo, sync);
    }
    i2c_master_write_reg(82, 0x0, data, 1, i2cOne);
}
//::
