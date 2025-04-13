#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vkeyboard_display.h"
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
  dut.reset = 1;
  while (n -- > 0) single_cycle();
  dut.reset = 0;
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
/*
VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;

static Vkeyboard_display *top;

void nvboard_bind_all_pins(Vkeyboard_display* top);

void step_and_dump_wave(){
  top->eval();
  contextp->timeInc(1);
  tfp->dump(contextp->time());
}

void sim_init(){
  contextp = new VerilatedContext;
  tfp = new VerilatedVcdC;
  top = new Vkeyboard_display;
  contextp->traceEverOn(true);
  top->trace(tfp, 0);
  tfp->open("dump.vcd");
}

void sim_exit(){
  step_and_dump_wave();
  tfp->close();
}

int main() {
  sim_init();
  nvboard_bind_all_pins(top);
  nvboard_init();
  top->clk = 0;
  top->reset = 1;

   while(1){
   	nvboard_update();
   	top->eval();
   	contextp->timeInc(1);
   }

  sim_exit();
  nvboard_quit();
}
*/



