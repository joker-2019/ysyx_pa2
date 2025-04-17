module ysyx_22040080_ifu(
	input clk, //时钟周期
	input rst,  //带n表示低电平有效

	output reg [31:0] instruction
);

always @(posedge clk)
        instruction <= 32'b000000000101_00000000000010010011;  // 赋值一个固定的指令

endmodule
