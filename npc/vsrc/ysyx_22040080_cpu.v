module ysyx_22040080_cpu(
	input  clk,
	input  rst
  
);
  reg [31:0] pc;
  wire [31:0] alu_result;
  wire [31:0] instruction;
  wire [4:0] rs1, rd;
  wire [2:0] func3;
  wire [31:0] imm_ext;
  wire [6:0] op;
  wire [31:0] rs1_data;
  wire wen;
  wire is_ebreak;
  wire [2:0] instr_type;
  wire [4:0] rs2;

import "DPI-C" function void ebreak_trigger();  // 声明 DPI-C 函数
always @(posedge clk) begin
  if(is_ebreak) begin
    ebreak_trigger();
  end

  if(rst) begin
   pc <= 32'h80000000;
  end
  else begin
    pc <= pc + 4;
  end
end

  //取指
ysyx_22040080_ifu ifu(
  .clk(clk),
  .rst(rst),
  .pc(pc),
  .instruction(instruction)
);

  //译码
ysyx_22040080_idu idu(
  .instruction(instruction),
  .rs1(rs1),
  .rs2(rs2),
  .rd(rd),
  .func3(func3),
  .imm_ext(imm_ext),
  .op(op),
  .is_ebreak(is_ebreak),
  .instr_type(instr_type)
);


  //执行
ysyx_22040080_alu alu(
  .clk(clk),
  .rs1_data(rs1_data),
  .imm_ext(imm_ext),
  .func3(func3),
  .result(alu_result),
  .wen(wen)
);

 //寄存器堆实例
RegisterFile regfile(
  .clk(clk),
  .wen(wen),
  .raddr1(rs1),
  .raddr2(5'b0), // 未使用，默认设为 x0
  .waddr(rd),
  .wdata(alu_result),
  .rdata1(rs1_data),
  .rdata2() // 未使用，可忽略或接空
);
endmodule
