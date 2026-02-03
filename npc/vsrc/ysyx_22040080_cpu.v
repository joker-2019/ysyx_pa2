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
  wire [31:0] lsu_mem_addr;     // 访存地址
  wire [31:0] lsu_mem_wdata;    // SW写入内存数据
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

  wire pc_update_en;
  reg wb_done;
  reg is_mem_inst;
  wire inst_active;  // 告知idu指令有效信号
  reg pc_valid;
  reg wb_data;

  reg [2:0] lsu_func3;
 // ifu AXI握手信号
  wire ifu_arvalid;     // ifu_valid;  // 取值有效  ifu--> memory pc更新后发出取值请求
  wire ifu_arready;  // mem_respReady  // memory --> ifu  存储器空闲，响应取值请求
  wire ifu_rvalid;   // mem 读取完请求信号
  wire ifu_rready;   //   ifu_respReady
  wire [31:0] ifu_araddr; //  ifu_raddr 
  wire [31:0] ifu_rdata;  //  ifu_rdata


// lsu-read AXI信号
  wire [31:0] lsu_araddr;
  wire lsu_arvalid;
  wire lsu_arready;
  wire [31:0] lsu_rdata;
  wire lsu_rvalid;
  wire lsu_rready;

  wire [31:0] lsu_awaddr;
  wire lsu_awvalid;
  wire lsu_awready;
  wire [31:0] lsu_wdata;

  wire lsu_wvalid;
  wire lsu_wready;
  wire lsu_bvalid;
  wire lsu_bready;

  // Arbiter -> Xbar AXI4-Lite 接口
  wire [31:0] axi_araddr;
  wire axi_arvalid;
  wire axi_arready;
  wire [31:0] axi_rdata;
  wire axi_rvalid;
  wire axi_rready;
  wire [31:0] axi_awaddr;
  wire axi_awvalid;
  wire axi_awready;
  wire [31:0] axi_wdata;
  wire axi_wvalid;
  wire axi_wready;
  wire axi_bvalid;
  wire axi_bready;
  wire [2:0] axi_func3;

  // Xbar -> Memory AXI4-Lite 接口
  wire [31:0] mem_araddr;
  wire mem_arvalid;
  wire mem_arready;
  wire [31:0] mem_rdata;
  wire mem_rvalid;
  wire mem_rready;
  wire [31:0] mem_awaddr;
  wire mem_awvalid;
  wire mem_awready;
  wire [31:0] mem_wdata;
  wire mem_wvalid;
  wire mem_wready;
  wire mem_bvalid;
  wire mem_bready;
  wire [2:0] mem_func3;

  // Xbar -> UART AXI4-Lite 接口
  wire [31:0] uart_araddr;
  wire uart_arvalid;
  wire uart_arready;
  wire [31:0] uart_rdata;
  wire uart_rvalid;
  wire uart_rready;
  wire [31:0] uart_awaddr;
  wire uart_awvalid;
  wire uart_awready;
  wire [31:0] uart_wdata;
  wire uart_wvalid;
  wire uart_wready;
  wire uart_bvalid;
  wire uart_bready;

  // Xbar -> CLINT AXI4-Lite 接口
  wire [31:0] clint_araddr;
  wire clint_arvalid;
  wire clint_arready;
  wire [31:0] clint_rdata;
  wire clint_rvalid;
  wire clint_rready;
  wire [31:0] clint_awaddr;
  wire clint_awvalid;
  wire clint_awready;
  wire [31:0] clint_wdata;
  wire clint_wvalid;
  wire clint_wready;
  wire clint_bvalid;
  wire clint_bready;

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
  .araddr(ifu_araddr),
  .rdata(ifu_rdata),
  .arvalid(ifu_arvalid),  // ifu_valid
  .arready(ifu_arready),  // mem_respReady
  .rvalid(ifu_rvalid),    // mem 读取完请求信号
  .rready(ifu_rready),    // ifu_respReady
  .pc_update_en(pc_update_en),
  .pc_valid(pc_valid) 
);
  // 总线仲裁器
