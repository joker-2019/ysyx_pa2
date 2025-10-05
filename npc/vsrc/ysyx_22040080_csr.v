module ysyx_22040080_csr( 
 input clk, 
 input rst, 
 input wen, 
 input [11:0] csr_addr, 
 // 写地址 
 output reg [31:0] rdata, 
 input [31:0] wdata, 
 output reg [31:0] mcycle, 
 // 低32位 
 output reg [31:0] mcycleh, 
 // 高32位 
 output reg [63:0] mcycle_full, 
 // 64位mcycle寄存器 
 output reg [31:0] mvendorid, // 厂商ID 这里指代"ysyx" 
 output reg [31:0] marchid, // 架构ID 这里指代"2025040104" 
 output reg [31:0] mepc, 
 output reg [31:0] mcause, 
 output reg [31:0] mstatus, 
 output reg [31:0] mtvec, 
 //exception 
 input trap_valid, 
 input [31:0] trap_mepc, 
 input [31:0] trap_mcause 
 );

import "DPI-C" task csr_write_commit(input int addr, input int wdata);
export "DPI-C" task get_csr_info; 
 task get_csr_info( 
  output bit[31:0] out_mstatus, 
  output bit[31:0] out_mepc, 
  output bit[31:0] out_mcause, 
  output bit[31:0] out_mtvec, 
  output bit[31:0] out_mvendorid, 
  output bit[31:0] out_marchid 
  ); 
  begin 
   out_mstatus = mstatus; 
   out_mepc = mepc; 
   out_mcause = mcause; 
   out_mtvec = mtvec; 
   out_mvendorid = mvendorid; 
   out_marchid = marchid; 
   $display("[get_csr_info] called: mtvec=0x%h, mepc=0x%h", out_mtvec, out_mepc); 
  end 
 endtask

  always @(posedge clk) begin
   if(rst) begin
    mcycle_full = 64'b0; //初始化寄存器mcycle
    mvendorid = 32'h79737978; // ysyx
    marchid = 32'h78797368; // 2025040104
    // exception
    mstatus = 32'h1800;
   end else begin
    mcycle_full = mcycle_full + 1; //每个时钟周期+1
   end
   if(wen) begin
     // $display("csr write: addr=0x%h, wdata=0x%h, wen=%b", csr_addr, wdata, wen);
     //立刻同步C端的问题，请立刻同步到c端，保证读取的是最新的值 
     if(csr_addr !=0) csr_write_commit({20'b0, csr_addr}, wdata); // 补全这个信息
     case(csr_addr)
      12'hB00: mcycle_full = { mcycle_full[63:32], wdata }; //写低32位
      12'hB80: mcycle_full = { wdata, mcycle_full[31:0] }; //写高32位
      12'h341: mepc = wdata; // mepc
      12'h342: mcause = wdata; // mcause
      12'h305: begin mtvec = wdata; $display("mtvec trigger and mtvec is :0x%h, wdata:0x%h", mtvec, wdata);  end
      12'h300: mstatus = wdata; // mstatus
      default: $display("Unsport csr_addr: %b", csr_addr);
     endcase
    end
  end

  assign mcycle = mcycle_full[31:0]; 
  assign mcycleh = mcycle_full[63:32];
  
  endmodule