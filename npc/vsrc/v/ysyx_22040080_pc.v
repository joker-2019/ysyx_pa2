module ysyx_22040080_pc (
    input  wire        clk,
    input  wire        rst,
    input  wire        trap_valid,
    input  wire        is_mret,
    input  wire [31:0] mtvec,
    input  wire [31:0] mepc,
    output reg  [31:0] pc,
    output reg  pc_valid,
    input wire [31:0] next_pc,
    input wire         pc_update_en, // alu阶段指令执行完成信号
    output reg  [31:0] trace_pc,
    output reg  [31:0] trace_instr,
    output reg  instr_done
);
import "DPI-C" function int pmem_read(input int addr, input int len);

always @(posedge clk) begin
  if (rst) begin
    pc <= 32'h80000000;
    trace_pc <= 32'h80000000;
    trace_instr <= 32'b0;
    instr_done <= 1'b0;
  end else if (pc_update_en) begin
  if (trap_valid)
    pc <= mtvec;
  else if (is_mret)
    pc <= mepc;
  else begin
    pc <= next_pc;
    pc_valid <= 1'b1;
    trace_pc <= next_pc;
    trace_instr <= pmem_read(next_pc, 4);
    instr_done <= 1'b1;
  end
  end else begin
    pc_valid <= 1'b0;
    trace_instr <= pmem_read(pc, 4);
    instr_done <= 1'b0;
  end
    
end

endmodule