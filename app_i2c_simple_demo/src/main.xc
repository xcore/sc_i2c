//:: declaration
#include <stdio.h>
#include <xs1.h>
#include "i2c.h"

struct r_i2c i2cPorts = {
    XS1_PORT_4E,
    XS1_PORT_4F,
};
//::

//::main program
int main(void) {
    struct i2c_data_info data;

    i2c_master_init(i2cPorts);
    data.data[0] = 0x12;
    i2c_master_tx(0x90, 0x07, data, i2cPorts);
    data.data[0] = 0x78;
    i2c_master_tx(0x90, 0x08, data, i2cPorts);
    i2c_master_rx(0x90, 0x07, data, i2cPorts);
    printf("%02x (should be 0x12)\n", data.data[0]);
    return 0;
}
//::
