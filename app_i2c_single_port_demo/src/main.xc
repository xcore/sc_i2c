//::declaration
#include <stdio.h>
#include <xs1.h>
#include "i2c.h"

port i2c = XS1_PORT_4F;
port gpio = XS1_PORT_4E;
//::

//::main program

int main(void)
{
  unsigned char data[1];
  int x;
  int i;

  i2c_master_init(i2c);

  gpio <: 0xF;

  data[0] = 0xFF;
  for(int j = 0; j < 1000000; j++) {
      for(i = 0x90; i < 0x9E; i += 2) {
          if (i == 0x94) i = 0x9C;
          x = i2c_master_read_reg(i, 1, data, 1, i2c);
          if ((i < 0x94 && data[0] != 0xc3) || (i > 0x94 && data[0] != 6)) printf("%d Device %x Reg 1 Value %x\n", j, i, data[0]);
      }
      for(i = 0x90; i < 0x9E; i += 2) {
          if (i == 0x94) i = 0x9C;
          data[0] = ~i;
          x = i2c_master_write_reg(i, 7, data, 1, i2c);
      }
      for(i = 0x90; i < 0x9E; i += 2) {
          if (i == 0x94) i = 0x9C;
          data[0] = i;
          x = i2c_master_write_reg(i, 8, data, 1, i2c);
      }
      for(i = 0x90; i < 0x9E; i += 2) {
          if (i == 0x94) i = 0x9C;
          data[0] = 0;
          x = i2c_master_read_reg(i, 8, data, 1, i2c);
          if (data[0] != i) printf("%d Device %x Reg 8 Value %x\n", j, i, data[0]);
      }
      for(i = 0x90; i < 0x9E; i += 2) {
          if (i == 0x94) i = 0x9C;
          data[0] = 0;
          x = i2c_master_read_reg(i, 7, data, 1, i2c);
          if (data[0] != (~i & 0xff)) printf("%d Device %x Reg 7 Value %x\n", j, i, data[0]);
      }
  }
  return 0;
}
//::
