module ysyx_22040080_ifu(
	input clk, //时钟周期
	input rst,  //带n表示低电平有效
	input [31:0] pc,

	input wire pc_update_en,
	input wire pc_valid,

	// AXI4-Lite 读通道（Master -> Slave）
	output reg [31:0] araddr,   // 读地址  ifu_raddr
	output reg arvalid,         // 读地址有效 
	input  arready,             // 从设备读地址就绪  memory的ready信号

	// AXI4-Lite 读通道（Slave -> Master）
	input  [31:0] rdata,        // 读数据 ifu_rdata
	input  rvalid,              // 读数据有效 memory的valid信号
	output reg rready          // 主机读数据就绪 ifu_respReady
);
 	reg initial_start; // 初始化启动
	reg [31:0] pc_latch;          // 仅锁存pc_valid有效时的PC（不立即给araddr）

	// 模拟CPU忙碌的随机延迟
	parameter RESP_READY_RAND_DELAY = 3;  // respReady延迟1~2拍
	reg [7:0] resp_ready_cnt;


always @(posedge clk) begin
	if(rst) begin
		initial_start <= 1'b1; // rst时置1：标识需要初始启动
		// AXI读地址通道复位
		araddr <= 32'h80000000;  // 初始PC地址 ifu_raddr
		arvalid <= 1'b0;								 // ifu_valid
		rready <= 1'b0;								  // 	ifu_respReady
		pc_latch <= 32'h80000000;  // 初始化pc_latch，避免0x0
	end else begin
		rready <= 1'b0;
		if(initial_start) begin		// 初始化
			arvalid <= 1'b1;
			initial_start <= 1'b0; 
			resp_ready_cnt <= RESP_READY_RAND_DELAY-1;
		end 
		else if (pc_valid) begin
			araddr <= pc;
			arvalid <= 1'b1;		// 发送访问内存请求
			resp_ready_cnt <= RESP_READY_RAND_DELAY-1;
		end

		if(arvalid && arready) begin
			arvalid <= 1'b0;            // 撤销arvalid，结束AR请求
		end
		// ---------------- 新增：respReady随机延迟逻辑 ----------------
		// 1. 计数器>0：CPU忙碌，无法接收指令（respReady=0）
		if(rvalid) begin
			if (resp_ready_cnt > 0) begin
				resp_ready_cnt <= resp_ready_cnt - 1;
				rready <= 1'b0;
			end else begin
				rready <= 1'b1;
			end
		end
	end
end

endmodule
