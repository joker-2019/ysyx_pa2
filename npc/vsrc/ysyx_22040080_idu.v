
import "DPI-C" function int gpr(int idx);
module ysyx_22040080_idu(
	input [31:0] instruction, //来自IFU的指令
	input clk;

	output [4:0] rs1, // 源寄存器rs1的地址
	output [4:0] rd, // 目标寄存器rd地址
	output [2:0] func3;
	output [31:0] imm_ext, //符号扩展后的立即数
	output [6:0] op	// 操作符
	
);
reg [31:0]ins1;
initial
	ins1 = {{27{1'b0}},instruction[19:15]};
always @(posedge clk) begin
    rs1 = gpr(ins1);
    imm = {{20{1'b0}},ins[31:20]};
end


//RISC-V的addi指令格式为I-type类型
//| 31      20 | 19   15 | 14   12 | 11    7 | 6    0 |
// | imm[11:0] | rs1     | funct3  | rd      | opcode |
//assign rs1_addr = instruction[19:15]; //rs1字段
//assign rd_addr = instruction[11:7];  //rd字段
//wire [11:0] imm = instruction[31:20]; //立即数低12位
//符号扩展立即数
//assign imm_ext = {{20{imm[11]}},imm};
// 提取 opcode 和 funct3
//wire [6:0] opcode = instruction[6:0];
//wire [2:0] funct3 = instruction[14:12];
//控制信号
//assign op = 3'b000; //定义alu操作(加法)
// 暂时仅支持 I-type 算术类，直接输出 funct3 作为 op 控制
//assign op = (opcode == 7'b0010011) ? funct3 : 3'b000;

endmodule
