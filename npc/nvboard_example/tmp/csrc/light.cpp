#include <stdio.h>
#include "Vlight.h"
#include "verilated.h"
#include "verilated_fst_c.h"
#include "nvboard.h"
#include <stdlib.h>
#include <assert.h>
#include <verilated_vcd_c.h>
#include <cstdint>
#include <thread>
#include <chrono>
Vlight* top;
VerilatedContext* contextp;
void nvboard_bind_all_pins(Vlight* top);

void single_cycle() {
    top->clk = 0; top->eval();
    top->clk = 1; top->eval();
    contextp->timeInc(1);
}

void reset(int n) {
    top->rst = 1;
    while (n-- > 0){
    contextp->timeInc(1);
    top->clk = !top->clk;
    top->eval();
    } //single_cycle();
    top->rst = 0;
}

int main(int argc, char** argv){
	//VerilatedContext* contextp=new VerilatedContext;
	contextp = new VerilatedContext; //  Verilator 提供的一个 仿真上下文对象，用于管理仿真器的全局状态，如时间步长、命令行参数解析等。
	contextp->commandArgs(argc,argv); // Verilator 可能会使用 命令行参数 来调整仿真行为 通过 commandArgs()，Verilator 可以接收并处理这些参数，而不需要手动解析 argc 和 argv
	top = new Vlight;

	nvboard_bind_all_pins(top);
	nvboard_init();
    	//top->led = 0x0001;  // 初始点亮最低
    	reset(10); //复位电路 10个时钟周期，确保仿真开始时电路处于 已知的稳定状态  如果不复位，电路可能从一个 未知状态 开始，导致仿真结果不可预测。
	/*while(1){
		top->led = top->led << 1;
		if(top->led & 0x8000){
			top->led = 0x0001;
		}
		std::this_thread::sleep_for(std::chrono::seconds(1));  // 直接延迟1秒
		nvboard_update();
		//delay_cycles(CYCLE_PER_STEP);
	}
	*/
	while(!contextp->gotFinish() ){
		nvboard_update();
		contextp->timeInc(1); // 让仿真时间前进
		top->clk = !top->clk; // 翻转时钟
		top->eval(); // 计算仿真状态
	}

	nvboard_quit();
	delete top;
	delete contextp;
	return 0;
}
