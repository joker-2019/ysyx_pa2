module ysyx_22040080_csr(
  input         clk,
  input         rst,
  input         wen,
  input  [11:0] addr,
  input  [31:0] wdata,
  // output [31:0] rdata,
  output [31:0] mcycle, // 低32位
  output [31:0] mcycleh, // 高32位
  output reg [63:0] mcycle_full, // 64位mcycle寄存器
  output reg [31:0] mvendorid, // 厂商ID 这里指代"ysyx"
  output reg [31:0] marchid,  // 架构ID 这里指代"2025040104"
  output reg [31:0] mepc,
  output reg [31:0] mcause,
  output reg [31:0] mstatus,
  output reg [31:0] mtvec,
  //exception
  input trap_valid,
  input [31:0] trap_mepc,
  input [31:0] trap_mcause
);

always @(posedge clk) begin
  if(rst) begin
    mcycle_full <= 64'b0; //初始化寄存器mcycle
    mvendorid <= 32'h79737978; // ysyx
    marchid <= 32'h78797368; // 2025040104
    // exception
    mepc <= 32'b0;
    mcause  <= 32'b0;
    mstatus <= 32'h00001800;
    // mtvec <= 32'h80000000; 
  end else begin
     mcycle_full <= mcycle_full + 1; //每个时钟周期+1
     if(wen) begin
      case(addr)
        12'hB00: mcycle_full <= { mcycle_full[63:32], wdata }; //写低32位
        12'hB80: mcycle_full <= { wdata, mcycle_full[31:0] }; //写高32位
        12'h341: mepc    <= wdata;  // mepc
        12'h342: mcause  <= wdata;  // mcause
        12'h305: mtvec   <= wdata;  // mtvec
        12'h300: mstatus <= wdata;  // mstatus
        default: ; // 忽略其他操作
      endcase
     end

     if(trap_valid) begin // 异常发生时，写入异常信息
      mepc <= trap_mepc;
      mcause <= trap_mcause;
      end
  end
end

assign mcycle  = mcycle_full[31:0];
assign mcycleh = mcycle_full[63:32];

endmodule
