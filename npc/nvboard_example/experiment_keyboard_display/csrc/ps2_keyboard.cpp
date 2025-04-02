#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vps2_keyboard.h"
#include <stdio.h>
#include "nvboard.h"
#include <stdlib.h>
static TOP_NAME dut;

void nvboard_bind_all_pins(TOP_NAME* top);

static void single_cycle() {
  dut.clk = 0; dut.eval();
  dut.clk = 1; dut.eval();
}

static void reset(int n) {
  dut.clrn = 1;
  while (n -- > 0) single_cycle();
  dut.clrn = 0;
}

int main() {
  nvboard_bind_all_pins(&dut);
  nvboard_init();

  reset(10);

  while(1) {
    nvboard_update();
    single_cycle();
  }
}

