module ysyx_22040080_alu(
	input clk,
	input [31:0] rs1_data, //来自regFile的rs1数据
	input [31:0] imm_ext,  //扩展后的立即数
	input [2:0] func3,

	//input [2:0] op,
	//input [4:0] rd_addr,   // 目标寄存器地址
	//output [4:0] rd_addr_out, //传递到写回阶段的rd地址

	output reg [31:0] result, //计算结果
	output reg wen //传递到写回阶段的写使能端

	
);

//ALU 逻辑

//ALU操作
always @(posedge clk) begin
    //new 默认值防止锁存器
    wen <= 1'b0;

    case(func3)
       3'b000: begin 
	   result <= rs1_data + imm_ext; //addi
	   wen <= 1'b1; //写使能
	   end
	default:  $display("ERROR"); //无操作符
	endcase
end

//assign rd_addr_out = rd_addr; //直接传递rd地址


endmodule
