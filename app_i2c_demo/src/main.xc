#include <stdio.h>
#include <xs1.h>
#include "debug_print.h"
#include "i2c.h"

port p_scl = XS1_PORT_4C;
port p_sda = XS1_PORT_1G;

void demo(client interface i2c_master_if i2c)
{
  i2c.write_reg(0x90, 0x07, 0x12);
  i2c.write_reg(0x90, 0x08, 0x78);
  unsigned char data = i2c.read_reg(0x90, 0x07);
  debug_printf("Read data %x from addr 0x90,0x07 (should be 0x12)\n", data);
}

int main(void) {
  i2c_master_if i2c[1];
  par {
    i2c_master(i2c, 1, p_scl, p_sda, 100);
    demo(i2c[0]);
  }
  return 0;
}
