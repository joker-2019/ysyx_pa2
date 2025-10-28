#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vdecode38.h"
#include <stdio.h>
#include "nvboard.h"
#include <stdlib.h>

VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;

static Vdecode38* top;

void nvboard_bind_all_pins(Vdecode38* top);

/*static void single_cycle(){
//dut.clk =0; dut.eval();
//dut.clk = 1; dut.eval();
dut. = 0; dut.eval();
dut.en = 1; dut.eval();
}

static void reset(int n){
dut.rst = 1;
while(n -- >0) single_cycle();
dut.rst = 0;
}
*/
void step_and_dump_wave(){
  top->eval();
  contextp->timeInc(1);
  tfp->dump(contextp->time());
}

void sim_init(){
  contextp = new VerilatedContext;
  tfp = new VerilatedVcdC;
  top = new Vdecode38;
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

  //reset(10);
  
 /* while(1){
   nvboard_update();
   single_cycle();
  }
  */
 /* top->en=0b0; top->x =0b00000000; step_and_dump_wave();
               top->x =0b00000001; step_and_dump_wave();
               top->x =0b00000010; step_and_dump_wave();
               top->x =0b00000100; step_and_dump_wave();
	       top->x =0b00001000; step_and_dump_wave();
	       top->x =0b00010000; step_and_dump_wave();
	       top->x =0b00100000; step_and_dump_wave();
	       top->x =0b01000000; step_and_dump_wave();
  top->en=0b1; top->x =0b00000000; step_and_dump_wave();
               top->x =0b00000001; step_and_dump_wave();
               top->x =0b00000010; step_and_dump_wave();
               top->x =0b00000100; step_and_dump_wave();
               top->x =0b00001000; step_and_dump_wave();
               top->x =0b00010000; step_and_dump_wave();
               top->x =0b00100000; step_and_dump_wave();
               top->x =0b01000000; step_and_dump_wave();
  */	      
   while(1){
   nvboard_update();
   top->eval();
   contextp->timeInc(1);
   }

   sim_exit();
  nvboard_quit();
}
