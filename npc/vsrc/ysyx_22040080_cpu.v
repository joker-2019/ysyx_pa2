module ysyx_22040080_cpu(
	input  clk,
	input  rst,
  output [31:0] trace_pc, // 输出当前PC值
  output [31:0] trace_instr, // 输出当前指令
  output [31:0] dnpc // jal/jalr指令的目标地址
);
  reg [31:0] pc;
  wire [31:0] alu_result;
  wire [31:0] instruction;
  wire [4:0] rs1, rd, rs2; // rs1 rs2 和 rd 寄存器地址
  wire [2:0] func3;
  wire [31:0] imm_ext; // 立即数扩展
  wire [6:0] op;
  wire [31:0] rs1_data, rs2_data; // rs1 寄存器数据
  wire wen;
  wire is_ebreak; 
  wire [2:0] instr_type; // 指令类型
  wire [31:0] jal_target; //跳转目标
  wire [31:0] next_pc;

// import "DPI-C" function void ebreak_trigger();  // 声明 DPI-C 函数

  // PC更新逻辑：新增分支、jal、jalr判断
  wire is_jal    = (op == 7'b1101111);
  wire is_jalr   = (op == 7'b1100111);
  wire is_branch = (op == 7'b1100011);

  wire branch_taken = is_branch && (
    (func3 == 3'b000 && rs1_data == rs2_data) ||       // beq
    (func3 == 3'b001 && rs1_data != rs2_data) ||       // bne
    (func3 == 3'b100 && $signed(rs1_data) < $signed(rs2_data)) || // blt
    (func3 == 3'b101 && $signed(rs1_data) >= $signed(rs2_data))   // bge
  );
  wire [31:0] branch_target = pc + imm_ext;

  assign next_pc = branch_taken     ? branch_target :
                   (is_jal || is_jalr) ? jal_target :
                   pc + 4;

always @(posedge clk) begin
  // 初始化
  if(rst) begin
   pc <= 32'h80000000;
  end else
    pc <= next_pc;
end

  //取指 else if (is_ebreak && !halted) begin
  //  halted <= 1;
  // 不更新PC
  // end
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
  .op(op),
  .pc(pc),
  .jal_target(jal_target),
  .result(alu_result),
  .wen(wen)
);

assign dnpc = jal_target; // 如果jal_target为0，则使用next_pc

 //寄存器堆实例
RegisterFile regfile(
  .clk(clk),
  .wen(wen),
  .raddr1(rs1),
  .raddr2(5'b0), // 未使用，默认设为 x0
  .waddr(rd),
  .wdata(alu_result),
  .rdata1(rs1_data),
  .rdata2(rs2_data) // 未使用，可忽略或接空
);

// itrace 用信号输出
assign trace_pc =  pc; // 输出当前PC值
assign trace_instr = instruction; // 输出当前指令
endmodule
