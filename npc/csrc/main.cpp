#include <stdio.h>
#include "Vtop.h"
#include "verilated.h"
#include "verilated_fst_c.h"
#include "nvboard.h"
#include <stdlib.h>
#include <assert.h>
#include <verilated_vcd_c.h>
static TOP_NAME dut;
Vtop* top;
void nvboard_bind_all_pins(Vtop* top);

int main(int argc, char** argv){
	VerilatedContext* contextp=new VerilatedContext;
	contextp->commandArgs(argc,argv);
	top = new Vtop;

	nvboard_bind_all_pins(&dut);
	nvboard_init();
	while(1){
		dut.eval();
		nvboard_update();
		contextp->timeInc(1);
	}

	nvboard_quit();
	delete top;
	return 0;
}
