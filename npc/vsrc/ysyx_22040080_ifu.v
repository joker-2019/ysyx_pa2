module ysyx_22040080_ifu(
	input clk, //时钟周期
	input rst,  //带n表示低电平有效
	input reg [31:0] pc,
	output reg [31:0] instruction //输出给下一级的指令
);
reg [31:0] instruction_tmp;
//import "DPI-C" function uint32_t imem_read(input uint32_t pc);
import "DPI-C" function int mem_read(input int pc);	
always @(posedge clk) begin
		if(rst) begin
			instruction <=32'b0;
		end
		else begin
			instruction <= mem_read(pc); // 从 pc读取指令
			// $display("instruction %x", instruction);
			//$display("pc %x", pc);
			
    end
end

endmodule
