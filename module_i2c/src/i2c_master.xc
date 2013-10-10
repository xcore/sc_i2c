#include <i2c.h>
#include <xs1.h>
#include <xclib.h>

static void wait_quarter(void) {
    timer gt;
    int time;

    gt :> time;
    time += (I2C_BIT_TIME + 3) / 4;
    gt when timerafter(time) :> int _;
}

static void wait_half(void) {
    wait_quarter();
    wait_quarter();
}

static int high_pulse_sample(port i2c_scl, port ?i2c_sda) {
    int temp;
    if (!isnull(i2c_sda)) {
        i2c_sda :> int _;
    }
    wait_quarter();
    i2c_scl :> void;
    wait_quarter();
    if (!isnull(i2c_sda)) {
        i2c_sda :> temp;
    }
    wait_quarter();
    i2c_scl <: 0;
    wait_quarter();
    return temp;
}

static void high_pulse(port i2c_scl) {
    high_pulse_sample(i2c_scl, null);
}

static void start_bit(port i2c_scl, port i2c_sda) {
    wait_quarter();
    i2c_sda  <: 0;
    wait_half();
    i2c_scl  <: 0;
    wait_quarter();
}

static void stop_bit(port i2c_scl, port i2c_sda) {
    wait_quarter();
    i2c_scl :> void;
    wait_half();
    i2c_sda :> void;
    wait_quarter();
}


static int tx8(port p_scl, port p_sda, unsigned data) {
  unsigned CtlAdrsData = ((unsigned) bitrev(data)) >> 24;
  for (int i = 8; i != 0; i--) {
    p_sda <: >> CtlAdrsData;
    high_pulse(p_scl);
  }
  return high_pulse_sample(p_scl, p_sda);
}

static unsigned char rx(int device, port p_scl, port p_sda)
{
   unsigned char data = 0;
   start_bit(p_scl, p_sda);
   tx8(p_scl, p_sda, (device << 1) | 1);
   for (int i = 8; i != 0; i--) {
     int temp = high_pulse_sample(p_scl, p_sda);
     data = (data << 1) | temp;
   }
   (void) high_pulse_sample(p_scl, p_sda);
   stop_bit(p_scl, p_sda);
   return data;
}

[[distributable]]
void i2c_master(server interface i2c_master_if c[n], unsigned n,
                port p_scl, port p_sda)
{
  p_scl :> void;
  p_sda :> void;
  while (1) {
    select {
    case c[int i].rx(unsigned device, unsigned char buf[n], unsigned n):
      for (int j = 0; j < n; j++)
        buf[j] = rx(device, p_scl, p_sda);
      break;

    case c[int i].tx(unsigned char buf[n], unsigned n) -> i2c_write_res_t result:
      int ack = 0;
      start_bit(p_scl, p_sda);
      for (int j = 0; j < n; j++)
        ack |= tx8(p_scl, p_sda, buf[j]);
      stop_bit(p_scl, p_sda);
      result = (ack == 0) ? I2C_WRITE_ACK_SUCCEEDED : I2C_WRITE_ACK_FAILED;
      break;

    case c[int i].read_reg(unsigned device, unsigned addr) -> char data:
      start_bit(p_scl, p_sda);
      tx8(p_scl, p_sda, device << 1);
      tx8(p_scl, p_sda, addr);
      stop_bit(p_scl, p_sda);
      data = rx(device, p_scl, p_sda);
      break;

    case c[int i].write_reg(unsigned device,
                            unsigned addr,
                            char data)        -> i2c_write_res_t result:
      int ack;
      start_bit(p_scl, p_sda);
      ack  = tx8(p_scl, p_sda, device << 1);
      ack |= tx8(p_scl, p_sda, addr);
      ack |= tx8(p_scl, p_sda, data);
      stop_bit(p_scl, p_sda);
      result = (ack == 0) ? I2C_WRITE_ACK_SUCCEEDED : I2C_WRITE_ACK_FAILED;
      break;
    }
  }
}
