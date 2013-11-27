#include <xs1.h>
#include <print.h>
#include <platform.h>
#include <xscope.h>
#include "i2c.h"
#include "i2c_slave_regs.h"

#define NUM_REG     12          //Number of I2C registers in array
#define LOOP_TIME   100000000   //1 seconds

on tile[0]: struct r_i2c p_i2c = {
    XS1_PORT_1F,  //D13 SCL - YELLOW on Ed's board
    XS1_PORT_1E,  //D12 SDA - RED on Ed's board
};

typedef struct i2c_reg_type{
    unsigned char addr;
    char descr[20];
} i2c_reg;

i2c_reg xmos_i2c[NUM_REG] =
    {{XMOS_DEVICE_ID,   "DeviceID           "},
     {SAMP_FREQ_3,      "Samp freq B3       "},
     {SAMP_FREQ_2,      "Samp freq B2       "},
     {SAMP_FREQ_1,      "Samp freq B1       "},
     {SAMP_FREQ_0,      "Samp freq B0       "},
     {DEV_STREAMING,    "Steaming active y/n"},
     {NUM_CHAN_IN,      "Input channels     "},
     {NUM_CHAN_OUT,     "Output channels    "},
     {DSD_MODE,         "DSD mode           "},
     {FW_REV_2,         "Firmware Major ver "},
     {FW_REV_1,         "Firmware Minor ver "},
     {FW_REV_0,         "Firmware Patch ver "}};

void xscope_user_init()
{
    xscope_register(0, 0, "", 0, "");
    xscope_config_io(XSCOPE_IO_BASIC);
}

void i2c_test(void)
{
    timer t;
    int success, time;
    unsigned char data[1] = {0x00};

    printstr("I2C read test program started, using slave address 0x");
    printhexln(XMOS_SLAVE_ADDR);
    i2c_master_init(p_i2c);

    while(1){
        for(int i = 0; i < NUM_REG; i++){
            success = i2c_master_read_reg(XMOS_SLAVE_ADDR, xmos_i2c[i].addr, data, 1, p_i2c);
            if (success == 0) printstrln("ERROR - ACK failed on I2C read");
            else {
                printstr("Read addr 0x");
                printhex(xmos_i2c[i].addr);
                printstr(", result = ");
                printint(data[0]);
                printstr(", ");
                printstrln(xmos_i2c[i].descr);
            }
        }//for loop
        t :> time;
        t when timerafter(time + LOOP_TIME) :> void; //wait a bit
    }//while (1)
}



int main() {

  par{
    on tile[0]: i2c_test();
  }
  return 0;
}

