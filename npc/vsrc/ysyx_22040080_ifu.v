module ysyx_22040080_ifu(
	input clk, //时钟周期
	input rst,  //带n表示低电平有效
	input [31:0] pc,
	output reg [31:0] instruction //输出给下一级的指令
);

import "DPI-C" function int mem_read(input int pc);
import "DPI-C" function void ebreak_trigger();  // 声明 DPI-C 函数	
always @(*) begin
			instruction = mem_read(pc); // 从 pc读取指令
			// $display("PC=0x%8h, Instruction = 0x%8h", pc, instruction);
			if(instruction == 32'b00000000000100000000000001110011) begin
				$finish;
				// ebreak_trigger();
			end
end

endmodule
