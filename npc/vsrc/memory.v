module memory(
 input clk,
 input rst,
 input [31:0] ifu_raddr,  // 来自IFU的取指地址（硬件接口）
 input ifu_valid,  // 来自IFU的取指有效信号（硬件接口）
 output reg [31:0] ifu_rdata,  // 给IFU的指令（硬件接口）
 output reg inst_active
);
reg [31:0] curr_instr;

import "DPI-C" function int pmem_read(input int addr, input int len);
import "DPI-C" function void ebreak_trigger();  // 声明 DPI-C 函数	

always @(posedge clk) begin
 /* if (rst) begin 
  trace_instr <= 32'b0;
 end else begin */
  // 临时变量避免重复调用mem_read
  if(ifu_valid) begin 
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
  end
  end
 // end
endmodule
