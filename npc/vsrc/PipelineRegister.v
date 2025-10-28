module PipelineRegister (
 input clk,
 input rst,
 input [31:0] result_in, // ALU 计算结果输入
 input [4:0] rd_in,         // 目的寄存器地址输入
 input wen_in,        // 写使能输入

 output reg [31:0] alu_result_out, // 输出到写回阶段
 output reg [4:0]  rd_out,
 output reg        wen_out
);
always @(posedge clk) begin
 if (rst) begin
  alu_result_out <= 32'b0;
  rd_out <= 5'b0;
  wen_out <= 1'b0;
  end else begin
   alu_result_out <= result_in;
   rd_out <= rd_in;
   wen_out <= wen_in;
   end
end
endmodule