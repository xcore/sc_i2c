#include "i2c_shared.h"
#include "swlock.h"

extern struct r_i2c i2cPorts;

swlock_t i2c_swlock = SWLOCK_INITIAL_VALUE;

void i2c_shared_master_init()
{
    swlock_acquire(&i2c_swlock);
    i2c_master_init(&i2cPorts);
    swlock_release(&i2c_swlock);
}

#ifndef I2C_TI_COMPATIBILITY

int i2c_shared_master_rx(int device, unsigned char data[], int nbytes)
{
    int retval;
    swlock_acquire(&i2c_swlock);
    retval = i2c_master_rx(device, data, nbytes, &i2cPorts);
    swlock_release(&i2c_swlock);
    return retval;
}

int i2c_shared_master_read_reg(int device, int reg_addr,
                        unsigned char data[],
                        int nbytes)
{
    int retval;
    swlock_acquire(&i2c_swlock);
    retval = i2c_master_read_reg(device, reg_addr, data, nbytes, &i2cPorts);
    swlock_release(&i2c_swlock);
    return retval;
}

#endif

int i2c_shared_master_write_reg(int device, int reg_addr,
                         unsigned char data[],
                         int nbytes)
{
    int retval;
    swlock_acquire(&i2c_swlock);
    retval = i2c_master_write_reg(device, reg_addr, data, nbytes, &i2cPorts);
    swlock_release(&i2c_swlock);
    return retval;
}
