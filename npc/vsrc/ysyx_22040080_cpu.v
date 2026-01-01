module ysyx_22040080_cpu(
	input  clk,
	input  rst,
  output reg [31:0] trace_pc, // 输出当前PC值
  output reg [31:0] trace_instr, // 输出当前指令
  output wire instr_done  // 新增：指令完成标志（单周期脉冲）
);
  reg [31:0] pc;
  wire [31:0] alu_result;
  wire [31:0] instruction;
  wire [4:0] rs1, rd, rs2; // rs1 rs2 和 rd 寄存器地址 
  wire [2:0] func3;
  wire [6:0] func7;
  wire [31:0] imm_ext; // 立即数扩展
  wire [4:0] shamt;
  wire [6:0] op;
  wire [31:0] rs1_data, rs2_data; // rs1 寄存器数据
  wire wen;
  // wire is_ebreak; 
  wire [2:0] instr_type; // 指令类型
  wire [31:0] jal_target; //跳转目标
  wire [31:0] next_pc;
  wire jump_flag; //是否跳转
  // wire branch_taken;
  wire [31:0] mem_addr;     // 访存地址
  wire [31:0] mem_wdata;    // SW写入内存数据
  // wire [31:0] mem_rdata;    // LW读取内存数据
  wire        is_load;      // LW指令标志
  wire        is_store;     // SW指令标志
  reg [31:0] load_data;

  // CSR
  wire        csr_wen;
  wire [11:0] csr_addr;
  wire [31:0] csr_wdata;
  wire [31:0] csr_rdata;
  wire [31:0] mcycle, mcycleh, mvendorid, marchid;
  wire [63:0] mcycle_full;
  // exception
  wire [31:0] mepc; // 发生异常的地址
  wire [31:0] mcause; // 异常号 机器模式异常号为11
  wire [31:0] mtvec; // 异常跳转地址
  wire [31:0] mstatus; // 处于那种状态，M代表机器模式 U代表user
  wire        trap_valid;      // ecall
  wire        is_mret;     // mret
  wire [31:0] trap_mepc;
  wire [31:0] trap_mcause;
  wire is_jal;
  wire is_jalr;
  wire is_branch;
  wire branch_taken;

  wire [31:0] ifu_raddr;
  wire [31:0] ifu_rdata;

  // 握手信号
  wire ifu_valid;  // 取值有效
  wire pc_update_en;
  // reg mem_done;
  reg wb_done;
  reg is_mem_inst;
  reg inst_active;
  reg pc_valid;
  reg wb_data;
  

  reg ifu_respReady;
  reg mem_respReady;

  reg lsu_reqValid;  // ID--> LSU
  reg lsu_reqReady;  // LSU --> WB

  reg lsu_respValid; // LSU --> WB
  reg lsu_respReady; // WB -- > LSU

  assign pc_update_en = wb_done;

generate_next_pc gpc(
  .clk(clk),
  .rst(rst),
  .pc(pc),
  .is_jal(is_jal),
  .is_jalr(is_jalr),
  .branch_taken(branch_taken),
  .jal_target(jal_target),
  .next_pc(next_pc)
);  

ysyx_22040080_pc pc_module(
  .clk(clk),
  .rst(rst),
  .trap_valid(trap_valid),
  .is_mret(is_mret),
  .mtvec(mtvec),
  .mepc(mepc),
  .pc(pc),
  .next_pc(next_pc),
  .pc_update_en(pc_update_en),
  .pc_valid(pc_valid),
  .trace_pc(trace_pc),
  .trace_instr(trace_instr),
  .instr_done(instr_done)
);

ysyx_22040080_ifu ifu(
  .clk(clk),
  .rst(rst),
  .pc(pc),
  .ifu_raddr(ifu_raddr),
  .ifu_rdata(instruction),
  // .trace_pc(trace_pc),
  .ifu_valid(ifu_valid),
  .pc_update_en(pc_update_en),
  .pc_valid(pc_valid),
  .ifu_respReady(ifu_respReady)
  
);


