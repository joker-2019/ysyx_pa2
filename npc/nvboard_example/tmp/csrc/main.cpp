#include <stdio.h>
#include <stdint.h>

#define NREG 4   //register
#define NMEM 16 //内存

//定义指令格式
typedef union 
{
	struct {uint8_t rs:2, rt:2,  op:4;}rtype; //R指令  rs源寄存器 rt目标寄存器  op操作符
	struct{uint8_t addr:4, op:4; }mtype; //M指令 addr 地址  op: 操作符  
	uint8_t inst;
	
}inst_t;

//初始化
uint32_t pc = 0x80000000; //32位pc, 初始值为0x80000000
uint8_t R[NREG] = {0}; //// 寄存器，R[0] 恒为 0
uint8_t m[NMEM] = {
	0b11100110,  // load  6#     | R[0] <- M[y]
	0b00000100,  // mov   r1, r0 | R[1] <- R[0]
	0b11100101,  // load  5#     | R[0] <- M[x]
	0b00010001,  // add   r0, r1 | R[0] <- R[0] + R[1]
	0b11110111,  // store 7#     | M[z] <- R[0]
	0b00010000,  // x = 16
	0b00100001,  // y = 33
	0b00000000,  // z = 0
}


int main(int argc, char** argv){
	
	return 0;
}
