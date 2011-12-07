#include "i2c.h"

struct r_i2c i2cPorts = {
    XS1_PORT_4E,
    XS1_PORT_4F
};

main() {
    struct i2c_data_info data;

    data.data_len = 1;
    data.data[0] = 0x12;
    i2c_master_init(i2cPorts);
    i2c_master_tx(0x7F, 0x01, data, i2cPorts);
    i2c_master_rx(0x7F, 0x01, data, i2cPorts);
}