ysyx_22040080_axi_arbiter arbiter(
  .clk(clk),
  .rst(rst),

  // IFU
  .ifu_araddr(ifu_araddr),
  .ifu_arvalid(ifu_arvalid),
  .ifu_arready(ifu_arready),
  .ifu_rdata(ifu_rdata),
  .ifu_rvalid(ifu_rvalid),
  .ifu_rready(ifu_rready),

  // LSU read
  .lsu_araddr(lsu_araddr),
  .lsu_arvalid(lsu_arvalid),
  .lsu_arready(lsu_arready),
  .lsu_rdata(lsu_rdata),
  .lsu_rvalid(lsu_rvalid),
  .lsu_rready(lsu_rready),

  // LSU write
  .lsu_awaddr(lsu_awaddr),
  .lsu_awvalid(lsu_awvalid),
  .lsu_awready(lsu_awready),
  .lsu_wdata(lsu_wdata),
  .lsu_wvalid(lsu_wvalid),
  .lsu_wready(lsu_wready),
  .lsu_bvalid(lsu_bvalid),
  .lsu_bready(lsu_bready),

  .lsu_func3(lsu_func3),

  // Memory side
  .m_araddr(axi_araddr),
  .m_arvalid(axi_arvalid),
  .m_arready(axi_arready),
  .m_rdata(axi_rdata),
  .m_rvalid(axi_rvalid),
  .m_rready(axi_rready),

  .m_awaddr(axi_awaddr),
  .m_awvalid(axi_awvalid),
  .m_awready(axi_awready),
  .m_wdata(axi_wdata),
  .m_wvalid(axi_wvalid),
  .m_wready(axi_wready),

  .m_bvalid(axi_bvalid),
  .m_bready(axi_bready),

  .m_func3(axi_func3),
  .inst_active(inst_active)
);

// 多路开关模块 (实现内存映射I/O.)  Xbar -> Memory, UART
ysyx_22040080_axi_xbar xbar(
  .clk(clk),
  .rst(rst),

  // Master side
  .m_araddr(axi_araddr),
  .m_arvalid(axi_arvalid),
  .m_arready(axi_arready),
  .m_rdata(axi_rdata),
  .m_rvalid(axi_rvalid),
  .m_rready(axi_rready),

  .m_awaddr(axi_awaddr),
  .m_awvalid(axi_awvalid),
  .m_awready(axi_awready),
  .m_wdata(axi_wdata),
  .m_wvalid(axi_wvalid),
  .m_wready(axi_wready),
  .m_bvalid(axi_bvalid),
  .m_bready(axi_bready),

  .m_func3(axi_func3),

  // Memory slave
  .mem_araddr(mem_araddr),
  .mem_arvalid(mem_arvalid),
  .mem_arready(mem_arready),
  .mem_rdata(mem_rdata),
  .mem_rvalid(mem_rvalid),
  .mem_rready(mem_rready),

  .mem_awaddr(mem_awaddr),
  .mem_awvalid(mem_awvalid),
  .mem_awready(mem_awready),
  .mem_wdata(mem_wdata),
  .mem_wvalid(mem_wvalid),
  .mem_wready(mem_wready),
  .mem_bvalid(mem_bvalid),
  .mem_bready(mem_bready),
  .mem_func3(mem_func3),

  // CLINT slave
  .clint_araddr(clint_araddr),
  .clint_arvalid(clint_arvalid),
  .clint_arready(clint_arready),
  .clint_rdata(clint_rdata),
  .clint_rvalid(clint_rvalid),
  .clint_rready(clint_rready),

  .clint_awaddr(clint_awaddr),
  .clint_awvalid(clint_awvalid),
  .clint_awready(clint_awready),
  .clint_wdata(clint_wdata),
  .clint_wvalid(clint_wvalid),
  .clint_wready(clint_wready),
  .clint_bvalid(clint_bvalid),
  .clint_bready(clint_bready),

  // UART slave
  .uart_araddr(uart_araddr),
  .uart_arvalid(uart_arvalid),
  .uart_arready(uart_arready),
  .uart_rdata(uart_rdata),
  .uart_rvalid(uart_rvalid),
  .uart_rready(uart_rready),

  .uart_awaddr(uart_awaddr),
  .uart_awvalid(uart_awvalid),
  .uart_awready(uart_awready),
  .uart_wdata(uart_wdata),
  .uart_wvalid(uart_wvalid),
  .uart_wready(uart_wready),
  .uart_bvalid(uart_bvalid),
  .uart_bready(uart_bready)
);

