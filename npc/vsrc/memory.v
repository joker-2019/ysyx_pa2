module memory(
 input clk,
 input rst,
 input [31:0] ifu_raddr,  // 来自IFU的取指地址（硬件接口）
 input ifu_valid,  // 来自IFU的取指有效信号（硬件接口）
 output reg [31:0] ifu_rdata,  // 给IFU的指令（硬件接口）
 output reg inst_active,
 output reg mem_respReady, // 存储器ready请求信号
 input ifu_respReady
);
reg [31:0] curr_instr;

// 只读延迟参数（编译期常量，仅配置，运行时不修改）
parameter READ_DELAY_CFG = 10;  // 读延迟：5个时钟周期（可改为10）
parameter REQ_READY_RAND_DELAY = 5;   // reqReady随机延迟范围（1~5周期）

// 核心寄存器：解决"ifu_valid仅1拍"的问题
reg [31:0] ifu_raddr_latch;    // 锁存请求地址（延迟期间不变）
reg [7:0]  read_delay_cnt;     // 延迟计数器（独立寄存器，代替修改parameter）
reg        req_pending;        // 锁存请求状态：标记"有未完成的读请求"
reg [7:0]  req_ready_cnt;   // reqReady随机延迟计数器

import "DPI-C" function int pmem_read(input int addr, input int len);
import "DPI-C" function void ebreak_trigger();  // 声明 DPI-C 函数	

always @(posedge clk) begin
 if (rst) begin 
  ifu_raddr_latch <= 32'b0;
  read_delay_cnt <= 8'b0;
  req_pending <=  1'b0;
  mem_respReady  <= 1'b0;
 end else begin
  inst_active <= 1'b0;
  mem_respReady <= 1'b0;
  // --------------------------
  // 1. 捕获1拍的ifu_valid：锁存地址+初始化计数器+标记请求未完成
  // --------------------------
  if(ifu_valid && !req_pending) begin
   ifu_raddr_latch <= ifu_raddr; // 锁存当前地址（仅1拍有效，必须存下来）
   read_delay_cnt <= READ_DELAY_CFG-1; // 初始化计数器（5拍→计数4→3→2→1→0）
   req_ready_cnt <=REQ_READY_RAND_DELAY-1;
   req_pending <= 1'b1;  // 锁存请求状态：标记"有未完成请求"
  end
  // --------------------------
  // 2. 延迟计数：逐周期递减，直到计数为0
  // --------------------------
  else if(req_pending) begin
   if(read_delay_cnt > 0) begin
    read_delay_cnt <= read_delay_cnt - 1;
    if(req_ready_cnt > 0) begin
     req_ready_cnt <= req_ready_cnt - 1;  
    end else begin
     read_delay_cnt <= 0;  // 存储器已就绪，强制结束读延迟
    end
   end else begin
   // --------------------------
   // 3. 延迟结束：执行读操作+返回响应
   // --------------------------
   curr_instr = pmem_read(ifu_raddr_latch, 4);
   if(curr_instr == 32'b00000000000100000000000001110011) begin
    $display("检测到ebreak, 执行$finish");
    ebreak_trigger();
   end
   ifu_rdata <= curr_instr;
   inst_active <= 1'b1;            // 置位响应信号

   // 新增：检测respReady是否有效，有效则完成响应
   if(ifu_respReady) begin
    req_pending <= 1'b0;       // 清除请求状态：延迟结束
    mem_respReady <= 1'b1; 
   end
  end
  // 临时变量避免重复调用mem_read
  /* if(ifu_valid) begin 
   curr_instr = pmem_read(ifu_raddr, 4);
   if (curr_instr == 32'b00000000000100000000000001110011) begin
    $display("检测到ebreak, 执行$finish"); // 新增打印
    ebreak_trigger(); // 触发ebreak
    // $finish(0);
   end 
   ifu_rdata <= curr_instr;  // 根据PC获取指令
   inst_active <= 1'b1; // 指令有效信号
   end else begin
   inst_active <= 1'b0;
  end */
  end
 end
end
endmodule
