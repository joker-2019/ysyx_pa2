module ysyx_22040080_csr(
  input         clk,
  input         rst,
  input         wen,
  input  [11:0] addr,
  input  [31:0] wdata,
  // output [31:0] rdata,
  output [31:0] mcycle, // 低32位
  output [31:0] mcycleh, // 高32位
  output reg [63:0] mcycle_full // 64位mcycle寄存器
);

// reg [63:0] mcycle_full; // 64位mcycle寄存器

always @(posedge clk) begin
  if(rst) begin
    mcycle_full <= 64'b0; //初始化寄存器mcycle
  end else begin
     mcycle_full <= mcycle_full + 1; //每个时钟周期+1
     if(wen) begin
      case(addr)
        12'hB00: begin mcycle_full[31:0] <= wdata; end //写低32位
        12'hB80: begin mcycle_full[63:32] <= wdata; end //写高32位
        default: ; // 忽略其他操作
      endcase
     end
  end
end

endmodule
