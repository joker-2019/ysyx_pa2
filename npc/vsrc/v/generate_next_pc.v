module generate_next_pc(
 input clk,
 input rst,
 input wire [31:0] pc,
input wire is_jal,
input wire is_jalr,
input wire branch_taken,
input wire [31:0] jal_target,
output reg [31:0] next_pc
);
always @(posedge clk) begin
 if(rst) begin
  next_pc <= 32'h80000000;
 end else
 if(branch_taken || is_jal || is_jalr) begin
  next_pc <= jal_target;
 end else begin
  next_pc <= pc + 4;
 end
end
endmodule