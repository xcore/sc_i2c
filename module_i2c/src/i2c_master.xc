#include <i2c.h>
#include <xs1.h>
#include <xclib.h>

static void wait_quarter(unsigned bit_time) {
    timer gt;
    int time;

    gt :> time;
    time += (bit_time + 3) / 4;
    gt when timerafter(time) :> int _;
}

static void wait_half(unsigned bit_time) {
    wait_quarter(bit_time);
    wait_quarter(bit_time);
}

static int high_pulse_sample(port i2c_scl, port ?i2c_sda, unsigned bit_time) {
    int temp;
    if (!isnull(i2c_sda)) {
        i2c_sda :> int _;
    }
    wait_quarter(bit_time);
    i2c_scl :> void;
    wait_quarter(bit_time);
    if (!isnull(i2c_sda)) {
        i2c_sda :> temp;
    }
    wait_quarter(bit_time);
    i2c_scl <: 0;
    wait_quarter(bit_time);
    return temp;
}

static void high_pulse(port i2c_scl, unsigned bit_time) {
   high_pulse_sample(i2c_scl, null, bit_time);
}

static void start_bit(port i2c_scl, port i2c_sda, unsigned bit_time) {
    wait_quarter(bit_time);
    i2c_sda  <: 0;
    wait_half(bit_time);
    i2c_scl  <: 0;
    wait_quarter(bit_time);
}

static void stop_bit(port i2c_scl, port i2c_sda, unsigned bit_time) {
    wait_quarter(bit_time);
    i2c_scl :> void;
    wait_half(bit_time);
    i2c_sda :> void;
    wait_quarter(bit_time);
}


static int tx8(port p_scl, port p_sda, unsigned data, unsigned bit_time) {
  unsigned CtlAdrsData = ((unsigned) bitrev(data)) >> 24;
  for (int i = 8; i != 0; i--) {
    p_sda <: >> CtlAdrsData;
    high_pulse(p_scl, bit_time);
  }
  return high_pulse_sample(p_scl, p_sda, bit_time);
}

static unsigned char rx(int device, port p_scl, port p_sda, unsigned bit_time)
{
   unsigned char data = 0;
   start_bit(p_scl, p_sda, bit_time);
   tx8(p_scl, p_sda, (device << 1) | 1, bit_time);
   for (int i = 8; i != 0; i--) {
     int temp = high_pulse_sample(p_scl, p_sda, bit_time);
     data = (data << 1) | temp;
   }
   (void) high_pulse_sample(p_scl, p_sda, bit_time);
   stop_bit(p_scl, p_sda, bit_time);
   return data;
}

[[distributable]]
void i2c_master(server interface i2c_master_if c[n], size_t n,
                port p_scl, port p_sda, unsigned kbits_per_second)
{
  unsigned bit_time = (XS1_TIMER_MHZ * 1000) / kbits_per_second;
  p_scl :> void;
  p_sda :> void;
  while (1) {
    select {
    case c[int i].rx(uint8_t device, uint8_t buf[n], size_t n):
      for (int j = 0; j < n; j++)
        buf[j] = rx(device, p_scl, p_sda, bit_time);
      break;

    case c[int i].tx(uint8_t device, uint8_t buf[n], size_t n) -> i2c_write_res_t result:
      int ack = 0;
      start_bit(p_scl, p_sda, bit_time);
      tx8(p_scl, p_sda, (device << 1), bit_time);
      for (int j = 0; j < n; j++)
        ack |= tx8(p_scl, p_sda, buf[j], bit_time);
      stop_bit(p_scl, p_sda, bit_time);
      result = (ack == 0) ? I2C_WRITE_ACK_SUCCEEDED : I2C_WRITE_ACK_FAILED;
      break;
    }
  }
}


extends client interface i2c_master_if : {
  extern inline void read_reg_n_m(client interface i2c_master_if i,
                           uint8_t device_addr,
                           uint8_t reg[m],
                           size_t m,
                           uint8_t data[n],
                           size_t n);

  extern inline uint8_t read_reg_8_8(client interface i2c_master_if i,
                                     uint8_t device_addr, uint8_t reg);

  extern inline uint8_t read_reg(client interface i2c_master_if i,
                                 uint8_t device_addr, uint8_t reg);

  extern inline void write_reg_n_m(client interface i2c_master_if i,
                                   uint8_t device_addr,
                                   uint8_t reg[m],
                                   size_t m,
                                   uint8_t data[n],
                                   size_t n);

  extern inline void write_reg_8_8(client interface i2c_master_if i,
                                   uint8_t device_addr, uint8_t reg,
                                   uint8_t data);

  extern inline void write_reg(client interface i2c_master_if i,
                               uint8_t device_addr, uint8_t reg, uint8_t data);
}