// Memory
memory mem(
  .clk(clk),
  .rst(rst),

  .araddr(mem_araddr),
  .arvalid(mem_arvalid),
  .arready(mem_arready),
  .rdata(mem_rdata),
  .rvalid(mem_rvalid),
  .rready(mem_rready),

  .awaddr(mem_awaddr),
  .awvalid(mem_awvalid),
  .awready(mem_awready),
  .wdata(mem_wdata),
  .wvalid(mem_wvalid),
  .wready(mem_wready),

  .bvalid(mem_bvalid),
  .bready(mem_bready),

  .func3(mem_func3)
);

// UART
ysyx_22040080_uart_axi uart(
  .clk(clk),
  .rst(rst),

  .araddr(uart_araddr),
  .arvalid(uart_arvalid),
  .arready(uart_arready),
  .rdata(uart_rdata),
  .rvalid(uart_rvalid),
  .rready(uart_rready),

  .awaddr(uart_awaddr),
  .awvalid(uart_awvalid),
  .awready(uart_awready),
  .wdata(uart_wdata),
  .wvalid(uart_wvalid),
  .wready(uart_wready),

  .bvalid(uart_bvalid),
  .bready(uart_bready)
);

ysyx_22040080_clint_axi clint(
  .clk(clk),
  .rst(rst),

  .araddr(clint_araddr),
  .arvalid(clint_arvalid),
  .arready(clint_arready),
  .rdata(clint_rdata),
  .rvalid(clint_rvalid),
  .rready(clint_rready),

  .awaddr(clint_awaddr),
  .awvalid(clint_awvalid),
  .awready(clint_awready),
  .wdata(clint_wdata),
  .wvalid(clint_wvalid),
  .wready(clint_wready),

  .bvalid(clint_bvalid),
  .bready(clint_bready)
);

  //译码
ysyx_22040080_idu idu(
  .rdata(ifu_rdata),
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
  .mem_addr(lsu_mem_addr),   // 新增: 访存地址
  .mem_wdata(lsu_mem_wdata), // 新增: SW写入内存数据
  // 新增CSR端口
  .csr_wen(csr_wen),
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
ysyx_22040080_lsu lsu(
  .clk(clk),
  .rst(rst),
  .load_data(load_data),
  .is_load(is_load),
  .is_store(is_store),
  .mem_addr(lsu_mem_addr),
  .mem_wdata(lsu_mem_wdata),
  .func3(func3),
  .alu_result(alu_result),
  .lsu_func3(lsu_func3),

  // lsu read channel
  .araddr(lsu_araddr),
  .rdata(lsu_rdata),

  .arvalid(lsu_arvalid),
  .arready(lsu_arready),
  .rvalid(lsu_rvalid),
  .rready(lsu_rready),

  // lsu write channel 
  .awaddr(lsu_awaddr),
  .wdata(lsu_wdata),

  .awvalid(lsu_awvalid),
  .awready(lsu_awready),

  .wvalid(lsu_wvalid),
  .wready(lsu_wready),

  .bvalid(lsu_bvalid),
  .bready(lsu_bready),

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