memory mem(
  .clk(clk),
  .rst(rst),
  .ifu_raddr(ifu_raddr),
  .ifu_rdata(instruction),
  .ifu_valid(ifu_valid),
  .inst_active(inst_active),
  .ifu_respReady(ifu_respReady),
  .mem_respReady(mem_respReady)
);

  //译码
ysyx_22040080_idu idu(
  .instruction(instruction),
  .inst_active(inst_active),
  .rs1(rs1),
  .rs2(rs2),
  .rd(rd),
  .func3(func3),
  .func7(func7),
  .imm_ext(imm_ext),
  .op(op),
  .shamt(shamt),
  // .is_ebreak(is_ebreak),
  .csr_addr(csr_addr),
  .instr_type(instr_type),
  //new add
  .is_jal(is_jal),
  .is_jalr(is_jalr),
  .is_branch(is_branch),
  .is_load(is_load),
  .is_store(is_store),
  .lsu_reqValid(lsu_reqValid)
);

//执行
ysyx_22040080_alu alu(
  .clk(clk),
  // .rst(rst),
  .inst_active(inst_active),
  .rs1_data(rs1_data),
  .rs2_data(rs2_data),
  .imm_ext(imm_ext),
  .func3(func3),
  .func7(func7),
  .op(op),
  .pc(pc),
  .shamt(shamt),
  .jump_flag(jump_flag),
  .jal_target(jal_target),
  .result(alu_result),
  .wen(wen),
  .branch_taken(branch_taken),
  .mem_addr(mem_addr),   // 新增: 访存地址
  .mem_wdata(mem_wdata), // 新增: SW写入内存数据
  // .mem_rdata(mem_rdata),
  // .is_load(is_load),     // 新增: LW标志
  // .is_store(is_store),   // 新增: SW标志
  // 新增CSR端口
  .csr_wen(csr_wen),
  // .csr_addr(csr_addr),
  .csr_rdata(csr_rdata),
  .csr_wdata(csr_wdata),
  // exception
  .trap_valid(trap_valid),
  .is_mret(is_mret),
  .trap_mepc(trap_mepc),
  .trap_mcause(trap_mcause)
);

// CSR模块实例化
ysyx_22040080_csr csr(
  .clk(clk),
  .rst(rst),
  .wen(csr_wen),
  .csr_addr(csr_addr),
  .wdata(csr_wdata),
  .rdata(csr_rdata),
  .mcycle(mcycle),
  .mcycleh(mcycleh),
  .mcycle_full(mcycle_full),
  .mvendorid(mvendorid),
  .marchid(marchid),
  // exception
  .mepc(mepc),
  .mcause(mcause),
  .mstatus(mstatus),
  .mtvec(mtvec),
  .trap_mepc(trap_mepc),
  .trap_mcause(trap_mcause),
  .trap_valid(trap_valid)
);

// 访存
ysyx_22040080_mem storage(
  .clk(clk),
  .rst(rst),
  .load_data(load_data),
  .is_load(is_load),
  .is_store(is_store),
  .mem_addr(mem_addr),
  .mem_wdata(mem_wdata),
  .func3(func3),
  .alu_result(alu_result),
  // .mem_done(mem_done),

  .lsu_reqValid(lsu_reqValid),
  .lsu_reqReady(lsu_reqReady),

  .lsu_respValid(lsu_respValid),
  .lsu_respReady(lsu_respReady)
);

 //寄存器堆实例
RegisterFile regfile(
  .clk(clk),
  // .wen(wen),
  .wen(wen),
  .rst(rst),
  .raddr1(rs1),
  .raddr2(rs2), // 未使用，默认设为 x0
  .waddr(rd),
  .wdata(alu_result),
  // .wdata(load_data),
  // .wdata(wb_data),
  .rdata1(rs1_data),
  .rdata2(rs2_data), // 未使用，可忽略或接空
  .wb_done(wb_done),
  .is_branch(is_branch),
  .is_load(is_load),
  // .mem_done(mem_done),
  .is_store(is_store),
  .load_data(load_data),

  .lsu_reqReady(lsu_reqReady),
  .lsu_respValid(lsu_respValid),
  .lsu_respReady(lsu_respReady)
);

endmodule
