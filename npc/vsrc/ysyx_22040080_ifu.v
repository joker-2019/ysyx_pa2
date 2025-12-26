module ysyx_22040080_ifu(
	input clk, //时钟周期
	input rst,  //带n表示低电平有效
	input [31:0] pc,
	// SimpleBus接口（对接memory_dpi模块）
 output reg [31:0] ifu_raddr,
 input [31:0] ifu_rdata,     // 从memory_dpi拿到的指令（DPI-C返回值）

	// output reg [31:0] instruction, //输出给下一级的指令
	// output reg [31:0] trace_pc,

	output reg ifu_valid, // 取值有效

	// output reg if_id_valid, // 取值完成标记
	// input wire idu_ready // 与IDU的握手信号
	input wire pc_update_en,
	input wire pc_valid
	// output reg inst_active
	
);
 reg initial_start; // 初始化启动
always @(posedge clk) begin
	if(rst) begin
		ifu_valid <= 1'b0;
		ifu_raddr <= 32'h80000000; // 初始化地址为初始PC（避免第一次地址无效）
		// trace_pc <= 32'h80000000;
		initial_start <= 1'b1; // rst时置1：标识需要初始启动
	end else begin
		if(initial_start) begin
			ifu_valid <= 1'b1;
			initial_start <= 1'b0;
		end else if (pc_valid) begin
			ifu_raddr <= pc;
			// trace_pc <= pc;
			ifu_valid <= 1'b1;
		end else begin
				ifu_valid <= 1'b0;
		end
	end
end

endmodule
