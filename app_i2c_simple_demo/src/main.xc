#include <xs1.h>
#include <stdio.h>
#include "i2c.h"

struct r_i2c i2cPorts = {
    XS1_PORT_4E,
    XS1_PORT_4F,
};

int main(void) {
    struct i2c_data_info data;
    timer t;
    int time;

    data.data_len = 1;
    data.data[0] = 0x12;
    i2c_master_init(i2cPorts);
    i2c_master_tx(0x90, 0x07, data, i2cPorts);
    for(int i = 3; i < 10; i++) {
        i2c_master_rx(0x90, i, data, i2cPorts);
        printf("%2d: %02x\n", i, data.data[0]);
    }
    data.data[0] = 0x78;
    i2c_master_tx(0x90, 0x07, data, i2cPorts);
    for(int i = 6; i < 9; i++) {
        i2c_master_rx(0x90, i, data, i2cPorts);
        printf("%2d: %02x (seven should be 0x78)\n", i, data.data[0]);
    }
    return 0;
}
