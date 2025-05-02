module ysyx_22040080_ifu(
	input clk, //时钟周期
	input rst,  //带n表示低电平有效
	input reg [31:0] pc,
	output reg [31:0] instruction //输出给下一级的指令
);

//import "DPI-C" function uint32_t imem_read(input uint32_t pc);
import "DPI-C" function int imem_read(input int pc);	
always @(posedge clk) begin
		if(rst) begin
			instruction <=32'b0;
		end
		else begin
			$display("pc %x", pc);
            instruction <= imem_read(pc); // 从 C++ 读取指令
			//instruction <= pc;
			//$display("pc %x", pc);
			
    end
end

endmodule
