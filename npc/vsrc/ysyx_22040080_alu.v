module ysyx_22040080_alu(
	input clk,
	input [31:0] rs1_data, //来自regFile的rs1数据
	input [31:0] imm_ext,  //扩展后的立即数
	input [2:0] func3,
	
	output reg [31:0] result, //计算结果
	output reg wen //传递到写回阶段的写使能端

	
);

//ALU 逻辑

//ALU操作
always @(posedge clk) begin

    case(func3)
        3'b000: begin 
	    	result <= rs1_data + imm_ext; //addi
	    	wen <= 1'b1; //写使能
	end
	    3'b001: begin 
			result <= 32'b0; 
	    	wen <= 1'b1; //写使能
	end
	    3'b010: begin 
			result <= 32'b0;
	    	wen <= 1'b1; //写使能
	end
		3'b011: begin
			result <= 32'b0;
	    	wen <= 1'b1; //写使能 
	end
		3'b100: begin 
			result <= 32'b0;
	    	wen <= 1'b1; //写使能
	end
		3'b101: begin
			result <= 32'b0;
	    	wen <= 1'b1; //写使能 
	end
		3'b110: begin 
			result <= 32'b0;
	    	wen <= 1'b1; //写使能
	end					
	default: begin  
		result <= 32'b0;
		wen <= 1'b0;
		$display("ERROR: Unsupported func3 %b", func3);
	end
	endcase
end

endmodule
