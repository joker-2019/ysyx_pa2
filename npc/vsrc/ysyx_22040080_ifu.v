module ysyx_22040080_ifu(
	input clk, //时钟周期
	input rst,  //带n表示低电平有效
	input [31:0] pc,
	// SimpleBus接口（对接memory_dpi模块）
 output reg [31:0] ifu_raddr,
 input [31:0] ifu_rdata,     // 从memory_dpi拿到的指令（DPI-C返回值）

	output reg ifu_valid, // 取值有效
	input wire pc_update_en,
	input wire pc_valid,
	output reg ifu_respReady  // 生成respReady
	
);
 reg initial_start; // 初始化启动

	// 模拟CPU忙碌的随机延迟
	parameter RESP_READY_RAND_DELAY = 2;  // respReady延迟1~2拍
	reg [7:0] resp_ready_cnt;

always @(posedge clk) begin
	if(rst) begin
		ifu_valid <= 1'b0;
		ifu_raddr <= 32'h80000000; // 初始化地址为初始PC（避免第一次地址无效）
		initial_start <= 1'b1; // rst时置1：标识需要初始启动
		ifu_respReady <= 1'b0; // cpu准备好标识
	end else begin
		if(initial_start) begin
			ifu_valid <= 1'b1;
			initial_start <= 1'b0;
			resp_ready_cnt <= RESP_READY_RAND_DELAY-1;
		end else if (pc_valid) begin
			ifu_raddr <= pc;
			ifu_valid <= 1'b1;
			resp_ready_cnt <= RESP_READY_RAND_DELAY-1;
		end else begin
				ifu_valid <= 1'b0;
		end
		// ---------------- 新增：respReady随机延迟逻辑 ----------------
		// 1. 计数器>0：CPU忙碌，无法接收指令（respReady=0）
		if (resp_ready_cnt > 0) begin
			resp_ready_cnt <= resp_ready_cnt - 1;
			ifu_respReady <= 1'b0;
		// 2. 计数器=0：CPU就绪，可接收指令（respReady=1），并重置随机计数器
		end else begin
			ifu_respReady <= 1'b1;
		end
	end
end

endmodule
