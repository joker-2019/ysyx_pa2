module generate_next_pc(
  input         clock,
  input         reset,
  input  [31:0] io_pc, // @[scala/ysyx/generate_next_pc.scala 7:14]
  input         io_is_jal, // @[scala/ysyx/generate_next_pc.scala 7:14]
  input         io_is_jalr, // @[scala/ysyx/generate_next_pc.scala 7:14]
  input         io_branch_taken, // @[scala/ysyx/generate_next_pc.scala 7:14]
  input  [31:0] io_jal_target, // @[scala/ysyx/generate_next_pc.scala 7:14]
  output [31:0] io_next_pc // @[scala/ysyx/generate_next_pc.scala 7:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] nextPcReg; // @[scala/ysyx/generate_next_pc.scala 17:26]
  wire [31:0] _nextPcReg_T_1 = io_pc + 32'h4; // @[scala/ysyx/generate_next_pc.scala 22:24]
  assign io_next_pc = nextPcReg; // @[scala/ysyx/generate_next_pc.scala 25:14]
  always @(posedge clock) begin
    if (reset) begin // @[scala/ysyx/generate_next_pc.scala 17:26]
      nextPcReg <= 32'h20000000; // @[scala/ysyx/generate_next_pc.scala 17:26]
    end else if (io_branch_taken | io_is_jal | io_is_jalr) begin // @[scala/ysyx/generate_next_pc.scala 19:52]
      nextPcReg <= io_jal_target; // @[scala/ysyx/generate_next_pc.scala 20:15]
    end else begin
      nextPcReg <= _nextPcReg_T_1; // @[scala/ysyx/generate_next_pc.scala 22:15]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  nextPcReg = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_22040080_pc(
  input         clock,
  input         reset,
  input         io_trap_valid, // @[scala/ysyx/ysyx_22040080_pc.scala 67:14]
  input         io_access_fault, // @[scala/ysyx/ysyx_22040080_pc.scala 67:14]
  input         io_is_mret, // @[scala/ysyx/ysyx_22040080_pc.scala 67:14]
  input  [31:0] io_mtvec, // @[scala/ysyx/ysyx_22040080_pc.scala 67:14]
  input  [31:0] io_mepc, // @[scala/ysyx/ysyx_22040080_pc.scala 67:14]
  output [31:0] io_pc, // @[scala/ysyx/ysyx_22040080_pc.scala 67:14]
  output        io_pc_valid, // @[scala/ysyx/ysyx_22040080_pc.scala 67:14]
  input  [31:0] io_next_pc, // @[scala/ysyx/ysyx_22040080_pc.scala 67:14]
  input         io_pc_update_en // @[scala/ysyx/ysyx_22040080_pc.scala 67:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
`endif // RANDOMIZE_REG_INIT
  wire [31:0] pmemReader_addr; // @[scala/ysyx/ysyx_22040080_pc.scala 91:26]
  wire [31:0] pmemReader_len; // @[scala/ysyx/ysyx_22040080_pc.scala 91:26]
  wire [31:0] pmemReader_data; // @[scala/ysyx/ysyx_22040080_pc.scala 91:26]
  wire  getInstrPc_clk; // @[scala/ysyx/ysyx_22040080_pc.scala 98:26]
  wire [31:0] getInstrPc_trace_pc; // @[scala/ysyx/ysyx_22040080_pc.scala 98:26]
  wire [31:0] getInstrPc_trace_instr; // @[scala/ysyx/ysyx_22040080_pc.scala 98:26]
  wire  getInstrPc_instr_done; // @[scala/ysyx/ysyx_22040080_pc.scala 98:26]
  reg [31:0] pcReg; // @[scala/ysyx/ysyx_22040080_pc.scala 82:30]
  reg  pcValidReg; // @[scala/ysyx/ysyx_22040080_pc.scala 83:30]
  reg [31:0] tracePcReg; // @[scala/ysyx/ysyx_22040080_pc.scala 84:30]
  reg [31:0] traceInstrReg; // @[scala/ysyx/ysyx_22040080_pc.scala 85:30]
  reg  instrDoneReg; // @[scala/ysyx/ysyx_22040080_pc.scala 86:30]
  wire  _T = io_pc_update_en | io_access_fault; // @[scala/ysyx/ysyx_22040080_pc.scala 111:24]
  wire [31:0] _GEN_0 = io_is_mret ? io_mepc : io_next_pc; // @[scala/ysyx/ysyx_22040080_pc.scala 120:29 122:13 126:21]
  wire [31:0] _GEN_2 = io_is_mret ? tracePcReg : io_next_pc; // @[scala/ysyx/ysyx_22040080_pc.scala 120:29 128:21 84:30]
  wire [31:0] _GEN_3 = io_is_mret ? traceInstrReg : pmemReader_data; // @[scala/ysyx/ysyx_22040080_pc.scala 120:29 129:21 85:30]
  wire  _GEN_4 = io_is_mret ? 1'h0 : 1'h1; // @[scala/ysyx/ysyx_22040080_pc.scala 109:16 120:29 130:21]
  wire  _GEN_9 = io_trap_valid ? 1'h0 : _GEN_4; // @[scala/ysyx/ysyx_22040080_pc.scala 109:16 116:32]
  wire  _GEN_14 = io_access_fault ? 1'h0 : _GEN_9; // @[scala/ysyx/ysyx_22040080_pc.scala 109:16 112:27]
  wire  _GEN_19 = (io_pc_update_en | io_access_fault) & _GEN_14; // @[scala/ysyx/ysyx_22040080_pc.scala 109:16 111:44]
  pmem_read_wrapper pmemReader ( // @[scala/ysyx/ysyx_22040080_pc.scala 91:26]
    .addr(pmemReader_addr),
    .len(pmemReader_len),
    .data(pmemReader_data)
  );
  get_instr_pc_wrapper getInstrPc ( // @[scala/ysyx/ysyx_22040080_pc.scala 98:26]
    .clk(getInstrPc_clk),
    .trace_pc(getInstrPc_trace_pc),
    .trace_instr(getInstrPc_trace_instr),
    .instr_done(getInstrPc_instr_done)
  );
  assign io_pc = pcReg; // @[scala/ysyx/ysyx_22040080_pc.scala 137:18]
  assign io_pc_valid = pcValidReg; // @[scala/ysyx/ysyx_22040080_pc.scala 138:18]
  assign pmemReader_addr = io_next_pc; // @[scala/ysyx/ysyx_22040080_pc.scala 93:22]
  assign pmemReader_len = 32'h4; // @[scala/ysyx/ysyx_22040080_pc.scala 92:21]
  assign getInstrPc_clk = clock; // @[scala/ysyx/ysyx_22040080_pc.scala 99:28]
  assign getInstrPc_trace_pc = tracePcReg; // @[scala/ysyx/ysyx_22040080_pc.scala 100:28]
  assign getInstrPc_trace_instr = traceInstrReg; // @[scala/ysyx/ysyx_22040080_pc.scala 101:29]
  assign getInstrPc_instr_done = instrDoneReg; // @[scala/ysyx/ysyx_22040080_pc.scala 102:28]
  always @(posedge clock) begin
    if (reset) begin // @[scala/ysyx/ysyx_22040080_pc.scala 82:30]
      pcReg <= 32'h20000000; // @[scala/ysyx/ysyx_22040080_pc.scala 82:30]
    end else if (io_pc_update_en | io_access_fault) begin // @[scala/ysyx/ysyx_22040080_pc.scala 111:44]
      if (io_access_fault) begin // @[scala/ysyx/ysyx_22040080_pc.scala 112:27]
        pcReg <= 32'h0; // @[scala/ysyx/ysyx_22040080_pc.scala 114:21]
      end else if (io_trap_valid) begin // @[scala/ysyx/ysyx_22040080_pc.scala 116:32]
        pcReg <= io_mtvec; // @[scala/ysyx/ysyx_22040080_pc.scala 118:13]
      end else begin
        pcReg <= _GEN_0;
      end
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_pc.scala 83:30]
      pcValidReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_pc.scala 83:30]
    end else begin
      pcValidReg <= _T;
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_pc.scala 84:30]
      tracePcReg <= 32'h20000000; // @[scala/ysyx/ysyx_22040080_pc.scala 84:30]
    end else if (io_pc_update_en | io_access_fault) begin // @[scala/ysyx/ysyx_22040080_pc.scala 111:44]
      if (!(io_access_fault)) begin // @[scala/ysyx/ysyx_22040080_pc.scala 112:27]
        if (!(io_trap_valid)) begin // @[scala/ysyx/ysyx_22040080_pc.scala 116:32]
          tracePcReg <= _GEN_2;
        end
      end
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_pc.scala 85:30]
      traceInstrReg <= 32'h0; // @[scala/ysyx/ysyx_22040080_pc.scala 85:30]
    end else if (io_pc_update_en | io_access_fault) begin // @[scala/ysyx/ysyx_22040080_pc.scala 111:44]
      if (!(io_access_fault)) begin // @[scala/ysyx/ysyx_22040080_pc.scala 112:27]
        if (!(io_trap_valid)) begin // @[scala/ysyx/ysyx_22040080_pc.scala 116:32]
          traceInstrReg <= _GEN_3;
        end
      end
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_pc.scala 86:30]
      instrDoneReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_pc.scala 86:30]
    end else begin
      instrDoneReg <= _GEN_19;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  pcReg = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  pcValidReg = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  tracePcReg = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  traceInstrReg = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  instrDoneReg = _RAND_4[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_22040080_ifu(
  input         clock,
  input         reset,
  input  [31:0] io_pc, // @[scala/ysyx/ysyx_22040080_ifu.scala 11:14]
  input         io_pc_valid, // @[scala/ysyx/ysyx_22040080_ifu.scala 11:14]
  output [31:0] io_araddr, // @[scala/ysyx/ysyx_22040080_ifu.scala 11:14]
  output        io_arvalid, // @[scala/ysyx/ysyx_22040080_ifu.scala 11:14]
  input         io_arready, // @[scala/ysyx/ysyx_22040080_ifu.scala 11:14]
  input         io_rvalid, // @[scala/ysyx/ysyx_22040080_ifu.scala 11:14]
  output        io_rready, // @[scala/ysyx/ysyx_22040080_ifu.scala 11:14]
  output        io_access_fault // @[scala/ysyx/ysyx_22040080_ifu.scala 11:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
`endif // RANDOMIZE_REG_INIT
  wire [31:0] addrChecker_addr; // @[scala/ysyx/ysyx_22040080_ifu.scala 47:27]
  wire  addrChecker_valid; // @[scala/ysyx/ysyx_22040080_ifu.scala 47:27]
  reg  initialStart; // @[scala/ysyx/ysyx_22040080_ifu.scala 36:29]
  reg [31:0] araddrReg; // @[scala/ysyx/ysyx_22040080_ifu.scala 38:29]
  reg  arvalidReg; // @[scala/ysyx/ysyx_22040080_ifu.scala 39:29]
  reg  rreadyReg; // @[scala/ysyx/ysyx_22040080_ifu.scala 40:29]
  reg  accessFaultReg; // @[scala/ysyx/ysyx_22040080_ifu.scala 41:31]
  reg [7:0] respReadyCnt; // @[scala/ysyx/ysyx_22040080_ifu.scala 44:29]
  wire [7:0] _respReadyCnt_T_1 = 8'h3 - 8'h1; // @[scala/ysyx/ysyx_22040080_ifu.scala 65:43]
  wire  _T = ~addrChecker_valid; // @[scala/ysyx/ysyx_22040080_ifu.scala 66:10]
  wire [7:0] _GEN_4 = io_pc_valid ? _respReadyCnt_T_1 : respReadyCnt; // @[scala/ysyx/ysyx_22040080_ifu.scala 69:28 73:18 44:29]
  wire  _GEN_5 = io_pc_valid & _T; // @[scala/ysyx/ysyx_22040080_ifu.scala 59:18 69:28]
  wire  _GEN_7 = initialStart ? 1'h0 : initialStart; // @[scala/ysyx/ysyx_22040080_ifu.scala 61:22 64:18 36:29]
  wire [7:0] _GEN_8 = initialStart ? _respReadyCnt_T_1 : _GEN_4; // @[scala/ysyx/ysyx_22040080_ifu.scala 61:22 65:18]
  wire [7:0] _respReadyCnt_T_5 = respReadyCnt - 8'h1; // @[scala/ysyx/ysyx_22040080_ifu.scala 87:36]
  wire  _GEN_13 = respReadyCnt > 8'h0 ? 1'h0 : 1'h1; // @[scala/ysyx/ysyx_22040080_ifu.scala 86:30 88:20 90:17]
  wire  _GEN_15 = io_rvalid & _GEN_13; // @[scala/ysyx/ysyx_22040080_ifu.scala 58:13 85:19]
  is_valid_address_wrapper addrChecker ( // @[scala/ysyx/ysyx_22040080_ifu.scala 47:27]
    .addr(addrChecker_addr),
    .valid(addrChecker_valid)
  );
  assign io_araddr = araddrReg; // @[scala/ysyx/ysyx_22040080_ifu.scala 97:14]
  assign io_arvalid = arvalidReg; // @[scala/ysyx/ysyx_22040080_ifu.scala 98:14]
  assign io_rready = rreadyReg; // @[scala/ysyx/ysyx_22040080_ifu.scala 99:14]
  assign io_access_fault = accessFaultReg; // @[scala/ysyx/ysyx_22040080_ifu.scala 100:19]
  assign addrChecker_addr = initialStart ? araddrReg : io_pc; // @[scala/ysyx/ysyx_22040080_ifu.scala 49:17]
  always @(posedge clock) begin
    initialStart <= reset | _GEN_7; // @[scala/ysyx/ysyx_22040080_ifu.scala 36:{29,29}]
    if (reset) begin // @[scala/ysyx/ysyx_22040080_ifu.scala 38:29]
      araddrReg <= 32'h20000000; // @[scala/ysyx/ysyx_22040080_ifu.scala 38:29]
    end else if (!(initialStart)) begin // @[scala/ysyx/ysyx_22040080_ifu.scala 61:22]
      if (io_pc_valid) begin // @[scala/ysyx/ysyx_22040080_ifu.scala 69:28]
        araddrReg <= io_pc; // @[scala/ysyx/ysyx_22040080_ifu.scala 71:18]
      end
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_ifu.scala 39:29]
      arvalidReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_ifu.scala 39:29]
    end else if (arvalidReg & io_arready) begin // @[scala/ysyx/ysyx_22040080_ifu.scala 80:34]
      arvalidReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_ifu.scala 81:16]
    end else if (initialStart) begin // @[scala/ysyx/ysyx_22040080_ifu.scala 61:22]
      arvalidReg <= addrChecker_valid; // @[scala/ysyx/ysyx_22040080_ifu.scala 63:18]
    end else if (io_pc_valid) begin // @[scala/ysyx/ysyx_22040080_ifu.scala 69:28]
      arvalidReg <= addrChecker_valid; // @[scala/ysyx/ysyx_22040080_ifu.scala 72:18]
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_ifu.scala 40:29]
      rreadyReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_ifu.scala 40:29]
    end else begin
      rreadyReg <= _GEN_15;
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_ifu.scala 41:31]
      accessFaultReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_ifu.scala 41:31]
    end else if (initialStart) begin // @[scala/ysyx/ysyx_22040080_ifu.scala 61:22]
      accessFaultReg <= _T;
    end else begin
      accessFaultReg <= _GEN_5;
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_ifu.scala 44:29]
      respReadyCnt <= 8'h0; // @[scala/ysyx/ysyx_22040080_ifu.scala 44:29]
    end else if (io_rvalid) begin // @[scala/ysyx/ysyx_22040080_ifu.scala 85:19]
      if (respReadyCnt > 8'h0) begin // @[scala/ysyx/ysyx_22040080_ifu.scala 86:30]
        respReadyCnt <= _respReadyCnt_T_5; // @[scala/ysyx/ysyx_22040080_ifu.scala 87:20]
      end else begin
        respReadyCnt <= _GEN_8;
      end
    end else begin
      respReadyCnt <= _GEN_8;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  initialStart = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  araddrReg = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  arvalidReg = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  rreadyReg = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  accessFaultReg = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  respReadyCnt = _RAND_5[7:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_22040080_axi_arbiter(
  input         clock,
  input         reset,
  input  [31:0] io_ifu_araddr, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  input         io_ifu_arvalid, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  output        io_ifu_arready, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  output [31:0] io_ifu_rdata, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  output        io_ifu_rvalid, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  input         io_ifu_rready, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  input  [31:0] io_lsu_araddr, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  input         io_lsu_arvalid, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  output        io_lsu_arready, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  output [31:0] io_lsu_rdata, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  output        io_lsu_rvalid, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  input         io_lsu_rready, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  input  [31:0] io_lsu_awaddr, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  input         io_lsu_awvalid, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  output        io_lsu_awready, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  input  [31:0] io_lsu_wdata, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  input         io_lsu_wvalid, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  output        io_lsu_wready, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  output        io_lsu_bvalid, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  input         io_lsu_bready, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  input  [2:0]  io_lsu_func3, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  output        io_m_awvalid, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  input         io_m_awready, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  output [31:0] io_m_awaddr, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  output [2:0]  io_m_awsize, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  output        io_m_wvalid, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  input         io_m_wready, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  output [31:0] io_m_wdata, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  output [3:0]  io_m_wstrb, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  input         io_m_bvalid, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  output        io_m_bready, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  output        io_m_arvalid, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  input         io_m_arready, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  output [31:0] io_m_araddr, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  output [2:0]  io_m_arsize, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  input         io_m_rvalid, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  output        io_m_rready, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  input  [31:0] io_m_rdata, // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
  output        io_inst_active // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 36:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
`endif // RANDOMIZE_REG_INIT
  wire  ebreakTrigger_clk; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 144:29]
  wire  ebreakTrigger_en; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 144:29]
  reg [2:0] stateReg; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 122:32]
  reg  readOwnerIfuReg; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 123:32]
  reg  awDoneReg; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 124:32]
  reg  wDoneReg; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 125:32]
  reg [2:0] func3LatchReg; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 126:32]
  reg [1:0] addrOffLatchReg; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 127:32]
  wire  reqWrite = io_lsu_awvalid | io_lsu_wvalid; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 132:35]
  wire [1:0] axSize = func3LatchReg[1:0]; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 154:29]
  wire [10:0] _wstrbWire_T_1 = 11'h1 << addrOffLatchReg; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 158:28]
  wire [10:0] _wstrbWire_T_3 = 11'h3 << addrOffLatchReg; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 159:28]
  wire [3:0] _wstrbWire_T_6 = 2'h0 == axSize ? _wstrbWire_T_1[3:0] : 4'hf; // @[src/main/scala/chisel3/util/Mux.scala 77:13]
  wire [3:0] _wstrbWire_T_8 = 2'h1 == axSize ? _wstrbWire_T_3[3:0] : _wstrbWire_T_6; // @[src/main/scala/chisel3/util/Mux.scala 77:13]
  wire [4:0] shiftBits = {addrOffLatchReg,3'h0}; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 164:22]
  wire [62:0] _GEN_102 = {{31'd0}, io_lsu_wdata}; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 165:36]
  wire [62:0] _alignedWdata_T = _GEN_102 << shiftBits; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 165:36]
  wire [31:0] alignedWdata = _alignedWdata_T[31:0]; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 165:49]
  wire [31:0] shiftedRdata = io_m_rdata >> shiftBits; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 168:34]
  wire [23:0] _processedRdata_T_2 = shiftedRdata[7] ? 24'hffffff : 24'h0; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 170:25]
  wire [31:0] _processedRdata_T_4 = {_processedRdata_T_2,shiftedRdata[7:0]}; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 170:20]
  wire [15:0] _processedRdata_T_7 = shiftedRdata[15] ? 16'hffff : 16'h0; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 171:25]
  wire [31:0] _processedRdata_T_9 = {_processedRdata_T_7,shiftedRdata[15:0]}; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 171:20]
  wire [31:0] _processedRdata_T_11 = {24'h0,shiftedRdata[7:0]}; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 173:20]
  wire [31:0] _processedRdata_T_13 = {16'h0,shiftedRdata[15:0]}; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 174:20]
  wire [31:0] _processedRdata_T_15 = 3'h0 == func3LatchReg ? _processedRdata_T_4 : io_m_rdata; // @[src/main/scala/chisel3/util/Mux.scala 77:13]
  wire [31:0] _processedRdata_T_17 = 3'h1 == func3LatchReg ? _processedRdata_T_9 : _processedRdata_T_15; // @[src/main/scala/chisel3/util/Mux.scala 77:13]
  wire [31:0] _processedRdata_T_19 = 3'h2 == func3LatchReg ? io_m_rdata : _processedRdata_T_17; // @[src/main/scala/chisel3/util/Mux.scala 77:13]
  wire [31:0] _processedRdata_T_21 = 3'h4 == func3LatchReg ? _processedRdata_T_11 : _processedRdata_T_19; // @[src/main/scala/chisel3/util/Mux.scala 77:13]
  wire [31:0] processedRdata = 3'h5 == func3LatchReg ? _processedRdata_T_13 : _processedRdata_T_21; // @[src/main/scala/chisel3/util/Mux.scala 77:13]
  wire [2:0] _GEN_0 = io_lsu_arvalid ? 3'h2 : stateReg; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 237:31 238:25 122:32]
  wire [2:0] _GEN_1 = io_lsu_arvalid ? io_lsu_func3 : func3LatchReg; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 237:31 239:25 126:32]
  wire [1:0] _GEN_2 = io_lsu_arvalid ? io_lsu_araddr[1:0] : addrOffLatchReg; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 237:31 240:25 127:32]
  wire  _GEN_9 = io_ifu_arvalid & io_m_arready | readOwnerIfuReg; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 252:44 253:25 123:32]
  wire  _GEN_11 = io_lsu_arvalid & io_m_arready ? 1'h0 : readOwnerIfuReg; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 266:44 267:25 123:32]
  wire [2:0] _GEN_12 = io_lsu_arvalid & io_m_arready ? 3'h3 : stateReg; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 266:44 268:25 122:32]
  wire  _mRreadyWire_T = readOwnerIfuReg ? io_ifu_rready : io_lsu_rready; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 276:25]
  wire [31:0] _GEN_13 = readOwnerIfuReg ? io_m_rdata : 32'h0; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 182:18 277:29 278:23]
  wire  _GEN_14 = readOwnerIfuReg & io_m_rvalid; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 183:18 277:29 279:23]
  wire [31:0] _GEN_15 = readOwnerIfuReg ? 32'h0 : processedRdata; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 187:18 277:29 281:23]
  wire  _GEN_16 = readOwnerIfuReg ? 1'h0 : io_m_rvalid; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 188:18 277:29 282:23]
  wire  _GEN_37 = 3'h3 == stateReg & _mRreadyWire_T; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20 276:19 139:32]
  wire  _GEN_59 = 3'h2 == stateReg ? 1'h0 : _GEN_37; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20 139:32]
  wire  _GEN_81 = 3'h1 == stateReg ? 1'h0 : _GEN_59; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20 139:32]
  wire  mRreadyWire = 3'h0 == stateReg ? 1'h0 : _GEN_81; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20 139:32]
  wire  _GEN_17 = io_m_rvalid & mRreadyWire & (readOwnerIfuReg & io_m_rdata == 32'h100073); // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 285:40 286:22 146:33]
  wire [2:0] _GEN_18 = io_m_rvalid & mRreadyWire ? 3'h0 : stateReg; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 285:40 287:18 122:32]
  wire  _GEN_19 = io_lsu_awvalid & io_m_awready | awDoneReg; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 304:44 305:19 124:32]
  wire  _GEN_20 = io_lsu_wvalid & io_m_wready | wDoneReg; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 307:42 308:18 125:32]
  wire [2:0] _GEN_21 = awDoneReg & wDoneReg ? 3'h5 : stateReg; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 310:35 311:18 122:32]
  wire [2:0] _GEN_22 = io_m_bvalid & io_lsu_bready ? 3'h0 : stateReg; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 321:42 322:18 122:32]
  wire  _GEN_23 = 3'h5 == stateReg & io_m_bvalid; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 191:18 221:20 319:21]
  wire  _GEN_24 = 3'h5 == stateReg & io_lsu_bready; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 216:18 221:20 320:21]
  wire [2:0] _GEN_25 = 3'h5 == stateReg ? _GEN_22 : stateReg; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20 122:32]
  wire [31:0] _GEN_26 = 3'h4 == stateReg ? io_lsu_awaddr : 32'h0; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 202:18 221:20 296:22]
  wire  _GEN_27 = 3'h4 == stateReg & io_lsu_awvalid; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 203:18 221:20 297:22]
  wire  _GEN_28 = 3'h4 == stateReg & io_m_awready; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 189:18 221:20 298:22]
  wire [31:0] _GEN_29 = 3'h4 == stateReg ? alignedWdata : 32'h0; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 210:18 221:20 300:22]
  wire  _GEN_30 = 3'h4 == stateReg & io_lsu_wvalid; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 211:18 221:20 301:22]
  wire  _GEN_31 = 3'h4 == stateReg & io_m_wready; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 190:18 221:20 302:22]
  wire  _GEN_32 = 3'h4 == stateReg ? _GEN_19 : awDoneReg; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20 124:32]
  wire  _GEN_33 = 3'h4 == stateReg ? _GEN_20 : wDoneReg; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20 125:32]
  wire [2:0] _GEN_34 = 3'h4 == stateReg ? _GEN_21 : _GEN_25; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20]
  wire  _GEN_35 = 3'h4 == stateReg ? 1'h0 : _GEN_23; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 191:18 221:20]
  wire  _GEN_36 = 3'h4 == stateReg ? 1'h0 : _GEN_24; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 216:18 221:20]
  wire [31:0] _GEN_38 = 3'h3 == stateReg ? _GEN_13 : 32'h0; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 182:18 221:20]
  wire [31:0] _GEN_40 = 3'h3 == stateReg ? _GEN_15 : 32'h0; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 187:18 221:20]
  wire [2:0] _GEN_43 = 3'h3 == stateReg ? _GEN_18 : _GEN_34; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20]
  wire [31:0] _GEN_44 = 3'h3 == stateReg ? 32'h0 : _GEN_26; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 202:18 221:20]
  wire  _GEN_45 = 3'h3 == stateReg ? 1'h0 : _GEN_27; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 203:18 221:20]
  wire  _GEN_46 = 3'h3 == stateReg ? 1'h0 : _GEN_28; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 189:18 221:20]
  wire [31:0] _GEN_47 = 3'h3 == stateReg ? 32'h0 : _GEN_29; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 210:18 221:20]
  wire  _GEN_48 = 3'h3 == stateReg ? 1'h0 : _GEN_30; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 211:18 221:20]
  wire  _GEN_49 = 3'h3 == stateReg ? 1'h0 : _GEN_31; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 190:18 221:20]
  wire  _GEN_50 = 3'h3 == stateReg ? awDoneReg : _GEN_32; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20 124:32]
  wire  _GEN_51 = 3'h3 == stateReg ? wDoneReg : _GEN_33; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20 125:32]
  wire  _GEN_52 = 3'h3 == stateReg ? 1'h0 : _GEN_35; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 191:18 221:20]
  wire  _GEN_53 = 3'h3 == stateReg ? 1'h0 : _GEN_36; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 216:18 221:20]
  wire [31:0] _GEN_54 = 3'h2 == stateReg ? io_lsu_araddr : 32'h0; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 194:18 221:20 262:22]
  wire  _GEN_55 = 3'h2 == stateReg & io_lsu_arvalid; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 195:18 221:20 263:22]
  wire  _GEN_56 = 3'h2 == stateReg & io_m_arready; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 186:18 221:20 264:22]
  wire [31:0] _GEN_60 = 3'h2 == stateReg ? 32'h0 : _GEN_38; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 182:18 221:20]
  wire  _GEN_61 = 3'h2 == stateReg ? 1'h0 : 3'h3 == stateReg & _GEN_14; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 183:18 221:20]
  wire [31:0] _GEN_62 = 3'h2 == stateReg ? 32'h0 : _GEN_40; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 187:18 221:20]
  wire  _GEN_63 = 3'h2 == stateReg ? 1'h0 : 3'h3 == stateReg & _GEN_16; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 188:18 221:20]
  wire  _GEN_64 = 3'h2 == stateReg ? 1'h0 : 3'h3 == stateReg & _GEN_17; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20 146:33]
  wire [31:0] _GEN_65 = 3'h2 == stateReg ? 32'h0 : _GEN_44; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 202:18 221:20]
  wire  _GEN_66 = 3'h2 == stateReg ? 1'h0 : _GEN_45; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 203:18 221:20]
  wire  _GEN_67 = 3'h2 == stateReg ? 1'h0 : _GEN_46; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 189:18 221:20]
  wire [31:0] _GEN_68 = 3'h2 == stateReg ? 32'h0 : _GEN_47; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 210:18 221:20]
  wire  _GEN_69 = 3'h2 == stateReg ? 1'h0 : _GEN_48; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 211:18 221:20]
  wire  _GEN_70 = 3'h2 == stateReg ? 1'h0 : _GEN_49; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 190:18 221:20]
  wire  _GEN_73 = 3'h2 == stateReg ? 1'h0 : _GEN_52; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 191:18 221:20]
  wire  _GEN_74 = 3'h2 == stateReg ? 1'h0 : _GEN_53; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 216:18 221:20]
  wire [31:0] _GEN_75 = 3'h1 == stateReg ? io_ifu_araddr : _GEN_54; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20 248:22]
  wire  _GEN_76 = 3'h1 == stateReg ? io_ifu_arvalid : _GEN_55; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20 249:22]
  wire  _GEN_77 = 3'h1 == stateReg & io_m_arready; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 181:18 221:20 250:22]
  wire  _GEN_80 = 3'h1 == stateReg ? 1'h0 : _GEN_56; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 186:18 221:20]
  wire [31:0] _GEN_82 = 3'h1 == stateReg ? 32'h0 : _GEN_60; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 182:18 221:20]
  wire  _GEN_83 = 3'h1 == stateReg ? 1'h0 : _GEN_61; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 183:18 221:20]
  wire [31:0] _GEN_84 = 3'h1 == stateReg ? 32'h0 : _GEN_62; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 187:18 221:20]
  wire  _GEN_85 = 3'h1 == stateReg ? 1'h0 : _GEN_63; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 188:18 221:20]
  wire  _GEN_86 = 3'h1 == stateReg ? 1'h0 : _GEN_64; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20 146:33]
  wire [31:0] _GEN_87 = 3'h1 == stateReg ? 32'h0 : _GEN_65; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 202:18 221:20]
  wire  _GEN_88 = 3'h1 == stateReg ? 1'h0 : _GEN_66; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 203:18 221:20]
  wire  _GEN_89 = 3'h1 == stateReg ? 1'h0 : _GEN_67; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 189:18 221:20]
  wire [31:0] _GEN_90 = 3'h1 == stateReg ? 32'h0 : _GEN_68; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 210:18 221:20]
  wire  _GEN_91 = 3'h1 == stateReg ? 1'h0 : _GEN_69; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 211:18 221:20]
  wire  _GEN_92 = 3'h1 == stateReg ? 1'h0 : _GEN_70; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 190:18 221:20]
  wire  _GEN_95 = 3'h1 == stateReg ? 1'h0 : _GEN_73; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 191:18 221:20]
  wire  _GEN_96 = 3'h1 == stateReg ? 1'h0 : _GEN_74; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 216:18 221:20]
  wire  _io_inst_active_T_1 = stateReg == 3'h3 & readOwnerIfuReg; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 333:46]
  wire  _io_inst_active_T_2 = _io_inst_active_T_1 & io_m_rvalid; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 334:38]
  ebreak_trigger_wrapper ebreakTrigger ( // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 144:29]
    .clk(ebreakTrigger_clk),
    .en(ebreakTrigger_en)
  );
  assign io_ifu_arready = 3'h0 == stateReg ? 1'h0 : _GEN_77; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 181:18 221:20]
  assign io_ifu_rdata = 3'h0 == stateReg ? 32'h0 : _GEN_82; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 182:18 221:20]
  assign io_ifu_rvalid = 3'h0 == stateReg ? 1'h0 : _GEN_83; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 183:18 221:20]
  assign io_lsu_arready = 3'h0 == stateReg ? 1'h0 : _GEN_80; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 186:18 221:20]
  assign io_lsu_rdata = 3'h0 == stateReg ? 32'h0 : _GEN_84; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 187:18 221:20]
  assign io_lsu_rvalid = 3'h0 == stateReg ? 1'h0 : _GEN_85; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 188:18 221:20]
  assign io_lsu_awready = 3'h0 == stateReg ? 1'h0 : _GEN_89; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 189:18 221:20]
  assign io_lsu_wready = 3'h0 == stateReg ? 1'h0 : _GEN_92; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 190:18 221:20]
  assign io_lsu_bvalid = 3'h0 == stateReg ? 1'h0 : _GEN_95; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 191:18 221:20]
  assign io_m_awvalid = 3'h0 == stateReg ? 1'h0 : _GEN_88; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 203:18 221:20]
  assign io_m_awaddr = 3'h0 == stateReg ? 32'h0 : _GEN_87; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 202:18 221:20]
  assign io_m_awsize = {{1'd0}, axSize}; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 206:18]
  assign io_m_wvalid = 3'h0 == stateReg ? 1'h0 : _GEN_91; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 211:18 221:20]
  assign io_m_wdata = 3'h0 == stateReg ? 32'h0 : _GEN_90; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 210:18 221:20]
  assign io_m_wstrb = 2'h2 == axSize ? 4'hf : _wstrbWire_T_8; // @[src/main/scala/chisel3/util/Mux.scala 77:13]
  assign io_m_bready = 3'h0 == stateReg ? 1'h0 : _GEN_96; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 216:18 221:20]
  assign io_m_arvalid = 3'h0 == stateReg ? 1'h0 : _GEN_76; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 195:18 221:20]
  assign io_m_araddr = 3'h0 == stateReg ? 32'h0 : _GEN_75; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 194:18 221:20]
  assign io_m_arsize = {{1'd0}, axSize}; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 198:18]
  assign io_m_rready = 3'h0 == stateReg ? 1'h0 : _GEN_81; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20 139:32]
  assign io_inst_active = _io_inst_active_T_2 & mRreadyWire; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 335:34]
  assign ebreakTrigger_clk = clock; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 145:24]
  assign ebreakTrigger_en = 3'h0 == stateReg ? 1'h0 : _GEN_86; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20 146:33]
  always @(posedge clock) begin
    if (reset) begin // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 122:32]
      stateReg <= 3'h0; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 122:32]
    end else if (3'h0 == stateReg) begin // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20]
      if (reqWrite) begin // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 229:22]
        stateReg <= 3'h4; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 230:25]
      end else if (io_ifu_arvalid) begin // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 233:31]
        stateReg <= 3'h1; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 234:25]
      end else begin
        stateReg <= _GEN_0;
      end
    end else if (3'h1 == stateReg) begin // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20]
      if (io_ifu_arvalid & io_m_arready) begin // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 252:44]
        stateReg <= 3'h3; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 254:25]
      end
    end else if (3'h2 == stateReg) begin // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20]
      stateReg <= _GEN_12;
    end else begin
      stateReg <= _GEN_43;
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 123:32]
      readOwnerIfuReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 123:32]
    end else if (!(3'h0 == stateReg)) begin // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20]
      if (3'h1 == stateReg) begin // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20]
        readOwnerIfuReg <= _GEN_9;
      end else if (3'h2 == stateReg) begin // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20]
        readOwnerIfuReg <= _GEN_11;
      end
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 124:32]
      awDoneReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 124:32]
    end else if (3'h0 == stateReg) begin // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20]
      awDoneReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 227:17]
    end else if (!(3'h1 == stateReg)) begin // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20]
      if (!(3'h2 == stateReg)) begin // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20]
        awDoneReg <= _GEN_50;
      end
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 125:32]
      wDoneReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 125:32]
    end else if (3'h0 == stateReg) begin // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20]
      wDoneReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 228:17]
    end else if (!(3'h1 == stateReg)) begin // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20]
      if (!(3'h2 == stateReg)) begin // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20]
        wDoneReg <= _GEN_51;
      end
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 126:32]
      func3LatchReg <= 3'h2; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 126:32]
    end else if (3'h0 == stateReg) begin // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20]
      if (reqWrite) begin // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 229:22]
        func3LatchReg <= io_lsu_func3; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 231:25]
      end else if (io_ifu_arvalid) begin // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 233:31]
        func3LatchReg <= 3'h2; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 235:25]
      end else begin
        func3LatchReg <= _GEN_1;
      end
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 127:32]
      addrOffLatchReg <= 2'h0; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 127:32]
    end else if (3'h0 == stateReg) begin // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 221:20]
      if (reqWrite) begin // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 229:22]
        addrOffLatchReg <= io_lsu_awaddr[1:0]; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 232:25]
      end else if (io_ifu_arvalid) begin // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 233:31]
        addrOffLatchReg <= 2'h0; // @[scala/ysyx/ysyx_22040080_axi_arbiter.scala 236:25]
      end else begin
        addrOffLatchReg <= _GEN_2;
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  stateReg = _RAND_0[2:0];
  _RAND_1 = {1{`RANDOM}};
  readOwnerIfuReg = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  awDoneReg = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  wDoneReg = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  func3LatchReg = _RAND_4[2:0];
  _RAND_5 = {1{`RANDOM}};
  addrOffLatchReg = _RAND_5[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_22040080_clint_axi(
  input         clock,
  input         reset,
  input  [31:0] io_araddr, // @[scala/ysyx/ysyx_22040080_clint_axi.scala 10:14]
  input         io_arvalid, // @[scala/ysyx/ysyx_22040080_clint_axi.scala 10:14]
  output        io_arready, // @[scala/ysyx/ysyx_22040080_clint_axi.scala 10:14]
  output [31:0] io_rdata, // @[scala/ysyx/ysyx_22040080_clint_axi.scala 10:14]
  output        io_rvalid, // @[scala/ysyx/ysyx_22040080_clint_axi.scala 10:14]
  input         io_rready, // @[scala/ysyx/ysyx_22040080_clint_axi.scala 10:14]
  input         io_awvalid, // @[scala/ysyx/ysyx_22040080_clint_axi.scala 10:14]
  output        io_awready, // @[scala/ysyx/ysyx_22040080_clint_axi.scala 10:14]
  input         io_wvalid, // @[scala/ysyx/ysyx_22040080_clint_axi.scala 10:14]
  output        io_wready, // @[scala/ysyx/ysyx_22040080_clint_axi.scala 10:14]
  output        io_bvalid, // @[scala/ysyx/ysyx_22040080_clint_axi.scala 10:14]
  input         io_bready // @[scala/ysyx/ysyx_22040080_clint_axi.scala 10:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] mtime; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 37:22]
  wire [63:0] _mtime_T_1 = mtime + 64'h1; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 38:18]
  reg  arreadyReg; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 43:27]
  reg  rvalidReg; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 44:27]
  reg [31:0] rdataReg; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 45:27]
  reg  awreadyReg; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 50:29]
  reg  wreadyReg; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 51:29]
  reg  bvalidReg; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 52:29]
  reg  awCaptured; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 55:29]
  reg  wCaptured; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 56:29]
  wire [31:0] _GEN_0 = io_araddr == 32'ha000004c ? mtime[63:32] : 32'h0; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 68:59 69:18 71:18]
  wire  _GEN_3 = io_arvalid & arreadyReg | rvalidReg; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 65:36 73:18 44:27]
  wire  _GEN_4 = io_arvalid & arreadyReg ? 1'h0 : 1'h1; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 64:16 65:36 74:18]
  wire  _GEN_5 = ~rvalidReg & _GEN_4; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 61:14 63:20]
  wire  _GEN_10 = io_awvalid & awreadyReg | awCaptured; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 93:38 95:21 55:29]
  wire  _GEN_11 = io_awvalid & awreadyReg ? 1'h0 : 1'h1; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 92:18 93:38 96:21]
  wire  _GEN_12 = ~awCaptured & _GEN_11; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 86:14 91:23]
  wire  _GEN_16 = io_wvalid & wreadyReg | wCaptured; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 102:36 104:20 56:29]
  wire  _GEN_17 = io_wvalid & wreadyReg ? 1'h0 : 1'h1; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 101:17 102:36 105:20]
  wire  _GEN_18 = ~wCaptured & _GEN_17; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 100:22 87:14]
  wire  _GEN_21 = awCaptured & wCaptured | bvalidReg; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 109:35 110:18 52:29]
  wire  _GEN_24 = ~bvalidReg & _GEN_12; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 86:14 89:20]
  wire  _GEN_27 = ~bvalidReg & _GEN_18; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 87:14 89:20]
  assign io_arready = arreadyReg; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 124:14]
  assign io_rdata = rdataReg; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 125:14]
  assign io_rvalid = rvalidReg; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 126:14]
  assign io_awready = awreadyReg; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 127:14]
  assign io_wready = wreadyReg; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 128:14]
  assign io_bvalid = bvalidReg; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 129:14]
  always @(posedge clock) begin
    if (reset) begin // @[scala/ysyx/ysyx_22040080_clint_axi.scala 37:22]
      mtime <= 64'h0; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 37:22]
    end else begin
      mtime <= _mtime_T_1; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 38:9]
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_clint_axi.scala 43:27]
      arreadyReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 43:27]
    end else begin
      arreadyReg <= _GEN_5;
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_clint_axi.scala 44:27]
      rvalidReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 44:27]
    end else if (rvalidReg & io_rready) begin // @[scala/ysyx/ysyx_22040080_clint_axi.scala 79:32]
      rvalidReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 80:15]
    end else if (~rvalidReg) begin // @[scala/ysyx/ysyx_22040080_clint_axi.scala 63:20]
      rvalidReg <= _GEN_3;
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_clint_axi.scala 45:27]
      rdataReg <= 32'h0; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 45:27]
    end else if (~rvalidReg) begin // @[scala/ysyx/ysyx_22040080_clint_axi.scala 63:20]
      if (io_arvalid & arreadyReg) begin // @[scala/ysyx/ysyx_22040080_clint_axi.scala 65:36]
        if (io_araddr == 32'ha0000048) begin // @[scala/ysyx/ysyx_22040080_clint_axi.scala 66:44]
          rdataReg <= mtime[31:0]; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 67:18]
        end else begin
          rdataReg <= _GEN_0;
        end
      end
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_clint_axi.scala 50:29]
      awreadyReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 50:29]
    end else begin
      awreadyReg <= _GEN_24;
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_clint_axi.scala 51:29]
      wreadyReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 51:29]
    end else begin
      wreadyReg <= _GEN_27;
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_clint_axi.scala 52:29]
      bvalidReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 52:29]
    end else if (bvalidReg & io_bready) begin // @[scala/ysyx/ysyx_22040080_clint_axi.scala 117:32]
      bvalidReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 118:15]
    end else if (~bvalidReg) begin // @[scala/ysyx/ysyx_22040080_clint_axi.scala 89:20]
      bvalidReg <= _GEN_21;
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_clint_axi.scala 55:29]
      awCaptured <= 1'h0; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 55:29]
    end else if (~bvalidReg) begin // @[scala/ysyx/ysyx_22040080_clint_axi.scala 89:20]
      if (awCaptured & wCaptured) begin // @[scala/ysyx/ysyx_22040080_clint_axi.scala 109:35]
        awCaptured <= 1'h0; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 111:18]
      end else if (~awCaptured) begin // @[scala/ysyx/ysyx_22040080_clint_axi.scala 91:23]
        awCaptured <= _GEN_10;
      end
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_clint_axi.scala 56:29]
      wCaptured <= 1'h0; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 56:29]
    end else if (~bvalidReg) begin // @[scala/ysyx/ysyx_22040080_clint_axi.scala 89:20]
      if (awCaptured & wCaptured) begin // @[scala/ysyx/ysyx_22040080_clint_axi.scala 109:35]
        wCaptured <= 1'h0; // @[scala/ysyx/ysyx_22040080_clint_axi.scala 112:18]
      end else if (~wCaptured) begin // @[scala/ysyx/ysyx_22040080_clint_axi.scala 100:22]
        wCaptured <= _GEN_16;
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {2{`RANDOM}};
  mtime = _RAND_0[63:0];
  _RAND_1 = {1{`RANDOM}};
  arreadyReg = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  rvalidReg = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  rdataReg = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  awreadyReg = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  wreadyReg = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  bvalidReg = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  awCaptured = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  wCaptured = _RAND_8[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_22040080_csr(
  input         clock,
  input         reset,
  input         io_wen, // @[scala/ysyx/ysyx_22040080_csr.scala 85:14]
  input  [11:0] io_csr_addr, // @[scala/ysyx/ysyx_22040080_csr.scala 85:14]
  output [31:0] io_rdata, // @[scala/ysyx/ysyx_22040080_csr.scala 85:14]
  input  [31:0] io_wdata, // @[scala/ysyx/ysyx_22040080_csr.scala 85:14]
  output [31:0] io_mepc, // @[scala/ysyx/ysyx_22040080_csr.scala 85:14]
  output [31:0] io_mtvec, // @[scala/ysyx/ysyx_22040080_csr.scala 85:14]
  input         io_trap_valid, // @[scala/ysyx/ysyx_22040080_csr.scala 85:14]
  input  [31:0] io_trap_mepc, // @[scala/ysyx/ysyx_22040080_csr.scala 85:14]
  input  [31:0] io_trap_mcause // @[scala/ysyx/ysyx_22040080_csr.scala 85:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
`endif // RANDOMIZE_REG_INIT
  wire  csrWriteCommit_clk; // @[scala/ysyx/ysyx_22040080_csr.scala 131:30]
  wire  csrWriteCommit_en; // @[scala/ysyx/ysyx_22040080_csr.scala 131:30]
  wire [31:0] csrWriteCommit_addr; // @[scala/ysyx/ysyx_22040080_csr.scala 131:30]
  wire [31:0] csrWriteCommit_wdata; // @[scala/ysyx/ysyx_22040080_csr.scala 131:30]
  wire  getCsrInfo_clk; // @[scala/ysyx/ysyx_22040080_csr.scala 140:26]
  wire [31:0] getCsrInfo_mstatus; // @[scala/ysyx/ysyx_22040080_csr.scala 140:26]
  wire [31:0] getCsrInfo_mepc; // @[scala/ysyx/ysyx_22040080_csr.scala 140:26]
  wire [31:0] getCsrInfo_mcause; // @[scala/ysyx/ysyx_22040080_csr.scala 140:26]
  wire [31:0] getCsrInfo_mtvec; // @[scala/ysyx/ysyx_22040080_csr.scala 140:26]
  wire [31:0] getCsrInfo_mvendorid; // @[scala/ysyx/ysyx_22040080_csr.scala 140:26]
  wire [31:0] getCsrInfo_marchid; // @[scala/ysyx/ysyx_22040080_csr.scala 140:26]
  reg [63:0] mcycleFullReg; // @[scala/ysyx/ysyx_22040080_csr.scala 120:30]
  reg [31:0] mepcReg; // @[scala/ysyx/ysyx_22040080_csr.scala 123:30]
  reg [31:0] mcauseReg; // @[scala/ysyx/ysyx_22040080_csr.scala 124:30]
  reg [31:0] mstatusReg; // @[scala/ysyx/ysyx_22040080_csr.scala 125:30]
  reg [31:0] mtvecReg; // @[scala/ysyx/ysyx_22040080_csr.scala 126:30]
  wire  _io_rdata_T_2 = 12'hb00 == io_csr_addr; // @[src/main/scala/chisel3/util/Mux.scala 77:13]
  wire [31:0] _io_rdata_T_3 = 12'hb00 == io_csr_addr ? mcycleFullReg[31:0] : 32'h0; // @[src/main/scala/chisel3/util/Mux.scala 77:13]
  wire  _io_rdata_T_4 = 12'hb80 == io_csr_addr; // @[src/main/scala/chisel3/util/Mux.scala 77:13]
  wire [31:0] _io_rdata_T_5 = 12'hb80 == io_csr_addr ? mcycleFullReg[63:32] : _io_rdata_T_3; // @[src/main/scala/chisel3/util/Mux.scala 77:13]
  wire [31:0] _io_rdata_T_7 = 12'hf11 == io_csr_addr ? 32'h79737978 : _io_rdata_T_5; // @[src/main/scala/chisel3/util/Mux.scala 77:13]
  wire [31:0] _io_rdata_T_9 = 12'hf12 == io_csr_addr ? 32'h78797368 : _io_rdata_T_7; // @[src/main/scala/chisel3/util/Mux.scala 77:13]
  wire  _io_rdata_T_10 = 12'h341 == io_csr_addr; // @[src/main/scala/chisel3/util/Mux.scala 77:13]
  wire [31:0] _io_rdata_T_11 = 12'h341 == io_csr_addr ? mepcReg : _io_rdata_T_9; // @[src/main/scala/chisel3/util/Mux.scala 77:13]
  wire  _io_rdata_T_12 = 12'h342 == io_csr_addr; // @[src/main/scala/chisel3/util/Mux.scala 77:13]
  wire [31:0] _io_rdata_T_13 = 12'h342 == io_csr_addr ? mcauseReg : _io_rdata_T_11; // @[src/main/scala/chisel3/util/Mux.scala 77:13]
  wire  _io_rdata_T_14 = 12'h305 == io_csr_addr; // @[src/main/scala/chisel3/util/Mux.scala 77:13]
  wire [31:0] _io_rdata_T_15 = 12'h305 == io_csr_addr ? mtvecReg : _io_rdata_T_13; // @[src/main/scala/chisel3/util/Mux.scala 77:13]
  wire  _io_rdata_T_16 = 12'h300 == io_csr_addr; // @[src/main/scala/chisel3/util/Mux.scala 77:13]
  wire [63:0] _mcycleFullReg_T_1 = mcycleFullReg + 64'h1; // @[scala/ysyx/ysyx_22040080_csr.scala 166:34]
  wire [31:0] _csrWriteCommit_io_addr_T = {20'h0,io_csr_addr}; // @[scala/ysyx/ysyx_22040080_csr.scala 175:35]
  wire [63:0] _mcycleFullReg_T_3 = {mcycleFullReg[63:32],io_wdata}; // @[scala/ysyx/ysyx_22040080_csr.scala 179:45]
  wire [63:0] _mcycleFullReg_T_5 = {io_wdata,mcycleFullReg[31:0]}; // @[scala/ysyx/ysyx_22040080_csr.scala 180:45]
  wire [31:0] _GEN_0 = _io_rdata_T_16 ? io_wdata : mstatusReg; // @[scala/ysyx/ysyx_22040080_csr.scala 178:25 125:30 184:36]
  wire [31:0] _GEN_1 = _io_rdata_T_14 ? io_wdata : mtvecReg; // @[scala/ysyx/ysyx_22040080_csr.scala 178:25 126:30 183:36]
  wire [31:0] _GEN_2 = _io_rdata_T_14 ? mstatusReg : _GEN_0; // @[scala/ysyx/ysyx_22040080_csr.scala 178:25 125:30]
  wire [31:0] _GEN_3 = _io_rdata_T_12 ? io_wdata : mcauseReg; // @[scala/ysyx/ysyx_22040080_csr.scala 178:25 124:30 182:36]
  wire [31:0] _GEN_4 = _io_rdata_T_12 ? mtvecReg : _GEN_1; // @[scala/ysyx/ysyx_22040080_csr.scala 178:25 126:30]
  wire [31:0] _GEN_5 = _io_rdata_T_12 ? mstatusReg : _GEN_2; // @[scala/ysyx/ysyx_22040080_csr.scala 178:25 125:30]
  wire [31:0] _GEN_6 = _io_rdata_T_10 ? io_wdata : mepcReg; // @[scala/ysyx/ysyx_22040080_csr.scala 178:25 123:30 181:36]
  wire [31:0] _GEN_7 = _io_rdata_T_10 ? mcauseReg : _GEN_3; // @[scala/ysyx/ysyx_22040080_csr.scala 178:25 124:30]
  wire [31:0] _GEN_8 = _io_rdata_T_10 ? mtvecReg : _GEN_4; // @[scala/ysyx/ysyx_22040080_csr.scala 178:25 126:30]
  wire [31:0] _GEN_9 = _io_rdata_T_10 ? mstatusReg : _GEN_5; // @[scala/ysyx/ysyx_22040080_csr.scala 178:25 125:30]
  wire [31:0] _GEN_11 = _io_rdata_T_4 ? mepcReg : _GEN_6; // @[scala/ysyx/ysyx_22040080_csr.scala 178:25 123:30]
  wire [31:0] _GEN_12 = _io_rdata_T_4 ? mcauseReg : _GEN_7; // @[scala/ysyx/ysyx_22040080_csr.scala 178:25 124:30]
  csr_write_commit_wrapper csrWriteCommit ( // @[scala/ysyx/ysyx_22040080_csr.scala 131:30]
    .clk(csrWriteCommit_clk),
    .en(csrWriteCommit_en),
    .addr(csrWriteCommit_addr),
    .wdata(csrWriteCommit_wdata)
  );
  get_csr_info_wrapper getCsrInfo ( // @[scala/ysyx/ysyx_22040080_csr.scala 140:26]
    .clk(getCsrInfo_clk),
    .mstatus(getCsrInfo_mstatus),
    .mepc(getCsrInfo_mepc),
    .mcause(getCsrInfo_mcause),
    .mtvec(getCsrInfo_mtvec),
    .mvendorid(getCsrInfo_mvendorid),
    .marchid(getCsrInfo_marchid)
  );
  assign io_rdata = 12'h300 == io_csr_addr ? mstatusReg : _io_rdata_T_15; // @[src/main/scala/chisel3/util/Mux.scala 77:13]
  assign io_mepc = mepcReg; // @[scala/ysyx/ysyx_22040080_csr.scala 205:18]
  assign io_mtvec = mtvecReg; // @[scala/ysyx/ysyx_22040080_csr.scala 208:18]
  assign csrWriteCommit_clk = clock; // @[scala/ysyx/ysyx_22040080_csr.scala 132:27]
  assign csrWriteCommit_en = io_wen & io_csr_addr != 12'h0; // @[scala/ysyx/ysyx_22040080_csr.scala 172:16 133:27 174:29]
  assign csrWriteCommit_addr = io_wen ? _csrWriteCommit_io_addr_T : 32'h0; // @[scala/ysyx/ysyx_22040080_csr.scala 172:16 134:27 175:29]
  assign csrWriteCommit_wdata = io_wen ? io_wdata : 32'h0; // @[scala/ysyx/ysyx_22040080_csr.scala 172:16 135:27 176:29]
  assign getCsrInfo_clk = clock; // @[scala/ysyx/ysyx_22040080_csr.scala 141:27]
  assign getCsrInfo_mstatus = mstatusReg; // @[scala/ysyx/ysyx_22040080_csr.scala 142:27]
  assign getCsrInfo_mepc = mepcReg; // @[scala/ysyx/ysyx_22040080_csr.scala 143:27]
  assign getCsrInfo_mcause = mcauseReg; // @[scala/ysyx/ysyx_22040080_csr.scala 144:27]
  assign getCsrInfo_mtvec = mtvecReg; // @[scala/ysyx/ysyx_22040080_csr.scala 145:27]
  assign getCsrInfo_mvendorid = 32'h79737978; // @[scala/ysyx/ysyx_22040080_csr.scala 146:27]
  assign getCsrInfo_marchid = 32'h78797368; // @[scala/ysyx/ysyx_22040080_csr.scala 147:27]
  always @(posedge clock) begin
    if (reset) begin // @[scala/ysyx/ysyx_22040080_csr.scala 120:30]
      mcycleFullReg <= 64'h0; // @[scala/ysyx/ysyx_22040080_csr.scala 120:30]
    end else if (io_wen) begin // @[scala/ysyx/ysyx_22040080_csr.scala 172:16]
      if (_io_rdata_T_2) begin // @[scala/ysyx/ysyx_22040080_csr.scala 178:25]
        mcycleFullReg <= _mcycleFullReg_T_3; // @[scala/ysyx/ysyx_22040080_csr.scala 179:39]
      end else if (_io_rdata_T_4) begin // @[scala/ysyx/ysyx_22040080_csr.scala 178:25]
        mcycleFullReg <= _mcycleFullReg_T_5; // @[scala/ysyx/ysyx_22040080_csr.scala 180:39]
      end else begin
        mcycleFullReg <= _mcycleFullReg_T_1; // @[scala/ysyx/ysyx_22040080_csr.scala 166:17]
      end
    end else begin
      mcycleFullReg <= _mcycleFullReg_T_1; // @[scala/ysyx/ysyx_22040080_csr.scala 166:17]
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_csr.scala 123:30]
      mepcReg <= 32'h0; // @[scala/ysyx/ysyx_22040080_csr.scala 123:30]
    end else if (io_trap_valid) begin // @[scala/ysyx/ysyx_22040080_csr.scala 192:23]
      mepcReg <= io_trap_mepc; // @[scala/ysyx/ysyx_22040080_csr.scala 193:15]
    end else if (io_wen) begin // @[scala/ysyx/ysyx_22040080_csr.scala 172:16]
      if (!(_io_rdata_T_2)) begin // @[scala/ysyx/ysyx_22040080_csr.scala 178:25]
        mepcReg <= _GEN_11;
      end
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_csr.scala 124:30]
      mcauseReg <= 32'h0; // @[scala/ysyx/ysyx_22040080_csr.scala 124:30]
    end else if (io_trap_valid) begin // @[scala/ysyx/ysyx_22040080_csr.scala 192:23]
      mcauseReg <= io_trap_mcause; // @[scala/ysyx/ysyx_22040080_csr.scala 194:15]
    end else if (io_wen) begin // @[scala/ysyx/ysyx_22040080_csr.scala 172:16]
      if (!(_io_rdata_T_2)) begin // @[scala/ysyx/ysyx_22040080_csr.scala 178:25]
        mcauseReg <= _GEN_12;
      end
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_csr.scala 125:30]
      mstatusReg <= 32'h1800; // @[scala/ysyx/ysyx_22040080_csr.scala 125:30]
    end else if (io_wen) begin // @[scala/ysyx/ysyx_22040080_csr.scala 172:16]
      if (!(_io_rdata_T_2)) begin // @[scala/ysyx/ysyx_22040080_csr.scala 178:25]
        if (!(_io_rdata_T_4)) begin // @[scala/ysyx/ysyx_22040080_csr.scala 178:25]
          mstatusReg <= _GEN_9;
        end
      end
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_csr.scala 126:30]
      mtvecReg <= 32'h0; // @[scala/ysyx/ysyx_22040080_csr.scala 126:30]
    end else if (io_wen) begin // @[scala/ysyx/ysyx_22040080_csr.scala 172:16]
      if (!(_io_rdata_T_2)) begin // @[scala/ysyx/ysyx_22040080_csr.scala 178:25]
        if (!(_io_rdata_T_4)) begin // @[scala/ysyx/ysyx_22040080_csr.scala 178:25]
          mtvecReg <= _GEN_8;
        end
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {2{`RANDOM}};
  mcycleFullReg = _RAND_0[63:0];
  _RAND_1 = {1{`RANDOM}};
  mepcReg = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  mcauseReg = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  mstatusReg = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  mtvecReg = _RAND_4[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_22040080_lsu(
  input         clock,
  input         reset,
  input  [31:0] io_mem_addr, // @[scala/ysyx/ysyx_22040080_lsu.scala 7:14]
  input  [31:0] io_mem_wdata, // @[scala/ysyx/ysyx_22040080_lsu.scala 7:14]
  input  [2:0]  io_func3, // @[scala/ysyx/ysyx_22040080_lsu.scala 7:14]
  input         io_is_load, // @[scala/ysyx/ysyx_22040080_lsu.scala 7:14]
  input         io_is_store, // @[scala/ysyx/ysyx_22040080_lsu.scala 7:14]
  output [31:0] io_load_data, // @[scala/ysyx/ysyx_22040080_lsu.scala 7:14]
  output [2:0]  io_lsu_func3, // @[scala/ysyx/ysyx_22040080_lsu.scala 7:14]
  input         io_lsu_reqValid, // @[scala/ysyx/ysyx_22040080_lsu.scala 7:14]
  output        io_lsu_reqReady, // @[scala/ysyx/ysyx_22040080_lsu.scala 7:14]
  output        io_lsu_respValid, // @[scala/ysyx/ysyx_22040080_lsu.scala 7:14]
  input         io_lsu_respReady, // @[scala/ysyx/ysyx_22040080_lsu.scala 7:14]
  output [31:0] io_araddr, // @[scala/ysyx/ysyx_22040080_lsu.scala 7:14]
  output        io_arvalid, // @[scala/ysyx/ysyx_22040080_lsu.scala 7:14]
  input         io_arready, // @[scala/ysyx/ysyx_22040080_lsu.scala 7:14]
  input  [31:0] io_rdata, // @[scala/ysyx/ysyx_22040080_lsu.scala 7:14]
  input         io_rvalid, // @[scala/ysyx/ysyx_22040080_lsu.scala 7:14]
  output        io_rready, // @[scala/ysyx/ysyx_22040080_lsu.scala 7:14]
  output [31:0] io_awaddr, // @[scala/ysyx/ysyx_22040080_lsu.scala 7:14]
  output        io_awvalid, // @[scala/ysyx/ysyx_22040080_lsu.scala 7:14]
  input         io_awready, // @[scala/ysyx/ysyx_22040080_lsu.scala 7:14]
  output [31:0] io_wdata, // @[scala/ysyx/ysyx_22040080_lsu.scala 7:14]
  output        io_wvalid, // @[scala/ysyx/ysyx_22040080_lsu.scala 7:14]
  input         io_wready, // @[scala/ysyx/ysyx_22040080_lsu.scala 7:14]
  input         io_bvalid, // @[scala/ysyx/ysyx_22040080_lsu.scala 7:14]
  output        io_bready, // @[scala/ysyx/ysyx_22040080_lsu.scala 7:14]
  output        io_access_fault // @[scala/ysyx/ysyx_22040080_lsu.scala 7:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
`endif // RANDOMIZE_REG_INIT
  wire [31:0] addrChecker_addr; // @[scala/ysyx/ysyx_22040080_lsu.scala 93:27]
  wire  addrChecker_valid; // @[scala/ysyx/ysyx_22040080_lsu.scala 93:27]
  reg [31:0] loadDataReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 57:32]
  reg [2:0] lsuFunc3Reg; // @[scala/ysyx/ysyx_22040080_lsu.scala 58:32]
  reg  lsuReqReadyReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 59:32]
  reg  lsuRespValidReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 60:32]
  reg [31:0] araddrReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 65:27]
  reg  arvalidReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 66:27]
  reg  rreadyReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 67:27]
  reg [31:0] awaddrReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 68:27]
  reg  awvalidReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 69:27]
  reg [31:0] wdataReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 70:27]
  reg  wvalidReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 71:27]
  reg  breadyReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 72:27]
  reg  accessFaultReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 73:31]
  reg  isLoadLatch; // @[scala/ysyx/ysyx_22040080_lsu.scala 81:30]
  reg  isStoreLatch; // @[scala/ysyx/ysyx_22040080_lsu.scala 82:30]
  reg  reqPending; // @[scala/ysyx/ysyx_22040080_lsu.scala 83:30]
  reg  awHandshakeDone; // @[scala/ysyx/ysyx_22040080_lsu.scala 89:32]
  reg  wHandshakeDone; // @[scala/ysyx/ysyx_22040080_lsu.scala 90:32]
  wire  _GEN_1 = io_is_load | arvalidReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 117:24 119:20 66:27]
  wire  _GEN_3 = io_is_store | awvalidReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 123:25 125:20 69:27]
  wire  _GEN_5 = io_is_store | wvalidReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 123:25 127:20 71:27]
  wire  _GEN_6 = io_is_store | breadyReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 123:25 128:20 72:27]
  wire  _GEN_8 = addrChecker_valid & _GEN_1; // @[scala/ysyx/ysyx_22040080_lsu.scala 115:24 135:23]
  wire  _GEN_10 = addrChecker_valid & _GEN_3; // @[scala/ysyx/ysyx_22040080_lsu.scala 115:24 136:23]
  wire  _GEN_12 = addrChecker_valid & _GEN_5; // @[scala/ysyx/ysyx_22040080_lsu.scala 115:24 137:23]
  wire  _GEN_13 = addrChecker_valid & _GEN_6; // @[scala/ysyx/ysyx_22040080_lsu.scala 115:24 138:23]
  wire  _GEN_15 = addrChecker_valid ? 1'h0 : 1'h1; // @[scala/ysyx/ysyx_22040080_lsu.scala 100:18 115:24 133:23]
  wire  _GEN_16 = addrChecker_valid ? lsuRespValidReg : 1'h1; // @[scala/ysyx/ysyx_22040080_lsu.scala 115:24 134:23 60:32]
  wire  _GEN_17 = addrChecker_valid & rreadyReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 115:24 139:23 67:27]
  wire  _GEN_24 = io_lsu_reqValid & ~reqPending | reqPending; // @[scala/ysyx/ysyx_22040080_lsu.scala 105:40 113:19 83:30]
  wire  _GEN_26 = io_lsu_reqValid & ~reqPending ? _GEN_8 : arvalidReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 105:40 66:27]
  wire  _GEN_28 = io_lsu_reqValid & ~reqPending ? _GEN_10 : awvalidReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 105:40 69:27]
  wire  _GEN_30 = io_lsu_reqValid & ~reqPending ? _GEN_12 : wvalidReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 105:40 71:27]
  wire  _GEN_31 = io_lsu_reqValid & ~reqPending ? _GEN_13 : breadyReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 105:40 72:27]
  wire  _GEN_33 = io_lsu_reqValid & ~reqPending & _GEN_15; // @[scala/ysyx/ysyx_22040080_lsu.scala 100:18 105:40]
  wire  _GEN_34 = io_lsu_reqValid & ~reqPending ? _GEN_16 : lsuRespValidReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 105:40 60:32]
  wire  _GEN_35 = io_lsu_reqValid & ~reqPending ? _GEN_17 : rreadyReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 105:40 67:27]
  wire  _GEN_37 = arvalidReg & io_arready | _GEN_33; // @[scala/ysyx/ysyx_22040080_lsu.scala 147:36 149:22]
  wire  _GEN_38 = arvalidReg & io_arready | _GEN_35; // @[scala/ysyx/ysyx_22040080_lsu.scala 147:36 150:22]
  wire  _GEN_40 = io_rvalid & rreadyReg | _GEN_34; // @[scala/ysyx/ysyx_22040080_lsu.scala 156:34 158:23]
  wire  _GEN_43 = isLoadLatch ? _GEN_37 : _GEN_33; // @[scala/ysyx/ysyx_22040080_lsu.scala 146:21]
  wire  _GEN_46 = isLoadLatch ? _GEN_40 : _GEN_34; // @[scala/ysyx/ysyx_22040080_lsu.scala 146:21]
  wire  _GEN_48 = awvalidReg & io_awready | awHandshakeDone; // @[scala/ysyx/ysyx_22040080_lsu.scala 167:36 169:23 89:32]
  wire  _GEN_50 = wvalidReg & io_wready | _GEN_43; // @[scala/ysyx/ysyx_22040080_lsu.scala 175:34 177:23]
  wire  _GEN_51 = wvalidReg & io_wready | wHandshakeDone; // @[scala/ysyx/ysyx_22040080_lsu.scala 175:34 178:23 90:32]
  wire  _GEN_57 = io_bvalid & breadyReg | _GEN_46; // @[scala/ysyx/ysyx_22040080_lsu.scala 188:34 189:23]
  is_valid_address_wrapper addrChecker ( // @[scala/ysyx/ysyx_22040080_lsu.scala 93:27]
    .addr(addrChecker_addr),
    .valid(addrChecker_valid)
  );
  assign io_load_data = loadDataReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 212:20]
  assign io_lsu_func3 = lsuFunc3Reg; // @[scala/ysyx/ysyx_22040080_lsu.scala 213:20]
  assign io_lsu_reqReady = lsuReqReadyReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 214:20]
  assign io_lsu_respValid = lsuRespValidReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 215:20]
  assign io_araddr = araddrReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 217:14]
  assign io_arvalid = arvalidReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 218:14]
  assign io_rready = rreadyReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 219:14]
  assign io_awaddr = awaddrReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 221:14]
  assign io_awvalid = awvalidReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 222:14]
  assign io_wdata = wdataReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 223:14]
  assign io_wvalid = wvalidReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 224:14]
  assign io_bready = breadyReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 225:14]
  assign io_access_fault = accessFaultReg; // @[scala/ysyx/ysyx_22040080_lsu.scala 226:19]
  assign addrChecker_addr = io_mem_addr; // @[scala/ysyx/ysyx_22040080_lsu.scala 94:23]
  always @(posedge clock) begin
    if (reset) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 57:32]
      loadDataReg <= 32'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 57:32]
    end else if (isLoadLatch) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 146:21]
      if (io_rvalid & rreadyReg) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 156:34]
        loadDataReg <= io_rdata; // @[scala/ysyx/ysyx_22040080_lsu.scala 157:23]
      end
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 58:32]
      lsuFunc3Reg <= 3'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 58:32]
    end else if (io_lsu_reqValid & ~reqPending) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 105:40]
      lsuFunc3Reg <= io_func3; // @[scala/ysyx/ysyx_22040080_lsu.scala 110:19]
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 59:32]
      lsuReqReadyReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 59:32]
    end else if (isStoreLatch) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 166:22]
      lsuReqReadyReg <= _GEN_50;
    end else if (isLoadLatch) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 146:21]
      lsuReqReadyReg <= _GEN_37;
    end else begin
      lsuReqReadyReg <= _GEN_33;
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 60:32]
      lsuRespValidReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 60:32]
    end else if (reqPending & lsuRespValidReg & io_lsu_respReady) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 198:59]
      lsuRespValidReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 199:21]
    end else if (isStoreLatch & awHandshakeDone & wHandshakeDone) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 187:59]
      lsuRespValidReg <= _GEN_57;
    end else if (isLoadLatch) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 146:21]
      lsuRespValidReg <= _GEN_40;
    end else begin
      lsuRespValidReg <= _GEN_34;
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 65:27]
      araddrReg <= 32'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 65:27]
    end else if (io_lsu_reqValid & ~reqPending) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 105:40]
      if (addrChecker_valid) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 115:24]
        if (io_is_load) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 117:24]
          araddrReg <= io_mem_addr; // @[scala/ysyx/ysyx_22040080_lsu.scala 118:20]
        end
      end
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 66:27]
      arvalidReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 66:27]
    end else if (isLoadLatch) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 146:21]
      if (arvalidReg & io_arready) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 147:36]
        arvalidReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 148:22]
      end else begin
        arvalidReg <= _GEN_26;
      end
    end else begin
      arvalidReg <= _GEN_26;
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 67:27]
      rreadyReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 67:27]
    end else if (isLoadLatch) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 146:21]
      if (io_rvalid & rreadyReg) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 156:34]
        rreadyReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 159:23]
      end else begin
        rreadyReg <= _GEN_38;
      end
    end else if (io_lsu_reqValid & ~reqPending) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 105:40]
      rreadyReg <= _GEN_17;
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 68:27]
      awaddrReg <= 32'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 68:27]
    end else if (io_lsu_reqValid & ~reqPending) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 105:40]
      if (addrChecker_valid) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 115:24]
        if (io_is_store) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 123:25]
          awaddrReg <= io_mem_addr; // @[scala/ysyx/ysyx_22040080_lsu.scala 124:20]
        end
      end
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 69:27]
      awvalidReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 69:27]
    end else if (isStoreLatch) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 166:22]
      if (awvalidReg & io_awready) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 167:36]
        awvalidReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 168:23]
      end else begin
        awvalidReg <= _GEN_28;
      end
    end else begin
      awvalidReg <= _GEN_28;
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 70:27]
      wdataReg <= 32'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 70:27]
    end else if (io_lsu_reqValid & ~reqPending) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 105:40]
      if (addrChecker_valid) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 115:24]
        if (io_is_store) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 123:25]
          wdataReg <= io_mem_wdata; // @[scala/ysyx/ysyx_22040080_lsu.scala 126:20]
        end
      end
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 71:27]
      wvalidReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 71:27]
    end else if (isStoreLatch) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 166:22]
      if (wvalidReg & io_wready) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 175:34]
        wvalidReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 176:23]
      end else begin
        wvalidReg <= _GEN_30;
      end
    end else begin
      wvalidReg <= _GEN_30;
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 72:27]
      breadyReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 72:27]
    end else if (isStoreLatch & awHandshakeDone & wHandshakeDone) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 187:59]
      if (io_bvalid & breadyReg) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 188:34]
        breadyReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 190:23]
      end else begin
        breadyReg <= _GEN_31;
      end
    end else begin
      breadyReg <= _GEN_31;
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 73:31]
      accessFaultReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 73:31]
    end else if (reqPending & lsuRespValidReg & io_lsu_respReady) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 198:59]
      accessFaultReg <= 1'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 206:21]
    end else if (io_lsu_reqValid & ~reqPending) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 105:40]
      if (!(addrChecker_valid)) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 115:24]
        accessFaultReg <= 1'h1; // @[scala/ysyx/ysyx_22040080_lsu.scala 132:23]
      end
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 81:30]
      isLoadLatch <= 1'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 81:30]
    end else if (reqPending & lsuRespValidReg & io_lsu_respReady) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 198:59]
      isLoadLatch <= 1'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 201:21]
    end else if (io_lsu_reqValid & ~reqPending) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 105:40]
      isLoadLatch <= io_is_load; // @[scala/ysyx/ysyx_22040080_lsu.scala 111:19]
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 82:30]
      isStoreLatch <= 1'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 82:30]
    end else if (reqPending & lsuRespValidReg & io_lsu_respReady) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 198:59]
      isStoreLatch <= 1'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 202:21]
    end else if (io_lsu_reqValid & ~reqPending) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 105:40]
      isStoreLatch <= io_is_store; // @[scala/ysyx/ysyx_22040080_lsu.scala 112:19]
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 83:30]
      reqPending <= 1'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 83:30]
    end else if (reqPending & lsuRespValidReg & io_lsu_respReady) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 198:59]
      reqPending <= 1'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 200:21]
    end else begin
      reqPending <= _GEN_24;
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 89:32]
      awHandshakeDone <= 1'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 89:32]
    end else if (reqPending & lsuRespValidReg & io_lsu_respReady) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 198:59]
      awHandshakeDone <= 1'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 204:21]
    end else if (isStoreLatch) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 166:22]
      awHandshakeDone <= _GEN_48;
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 90:32]
      wHandshakeDone <= 1'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 90:32]
    end else if (reqPending & lsuRespValidReg & io_lsu_respReady) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 198:59]
      wHandshakeDone <= 1'h0; // @[scala/ysyx/ysyx_22040080_lsu.scala 205:21]
    end else if (isStoreLatch) begin // @[scala/ysyx/ysyx_22040080_lsu.scala 166:22]
      wHandshakeDone <= _GEN_51;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  loadDataReg = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  lsuFunc3Reg = _RAND_1[2:0];
  _RAND_2 = {1{`RANDOM}};
  lsuReqReadyReg = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  lsuRespValidReg = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  araddrReg = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  arvalidReg = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  rreadyReg = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  awaddrReg = _RAND_7[31:0];
  _RAND_8 = {1{`RANDOM}};
  awvalidReg = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  wdataReg = _RAND_9[31:0];
  _RAND_10 = {1{`RANDOM}};
  wvalidReg = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  breadyReg = _RAND_11[0:0];
  _RAND_12 = {1{`RANDOM}};
  accessFaultReg = _RAND_12[0:0];
  _RAND_13 = {1{`RANDOM}};
  isLoadLatch = _RAND_13[0:0];
  _RAND_14 = {1{`RANDOM}};
  isStoreLatch = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  reqPending = _RAND_15[0:0];
  _RAND_16 = {1{`RANDOM}};
  awHandshakeDone = _RAND_16[0:0];
  _RAND_17 = {1{`RANDOM}};
  wHandshakeDone = _RAND_17[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_22040080_idu(
  input  [31:0] io_rdata, // @[scala/ysyx/ysyx_22040080_idu.scala 7:14]
  input         io_inst_active, // @[scala/ysyx/ysyx_22040080_idu.scala 7:14]
  output [4:0]  io_rs1, // @[scala/ysyx/ysyx_22040080_idu.scala 7:14]
  output [4:0]  io_rs2, // @[scala/ysyx/ysyx_22040080_idu.scala 7:14]
  output [4:0]  io_rd, // @[scala/ysyx/ysyx_22040080_idu.scala 7:14]
  output [2:0]  io_func3, // @[scala/ysyx/ysyx_22040080_idu.scala 7:14]
  output [31:0] io_imm_ext, // @[scala/ysyx/ysyx_22040080_idu.scala 7:14]
  output [6:0]  io_op, // @[scala/ysyx/ysyx_22040080_idu.scala 7:14]
  output [6:0]  io_func7, // @[scala/ysyx/ysyx_22040080_idu.scala 7:14]
  output [4:0]  io_shamt, // @[scala/ysyx/ysyx_22040080_idu.scala 7:14]
  output [11:0] io_csr_addr, // @[scala/ysyx/ysyx_22040080_idu.scala 7:14]
  output        io_is_jal, // @[scala/ysyx/ysyx_22040080_idu.scala 7:14]
  output        io_is_jalr, // @[scala/ysyx/ysyx_22040080_idu.scala 7:14]
  output        io_is_branch, // @[scala/ysyx/ysyx_22040080_idu.scala 7:14]
  output        io_is_load, // @[scala/ysyx/ysyx_22040080_idu.scala 7:14]
  output        io_is_store, // @[scala/ysyx/ysyx_22040080_idu.scala 7:14]
  output        io_lsu_reqValid // @[scala/ysyx/ysyx_22040080_idu.scala 7:14]
);
  wire [6:0] opcode = io_inst_active ? io_rdata[6:0] : 7'h0; // @[scala/ysyx/ysyx_22040080_idu.scala 84:24 93:12 56:30]
  wire  _io_shamt_T = opcode == 7'h13; // @[scala/ysyx/ysyx_22040080_idu.scala 99:28]
  wire [2:0] funct3 = io_inst_active ? io_rdata[14:12] : 3'h0; // @[scala/ysyx/ysyx_22040080_idu.scala 84:24 94:12 57:30]
  wire [4:0] _io_shamt_T_5 = opcode == 7'h13 & funct3[1:0] == 2'h1 ? io_rdata[24:20] : 5'h0; // @[scala/ysyx/ysyx_22040080_idu.scala 99:20]
  wire  _instrType_T = opcode == 7'h33; // @[scala/ysyx/ysyx_22040080_idu.scala 106:15]
  wire  _instrType_T_2 = opcode == 7'h3; // @[scala/ysyx/ysyx_22040080_idu.scala 108:15]
  wire  _instrType_T_3 = opcode == 7'h67; // @[scala/ysyx/ysyx_22040080_idu.scala 109:15]
  wire  _instrType_T_4 = opcode == 7'h73; // @[scala/ysyx/ysyx_22040080_idu.scala 110:15]
  wire  _instrType_T_5 = opcode == 7'h23; // @[scala/ysyx/ysyx_22040080_idu.scala 111:15]
  wire  _instrType_T_6 = opcode == 7'h63; // @[scala/ysyx/ysyx_22040080_idu.scala 112:15]
  wire  _instrType_T_7 = opcode == 7'h37; // @[scala/ysyx/ysyx_22040080_idu.scala 113:15]
  wire  _instrType_T_8 = opcode == 7'h17; // @[scala/ysyx/ysyx_22040080_idu.scala 114:15]
  wire  _instrType_T_9 = opcode == 7'h6f; // @[scala/ysyx/ysyx_22040080_idu.scala 115:15]
  wire [2:0] _instrType_T_10 = _instrType_T_9 ? 3'h5 : 3'h7; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [2:0] _instrType_T_11 = _instrType_T_8 ? 3'h4 : _instrType_T_10; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [2:0] _instrType_T_12 = _instrType_T_7 ? 3'h4 : _instrType_T_11; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [2:0] _instrType_T_13 = _instrType_T_6 ? 3'h3 : _instrType_T_12; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [2:0] _instrType_T_14 = _instrType_T_5 ? 3'h2 : _instrType_T_13; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [2:0] _instrType_T_15 = _instrType_T_4 ? 3'h1 : _instrType_T_14; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [2:0] _instrType_T_16 = _instrType_T_3 ? 3'h1 : _instrType_T_15; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [2:0] _instrType_T_17 = _instrType_T_2 ? 3'h1 : _instrType_T_16; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [2:0] _instrType_T_18 = _io_shamt_T ? 3'h1 : _instrType_T_17; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [2:0] _instrType_T_19 = _instrType_T ? 3'h0 : _instrType_T_18; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [2:0] instrType = io_inst_active ? _instrType_T_19 : 3'h7; // @[scala/ysyx/ysyx_22040080_idu.scala 105:15 84:24 58:30]
  wire [19:0] _immExt_T_2 = io_rdata[31] ? 20'hfffff : 20'h0; // @[scala/ysyx/ysyx_22040080_idu.scala 135:27]
  wire [31:0] _immExt_T_4 = {_immExt_T_2,io_rdata[31:20]}; // @[scala/ysyx/ysyx_22040080_idu.scala 135:22]
  wire [31:0] _immExt_T_10 = {_immExt_T_2,io_rdata[31:25],io_rdata[11:7]}; // @[scala/ysyx/ysyx_22040080_idu.scala 139:22]
  wire [31:0] _immExt_T_17 = {_immExt_T_2,io_rdata[7],io_rdata[30:25],io_rdata[11:8],1'h0}; // @[scala/ysyx/ysyx_22040080_idu.scala 143:22]
  wire [31:0] _immExt_T_19 = {io_rdata[31:12],12'h0}; // @[scala/ysyx/ysyx_22040080_idu.scala 147:22]
  wire [11:0] _immExt_T_22 = io_rdata[31] ? 12'hfff : 12'h0; // @[scala/ysyx/ysyx_22040080_idu.scala 151:27]
  wire [31:0] _immExt_T_26 = {_immExt_T_22,io_rdata[19:12],io_rdata[20],io_rdata[30:21],1'h0}; // @[scala/ysyx/ysyx_22040080_idu.scala 151:22]
  wire [31:0] _GEN_0 = 3'h5 == instrType ? _immExt_T_26 : 32'h0; // @[scala/ysyx/ysyx_22040080_idu.scala 132:23 151:16 59:30]
  wire [31:0] _GEN_1 = 3'h4 == instrType ? _immExt_T_19 : _GEN_0; // @[scala/ysyx/ysyx_22040080_idu.scala 132:23 147:16]
  wire [31:0] _GEN_2 = 3'h3 == instrType ? _immExt_T_17 : _GEN_1; // @[scala/ysyx/ysyx_22040080_idu.scala 132:23 143:16]
  wire [31:0] _GEN_3 = 3'h2 == instrType ? _immExt_T_10 : _GEN_2; // @[scala/ysyx/ysyx_22040080_idu.scala 132:23 139:16]
  wire [31:0] _GEN_4 = 3'h1 == instrType ? _immExt_T_4 : _GEN_3; // @[scala/ysyx/ysyx_22040080_idu.scala 132:23 135:16]
  wire [31:0] immExt = io_inst_active ? _GEN_4 : 32'h0; // @[scala/ysyx/ysyx_22040080_idu.scala 84:24 59:30]
  wire [11:0] _io_csr_addr_T_2 = _instrType_T_4 ? immExt[11:0] : 12'h0; // @[scala/ysyx/ysyx_22040080_idu.scala 157:23]
  assign io_rs1 = io_inst_active ? io_rdata[19:15] : 5'h0; // @[scala/ysyx/ysyx_22040080_idu.scala 84:24 88:14 64:18]
  assign io_rs2 = io_inst_active ? io_rdata[24:20] : 5'h0; // @[scala/ysyx/ysyx_22040080_idu.scala 84:24 89:14 65:18]
  assign io_rd = io_inst_active ? io_rdata[11:7] : 5'h0; // @[scala/ysyx/ysyx_22040080_idu.scala 84:24 91:14 67:18]
  assign io_func3 = io_inst_active ? funct3 : 3'h0; // @[scala/ysyx/ysyx_22040080_idu.scala 84:24 96:14 68:18]
  assign io_imm_ext = io_inst_active ? immExt : 32'h0; // @[scala/ysyx/ysyx_22040080_idu.scala 154:16 75:18 84:24]
  assign io_op = io_inst_active ? opcode : 7'h0; // @[scala/ysyx/ysyx_22040080_idu.scala 84:24 95:14 69:18]
  assign io_func7 = io_inst_active ? io_rdata[31:25] : 7'h0; // @[scala/ysyx/ysyx_22040080_idu.scala 84:24 90:14 66:18]
  assign io_shamt = io_inst_active ? _io_shamt_T_5 : 5'h0; // @[scala/ysyx/ysyx_22040080_idu.scala 84:24 99:14 70:18]
  assign io_csr_addr = io_inst_active ? _io_csr_addr_T_2 : 12'h0; // @[scala/ysyx/ysyx_22040080_idu.scala 157:17 76:18 84:24]
  assign io_is_jal = io_inst_active & _instrType_T_9; // @[scala/ysyx/ysyx_22040080_idu.scala 122:20 72:18 84:24]
  assign io_is_jalr = io_inst_active & _instrType_T_3; // @[scala/ysyx/ysyx_22040080_idu.scala 123:20 73:18 84:24]
  assign io_is_branch = io_inst_active & _instrType_T_6; // @[scala/ysyx/ysyx_22040080_idu.scala 124:20 74:18 84:24]
  assign io_is_load = io_inst_active & _instrType_T_2; // @[scala/ysyx/ysyx_22040080_idu.scala 125:20 77:18 84:24]
  assign io_is_store = io_inst_active & _instrType_T_5; // @[scala/ysyx/ysyx_22040080_idu.scala 126:20 78:18 84:24]
  assign io_lsu_reqValid = io_inst_active & (_instrType_T_2 | _instrType_T_5); // @[scala/ysyx/ysyx_22040080_idu.scala 127:21 79:19 84:24]
endmodule
module ysyx_22040080_alu(
  input  [31:0] io_rs1_data, // @[scala/ysyx/ysyx_22040080_alu.scala 7:14]
  input  [31:0] io_rs2_data, // @[scala/ysyx/ysyx_22040080_alu.scala 7:14]
  input  [31:0] io_imm_ext, // @[scala/ysyx/ysyx_22040080_alu.scala 7:14]
  input  [2:0]  io_func3, // @[scala/ysyx/ysyx_22040080_alu.scala 7:14]
  input  [6:0]  io_func7, // @[scala/ysyx/ysyx_22040080_alu.scala 7:14]
  input  [6:0]  io_op, // @[scala/ysyx/ysyx_22040080_alu.scala 7:14]
  input  [31:0] io_pc, // @[scala/ysyx/ysyx_22040080_alu.scala 7:14]
  input  [4:0]  io_shamt, // @[scala/ysyx/ysyx_22040080_alu.scala 7:14]
  input         io_inst_active, // @[scala/ysyx/ysyx_22040080_alu.scala 7:14]
  output [31:0] io_result, // @[scala/ysyx/ysyx_22040080_alu.scala 7:14]
  output        io_wen, // @[scala/ysyx/ysyx_22040080_alu.scala 7:14]
  output        io_branch_taken, // @[scala/ysyx/ysyx_22040080_alu.scala 7:14]
  output [31:0] io_jal_target, // @[scala/ysyx/ysyx_22040080_alu.scala 7:14]
  output [31:0] io_mem_addr, // @[scala/ysyx/ysyx_22040080_alu.scala 7:14]
  output [31:0] io_mem_wdata, // @[scala/ysyx/ysyx_22040080_alu.scala 7:14]
  input  [31:0] io_csr_rdata, // @[scala/ysyx/ysyx_22040080_alu.scala 7:14]
  output        io_csr_wen, // @[scala/ysyx/ysyx_22040080_alu.scala 7:14]
  output [31:0] io_csr_wdata, // @[scala/ysyx/ysyx_22040080_alu.scala 7:14]
  output        io_trap_valid, // @[scala/ysyx/ysyx_22040080_alu.scala 7:14]
  output        io_is_mret, // @[scala/ysyx/ysyx_22040080_alu.scala 7:14]
  output [31:0] io_trap_mepc, // @[scala/ysyx/ysyx_22040080_alu.scala 7:14]
  output [31:0] io_trap_mcause // @[scala/ysyx/ysyx_22040080_alu.scala 7:14]
);
  wire  _alu_in1_T_2 = io_op == 7'h13 | io_op == 7'h67; // @[scala/ysyx/ysyx_22040080_alu.scala 57:26]
  wire  _alu_in1_T_5 = io_op == 7'h17 | io_op == 7'h6f; // @[scala/ysyx/ysyx_22040080_alu.scala 58:26]
  wire [31:0] _alu_in1_T_6 = _alu_in1_T_5 ? io_pc : 32'h0; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] alu_in1 = _alu_in1_T_2 ? io_rs1_data : _alu_in1_T_6; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] alu_sum = alu_in1 + io_imm_ext; // @[scala/ysyx/ysyx_22040080_alu.scala 61:25]
  wire  _T_1 = 3'h0 == io_func3; // @[scala/ysyx/ysyx_22040080_alu.scala 90:26]
  wire  _T_2 = 3'h1 == io_func3; // @[scala/ysyx/ysyx_22040080_alu.scala 90:26]
  wire [62:0] _GEN_1 = {{31'd0}, io_rs1_data}; // @[scala/ysyx/ysyx_22040080_alu.scala 96:38]
  wire [62:0] _io_result_T = _GEN_1 << io_shamt; // @[scala/ysyx/ysyx_22040080_alu.scala 96:38]
  wire  _T_3 = 3'h3 == io_func3; // @[scala/ysyx/ysyx_22040080_alu.scala 90:26]
  wire  _T_4 = 3'h4 == io_func3; // @[scala/ysyx/ysyx_22040080_alu.scala 90:26]
  wire [31:0] _io_result_T_3 = io_rs1_data ^ io_imm_ext; // @[scala/ysyx/ysyx_22040080_alu.scala 104:38]
  wire  _T_5 = 3'h5 == io_func3; // @[scala/ysyx/ysyx_22040080_alu.scala 90:26]
  wire  _T_6 = io_func7 == 7'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 108:27]
  wire [31:0] _io_result_T_4 = io_rs1_data >> io_shamt; // @[scala/ysyx/ysyx_22040080_alu.scala 109:40]
  wire  _T_7 = io_func7 == 7'h20; // @[scala/ysyx/ysyx_22040080_alu.scala 111:34]
  wire [31:0] _io_result_T_5 = io_rs1_data; // @[scala/ysyx/ysyx_22040080_alu.scala 112:41]
  wire [31:0] _io_result_T_7 = $signed(io_rs1_data) >>> io_shamt; // @[scala/ysyx/ysyx_22040080_alu.scala 112:61]
  wire [31:0] _GEN_0 = io_func7 == 7'h20 ? _io_result_T_7 : 32'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 111:52 112:25 66:19]
  wire [31:0] _GEN_2 = io_func7 == 7'h0 ? _io_result_T_4 : _GEN_0; // @[scala/ysyx/ysyx_22040080_alu.scala 108:45 109:25]
  wire  _GEN_3 = io_func7 == 7'h0 | _T_7; // @[scala/ysyx/ysyx_22040080_alu.scala 108:45 110:22]
  wire  _T_8 = 3'h6 == io_func3; // @[scala/ysyx/ysyx_22040080_alu.scala 90:26]
  wire [31:0] _io_result_T_8 = io_rs1_data | io_imm_ext; // @[scala/ysyx/ysyx_22040080_alu.scala 117:38]
  wire  _T_9 = 3'h7 == io_func3; // @[scala/ysyx/ysyx_22040080_alu.scala 90:26]
  wire [31:0] _io_result_T_9 = io_rs1_data & io_imm_ext; // @[scala/ysyx/ysyx_22040080_alu.scala 121:38]
  wire [31:0] _GEN_4 = 3'h7 == io_func3 ? _io_result_T_9 : 32'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 121:23 66:19 90:26]
  wire [31:0] _GEN_6 = 3'h6 == io_func3 ? _io_result_T_8 : _GEN_4; // @[scala/ysyx/ysyx_22040080_alu.scala 117:23 90:26]
  wire  _GEN_7 = 3'h6 == io_func3 | 3'h7 == io_func3; // @[scala/ysyx/ysyx_22040080_alu.scala 118:20 90:26]
  wire [31:0] _GEN_8 = 3'h5 == io_func3 ? _GEN_2 : _GEN_6; // @[scala/ysyx/ysyx_22040080_alu.scala 90:26]
  wire  _GEN_9 = 3'h5 == io_func3 ? _GEN_3 : _GEN_7; // @[scala/ysyx/ysyx_22040080_alu.scala 90:26]
  wire [31:0] _GEN_10 = 3'h4 == io_func3 ? _io_result_T_3 : _GEN_8; // @[scala/ysyx/ysyx_22040080_alu.scala 104:23 90:26]
  wire  _GEN_11 = 3'h4 == io_func3 | _GEN_9; // @[scala/ysyx/ysyx_22040080_alu.scala 105:20 90:26]
  wire [31:0] _GEN_12 = 3'h3 == io_func3 ? {{31'd0}, io_rs1_data < io_imm_ext} : _GEN_10; // @[scala/ysyx/ysyx_22040080_alu.scala 100:23 90:26]
  wire  _GEN_13 = 3'h3 == io_func3 | _GEN_11; // @[scala/ysyx/ysyx_22040080_alu.scala 101:20 90:26]
  wire [62:0] _GEN_14 = 3'h1 == io_func3 ? _io_result_T : {{31'd0}, _GEN_12}; // @[scala/ysyx/ysyx_22040080_alu.scala 90:26 96:23]
  wire  _GEN_15 = 3'h1 == io_func3 | _GEN_13; // @[scala/ysyx/ysyx_22040080_alu.scala 90:26 97:20]
  wire [62:0] _GEN_16 = 3'h0 == io_func3 ? {{31'd0}, alu_sum} : _GEN_14; // @[scala/ysyx/ysyx_22040080_alu.scala 90:26 92:23]
  wire  _GEN_17 = 3'h0 == io_func3 | _GEN_15; // @[scala/ysyx/ysyx_22040080_alu.scala 90:26 93:20]
  wire [31:0] _io_result_T_11 = io_rs1_data + io_rs2_data; // @[scala/ysyx/ysyx_22040080_alu.scala 134:40]
  wire [31:0] _io_result_T_13 = io_rs1_data - io_rs2_data; // @[scala/ysyx/ysyx_22040080_alu.scala 137:40]
  wire [31:0] _GEN_18 = _T_7 ? _io_result_T_13 : 32'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 136:52 137:25 66:19]
  wire [31:0] _GEN_20 = _T_6 ? _io_result_T_11 : _GEN_18; // @[scala/ysyx/ysyx_22040080_alu.scala 133:45 134:25]
  wire [62:0] _GEN_5 = {{31'd0}, io_rs1_data}; // @[scala/ysyx/ysyx_22040080_alu.scala 142:38]
  wire [62:0] _io_result_T_15 = _GEN_5 << io_rs2_data[4:0]; // @[scala/ysyx/ysyx_22040080_alu.scala 142:38]
  wire  _T_15 = 3'h2 == io_func3; // @[scala/ysyx/ysyx_22040080_alu.scala 131:26]
  wire [31:0] _io_result_T_17 = io_rs2_data; // @[scala/ysyx/ysyx_22040080_alu.scala 146:63]
  wire  _io_result_T_18 = $signed(io_rs1_data) < $signed(io_rs2_data); // @[scala/ysyx/ysyx_22040080_alu.scala 146:49]
  wire  _io_result_T_20 = io_rs1_data < io_rs2_data; // @[scala/ysyx/ysyx_22040080_alu.scala 151:44]
  wire  _GEN_22 = _T_6 & io_rs1_data < io_rs2_data; // @[scala/ysyx/ysyx_22040080_alu.scala 150:45 151:25 66:19]
  wire [31:0] _io_result_T_22 = io_rs1_data ^ io_rs2_data; // @[scala/ysyx/ysyx_22040080_alu.scala 156:38]
  wire [31:0] _io_result_T_24 = io_rs1_data >> io_rs2_data[4:0]; // @[scala/ysyx/ysyx_22040080_alu.scala 161:40]
  wire [31:0] _io_result_T_28 = $signed(io_rs1_data) >>> io_rs2_data[4:0]; // @[scala/ysyx/ysyx_22040080_alu.scala 164:70]
  wire [31:0] _GEN_24 = _T_7 ? _io_result_T_28 : 32'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 163:52 164:25 66:19]
  wire [31:0] _GEN_26 = _T_6 ? _io_result_T_24 : _GEN_24; // @[scala/ysyx/ysyx_22040080_alu.scala 160:45 161:25]
  wire [31:0] _io_result_T_29 = io_rs1_data | io_rs2_data; // @[scala/ysyx/ysyx_22040080_alu.scala 169:38]
  wire [31:0] _io_result_T_30 = io_rs1_data & io_rs2_data; // @[scala/ysyx/ysyx_22040080_alu.scala 173:38]
  wire [31:0] _GEN_28 = _T_9 ? _io_result_T_30 : 32'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 131:26 173:23 66:19]
  wire [31:0] _GEN_30 = _T_8 ? _io_result_T_29 : _GEN_28; // @[scala/ysyx/ysyx_22040080_alu.scala 131:26 169:23]
  wire [31:0] _GEN_32 = _T_5 ? _GEN_26 : _GEN_30; // @[scala/ysyx/ysyx_22040080_alu.scala 131:26]
  wire [31:0] _GEN_34 = _T_4 ? _io_result_T_22 : _GEN_32; // @[scala/ysyx/ysyx_22040080_alu.scala 131:26 156:23]
  wire [31:0] _GEN_36 = _T_3 ? {{31'd0}, _GEN_22} : _GEN_34; // @[scala/ysyx/ysyx_22040080_alu.scala 131:26]
  wire  _GEN_37 = _T_3 ? _T_6 : _GEN_11; // @[scala/ysyx/ysyx_22040080_alu.scala 131:26]
  wire [31:0] _GEN_38 = 3'h2 == io_func3 ? {{31'd0}, $signed(_io_result_T_5) < $signed(_io_result_T_17)} : _GEN_36; // @[scala/ysyx/ysyx_22040080_alu.scala 131:26 146:23]
  wire  _GEN_39 = 3'h2 == io_func3 | _GEN_37; // @[scala/ysyx/ysyx_22040080_alu.scala 131:26 147:20]
  wire [62:0] _GEN_40 = _T_2 ? _io_result_T_15 : {{31'd0}, _GEN_38}; // @[scala/ysyx/ysyx_22040080_alu.scala 131:26 142:23]
  wire  _GEN_41 = _T_2 | _GEN_39; // @[scala/ysyx/ysyx_22040080_alu.scala 131:26 143:20]
  wire [62:0] _GEN_42 = _T_1 ? {{31'd0}, _GEN_20} : _GEN_40; // @[scala/ysyx/ysyx_22040080_alu.scala 131:26]
  wire  _GEN_43 = _T_1 ? _GEN_3 : _GEN_41; // @[scala/ysyx/ysyx_22040080_alu.scala 131:26]
  wire [31:0] _io_mem_addr_T_1 = io_rs1_data + io_imm_ext; // @[scala/ysyx/ysyx_22040080_alu.scala 183:36]
  wire  _GEN_44 = _T_9 & io_rs1_data >= io_rs2_data; // @[scala/ysyx/ysyx_22040080_alu.scala 200:26 206:27 199:32]
  wire  _GEN_45 = _T_8 ? _io_result_T_20 : _GEN_44; // @[scala/ysyx/ysyx_22040080_alu.scala 200:26 205:27]
  wire  _GEN_46 = _T_5 ? $signed(io_rs1_data) >= $signed(io_rs2_data) : _GEN_45; // @[scala/ysyx/ysyx_22040080_alu.scala 200:26 204:27]
  wire  _GEN_47 = _T_4 ? _io_result_T_18 : _GEN_46; // @[scala/ysyx/ysyx_22040080_alu.scala 200:26 203:27]
  wire  _GEN_48 = _T_2 ? io_rs1_data != io_rs2_data : _GEN_47; // @[scala/ysyx/ysyx_22040080_alu.scala 200:26 202:27]
  wire  taken = _T_1 ? io_rs1_data == io_rs2_data : _GEN_48; // @[scala/ysyx/ysyx_22040080_alu.scala 200:26 201:27]
  wire [31:0] _io_jal_target_T_1 = io_pc + io_imm_ext; // @[scala/ysyx/ysyx_22040080_alu.scala 211:34]
  wire [31:0] _GEN_51 = taken ? _io_jal_target_T_1 : 32'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 209:21 211:25 70:19]
  wire [31:0] _io_result_T_32 = io_pc + 32'h4; // @[scala/ysyx/ysyx_22040080_alu.scala 235:31]
  wire [31:0] _io_jal_target_T_4 = _io_mem_addr_T_1 & 32'hfffffffe; // @[scala/ysyx/ysyx_22040080_alu.scala 247:53]
  wire  _T_40 = io_imm_ext[11:0] == 12'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 257:36]
  wire  _T_42 = io_imm_ext[11:0] == 12'h302; // @[scala/ysyx/ysyx_22040080_alu.scala 261:43]
  wire [31:0] _GEN_54 = io_imm_ext[11:0] == 12'h0 ? io_pc : 32'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 257:50 259:30 76:19]
  wire [3:0] _GEN_55 = io_imm_ext[11:0] == 12'h0 ? 4'hb : 4'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 257:50 260:30 77:19]
  wire  _GEN_56 = io_imm_ext[11:0] == 12'h0 ? 1'h0 : _T_42; // @[scala/ysyx/ysyx_22040080_alu.scala 257:50 78:19]
  wire [31:0] _io_csr_wdata_T = io_rs1_data | io_csr_rdata; // @[scala/ysyx/ysyx_22040080_alu.scala 273:41]
  wire [31:0] _GEN_57 = _T_15 ? io_csr_rdata : 32'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 255:26 272:26 66:19]
  wire [31:0] _GEN_58 = _T_15 ? _io_csr_wdata_T : 32'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 255:26 273:26 74:19]
  wire [31:0] _GEN_60 = _T_2 ? io_csr_rdata : _GEN_57; // @[scala/ysyx/ysyx_22040080_alu.scala 255:26 266:26]
  wire [31:0] _GEN_61 = _T_2 ? io_rs1_data : _GEN_58; // @[scala/ysyx/ysyx_22040080_alu.scala 255:26 267:26]
  wire  _GEN_62 = _T_2 | _T_15; // @[scala/ysyx/ysyx_22040080_alu.scala 255:26 268:26]
  wire  _GEN_63 = _T_1 & _T_40; // @[scala/ysyx/ysyx_22040080_alu.scala 255:26 75:19]
  wire [31:0] _GEN_64 = _T_1 ? _GEN_54 : 32'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 255:26 76:19]
  wire [3:0] _GEN_65 = _T_1 ? _GEN_55 : 4'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 255:26 77:19]
  wire  _GEN_66 = _T_1 & _GEN_56; // @[scala/ysyx/ysyx_22040080_alu.scala 255:26 78:19]
  wire [31:0] _GEN_67 = _T_1 ? 32'h0 : _GEN_60; // @[scala/ysyx/ysyx_22040080_alu.scala 255:26 66:19]
  wire [31:0] _GEN_68 = _T_1 ? 32'h0 : _GEN_61; // @[scala/ysyx/ysyx_22040080_alu.scala 255:26 74:19]
  wire  _GEN_69 = _T_1 ? 1'h0 : _GEN_62; // @[scala/ysyx/ysyx_22040080_alu.scala 255:26 73:19]
  wire [31:0] _GEN_71 = 7'h73 == io_op ? _GEN_64 : 32'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 76:19 84:19]
  wire [3:0] _GEN_72 = 7'h73 == io_op ? _GEN_65 : 4'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 77:19 84:19]
  wire [31:0] _GEN_74 = 7'h73 == io_op ? _GEN_67 : 32'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 66:19 84:19]
  wire [31:0] _GEN_75 = 7'h73 == io_op ? _GEN_68 : 32'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 74:19 84:19]
  wire  _GEN_76 = 7'h73 == io_op & _GEN_69; // @[scala/ysyx/ysyx_22040080_alu.scala 73:19 84:19]
  wire [31:0] _GEN_77 = 7'h67 == io_op ? _io_result_T_32 : _GEN_74; // @[scala/ysyx/ysyx_22040080_alu.scala 84:19 245:22]
  wire [31:0] _GEN_79 = 7'h67 == io_op ? _io_jal_target_T_4 : 32'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 84:19 247:23 70:19]
  wire  _GEN_80 = 7'h67 == io_op | _GEN_76; // @[scala/ysyx/ysyx_22040080_alu.scala 248:16 84:19]
  wire  _GEN_81 = 7'h67 == io_op ? 1'h0 : 7'h73 == io_op & _GEN_63; // @[scala/ysyx/ysyx_22040080_alu.scala 75:19 84:19]
  wire [31:0] _GEN_82 = 7'h67 == io_op ? 32'h0 : _GEN_71; // @[scala/ysyx/ysyx_22040080_alu.scala 76:19 84:19]
  wire [3:0] _GEN_83 = 7'h67 == io_op ? 4'h0 : _GEN_72; // @[scala/ysyx/ysyx_22040080_alu.scala 77:19 84:19]
  wire  _GEN_84 = 7'h67 == io_op ? 1'h0 : 7'h73 == io_op & _GEN_66; // @[scala/ysyx/ysyx_22040080_alu.scala 78:19 84:19]
  wire [31:0] _GEN_85 = 7'h67 == io_op ? 32'h0 : _GEN_75; // @[scala/ysyx/ysyx_22040080_alu.scala 74:19 84:19]
  wire  _GEN_86 = 7'h67 == io_op ? 1'h0 : 7'h73 == io_op & _GEN_69; // @[scala/ysyx/ysyx_22040080_alu.scala 73:19 84:19]
  wire [31:0] _GEN_87 = 7'h6f == io_op ? _io_result_T_32 : _GEN_77; // @[scala/ysyx/ysyx_22040080_alu.scala 84:19 235:22]
  wire [31:0] _GEN_89 = 7'h6f == io_op ? alu_sum : _GEN_79; // @[scala/ysyx/ysyx_22040080_alu.scala 84:19 237:23]
  wire  _GEN_90 = 7'h6f == io_op | _GEN_80; // @[scala/ysyx/ysyx_22040080_alu.scala 238:16 84:19]
  wire  _GEN_91 = 7'h6f == io_op ? 1'h0 : _GEN_81; // @[scala/ysyx/ysyx_22040080_alu.scala 75:19 84:19]
  wire [31:0] _GEN_92 = 7'h6f == io_op ? 32'h0 : _GEN_82; // @[scala/ysyx/ysyx_22040080_alu.scala 76:19 84:19]
  wire [3:0] _GEN_93 = 7'h6f == io_op ? 4'h0 : _GEN_83; // @[scala/ysyx/ysyx_22040080_alu.scala 77:19 84:19]
  wire  _GEN_94 = 7'h6f == io_op ? 1'h0 : _GEN_84; // @[scala/ysyx/ysyx_22040080_alu.scala 78:19 84:19]
  wire [31:0] _GEN_95 = 7'h6f == io_op ? 32'h0 : _GEN_85; // @[scala/ysyx/ysyx_22040080_alu.scala 74:19 84:19]
  wire  _GEN_96 = 7'h6f == io_op ? 1'h0 : _GEN_86; // @[scala/ysyx/ysyx_22040080_alu.scala 73:19 84:19]
  wire [31:0] _GEN_97 = 7'h37 == io_op ? io_imm_ext : _GEN_87; // @[scala/ysyx/ysyx_22040080_alu.scala 227:19 84:19]
  wire  _GEN_98 = 7'h37 == io_op | _GEN_90; // @[scala/ysyx/ysyx_22040080_alu.scala 228:16 84:19]
  wire [31:0] _GEN_100 = 7'h37 == io_op ? 32'h0 : _GEN_89; // @[scala/ysyx/ysyx_22040080_alu.scala 70:19 84:19]
  wire  _GEN_101 = 7'h37 == io_op ? 1'h0 : _GEN_91; // @[scala/ysyx/ysyx_22040080_alu.scala 75:19 84:19]
  wire [31:0] _GEN_102 = 7'h37 == io_op ? 32'h0 : _GEN_92; // @[scala/ysyx/ysyx_22040080_alu.scala 76:19 84:19]
  wire [3:0] _GEN_103 = 7'h37 == io_op ? 4'h0 : _GEN_93; // @[scala/ysyx/ysyx_22040080_alu.scala 77:19 84:19]
  wire  _GEN_104 = 7'h37 == io_op ? 1'h0 : _GEN_94; // @[scala/ysyx/ysyx_22040080_alu.scala 78:19 84:19]
  wire [31:0] _GEN_105 = 7'h37 == io_op ? 32'h0 : _GEN_95; // @[scala/ysyx/ysyx_22040080_alu.scala 74:19 84:19]
  wire  _GEN_106 = 7'h37 == io_op ? 1'h0 : _GEN_96; // @[scala/ysyx/ysyx_22040080_alu.scala 73:19 84:19]
  wire [31:0] _GEN_107 = 7'h17 == io_op ? alu_sum : _GEN_97; // @[scala/ysyx/ysyx_22040080_alu.scala 219:19 84:19]
  wire  _GEN_108 = 7'h17 == io_op | _GEN_98; // @[scala/ysyx/ysyx_22040080_alu.scala 220:16 84:19]
  wire [31:0] _GEN_110 = 7'h17 == io_op ? 32'h0 : _GEN_100; // @[scala/ysyx/ysyx_22040080_alu.scala 70:19 84:19]
  wire  _GEN_111 = 7'h17 == io_op ? 1'h0 : _GEN_101; // @[scala/ysyx/ysyx_22040080_alu.scala 75:19 84:19]
  wire [31:0] _GEN_112 = 7'h17 == io_op ? 32'h0 : _GEN_102; // @[scala/ysyx/ysyx_22040080_alu.scala 76:19 84:19]
  wire [3:0] _GEN_113 = 7'h17 == io_op ? 4'h0 : _GEN_103; // @[scala/ysyx/ysyx_22040080_alu.scala 77:19 84:19]
  wire  _GEN_114 = 7'h17 == io_op ? 1'h0 : _GEN_104; // @[scala/ysyx/ysyx_22040080_alu.scala 78:19 84:19]
  wire [31:0] _GEN_115 = 7'h17 == io_op ? 32'h0 : _GEN_105; // @[scala/ysyx/ysyx_22040080_alu.scala 74:19 84:19]
  wire  _GEN_116 = 7'h17 == io_op ? 1'h0 : _GEN_106; // @[scala/ysyx/ysyx_22040080_alu.scala 73:19 84:19]
  wire  _GEN_117 = 7'h63 == io_op & taken; // @[scala/ysyx/ysyx_22040080_alu.scala 84:19 208:25 69:19]
  wire [31:0] _GEN_119 = 7'h63 == io_op ? _GEN_51 : _GEN_110; // @[scala/ysyx/ysyx_22040080_alu.scala 84:19]
  wire [31:0] _GEN_120 = 7'h63 == io_op ? 32'h0 : _GEN_107; // @[scala/ysyx/ysyx_22040080_alu.scala 66:19 84:19]
  wire  _GEN_121 = 7'h63 == io_op ? 1'h0 : _GEN_108; // @[scala/ysyx/ysyx_22040080_alu.scala 67:19 84:19]
  wire  _GEN_122 = 7'h63 == io_op ? 1'h0 : _GEN_111; // @[scala/ysyx/ysyx_22040080_alu.scala 75:19 84:19]
  wire [31:0] _GEN_123 = 7'h63 == io_op ? 32'h0 : _GEN_112; // @[scala/ysyx/ysyx_22040080_alu.scala 76:19 84:19]
  wire [3:0] _GEN_124 = 7'h63 == io_op ? 4'h0 : _GEN_113; // @[scala/ysyx/ysyx_22040080_alu.scala 77:19 84:19]
  wire  _GEN_125 = 7'h63 == io_op ? 1'h0 : _GEN_114; // @[scala/ysyx/ysyx_22040080_alu.scala 78:19 84:19]
  wire [31:0] _GEN_126 = 7'h63 == io_op ? 32'h0 : _GEN_115; // @[scala/ysyx/ysyx_22040080_alu.scala 74:19 84:19]
  wire  _GEN_127 = 7'h63 == io_op ? 1'h0 : _GEN_116; // @[scala/ysyx/ysyx_22040080_alu.scala 73:19 84:19]
  wire [31:0] _GEN_128 = 7'h23 == io_op ? _io_mem_addr_T_1 : 32'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 84:19 191:22 71:19]
  wire [31:0] _GEN_129 = 7'h23 == io_op ? io_rs2_data : 32'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 84:19 192:22 72:19]
  wire  _GEN_130 = 7'h23 == io_op ? 1'h0 : _GEN_117; // @[scala/ysyx/ysyx_22040080_alu.scala 69:19 84:19]
  wire [31:0] _GEN_132 = 7'h23 == io_op ? 32'h0 : _GEN_119; // @[scala/ysyx/ysyx_22040080_alu.scala 70:19 84:19]
  wire [31:0] _GEN_133 = 7'h23 == io_op ? 32'h0 : _GEN_120; // @[scala/ysyx/ysyx_22040080_alu.scala 66:19 84:19]
  wire  _GEN_134 = 7'h23 == io_op ? 1'h0 : _GEN_121; // @[scala/ysyx/ysyx_22040080_alu.scala 67:19 84:19]
  wire  _GEN_135 = 7'h23 == io_op ? 1'h0 : _GEN_122; // @[scala/ysyx/ysyx_22040080_alu.scala 75:19 84:19]
  wire [31:0] _GEN_136 = 7'h23 == io_op ? 32'h0 : _GEN_123; // @[scala/ysyx/ysyx_22040080_alu.scala 76:19 84:19]
  wire [3:0] _GEN_137 = 7'h23 == io_op ? 4'h0 : _GEN_124; // @[scala/ysyx/ysyx_22040080_alu.scala 77:19 84:19]
  wire  _GEN_138 = 7'h23 == io_op ? 1'h0 : _GEN_125; // @[scala/ysyx/ysyx_22040080_alu.scala 78:19 84:19]
  wire [31:0] _GEN_139 = 7'h23 == io_op ? 32'h0 : _GEN_126; // @[scala/ysyx/ysyx_22040080_alu.scala 74:19 84:19]
  wire  _GEN_140 = 7'h23 == io_op ? 1'h0 : _GEN_127; // @[scala/ysyx/ysyx_22040080_alu.scala 73:19 84:19]
  wire [31:0] _GEN_141 = 7'h3 == io_op ? _io_mem_addr_T_1 : _GEN_128; // @[scala/ysyx/ysyx_22040080_alu.scala 84:19 183:21]
  wire  _GEN_142 = 7'h3 == io_op | _GEN_134; // @[scala/ysyx/ysyx_22040080_alu.scala 184:16 84:19]
  wire [31:0] _GEN_143 = 7'h3 == io_op ? 32'h0 : _GEN_129; // @[scala/ysyx/ysyx_22040080_alu.scala 72:19 84:19]
  wire  _GEN_144 = 7'h3 == io_op ? 1'h0 : _GEN_130; // @[scala/ysyx/ysyx_22040080_alu.scala 69:19 84:19]
  wire [31:0] _GEN_146 = 7'h3 == io_op ? 32'h0 : _GEN_132; // @[scala/ysyx/ysyx_22040080_alu.scala 70:19 84:19]
  wire [31:0] _GEN_147 = 7'h3 == io_op ? 32'h0 : _GEN_133; // @[scala/ysyx/ysyx_22040080_alu.scala 66:19 84:19]
  wire  _GEN_148 = 7'h3 == io_op ? 1'h0 : _GEN_135; // @[scala/ysyx/ysyx_22040080_alu.scala 75:19 84:19]
  wire [31:0] _GEN_149 = 7'h3 == io_op ? 32'h0 : _GEN_136; // @[scala/ysyx/ysyx_22040080_alu.scala 76:19 84:19]
  wire [3:0] _GEN_150 = 7'h3 == io_op ? 4'h0 : _GEN_137; // @[scala/ysyx/ysyx_22040080_alu.scala 77:19 84:19]
  wire  _GEN_151 = 7'h3 == io_op ? 1'h0 : _GEN_138; // @[scala/ysyx/ysyx_22040080_alu.scala 78:19 84:19]
  wire [31:0] _GEN_152 = 7'h3 == io_op ? 32'h0 : _GEN_139; // @[scala/ysyx/ysyx_22040080_alu.scala 74:19 84:19]
  wire  _GEN_153 = 7'h3 == io_op ? 1'h0 : _GEN_140; // @[scala/ysyx/ysyx_22040080_alu.scala 73:19 84:19]
  wire [62:0] _GEN_154 = 7'h33 == io_op ? _GEN_42 : {{31'd0}, _GEN_147}; // @[scala/ysyx/ysyx_22040080_alu.scala 84:19]
  wire  _GEN_155 = 7'h33 == io_op ? _GEN_43 : _GEN_142; // @[scala/ysyx/ysyx_22040080_alu.scala 84:19]
  wire [31:0] _GEN_156 = 7'h33 == io_op ? 32'h0 : _GEN_141; // @[scala/ysyx/ysyx_22040080_alu.scala 71:19 84:19]
  wire [31:0] _GEN_157 = 7'h33 == io_op ? 32'h0 : _GEN_143; // @[scala/ysyx/ysyx_22040080_alu.scala 72:19 84:19]
  wire  _GEN_158 = 7'h33 == io_op ? 1'h0 : _GEN_144; // @[scala/ysyx/ysyx_22040080_alu.scala 69:19 84:19]
  wire [31:0] _GEN_160 = 7'h33 == io_op ? 32'h0 : _GEN_146; // @[scala/ysyx/ysyx_22040080_alu.scala 70:19 84:19]
  wire  _GEN_161 = 7'h33 == io_op ? 1'h0 : _GEN_148; // @[scala/ysyx/ysyx_22040080_alu.scala 75:19 84:19]
  wire [31:0] _GEN_162 = 7'h33 == io_op ? 32'h0 : _GEN_149; // @[scala/ysyx/ysyx_22040080_alu.scala 76:19 84:19]
  wire [3:0] _GEN_163 = 7'h33 == io_op ? 4'h0 : _GEN_150; // @[scala/ysyx/ysyx_22040080_alu.scala 77:19 84:19]
  wire  _GEN_164 = 7'h33 == io_op ? 1'h0 : _GEN_151; // @[scala/ysyx/ysyx_22040080_alu.scala 78:19 84:19]
  wire [31:0] _GEN_165 = 7'h33 == io_op ? 32'h0 : _GEN_152; // @[scala/ysyx/ysyx_22040080_alu.scala 74:19 84:19]
  wire  _GEN_166 = 7'h33 == io_op ? 1'h0 : _GEN_153; // @[scala/ysyx/ysyx_22040080_alu.scala 73:19 84:19]
  wire [62:0] _GEN_167 = 7'h13 == io_op ? _GEN_16 : _GEN_154; // @[scala/ysyx/ysyx_22040080_alu.scala 84:19]
  wire  _GEN_168 = 7'h13 == io_op ? _GEN_17 : _GEN_155; // @[scala/ysyx/ysyx_22040080_alu.scala 84:19]
  wire [31:0] _GEN_169 = 7'h13 == io_op ? 32'h0 : _GEN_156; // @[scala/ysyx/ysyx_22040080_alu.scala 71:19 84:19]
  wire [31:0] _GEN_170 = 7'h13 == io_op ? 32'h0 : _GEN_157; // @[scala/ysyx/ysyx_22040080_alu.scala 72:19 84:19]
  wire  _GEN_171 = 7'h13 == io_op ? 1'h0 : _GEN_158; // @[scala/ysyx/ysyx_22040080_alu.scala 69:19 84:19]
  wire [31:0] _GEN_173 = 7'h13 == io_op ? 32'h0 : _GEN_160; // @[scala/ysyx/ysyx_22040080_alu.scala 70:19 84:19]
  wire  _GEN_174 = 7'h13 == io_op ? 1'h0 : _GEN_161; // @[scala/ysyx/ysyx_22040080_alu.scala 75:19 84:19]
  wire [31:0] _GEN_175 = 7'h13 == io_op ? 32'h0 : _GEN_162; // @[scala/ysyx/ysyx_22040080_alu.scala 76:19 84:19]
  wire [3:0] _GEN_176 = 7'h13 == io_op ? 4'h0 : _GEN_163; // @[scala/ysyx/ysyx_22040080_alu.scala 77:19 84:19]
  wire  _GEN_177 = 7'h13 == io_op ? 1'h0 : _GEN_164; // @[scala/ysyx/ysyx_22040080_alu.scala 78:19 84:19]
  wire [31:0] _GEN_178 = 7'h13 == io_op ? 32'h0 : _GEN_165; // @[scala/ysyx/ysyx_22040080_alu.scala 74:19 84:19]
  wire  _GEN_179 = 7'h13 == io_op ? 1'h0 : _GEN_166; // @[scala/ysyx/ysyx_22040080_alu.scala 73:19 84:19]
  wire [62:0] _GEN_180 = io_inst_active ? _GEN_167 : 63'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 66:19 83:24]
  wire [3:0] _GEN_189 = io_inst_active ? _GEN_176 : 4'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 77:19 83:24]
  assign io_result = _GEN_180[31:0];
  assign io_wen = io_inst_active & _GEN_168; // @[scala/ysyx/ysyx_22040080_alu.scala 67:19 83:24]
  assign io_branch_taken = io_inst_active & _GEN_171; // @[scala/ysyx/ysyx_22040080_alu.scala 69:19 83:24]
  assign io_jal_target = io_inst_active ? _GEN_173 : 32'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 70:19 83:24]
  assign io_mem_addr = io_inst_active ? _GEN_169 : 32'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 71:19 83:24]
  assign io_mem_wdata = io_inst_active ? _GEN_170 : 32'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 72:19 83:24]
  assign io_csr_wen = io_inst_active & _GEN_179; // @[scala/ysyx/ysyx_22040080_alu.scala 73:19 83:24]
  assign io_csr_wdata = io_inst_active ? _GEN_178 : 32'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 74:19 83:24]
  assign io_trap_valid = io_inst_active & _GEN_174; // @[scala/ysyx/ysyx_22040080_alu.scala 75:19 83:24]
  assign io_is_mret = io_inst_active & _GEN_177; // @[scala/ysyx/ysyx_22040080_alu.scala 78:19 83:24]
  assign io_trap_mepc = io_inst_active ? _GEN_175 : 32'h0; // @[scala/ysyx/ysyx_22040080_alu.scala 76:19 83:24]
  assign io_trap_mcause = {{28'd0}, _GEN_189};
endmodule
module RegisterFile(
  input         clock,
  input         reset,
  input         io_wen, // @[scala/ysyx/RegisterFile.scala 65:14]
  input  [4:0]  io_raddr1, // @[scala/ysyx/RegisterFile.scala 65:14]
  input  [4:0]  io_raddr2, // @[scala/ysyx/RegisterFile.scala 65:14]
  input  [4:0]  io_waddr, // @[scala/ysyx/RegisterFile.scala 65:14]
  input  [31:0] io_wdata, // @[scala/ysyx/RegisterFile.scala 65:14]
  output [31:0] io_rdata1, // @[scala/ysyx/RegisterFile.scala 65:14]
  output [31:0] io_rdata2, // @[scala/ysyx/RegisterFile.scala 65:14]
  output        io_wb_done, // @[scala/ysyx/RegisterFile.scala 65:14]
  input         io_is_branch, // @[scala/ysyx/RegisterFile.scala 65:14]
  input         io_is_load, // @[scala/ysyx/RegisterFile.scala 65:14]
  input         io_is_store, // @[scala/ysyx/RegisterFile.scala 65:14]
  input  [31:0] io_load_data, // @[scala/ysyx/RegisterFile.scala 65:14]
  input         io_lsu_reqReady, // @[scala/ysyx/RegisterFile.scala 65:14]
  input         io_lsu_respValid, // @[scala/ysyx/RegisterFile.scala 65:14]
  output        io_lsu_respReady // @[scala/ysyx/RegisterFile.scala 65:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
  reg [31:0] _RAND_24;
  reg [31:0] _RAND_25;
  reg [31:0] _RAND_26;
  reg [31:0] _RAND_27;
  reg [31:0] _RAND_28;
  reg [31:0] _RAND_29;
  reg [31:0] _RAND_30;
  reg [31:0] _RAND_31;
  reg [31:0] _RAND_32;
  reg [31:0] _RAND_33;
  reg [31:0] _RAND_34;
  reg [31:0] _RAND_35;
  reg [31:0] _RAND_36;
  reg [31:0] _RAND_37;
  reg [31:0] _RAND_38;
`endif // RANDOMIZE_REG_INIT
  wire  regWriteCommit_clk; // @[scala/ysyx/RegisterFile.scala 109:30]
  wire  regWriteCommit_en; // @[scala/ysyx/RegisterFile.scala 109:30]
  wire [31:0] regWriteCommit_addr; // @[scala/ysyx/RegisterFile.scala 109:30]
  wire [31:0] regWriteCommit_wdata; // @[scala/ysyx/RegisterFile.scala 109:30]
  wire  getRegInfo_clk; // @[scala/ysyx/RegisterFile.scala 118:26]
  wire [1023:0] getRegInfo_rf_flat; // @[scala/ysyx/RegisterFile.scala 118:26]
  reg [31:0] rf_0; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_1; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_2; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_3; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_4; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_5; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_6; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_7; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_8; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_9; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_10; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_11; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_12; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_13; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_14; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_15; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_16; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_17; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_18; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_19; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_20; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_21; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_22; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_23; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_24; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_25; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_26; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_27; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_28; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_29; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_30; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [31:0] rf_31; // @[scala/ysyx/RegisterFile.scala 95:19]
  reg [4:0] load_waddr_buf; // @[scala/ysyx/RegisterFile.scala 97:35]
  reg  load_wen_buf; // @[scala/ysyx/RegisterFile.scala 98:35]
  reg  is_store_latch; // @[scala/ysyx/RegisterFile.scala 99:35]
  reg  store_req_accepted; // @[scala/ysyx/RegisterFile.scala 100:35]
  reg [7:0] wb_resp_ready_cnt; // @[scala/ysyx/RegisterFile.scala 101:35]
  reg  wbDoneReg; // @[scala/ysyx/RegisterFile.scala 103:32]
  reg  lsuRespReadyReg; // @[scala/ysyx/RegisterFile.scala 104:32]
  wire [255:0] getRegInfo_io_rf_flat_lo_lo = {rf_7,rf_6,rf_5,rf_4,rf_3,rf_2,rf_1,rf_0}; // @[scala/ysyx/RegisterFile.scala 120:31]
  wire [511:0] getRegInfo_io_rf_flat_lo = {rf_15,rf_14,rf_13,rf_12,rf_11,rf_10,rf_9,rf_8,getRegInfo_io_rf_flat_lo_lo}; // @[scala/ysyx/RegisterFile.scala 120:31]
  wire [255:0] getRegInfo_io_rf_flat_hi_lo = {rf_23,rf_22,rf_21,rf_20,rf_19,rf_18,rf_17,rf_16}; // @[scala/ysyx/RegisterFile.scala 120:31]
  wire [511:0] getRegInfo_io_rf_flat_hi = {rf_31,rf_30,rf_29,rf_28,rf_27,rf_26,rf_25,rf_24,getRegInfo_io_rf_flat_hi_lo}; // @[scala/ysyx/RegisterFile.scala 120:31]
  wire [31:0] _GEN_1 = 5'h1 == io_raddr1 ? rf_1 : rf_0; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_2 = 5'h2 == io_raddr1 ? rf_2 : _GEN_1; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_3 = 5'h3 == io_raddr1 ? rf_3 : _GEN_2; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_4 = 5'h4 == io_raddr1 ? rf_4 : _GEN_3; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_5 = 5'h5 == io_raddr1 ? rf_5 : _GEN_4; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_6 = 5'h6 == io_raddr1 ? rf_6 : _GEN_5; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_7 = 5'h7 == io_raddr1 ? rf_7 : _GEN_6; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_8 = 5'h8 == io_raddr1 ? rf_8 : _GEN_7; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_9 = 5'h9 == io_raddr1 ? rf_9 : _GEN_8; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_10 = 5'ha == io_raddr1 ? rf_10 : _GEN_9; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_11 = 5'hb == io_raddr1 ? rf_11 : _GEN_10; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_12 = 5'hc == io_raddr1 ? rf_12 : _GEN_11; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_13 = 5'hd == io_raddr1 ? rf_13 : _GEN_12; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_14 = 5'he == io_raddr1 ? rf_14 : _GEN_13; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_15 = 5'hf == io_raddr1 ? rf_15 : _GEN_14; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_16 = 5'h10 == io_raddr1 ? rf_16 : _GEN_15; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_17 = 5'h11 == io_raddr1 ? rf_17 : _GEN_16; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_18 = 5'h12 == io_raddr1 ? rf_18 : _GEN_17; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_19 = 5'h13 == io_raddr1 ? rf_19 : _GEN_18; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_20 = 5'h14 == io_raddr1 ? rf_20 : _GEN_19; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_21 = 5'h15 == io_raddr1 ? rf_21 : _GEN_20; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_22 = 5'h16 == io_raddr1 ? rf_22 : _GEN_21; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_23 = 5'h17 == io_raddr1 ? rf_23 : _GEN_22; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_24 = 5'h18 == io_raddr1 ? rf_24 : _GEN_23; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_25 = 5'h19 == io_raddr1 ? rf_25 : _GEN_24; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_26 = 5'h1a == io_raddr1 ? rf_26 : _GEN_25; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_27 = 5'h1b == io_raddr1 ? rf_27 : _GEN_26; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_28 = 5'h1c == io_raddr1 ? rf_28 : _GEN_27; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_29 = 5'h1d == io_raddr1 ? rf_29 : _GEN_28; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_30 = 5'h1e == io_raddr1 ? rf_30 : _GEN_29; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_31 = 5'h1f == io_raddr1 ? rf_31 : _GEN_30; // @[scala/ysyx/RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_33 = 5'h1 == io_raddr2 ? rf_1 : rf_0; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_34 = 5'h2 == io_raddr2 ? rf_2 : _GEN_33; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_35 = 5'h3 == io_raddr2 ? rf_3 : _GEN_34; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_36 = 5'h4 == io_raddr2 ? rf_4 : _GEN_35; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_37 = 5'h5 == io_raddr2 ? rf_5 : _GEN_36; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_38 = 5'h6 == io_raddr2 ? rf_6 : _GEN_37; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_39 = 5'h7 == io_raddr2 ? rf_7 : _GEN_38; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_40 = 5'h8 == io_raddr2 ? rf_8 : _GEN_39; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_41 = 5'h9 == io_raddr2 ? rf_9 : _GEN_40; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_42 = 5'ha == io_raddr2 ? rf_10 : _GEN_41; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_43 = 5'hb == io_raddr2 ? rf_11 : _GEN_42; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_44 = 5'hc == io_raddr2 ? rf_12 : _GEN_43; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_45 = 5'hd == io_raddr2 ? rf_13 : _GEN_44; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_46 = 5'he == io_raddr2 ? rf_14 : _GEN_45; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_47 = 5'hf == io_raddr2 ? rf_15 : _GEN_46; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_48 = 5'h10 == io_raddr2 ? rf_16 : _GEN_47; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_49 = 5'h11 == io_raddr2 ? rf_17 : _GEN_48; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_50 = 5'h12 == io_raddr2 ? rf_18 : _GEN_49; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_51 = 5'h13 == io_raddr2 ? rf_19 : _GEN_50; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_52 = 5'h14 == io_raddr2 ? rf_20 : _GEN_51; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_53 = 5'h15 == io_raddr2 ? rf_21 : _GEN_52; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_54 = 5'h16 == io_raddr2 ? rf_22 : _GEN_53; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_55 = 5'h17 == io_raddr2 ? rf_23 : _GEN_54; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_56 = 5'h18 == io_raddr2 ? rf_24 : _GEN_55; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_57 = 5'h19 == io_raddr2 ? rf_25 : _GEN_56; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_58 = 5'h1a == io_raddr2 ? rf_26 : _GEN_57; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_59 = 5'h1b == io_raddr2 ? rf_27 : _GEN_58; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_60 = 5'h1c == io_raddr2 ? rf_28 : _GEN_59; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_61 = 5'h1d == io_raddr2 ? rf_29 : _GEN_60; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_62 = 5'h1e == io_raddr2 ? rf_30 : _GEN_61; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_63 = 5'h1f == io_raddr2 ? rf_31 : _GEN_62; // @[scala/ysyx/RegisterFile.scala 126:{19,19}]
  wire  _T_2 = io_waddr != 5'h0; // @[scala/ysyx/RegisterFile.scala 140:19]
  wire [31:0] _regWriteCommit_io_addr_T = {27'h0,io_waddr}; // @[scala/ysyx/RegisterFile.scala 142:37]
  wire [31:0] _GEN_97 = io_waddr != 5'h0 ? _regWriteCommit_io_addr_T : 32'h0; // @[scala/ysyx/RegisterFile.scala 112:27 140:28 142:31]
  wire [31:0] _GEN_98 = io_waddr != 5'h0 ? io_wdata : 32'h0; // @[scala/ysyx/RegisterFile.scala 113:27 140:28 143:31]
  wire [7:0] _wb_resp_ready_cnt_T_1 = 8'h2 - 8'h1; // @[scala/ysyx/RegisterFile.scala 160:48]
  wire  _GEN_131 = io_lsu_reqReady | store_req_accepted; // @[scala/ysyx/RegisterFile.scala 176:29 177:28 100:35]
  wire  _T_5 = wb_resp_ready_cnt > 8'h0; // @[scala/ysyx/RegisterFile.scala 181:30]
  wire [7:0] _wb_resp_ready_cnt_T_5 = wb_resp_ready_cnt - 8'h1; // @[scala/ysyx/RegisterFile.scala 182:48]
  wire  _GEN_133 = io_lsu_respValid ? 1'h0 : is_store_latch; // @[scala/ysyx/RegisterFile.scala 184:32 187:30 99:35]
  wire  _GEN_134 = io_lsu_respValid ? 1'h0 : store_req_accepted; // @[scala/ysyx/RegisterFile.scala 184:32 188:30 100:35]
  wire [7:0] _GEN_135 = wb_resp_ready_cnt > 8'h0 ? _wb_resp_ready_cnt_T_5 : wb_resp_ready_cnt; // @[scala/ysyx/RegisterFile.scala 181:37 182:27 101:35]
  wire  _GEN_136 = wb_resp_ready_cnt > 8'h0 ? 1'h0 : io_lsu_respValid; // @[scala/ysyx/RegisterFile.scala 134:19 181:37]
  wire  _GEN_137 = wb_resp_ready_cnt > 8'h0 ? is_store_latch : _GEN_133; // @[scala/ysyx/RegisterFile.scala 181:37 99:35]
  wire  _GEN_138 = wb_resp_ready_cnt > 8'h0 ? store_req_accepted : _GEN_134; // @[scala/ysyx/RegisterFile.scala 100:35 181:37]
  wire  _GEN_139 = ~store_req_accepted ? _GEN_131 : _GEN_138; // @[scala/ysyx/RegisterFile.scala 174:31]
  wire [7:0] _GEN_140 = ~store_req_accepted ? wb_resp_ready_cnt : _GEN_135; // @[scala/ysyx/RegisterFile.scala 174:31 101:35]
  wire  _GEN_141 = ~store_req_accepted ? 1'h0 : _GEN_136; // @[scala/ysyx/RegisterFile.scala 134:19 174:31]
  wire  _GEN_142 = ~store_req_accepted ? is_store_latch : _GEN_137; // @[scala/ysyx/RegisterFile.scala 174:31 99:35]
  wire  _T_7 = load_waddr_buf != 5'h0; // @[scala/ysyx/RegisterFile.scala 203:29]
  wire [31:0] _regWriteCommit_io_addr_T_1 = {27'h0,load_waddr_buf}; // @[scala/ysyx/RegisterFile.scala 205:41]
  wire [31:0] _GEN_143 = 5'h0 == load_waddr_buf ? io_load_data : rf_0; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_144 = 5'h1 == load_waddr_buf ? io_load_data : rf_1; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_145 = 5'h2 == load_waddr_buf ? io_load_data : rf_2; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_146 = 5'h3 == load_waddr_buf ? io_load_data : rf_3; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_147 = 5'h4 == load_waddr_buf ? io_load_data : rf_4; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_148 = 5'h5 == load_waddr_buf ? io_load_data : rf_5; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_149 = 5'h6 == load_waddr_buf ? io_load_data : rf_6; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_150 = 5'h7 == load_waddr_buf ? io_load_data : rf_7; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_151 = 5'h8 == load_waddr_buf ? io_load_data : rf_8; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_152 = 5'h9 == load_waddr_buf ? io_load_data : rf_9; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_153 = 5'ha == load_waddr_buf ? io_load_data : rf_10; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_154 = 5'hb == load_waddr_buf ? io_load_data : rf_11; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_155 = 5'hc == load_waddr_buf ? io_load_data : rf_12; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_156 = 5'hd == load_waddr_buf ? io_load_data : rf_13; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_157 = 5'he == load_waddr_buf ? io_load_data : rf_14; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_158 = 5'hf == load_waddr_buf ? io_load_data : rf_15; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_159 = 5'h10 == load_waddr_buf ? io_load_data : rf_16; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_160 = 5'h11 == load_waddr_buf ? io_load_data : rf_17; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_161 = 5'h12 == load_waddr_buf ? io_load_data : rf_18; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_162 = 5'h13 == load_waddr_buf ? io_load_data : rf_19; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_163 = 5'h14 == load_waddr_buf ? io_load_data : rf_20; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_164 = 5'h15 == load_waddr_buf ? io_load_data : rf_21; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_165 = 5'h16 == load_waddr_buf ? io_load_data : rf_22; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_166 = 5'h17 == load_waddr_buf ? io_load_data : rf_23; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_167 = 5'h18 == load_waddr_buf ? io_load_data : rf_24; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_168 = 5'h19 == load_waddr_buf ? io_load_data : rf_25; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_169 = 5'h1a == load_waddr_buf ? io_load_data : rf_26; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_170 = 5'h1b == load_waddr_buf ? io_load_data : rf_27; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_171 = 5'h1c == load_waddr_buf ? io_load_data : rf_28; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_172 = 5'h1d == load_waddr_buf ? io_load_data : rf_29; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_173 = 5'h1e == load_waddr_buf ? io_load_data : rf_30; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_174 = 5'h1f == load_waddr_buf ? io_load_data : rf_31; // @[scala/ysyx/RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_176 = load_waddr_buf != 5'h0 ? _regWriteCommit_io_addr_T_1 : 32'h0; // @[scala/ysyx/RegisterFile.scala 112:27 203:38 205:35]
  wire [31:0] _GEN_177 = load_waddr_buf != 5'h0 ? io_load_data : 32'h0; // @[scala/ysyx/RegisterFile.scala 113:27 203:38 206:35]
  wire [31:0] _GEN_178 = load_waddr_buf != 5'h0 ? _GEN_143 : rf_0; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_179 = load_waddr_buf != 5'h0 ? _GEN_144 : rf_1; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_180 = load_waddr_buf != 5'h0 ? _GEN_145 : rf_2; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_181 = load_waddr_buf != 5'h0 ? _GEN_146 : rf_3; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_182 = load_waddr_buf != 5'h0 ? _GEN_147 : rf_4; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_183 = load_waddr_buf != 5'h0 ? _GEN_148 : rf_5; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_184 = load_waddr_buf != 5'h0 ? _GEN_149 : rf_6; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_185 = load_waddr_buf != 5'h0 ? _GEN_150 : rf_7; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_186 = load_waddr_buf != 5'h0 ? _GEN_151 : rf_8; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_187 = load_waddr_buf != 5'h0 ? _GEN_152 : rf_9; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_188 = load_waddr_buf != 5'h0 ? _GEN_153 : rf_10; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_189 = load_waddr_buf != 5'h0 ? _GEN_154 : rf_11; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_190 = load_waddr_buf != 5'h0 ? _GEN_155 : rf_12; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_191 = load_waddr_buf != 5'h0 ? _GEN_156 : rf_13; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_192 = load_waddr_buf != 5'h0 ? _GEN_157 : rf_14; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_193 = load_waddr_buf != 5'h0 ? _GEN_158 : rf_15; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_194 = load_waddr_buf != 5'h0 ? _GEN_159 : rf_16; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_195 = load_waddr_buf != 5'h0 ? _GEN_160 : rf_17; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_196 = load_waddr_buf != 5'h0 ? _GEN_161 : rf_18; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_197 = load_waddr_buf != 5'h0 ? _GEN_162 : rf_19; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_198 = load_waddr_buf != 5'h0 ? _GEN_163 : rf_20; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_199 = load_waddr_buf != 5'h0 ? _GEN_164 : rf_21; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_200 = load_waddr_buf != 5'h0 ? _GEN_165 : rf_22; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_201 = load_waddr_buf != 5'h0 ? _GEN_166 : rf_23; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_202 = load_waddr_buf != 5'h0 ? _GEN_167 : rf_24; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_203 = load_waddr_buf != 5'h0 ? _GEN_168 : rf_25; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_204 = load_waddr_buf != 5'h0 ? _GEN_169 : rf_26; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_205 = load_waddr_buf != 5'h0 ? _GEN_170 : rf_27; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_206 = load_waddr_buf != 5'h0 ? _GEN_171 : rf_28; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_207 = load_waddr_buf != 5'h0 ? _GEN_172 : rf_29; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_208 = load_waddr_buf != 5'h0 ? _GEN_173 : rf_30; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_209 = load_waddr_buf != 5'h0 ? _GEN_174 : rf_31; // @[scala/ysyx/RegisterFile.scala 203:38 95:19]
  wire  _GEN_210 = io_lsu_respValid & _T_7; // @[scala/ysyx/RegisterFile.scala 111:27 201:30]
  wire [31:0] _GEN_211 = io_lsu_respValid ? _GEN_176 : 32'h0; // @[scala/ysyx/RegisterFile.scala 112:27 201:30]
  wire [31:0] _GEN_212 = io_lsu_respValid ? _GEN_177 : 32'h0; // @[scala/ysyx/RegisterFile.scala 113:27 201:30]
  wire [31:0] _GEN_213 = io_lsu_respValid ? _GEN_178 : rf_0; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_214 = io_lsu_respValid ? _GEN_179 : rf_1; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_215 = io_lsu_respValid ? _GEN_180 : rf_2; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_216 = io_lsu_respValid ? _GEN_181 : rf_3; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_217 = io_lsu_respValid ? _GEN_182 : rf_4; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_218 = io_lsu_respValid ? _GEN_183 : rf_5; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_219 = io_lsu_respValid ? _GEN_184 : rf_6; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_220 = io_lsu_respValid ? _GEN_185 : rf_7; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_221 = io_lsu_respValid ? _GEN_186 : rf_8; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_222 = io_lsu_respValid ? _GEN_187 : rf_9; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_223 = io_lsu_respValid ? _GEN_188 : rf_10; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_224 = io_lsu_respValid ? _GEN_189 : rf_11; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_225 = io_lsu_respValid ? _GEN_190 : rf_12; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_226 = io_lsu_respValid ? _GEN_191 : rf_13; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_227 = io_lsu_respValid ? _GEN_192 : rf_14; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_228 = io_lsu_respValid ? _GEN_193 : rf_15; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_229 = io_lsu_respValid ? _GEN_194 : rf_16; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_230 = io_lsu_respValid ? _GEN_195 : rf_17; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_231 = io_lsu_respValid ? _GEN_196 : rf_18; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_232 = io_lsu_respValid ? _GEN_197 : rf_19; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_233 = io_lsu_respValid ? _GEN_198 : rf_20; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_234 = io_lsu_respValid ? _GEN_199 : rf_21; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_235 = io_lsu_respValid ? _GEN_200 : rf_22; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_236 = io_lsu_respValid ? _GEN_201 : rf_23; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_237 = io_lsu_respValid ? _GEN_202 : rf_24; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_238 = io_lsu_respValid ? _GEN_203 : rf_25; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_239 = io_lsu_respValid ? _GEN_204 : rf_26; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_240 = io_lsu_respValid ? _GEN_205 : rf_27; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_241 = io_lsu_respValid ? _GEN_206 : rf_28; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_242 = io_lsu_respValid ? _GEN_207 : rf_29; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_243 = io_lsu_respValid ? _GEN_208 : rf_30; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_244 = io_lsu_respValid ? _GEN_209 : rf_31; // @[scala/ysyx/RegisterFile.scala 201:30 95:19]
  wire  _GEN_245 = io_lsu_respValid ? 1'h0 : load_wen_buf; // @[scala/ysyx/RegisterFile.scala 201:30 210:22 98:35]
  wire  _GEN_248 = _T_5 ? 1'h0 : _GEN_210; // @[scala/ysyx/RegisterFile.scala 111:27 197:35]
  wire [31:0] _GEN_249 = _T_5 ? 32'h0 : _GEN_211; // @[scala/ysyx/RegisterFile.scala 112:27 197:35]
  wire [31:0] _GEN_250 = _T_5 ? 32'h0 : _GEN_212; // @[scala/ysyx/RegisterFile.scala 113:27 197:35]
  wire [31:0] _GEN_251 = _T_5 ? rf_0 : _GEN_213; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_252 = _T_5 ? rf_1 : _GEN_214; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_253 = _T_5 ? rf_2 : _GEN_215; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_254 = _T_5 ? rf_3 : _GEN_216; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_255 = _T_5 ? rf_4 : _GEN_217; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_256 = _T_5 ? rf_5 : _GEN_218; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_257 = _T_5 ? rf_6 : _GEN_219; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_258 = _T_5 ? rf_7 : _GEN_220; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_259 = _T_5 ? rf_8 : _GEN_221; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_260 = _T_5 ? rf_9 : _GEN_222; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_261 = _T_5 ? rf_10 : _GEN_223; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_262 = _T_5 ? rf_11 : _GEN_224; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_263 = _T_5 ? rf_12 : _GEN_225; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_264 = _T_5 ? rf_13 : _GEN_226; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_265 = _T_5 ? rf_14 : _GEN_227; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_266 = _T_5 ? rf_15 : _GEN_228; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_267 = _T_5 ? rf_16 : _GEN_229; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_268 = _T_5 ? rf_17 : _GEN_230; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_269 = _T_5 ? rf_18 : _GEN_231; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_270 = _T_5 ? rf_19 : _GEN_232; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_271 = _T_5 ? rf_20 : _GEN_233; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_272 = _T_5 ? rf_21 : _GEN_234; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_273 = _T_5 ? rf_22 : _GEN_235; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_274 = _T_5 ? rf_23 : _GEN_236; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_275 = _T_5 ? rf_24 : _GEN_237; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_276 = _T_5 ? rf_25 : _GEN_238; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_277 = _T_5 ? rf_26 : _GEN_239; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_278 = _T_5 ? rf_27 : _GEN_240; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_279 = _T_5 ? rf_28 : _GEN_241; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_280 = _T_5 ? rf_29 : _GEN_242; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_281 = _T_5 ? rf_30 : _GEN_243; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_282 = _T_5 ? rf_31 : _GEN_244; // @[scala/ysyx/RegisterFile.scala 197:35 95:19]
  wire  _GEN_283 = _T_5 ? load_wen_buf : _GEN_245; // @[scala/ysyx/RegisterFile.scala 197:35 98:35]
  wire [7:0] _GEN_284 = load_wen_buf ? _GEN_135 : wb_resp_ready_cnt; // @[scala/ysyx/RegisterFile.scala 196:27 101:35]
  wire  _GEN_285 = load_wen_buf & _GEN_136; // @[scala/ysyx/RegisterFile.scala 134:19 196:27]
  wire  _GEN_286 = load_wen_buf & _GEN_248; // @[scala/ysyx/RegisterFile.scala 111:27 196:27]
  wire [31:0] _GEN_287 = load_wen_buf ? _GEN_249 : 32'h0; // @[scala/ysyx/RegisterFile.scala 112:27 196:27]
  wire [31:0] _GEN_288 = load_wen_buf ? _GEN_250 : 32'h0; // @[scala/ysyx/RegisterFile.scala 113:27 196:27]
  wire [31:0] _GEN_289 = load_wen_buf ? _GEN_251 : rf_0; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_290 = load_wen_buf ? _GEN_252 : rf_1; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_291 = load_wen_buf ? _GEN_253 : rf_2; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_292 = load_wen_buf ? _GEN_254 : rf_3; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_293 = load_wen_buf ? _GEN_255 : rf_4; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_294 = load_wen_buf ? _GEN_256 : rf_5; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_295 = load_wen_buf ? _GEN_257 : rf_6; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_296 = load_wen_buf ? _GEN_258 : rf_7; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_297 = load_wen_buf ? _GEN_259 : rf_8; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_298 = load_wen_buf ? _GEN_260 : rf_9; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_299 = load_wen_buf ? _GEN_261 : rf_10; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_300 = load_wen_buf ? _GEN_262 : rf_11; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_301 = load_wen_buf ? _GEN_263 : rf_12; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_302 = load_wen_buf ? _GEN_264 : rf_13; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_303 = load_wen_buf ? _GEN_265 : rf_14; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_304 = load_wen_buf ? _GEN_266 : rf_15; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_305 = load_wen_buf ? _GEN_267 : rf_16; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_306 = load_wen_buf ? _GEN_268 : rf_17; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_307 = load_wen_buf ? _GEN_269 : rf_18; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_308 = load_wen_buf ? _GEN_270 : rf_19; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_309 = load_wen_buf ? _GEN_271 : rf_20; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_310 = load_wen_buf ? _GEN_272 : rf_21; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_311 = load_wen_buf ? _GEN_273 : rf_22; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_312 = load_wen_buf ? _GEN_274 : rf_23; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_313 = load_wen_buf ? _GEN_275 : rf_24; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_314 = load_wen_buf ? _GEN_276 : rf_25; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_315 = load_wen_buf ? _GEN_277 : rf_26; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_316 = load_wen_buf ? _GEN_278 : rf_27; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_317 = load_wen_buf ? _GEN_279 : rf_28; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_318 = load_wen_buf ? _GEN_280 : rf_29; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_319 = load_wen_buf ? _GEN_281 : rf_30; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_320 = load_wen_buf ? _GEN_282 : rf_31; // @[scala/ysyx/RegisterFile.scala 196:27 95:19]
  wire  _GEN_321 = load_wen_buf ? _GEN_283 : load_wen_buf; // @[scala/ysyx/RegisterFile.scala 196:27 98:35]
  wire  _GEN_322 = is_store_latch ? _GEN_139 : store_req_accepted; // @[scala/ysyx/RegisterFile.scala 173:29 100:35]
  wire [7:0] _GEN_323 = is_store_latch ? _GEN_140 : _GEN_284; // @[scala/ysyx/RegisterFile.scala 173:29]
  wire  _GEN_324 = is_store_latch ? _GEN_141 : _GEN_285; // @[scala/ysyx/RegisterFile.scala 173:29]
  wire  _GEN_325 = is_store_latch ? _GEN_142 : is_store_latch; // @[scala/ysyx/RegisterFile.scala 173:29 99:35]
  wire  _GEN_326 = is_store_latch ? 1'h0 : _GEN_286; // @[scala/ysyx/RegisterFile.scala 111:27 173:29]
  wire [31:0] _GEN_327 = is_store_latch ? 32'h0 : _GEN_287; // @[scala/ysyx/RegisterFile.scala 112:27 173:29]
  wire [31:0] _GEN_328 = is_store_latch ? 32'h0 : _GEN_288; // @[scala/ysyx/RegisterFile.scala 113:27 173:29]
  wire [31:0] _GEN_329 = is_store_latch ? rf_0 : _GEN_289; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_330 = is_store_latch ? rf_1 : _GEN_290; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_331 = is_store_latch ? rf_2 : _GEN_291; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_332 = is_store_latch ? rf_3 : _GEN_292; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_333 = is_store_latch ? rf_4 : _GEN_293; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_334 = is_store_latch ? rf_5 : _GEN_294; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_335 = is_store_latch ? rf_6 : _GEN_295; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_336 = is_store_latch ? rf_7 : _GEN_296; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_337 = is_store_latch ? rf_8 : _GEN_297; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_338 = is_store_latch ? rf_9 : _GEN_298; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_339 = is_store_latch ? rf_10 : _GEN_299; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_340 = is_store_latch ? rf_11 : _GEN_300; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_341 = is_store_latch ? rf_12 : _GEN_301; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_342 = is_store_latch ? rf_13 : _GEN_302; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_343 = is_store_latch ? rf_14 : _GEN_303; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_344 = is_store_latch ? rf_15 : _GEN_304; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_345 = is_store_latch ? rf_16 : _GEN_305; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_346 = is_store_latch ? rf_17 : _GEN_306; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_347 = is_store_latch ? rf_18 : _GEN_307; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_348 = is_store_latch ? rf_19 : _GEN_308; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_349 = is_store_latch ? rf_20 : _GEN_309; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_350 = is_store_latch ? rf_21 : _GEN_310; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_351 = is_store_latch ? rf_22 : _GEN_311; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_352 = is_store_latch ? rf_23 : _GEN_312; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_353 = is_store_latch ? rf_24 : _GEN_313; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_354 = is_store_latch ? rf_25 : _GEN_314; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_355 = is_store_latch ? rf_26 : _GEN_315; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_356 = is_store_latch ? rf_27 : _GEN_316; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_357 = is_store_latch ? rf_28 : _GEN_317; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_358 = is_store_latch ? rf_29 : _GEN_318; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_359 = is_store_latch ? rf_30 : _GEN_319; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_360 = is_store_latch ? rf_31 : _GEN_320; // @[scala/ysyx/RegisterFile.scala 173:29 95:19]
  wire  _GEN_361 = is_store_latch ? load_wen_buf : _GEN_321; // @[scala/ysyx/RegisterFile.scala 173:29 98:35]
  wire  _GEN_362 = io_is_store | _GEN_325; // @[scala/ysyx/RegisterFile.scala 165:26 166:24]
  wire  _GEN_363 = io_is_store ? 1'h0 : _GEN_322; // @[scala/ysyx/RegisterFile.scala 165:26 167:24]
  wire [7:0] _GEN_364 = io_is_store ? _wb_resp_ready_cnt_T_1 : _GEN_323; // @[scala/ysyx/RegisterFile.scala 165:26 168:24]
  wire  _GEN_365 = io_is_store ? 1'h0 : _GEN_324; // @[scala/ysyx/RegisterFile.scala 134:19 165:26]
  wire  _GEN_366 = io_is_store ? 1'h0 : _GEN_326; // @[scala/ysyx/RegisterFile.scala 165:26 111:27]
  wire [31:0] _GEN_367 = io_is_store ? 32'h0 : _GEN_327; // @[scala/ysyx/RegisterFile.scala 165:26 112:27]
  wire [31:0] _GEN_368 = io_is_store ? 32'h0 : _GEN_328; // @[scala/ysyx/RegisterFile.scala 165:26 113:27]
  wire [31:0] _GEN_369 = io_is_store ? rf_0 : _GEN_329; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_370 = io_is_store ? rf_1 : _GEN_330; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_371 = io_is_store ? rf_2 : _GEN_331; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_372 = io_is_store ? rf_3 : _GEN_332; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_373 = io_is_store ? rf_4 : _GEN_333; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_374 = io_is_store ? rf_5 : _GEN_334; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_375 = io_is_store ? rf_6 : _GEN_335; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_376 = io_is_store ? rf_7 : _GEN_336; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_377 = io_is_store ? rf_8 : _GEN_337; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_378 = io_is_store ? rf_9 : _GEN_338; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_379 = io_is_store ? rf_10 : _GEN_339; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_380 = io_is_store ? rf_11 : _GEN_340; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_381 = io_is_store ? rf_12 : _GEN_341; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_382 = io_is_store ? rf_13 : _GEN_342; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_383 = io_is_store ? rf_14 : _GEN_343; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_384 = io_is_store ? rf_15 : _GEN_344; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_385 = io_is_store ? rf_16 : _GEN_345; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_386 = io_is_store ? rf_17 : _GEN_346; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_387 = io_is_store ? rf_18 : _GEN_347; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_388 = io_is_store ? rf_19 : _GEN_348; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_389 = io_is_store ? rf_20 : _GEN_349; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_390 = io_is_store ? rf_21 : _GEN_350; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_391 = io_is_store ? rf_22 : _GEN_351; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_392 = io_is_store ? rf_23 : _GEN_352; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_393 = io_is_store ? rf_24 : _GEN_353; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_394 = io_is_store ? rf_25 : _GEN_354; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_395 = io_is_store ? rf_26 : _GEN_355; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_396 = io_is_store ? rf_27 : _GEN_356; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_397 = io_is_store ? rf_28 : _GEN_357; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_398 = io_is_store ? rf_29 : _GEN_358; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_399 = io_is_store ? rf_30 : _GEN_359; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_400 = io_is_store ? rf_31 : _GEN_360; // @[scala/ysyx/RegisterFile.scala 165:26 95:19]
  wire  _GEN_401 = io_is_store ? load_wen_buf : _GEN_361; // @[scala/ysyx/RegisterFile.scala 165:26 98:35]
  wire  _GEN_403 = io_wen & io_is_load | _GEN_401; // @[scala/ysyx/RegisterFile.scala 157:35 159:23]
  wire  _GEN_407 = io_wen & io_is_load ? 1'h0 : _GEN_365; // @[scala/ysyx/RegisterFile.scala 134:19 157:35]
  wire  _GEN_408 = io_wen & io_is_load ? 1'h0 : _GEN_366; // @[scala/ysyx/RegisterFile.scala 111:27 157:35]
  wire [31:0] _GEN_409 = io_wen & io_is_load ? 32'h0 : _GEN_367; // @[scala/ysyx/RegisterFile.scala 112:27 157:35]
  wire [31:0] _GEN_410 = io_wen & io_is_load ? 32'h0 : _GEN_368; // @[scala/ysyx/RegisterFile.scala 113:27 157:35]
  wire  _GEN_443 = io_is_branch | _GEN_407; // @[scala/ysyx/RegisterFile.scala 151:27 152:15]
  wire  _GEN_450 = io_is_branch ? 1'h0 : _GEN_408; // @[scala/ysyx/RegisterFile.scala 111:27 151:27]
  wire [31:0] _GEN_451 = io_is_branch ? 32'h0 : _GEN_409; // @[scala/ysyx/RegisterFile.scala 112:27 151:27]
  wire [31:0] _GEN_452 = io_is_branch ? 32'h0 : _GEN_410; // @[scala/ysyx/RegisterFile.scala 113:27 151:27]
  wire  _GEN_520 = io_wen & ~io_is_load | _GEN_443; // @[scala/ysyx/RegisterFile.scala 139:31 146:15]
  reg_write_commit_wrapper regWriteCommit ( // @[scala/ysyx/RegisterFile.scala 109:30]
    .clk(regWriteCommit_clk),
    .en(regWriteCommit_en),
    .addr(regWriteCommit_addr),
    .wdata(regWriteCommit_wdata)
  );
  get_reg_info_wrapper getRegInfo ( // @[scala/ysyx/RegisterFile.scala 118:26]
    .clk(getRegInfo_clk),
    .rf_flat(getRegInfo_rf_flat)
  );
  assign io_rdata1 = io_raddr1 == 5'h0 ? 32'h0 : _GEN_31; // @[scala/ysyx/RegisterFile.scala 125:19]
  assign io_rdata2 = io_raddr2 == 5'h0 ? 32'h0 : _GEN_63; // @[scala/ysyx/RegisterFile.scala 126:19]
  assign io_wb_done = wbDoneReg; // @[scala/ysyx/RegisterFile.scala 218:20]
  assign io_lsu_respReady = lsuRespReadyReg; // @[scala/ysyx/RegisterFile.scala 219:20]
  assign regWriteCommit_clk = clock; // @[scala/ysyx/RegisterFile.scala 110:27]
  assign regWriteCommit_en = io_wen & ~io_is_load ? _T_2 : _GEN_450; // @[scala/ysyx/RegisterFile.scala 139:31]
  assign regWriteCommit_addr = io_wen & ~io_is_load ? _GEN_97 : _GEN_451; // @[scala/ysyx/RegisterFile.scala 139:31]
  assign regWriteCommit_wdata = io_wen & ~io_is_load ? _GEN_98 : _GEN_452; // @[scala/ysyx/RegisterFile.scala 139:31]
  assign getRegInfo_clk = clock; // @[scala/ysyx/RegisterFile.scala 119:25]
  assign getRegInfo_rf_flat = {getRegInfo_io_rf_flat_hi,getRegInfo_io_rf_flat_lo}; // @[scala/ysyx/RegisterFile.scala 120:31]
  always @(posedge clock) begin
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_0 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'h0 == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_0 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_0 <= _GEN_369;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_1 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'h1 == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_1 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_1 <= _GEN_370;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_2 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'h2 == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_2 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_2 <= _GEN_371;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_3 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'h3 == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_3 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_3 <= _GEN_372;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_4 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'h4 == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_4 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_4 <= _GEN_373;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_5 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'h5 == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_5 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_5 <= _GEN_374;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_6 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'h6 == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_6 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_6 <= _GEN_375;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_7 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'h7 == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_7 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_7 <= _GEN_376;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_8 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'h8 == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_8 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_8 <= _GEN_377;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_9 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'h9 == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_9 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_9 <= _GEN_378;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_10 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'ha == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_10 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_10 <= _GEN_379;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_11 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'hb == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_11 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_11 <= _GEN_380;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_12 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'hc == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_12 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_12 <= _GEN_381;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_13 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'hd == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_13 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_13 <= _GEN_382;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_14 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'he == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_14 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_14 <= _GEN_383;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_15 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'hf == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_15 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_15 <= _GEN_384;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_16 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'h10 == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_16 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_16 <= _GEN_385;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_17 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'h11 == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_17 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_17 <= _GEN_386;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_18 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'h12 == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_18 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_18 <= _GEN_387;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_19 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'h13 == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_19 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_19 <= _GEN_388;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_20 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'h14 == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_20 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_20 <= _GEN_389;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_21 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'h15 == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_21 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_21 <= _GEN_390;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_22 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'h16 == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_22 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_22 <= _GEN_391;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_23 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'h17 == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_23 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_23 <= _GEN_392;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_24 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'h18 == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_24 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_24 <= _GEN_393;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_25 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'h19 == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_25 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_25 <= _GEN_394;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_26 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'h1a == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_26 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_26 <= _GEN_395;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_27 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'h1b == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_27 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_27 <= _GEN_396;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_28 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'h1c == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_28 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_28 <= _GEN_397;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_29 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'h1d == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_29 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_29 <= _GEN_398;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_30 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'h1e == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_30 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_30 <= _GEN_399;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 95:19]
      rf_31 <= 32'h0; // @[scala/ysyx/RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[scala/ysyx/RegisterFile.scala 140:28]
        if (5'h1f == io_waddr) begin // @[scala/ysyx/RegisterFile.scala 144:20]
          rf_31 <= io_wdata; // @[scala/ysyx/RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
        rf_31 <= _GEN_400;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 97:35]
      load_waddr_buf <= 5'h0; // @[scala/ysyx/RegisterFile.scala 97:35]
    end else if (!(io_wen & ~io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
        if (io_wen & io_is_load) begin // @[scala/ysyx/RegisterFile.scala 157:35]
          load_waddr_buf <= io_waddr; // @[scala/ysyx/RegisterFile.scala 158:23]
        end
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 98:35]
      load_wen_buf <= 1'h0; // @[scala/ysyx/RegisterFile.scala 98:35]
    end else if (!(io_wen & ~io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
        load_wen_buf <= _GEN_403;
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 99:35]
      is_store_latch <= 1'h0; // @[scala/ysyx/RegisterFile.scala 99:35]
    end else if (!(io_wen & ~io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
        if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
          is_store_latch <= _GEN_362;
        end
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 100:35]
      store_req_accepted <= 1'h0; // @[scala/ysyx/RegisterFile.scala 100:35]
    end else if (!(io_wen & ~io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
        if (!(io_wen & io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 157:35]
          store_req_accepted <= _GEN_363;
        end
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 101:35]
      wb_resp_ready_cnt <= 8'h0; // @[scala/ysyx/RegisterFile.scala 101:35]
    end else if (!(io_wen & ~io_is_load)) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      if (!(io_is_branch)) begin // @[scala/ysyx/RegisterFile.scala 151:27]
        if (io_wen & io_is_load) begin // @[scala/ysyx/RegisterFile.scala 157:35]
          wb_resp_ready_cnt <= _wb_resp_ready_cnt_T_1; // @[scala/ysyx/RegisterFile.scala 160:23]
        end else begin
          wb_resp_ready_cnt <= _GEN_364;
        end
      end
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 103:32]
      wbDoneReg <= 1'h0; // @[scala/ysyx/RegisterFile.scala 103:32]
    end else begin
      wbDoneReg <= _GEN_520;
    end
    if (reset) begin // @[scala/ysyx/RegisterFile.scala 104:32]
      lsuRespReadyReg <= 1'h0; // @[scala/ysyx/RegisterFile.scala 104:32]
    end else if (io_wen & ~io_is_load) begin // @[scala/ysyx/RegisterFile.scala 139:31]
      lsuRespReadyReg <= 1'h0; // @[scala/ysyx/RegisterFile.scala 134:19]
    end else if (io_is_branch) begin // @[scala/ysyx/RegisterFile.scala 151:27]
      lsuRespReadyReg <= 1'h0; // @[scala/ysyx/RegisterFile.scala 134:19]
    end else if (io_wen & io_is_load) begin // @[scala/ysyx/RegisterFile.scala 157:35]
      lsuRespReadyReg <= 1'h0; // @[scala/ysyx/RegisterFile.scala 134:19]
    end else begin
      lsuRespReadyReg <= _GEN_365;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  rf_0 = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  rf_1 = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  rf_2 = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  rf_3 = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  rf_4 = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  rf_5 = _RAND_5[31:0];
  _RAND_6 = {1{`RANDOM}};
  rf_6 = _RAND_6[31:0];
  _RAND_7 = {1{`RANDOM}};
  rf_7 = _RAND_7[31:0];
  _RAND_8 = {1{`RANDOM}};
  rf_8 = _RAND_8[31:0];
  _RAND_9 = {1{`RANDOM}};
  rf_9 = _RAND_9[31:0];
  _RAND_10 = {1{`RANDOM}};
  rf_10 = _RAND_10[31:0];
  _RAND_11 = {1{`RANDOM}};
  rf_11 = _RAND_11[31:0];
  _RAND_12 = {1{`RANDOM}};
  rf_12 = _RAND_12[31:0];
  _RAND_13 = {1{`RANDOM}};
  rf_13 = _RAND_13[31:0];
  _RAND_14 = {1{`RANDOM}};
  rf_14 = _RAND_14[31:0];
  _RAND_15 = {1{`RANDOM}};
  rf_15 = _RAND_15[31:0];
  _RAND_16 = {1{`RANDOM}};
  rf_16 = _RAND_16[31:0];
  _RAND_17 = {1{`RANDOM}};
  rf_17 = _RAND_17[31:0];
  _RAND_18 = {1{`RANDOM}};
  rf_18 = _RAND_18[31:0];
  _RAND_19 = {1{`RANDOM}};
  rf_19 = _RAND_19[31:0];
  _RAND_20 = {1{`RANDOM}};
  rf_20 = _RAND_20[31:0];
  _RAND_21 = {1{`RANDOM}};
  rf_21 = _RAND_21[31:0];
  _RAND_22 = {1{`RANDOM}};
  rf_22 = _RAND_22[31:0];
  _RAND_23 = {1{`RANDOM}};
  rf_23 = _RAND_23[31:0];
  _RAND_24 = {1{`RANDOM}};
  rf_24 = _RAND_24[31:0];
  _RAND_25 = {1{`RANDOM}};
  rf_25 = _RAND_25[31:0];
  _RAND_26 = {1{`RANDOM}};
  rf_26 = _RAND_26[31:0];
  _RAND_27 = {1{`RANDOM}};
  rf_27 = _RAND_27[31:0];
  _RAND_28 = {1{`RANDOM}};
  rf_28 = _RAND_28[31:0];
  _RAND_29 = {1{`RANDOM}};
  rf_29 = _RAND_29[31:0];
  _RAND_30 = {1{`RANDOM}};
  rf_30 = _RAND_30[31:0];
  _RAND_31 = {1{`RANDOM}};
  rf_31 = _RAND_31[31:0];
  _RAND_32 = {1{`RANDOM}};
  load_waddr_buf = _RAND_32[4:0];
  _RAND_33 = {1{`RANDOM}};
  load_wen_buf = _RAND_33[0:0];
  _RAND_34 = {1{`RANDOM}};
  is_store_latch = _RAND_34[0:0];
  _RAND_35 = {1{`RANDOM}};
  store_req_accepted = _RAND_35[0:0];
  _RAND_36 = {1{`RANDOM}};
  wb_resp_ready_cnt = _RAND_36[7:0];
  _RAND_37 = {1{`RANDOM}};
  wbDoneReg = _RAND_37[0:0];
  _RAND_38 = {1{`RANDOM}};
  lsuRespReadyReg = _RAND_38[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_22040080_cpu(
  input         clock,
  input         reset,
  input         io_interrupt, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input         io_master_awready, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output        io_master_awvalid, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output [31:0] io_master_awaddr, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output [3:0]  io_master_awid, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output [7:0]  io_master_awlen, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output [2:0]  io_master_awsize, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output [1:0]  io_master_awburst, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input         io_master_wready, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output        io_master_wvalid, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output [31:0] io_master_wdata, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output [3:0]  io_master_wstrb, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output        io_master_wlast, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output        io_master_bready, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input         io_master_bvalid, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input  [1:0]  io_master_bresp, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input  [3:0]  io_master_bid, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input         io_master_arready, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output        io_master_arvalid, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output [31:0] io_master_araddr, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output [3:0]  io_master_arid, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output [7:0]  io_master_arlen, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output [2:0]  io_master_arsize, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output [1:0]  io_master_arburst, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output        io_master_rready, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input         io_master_rvalid, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input  [1:0]  io_master_rresp, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input  [31:0] io_master_rdata, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input         io_master_rlast, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input  [3:0]  io_master_rid, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output        io_slave_awready, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input         io_slave_awvalid, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input  [31:0] io_slave_awaddr, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input  [3:0]  io_slave_awid, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input  [7:0]  io_slave_awlen, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input  [2:0]  io_slave_awsize, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input  [1:0]  io_slave_awburst, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output        io_slave_wready, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input         io_slave_wvalid, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input  [31:0] io_slave_wdata, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input  [3:0]  io_slave_wstrb, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input         io_slave_wlast, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input         io_slave_bready, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output        io_slave_bvalid, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output [1:0]  io_slave_bresp, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output [3:0]  io_slave_bid, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output        io_slave_arready, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input         io_slave_arvalid, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input  [31:0] io_slave_araddr, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input  [3:0]  io_slave_arid, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input  [7:0]  io_slave_arlen, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input  [2:0]  io_slave_arsize, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input  [1:0]  io_slave_arburst, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  input         io_slave_rready, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output        io_slave_rvalid, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output [1:0]  io_slave_rresp, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output [31:0] io_slave_rdata, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output        io_slave_rlast, // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
  output [3:0]  io_slave_rid // @[scala/ysyx/ysyx_22040080_cpu.scala 17:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
`endif // RANDOMIZE_REG_INIT
  wire  gpc_clock; // @[scala/ysyx/ysyx_22040080_cpu.scala 102:25]
  wire  gpc_reset; // @[scala/ysyx/ysyx_22040080_cpu.scala 102:25]
  wire [31:0] gpc_io_pc; // @[scala/ysyx/ysyx_22040080_cpu.scala 102:25]
  wire  gpc_io_is_jal; // @[scala/ysyx/ysyx_22040080_cpu.scala 102:25]
  wire  gpc_io_is_jalr; // @[scala/ysyx/ysyx_22040080_cpu.scala 102:25]
  wire  gpc_io_branch_taken; // @[scala/ysyx/ysyx_22040080_cpu.scala 102:25]
  wire [31:0] gpc_io_jal_target; // @[scala/ysyx/ysyx_22040080_cpu.scala 102:25]
  wire [31:0] gpc_io_next_pc; // @[scala/ysyx/ysyx_22040080_cpu.scala 102:25]
  wire  pc_mod_clock; // @[scala/ysyx/ysyx_22040080_cpu.scala 103:25]
  wire  pc_mod_reset; // @[scala/ysyx/ysyx_22040080_cpu.scala 103:25]
  wire  pc_mod_io_trap_valid; // @[scala/ysyx/ysyx_22040080_cpu.scala 103:25]
  wire  pc_mod_io_access_fault; // @[scala/ysyx/ysyx_22040080_cpu.scala 103:25]
  wire  pc_mod_io_is_mret; // @[scala/ysyx/ysyx_22040080_cpu.scala 103:25]
  wire [31:0] pc_mod_io_mtvec; // @[scala/ysyx/ysyx_22040080_cpu.scala 103:25]
  wire [31:0] pc_mod_io_mepc; // @[scala/ysyx/ysyx_22040080_cpu.scala 103:25]
  wire [31:0] pc_mod_io_pc; // @[scala/ysyx/ysyx_22040080_cpu.scala 103:25]
  wire  pc_mod_io_pc_valid; // @[scala/ysyx/ysyx_22040080_cpu.scala 103:25]
  wire [31:0] pc_mod_io_next_pc; // @[scala/ysyx/ysyx_22040080_cpu.scala 103:25]
  wire  pc_mod_io_pc_update_en; // @[scala/ysyx/ysyx_22040080_cpu.scala 103:25]
  wire  ifu_clock; // @[scala/ysyx/ysyx_22040080_cpu.scala 104:25]
  wire  ifu_reset; // @[scala/ysyx/ysyx_22040080_cpu.scala 104:25]
  wire [31:0] ifu_io_pc; // @[scala/ysyx/ysyx_22040080_cpu.scala 104:25]
  wire  ifu_io_pc_valid; // @[scala/ysyx/ysyx_22040080_cpu.scala 104:25]
  wire [31:0] ifu_io_araddr; // @[scala/ysyx/ysyx_22040080_cpu.scala 104:25]
  wire  ifu_io_arvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 104:25]
  wire  ifu_io_arready; // @[scala/ysyx/ysyx_22040080_cpu.scala 104:25]
  wire  ifu_io_rvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 104:25]
  wire  ifu_io_rready; // @[scala/ysyx/ysyx_22040080_cpu.scala 104:25]
  wire  ifu_io_access_fault; // @[scala/ysyx/ysyx_22040080_cpu.scala 104:25]
  wire  arbiter_clock; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire  arbiter_reset; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire [31:0] arbiter_io_ifu_araddr; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire  arbiter_io_ifu_arvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire  arbiter_io_ifu_arready; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire [31:0] arbiter_io_ifu_rdata; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire  arbiter_io_ifu_rvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire  arbiter_io_ifu_rready; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire [31:0] arbiter_io_lsu_araddr; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire  arbiter_io_lsu_arvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire  arbiter_io_lsu_arready; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire [31:0] arbiter_io_lsu_rdata; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire  arbiter_io_lsu_rvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire  arbiter_io_lsu_rready; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire [31:0] arbiter_io_lsu_awaddr; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire  arbiter_io_lsu_awvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire  arbiter_io_lsu_awready; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire [31:0] arbiter_io_lsu_wdata; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire  arbiter_io_lsu_wvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire  arbiter_io_lsu_wready; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire  arbiter_io_lsu_bvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire  arbiter_io_lsu_bready; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire [2:0] arbiter_io_lsu_func3; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire  arbiter_io_m_awvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire  arbiter_io_m_awready; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire [31:0] arbiter_io_m_awaddr; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire [2:0] arbiter_io_m_awsize; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire  arbiter_io_m_wvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire  arbiter_io_m_wready; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire [31:0] arbiter_io_m_wdata; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire [3:0] arbiter_io_m_wstrb; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire  arbiter_io_m_bvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire  arbiter_io_m_bready; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire  arbiter_io_m_arvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire  arbiter_io_m_arready; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire [31:0] arbiter_io_m_araddr; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire [2:0] arbiter_io_m_arsize; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire  arbiter_io_m_rvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire  arbiter_io_m_rready; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire [31:0] arbiter_io_m_rdata; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire  arbiter_io_inst_active; // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
  wire  clint_mod_clock; // @[scala/ysyx/ysyx_22040080_cpu.scala 106:25]
  wire  clint_mod_reset; // @[scala/ysyx/ysyx_22040080_cpu.scala 106:25]
  wire [31:0] clint_mod_io_araddr; // @[scala/ysyx/ysyx_22040080_cpu.scala 106:25]
  wire  clint_mod_io_arvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 106:25]
  wire  clint_mod_io_arready; // @[scala/ysyx/ysyx_22040080_cpu.scala 106:25]
  wire [31:0] clint_mod_io_rdata; // @[scala/ysyx/ysyx_22040080_cpu.scala 106:25]
  wire  clint_mod_io_rvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 106:25]
  wire  clint_mod_io_rready; // @[scala/ysyx/ysyx_22040080_cpu.scala 106:25]
  wire  clint_mod_io_awvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 106:25]
  wire  clint_mod_io_awready; // @[scala/ysyx/ysyx_22040080_cpu.scala 106:25]
  wire  clint_mod_io_wvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 106:25]
  wire  clint_mod_io_wready; // @[scala/ysyx/ysyx_22040080_cpu.scala 106:25]
  wire  clint_mod_io_bvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 106:25]
  wire  clint_mod_io_bready; // @[scala/ysyx/ysyx_22040080_cpu.scala 106:25]
  wire  csr_clock; // @[scala/ysyx/ysyx_22040080_cpu.scala 107:25]
  wire  csr_reset; // @[scala/ysyx/ysyx_22040080_cpu.scala 107:25]
  wire  csr_io_wen; // @[scala/ysyx/ysyx_22040080_cpu.scala 107:25]
  wire [11:0] csr_io_csr_addr; // @[scala/ysyx/ysyx_22040080_cpu.scala 107:25]
  wire [31:0] csr_io_rdata; // @[scala/ysyx/ysyx_22040080_cpu.scala 107:25]
  wire [31:0] csr_io_wdata; // @[scala/ysyx/ysyx_22040080_cpu.scala 107:25]
  wire [31:0] csr_io_mepc; // @[scala/ysyx/ysyx_22040080_cpu.scala 107:25]
  wire [31:0] csr_io_mtvec; // @[scala/ysyx/ysyx_22040080_cpu.scala 107:25]
  wire  csr_io_trap_valid; // @[scala/ysyx/ysyx_22040080_cpu.scala 107:25]
  wire [31:0] csr_io_trap_mepc; // @[scala/ysyx/ysyx_22040080_cpu.scala 107:25]
  wire [31:0] csr_io_trap_mcause; // @[scala/ysyx/ysyx_22040080_cpu.scala 107:25]
  wire  lsu_clock; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire  lsu_reset; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire [31:0] lsu_io_mem_addr; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire [31:0] lsu_io_mem_wdata; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire [2:0] lsu_io_func3; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire  lsu_io_is_load; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire  lsu_io_is_store; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire [31:0] lsu_io_load_data; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire [2:0] lsu_io_lsu_func3; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire  lsu_io_lsu_reqValid; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire  lsu_io_lsu_reqReady; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire  lsu_io_lsu_respValid; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire  lsu_io_lsu_respReady; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire [31:0] lsu_io_araddr; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire  lsu_io_arvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire  lsu_io_arready; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire [31:0] lsu_io_rdata; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire  lsu_io_rvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire  lsu_io_rready; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire [31:0] lsu_io_awaddr; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire  lsu_io_awvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire  lsu_io_awready; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire [31:0] lsu_io_wdata; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire  lsu_io_wvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire  lsu_io_wready; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire  lsu_io_bvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire  lsu_io_bready; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire  lsu_io_access_fault; // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
  wire [31:0] idu_io_rdata; // @[scala/ysyx/ysyx_22040080_cpu.scala 109:25]
  wire  idu_io_inst_active; // @[scala/ysyx/ysyx_22040080_cpu.scala 109:25]
  wire [4:0] idu_io_rs1; // @[scala/ysyx/ysyx_22040080_cpu.scala 109:25]
  wire [4:0] idu_io_rs2; // @[scala/ysyx/ysyx_22040080_cpu.scala 109:25]
  wire [4:0] idu_io_rd; // @[scala/ysyx/ysyx_22040080_cpu.scala 109:25]
  wire [2:0] idu_io_func3; // @[scala/ysyx/ysyx_22040080_cpu.scala 109:25]
  wire [31:0] idu_io_imm_ext; // @[scala/ysyx/ysyx_22040080_cpu.scala 109:25]
  wire [6:0] idu_io_op; // @[scala/ysyx/ysyx_22040080_cpu.scala 109:25]
  wire [6:0] idu_io_func7; // @[scala/ysyx/ysyx_22040080_cpu.scala 109:25]
  wire [4:0] idu_io_shamt; // @[scala/ysyx/ysyx_22040080_cpu.scala 109:25]
  wire [11:0] idu_io_csr_addr; // @[scala/ysyx/ysyx_22040080_cpu.scala 109:25]
  wire  idu_io_is_jal; // @[scala/ysyx/ysyx_22040080_cpu.scala 109:25]
  wire  idu_io_is_jalr; // @[scala/ysyx/ysyx_22040080_cpu.scala 109:25]
  wire  idu_io_is_branch; // @[scala/ysyx/ysyx_22040080_cpu.scala 109:25]
  wire  idu_io_is_load; // @[scala/ysyx/ysyx_22040080_cpu.scala 109:25]
  wire  idu_io_is_store; // @[scala/ysyx/ysyx_22040080_cpu.scala 109:25]
  wire  idu_io_lsu_reqValid; // @[scala/ysyx/ysyx_22040080_cpu.scala 109:25]
  wire [31:0] alu_io_rs1_data; // @[scala/ysyx/ysyx_22040080_cpu.scala 110:25]
  wire [31:0] alu_io_rs2_data; // @[scala/ysyx/ysyx_22040080_cpu.scala 110:25]
  wire [31:0] alu_io_imm_ext; // @[scala/ysyx/ysyx_22040080_cpu.scala 110:25]
  wire [2:0] alu_io_func3; // @[scala/ysyx/ysyx_22040080_cpu.scala 110:25]
  wire [6:0] alu_io_func7; // @[scala/ysyx/ysyx_22040080_cpu.scala 110:25]
  wire [6:0] alu_io_op; // @[scala/ysyx/ysyx_22040080_cpu.scala 110:25]
  wire [31:0] alu_io_pc; // @[scala/ysyx/ysyx_22040080_cpu.scala 110:25]
  wire [4:0] alu_io_shamt; // @[scala/ysyx/ysyx_22040080_cpu.scala 110:25]
  wire  alu_io_inst_active; // @[scala/ysyx/ysyx_22040080_cpu.scala 110:25]
  wire [31:0] alu_io_result; // @[scala/ysyx/ysyx_22040080_cpu.scala 110:25]
  wire  alu_io_wen; // @[scala/ysyx/ysyx_22040080_cpu.scala 110:25]
  wire  alu_io_branch_taken; // @[scala/ysyx/ysyx_22040080_cpu.scala 110:25]
  wire [31:0] alu_io_jal_target; // @[scala/ysyx/ysyx_22040080_cpu.scala 110:25]
  wire [31:0] alu_io_mem_addr; // @[scala/ysyx/ysyx_22040080_cpu.scala 110:25]
  wire [31:0] alu_io_mem_wdata; // @[scala/ysyx/ysyx_22040080_cpu.scala 110:25]
  wire [31:0] alu_io_csr_rdata; // @[scala/ysyx/ysyx_22040080_cpu.scala 110:25]
  wire  alu_io_csr_wen; // @[scala/ysyx/ysyx_22040080_cpu.scala 110:25]
  wire [31:0] alu_io_csr_wdata; // @[scala/ysyx/ysyx_22040080_cpu.scala 110:25]
  wire  alu_io_trap_valid; // @[scala/ysyx/ysyx_22040080_cpu.scala 110:25]
  wire  alu_io_is_mret; // @[scala/ysyx/ysyx_22040080_cpu.scala 110:25]
  wire [31:0] alu_io_trap_mepc; // @[scala/ysyx/ysyx_22040080_cpu.scala 110:25]
  wire [31:0] alu_io_trap_mcause; // @[scala/ysyx/ysyx_22040080_cpu.scala 110:25]
  wire  regfile_clock; // @[scala/ysyx/ysyx_22040080_cpu.scala 111:25]
  wire  regfile_reset; // @[scala/ysyx/ysyx_22040080_cpu.scala 111:25]
  wire  regfile_io_wen; // @[scala/ysyx/ysyx_22040080_cpu.scala 111:25]
  wire [4:0] regfile_io_raddr1; // @[scala/ysyx/ysyx_22040080_cpu.scala 111:25]
  wire [4:0] regfile_io_raddr2; // @[scala/ysyx/ysyx_22040080_cpu.scala 111:25]
  wire [4:0] regfile_io_waddr; // @[scala/ysyx/ysyx_22040080_cpu.scala 111:25]
  wire [31:0] regfile_io_wdata; // @[scala/ysyx/ysyx_22040080_cpu.scala 111:25]
  wire [31:0] regfile_io_rdata1; // @[scala/ysyx/ysyx_22040080_cpu.scala 111:25]
  wire [31:0] regfile_io_rdata2; // @[scala/ysyx/ysyx_22040080_cpu.scala 111:25]
  wire  regfile_io_wb_done; // @[scala/ysyx/ysyx_22040080_cpu.scala 111:25]
  wire  regfile_io_is_branch; // @[scala/ysyx/ysyx_22040080_cpu.scala 111:25]
  wire  regfile_io_is_load; // @[scala/ysyx/ysyx_22040080_cpu.scala 111:25]
  wire  regfile_io_is_store; // @[scala/ysyx/ysyx_22040080_cpu.scala 111:25]
  wire [31:0] regfile_io_load_data; // @[scala/ysyx/ysyx_22040080_cpu.scala 111:25]
  wire  regfile_io_lsu_reqReady; // @[scala/ysyx/ysyx_22040080_cpu.scala 111:25]
  wire  regfile_io_lsu_respValid; // @[scala/ysyx/ysyx_22040080_cpu.scala 111:25]
  wire  regfile_io_lsu_respReady; // @[scala/ysyx/ysyx_22040080_cpu.scala 111:25]
  reg  accessFaultLatched; // @[scala/ysyx/ysyx_22040080_cpu.scala 116:35]
  reg  readToClint; // @[scala/ysyx/ysyx_22040080_cpu.scala 190:29]
  reg  readRouted; // @[scala/ysyx/ysyx_22040080_cpu.scala 191:29]
  reg  writeToClint; // @[scala/ysyx/ysyx_22040080_cpu.scala 194:29]
  reg  writeRouted; // @[scala/ysyx/ysyx_22040080_cpu.scala 195:29]
  wire [31:0] _arClint_T = arbiter_io_m_araddr & 32'hffff0000; // @[scala/ysyx/ysyx_22040080_cpu.scala 187:45]
  wire  arClint = _arClint_T == 32'h2000000; // @[scala/ysyx/ysyx_22040080_cpu.scala 187:59]
  wire  _GEN_0 = clint_mod_io_arready | readToClint; // @[scala/ysyx/ysyx_22040080_cpu.scala 241:34 242:21 190:29]
  wire  _GEN_1 = clint_mod_io_arready | readRouted; // @[scala/ysyx/ysyx_22040080_cpu.scala 241:34 243:21 191:29]
  wire  _GEN_3 = io_master_arready | readRouted; // @[scala/ysyx/ysyx_22040080_cpu.scala 251:31 253:21 191:29]
  wire [31:0] _GEN_4 = arClint ? arbiter_io_m_araddr : 32'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 237:19 198:24 238:28]
  wire  _GEN_6 = arClint ? clint_mod_io_arready : io_master_arready; // @[scala/ysyx/ysyx_22040080_cpu.scala 237:19 240:28 250:28]
  wire  _GEN_8 = arClint ? _GEN_1 : _GEN_3; // @[scala/ysyx/ysyx_22040080_cpu.scala 237:19]
  wire  _GEN_9 = arClint ? 1'h0 : 1'h1; // @[scala/ysyx/ysyx_22040080_cpu.scala 237:19 208:21 246:28]
  wire [31:0] _GEN_10 = arClint ? 32'h0 : arbiter_io_m_araddr; // @[scala/ysyx/ysyx_22040080_cpu.scala 237:19 209:21 247:28]
  wire  _GEN_17 = ~readRouted & arbiter_io_m_arvalid ? _GEN_8 : readRouted; // @[scala/ysyx/ysyx_22040080_cpu.scala 191:29 236:45]
  wire [31:0] _GEN_24 = readRouted & ~readToClint ? io_master_rdata : 32'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 274:43 275:25 285:25]
  wire  _GEN_25 = readRouted & ~readToClint & io_master_rvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 274:43 276:25 286:25]
  wire  _GEN_29 = readRouted & ~readToClint & arbiter_io_m_rready; // @[scala/ysyx/ysyx_22040080_cpu.scala 214:21 274:43 280:25]
  wire [31:0] _awClint_T = arbiter_io_m_awaddr & 32'hffff0000; // @[scala/ysyx/ysyx_22040080_cpu.scala 187:45]
  wire  awClint = _awClint_T == 32'h2000000; // @[scala/ysyx/ysyx_22040080_cpu.scala 187:59]
  wire  _GEN_39 = clint_mod_io_awready | writeToClint; // @[scala/ysyx/ysyx_22040080_cpu.scala 304:34 305:22 194:29]
  wire  _GEN_40 = clint_mod_io_awready | writeRouted; // @[scala/ysyx/ysyx_22040080_cpu.scala 304:34 306:22 195:29]
  wire  _GEN_42 = io_master_awready | writeRouted; // @[scala/ysyx/ysyx_22040080_cpu.scala 314:31 316:22 195:29]
  wire  _GEN_45 = awClint ? clint_mod_io_awready : io_master_awready; // @[scala/ysyx/ysyx_22040080_cpu.scala 300:19 303:28 313:28]
  wire  _GEN_47 = awClint ? _GEN_40 : _GEN_42; // @[scala/ysyx/ysyx_22040080_cpu.scala 300:19]
  wire  _GEN_48 = awClint ? 1'h0 : 1'h1; // @[scala/ysyx/ysyx_22040080_cpu.scala 300:19 216:21 309:28]
  wire [31:0] _GEN_49 = awClint ? 32'h0 : arbiter_io_m_awaddr; // @[scala/ysyx/ysyx_22040080_cpu.scala 300:19 217:21 310:28]
  wire  _GEN_56 = ~writeRouted & arbiter_io_m_awvalid ? _GEN_47 : writeRouted; // @[scala/ysyx/ysyx_22040080_cpu.scala 195:29 299:46]
  wire [31:0] _GEN_63 = writeRouted & ~writeToClint ? arbiter_io_m_wdata : 32'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 223:21 338:45 339:26]
  wire  _GEN_64 = writeRouted & ~writeToClint & arbiter_io_m_wvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 222:21 338:45 340:26]
  wire [3:0] _GEN_65 = arbiter_io_m_wstrb; // @[scala/ysyx/ysyx_22040080_cpu.scala 224:21 338:45 341:26]
  wire  _GEN_67 = writeRouted & ~writeToClint & io_master_wready; // @[scala/ysyx/ysyx_22040080_cpu.scala 338:45 343:26 352:26]
  wire  _GEN_68 = writeRouted & ~writeToClint & io_master_bvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 338:45 344:26 353:26]
  wire  _GEN_71 = writeRouted & ~writeToClint & arbiter_io_m_bready; // @[scala/ysyx/ysyx_22040080_cpu.scala 226:21 338:45 347:26]
  wire  _busReadFault_T_3 = _GEN_25 & arbiter_io_m_rready; // @[scala/ysyx/ysyx_22040080_cpu.scala 381:39]
  wire  _busReadFault_T_4 = io_master_rresp != 2'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 383:39]
  wire  busReadFault = _busReadFault_T_3 & _busReadFault_T_4; // @[scala/ysyx/ysyx_22040080_cpu.scala 382:42]
  wire  _busWriteFault_T_3 = _GEN_68 & arbiter_io_m_bready; // @[scala/ysyx/ysyx_22040080_cpu.scala 387:40]
  wire  _busWriteFault_T_4 = io_master_bresp != 2'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 389:40]
  wire  busWriteFault = _busWriteFault_T_3 & _busWriteFault_T_4; // @[scala/ysyx/ysyx_22040080_cpu.scala 388:43]
  wire  accessFaultNow = ifu_io_access_fault | lsu_io_access_fault | busReadFault | busWriteFault; // @[scala/ysyx/ysyx_22040080_cpu.scala 391:83]
  wire  _GEN_86 = accessFaultLatched ? 1'h0 : accessFaultLatched; // @[scala/ysyx/ysyx_22040080_cpu.scala 395:35 397:24 116:35]
  wire  _GEN_87 = accessFaultNow | _GEN_86; // @[scala/ysyx/ysyx_22040080_cpu.scala 393:24 394:24]
  generate_next_pc gpc ( // @[scala/ysyx/ysyx_22040080_cpu.scala 102:25]
    .clock(gpc_clock),
    .reset(gpc_reset),
    .io_pc(gpc_io_pc),
    .io_is_jal(gpc_io_is_jal),
    .io_is_jalr(gpc_io_is_jalr),
    .io_branch_taken(gpc_io_branch_taken),
    .io_jal_target(gpc_io_jal_target),
    .io_next_pc(gpc_io_next_pc)
  );
  ysyx_22040080_pc pc_mod ( // @[scala/ysyx/ysyx_22040080_cpu.scala 103:25]
    .clock(pc_mod_clock),
    .reset(pc_mod_reset),
    .io_trap_valid(pc_mod_io_trap_valid),
    .io_access_fault(pc_mod_io_access_fault),
    .io_is_mret(pc_mod_io_is_mret),
    .io_mtvec(pc_mod_io_mtvec),
    .io_mepc(pc_mod_io_mepc),
    .io_pc(pc_mod_io_pc),
    .io_pc_valid(pc_mod_io_pc_valid),
    .io_next_pc(pc_mod_io_next_pc),
    .io_pc_update_en(pc_mod_io_pc_update_en)
  );
  ysyx_22040080_ifu ifu ( // @[scala/ysyx/ysyx_22040080_cpu.scala 104:25]
    .clock(ifu_clock),
    .reset(ifu_reset),
    .io_pc(ifu_io_pc),
    .io_pc_valid(ifu_io_pc_valid),
    .io_araddr(ifu_io_araddr),
    .io_arvalid(ifu_io_arvalid),
    .io_arready(ifu_io_arready),
    .io_rvalid(ifu_io_rvalid),
    .io_rready(ifu_io_rready),
    .io_access_fault(ifu_io_access_fault)
  );
  ysyx_22040080_axi_arbiter arbiter ( // @[scala/ysyx/ysyx_22040080_cpu.scala 105:25]
    .clock(arbiter_clock),
    .reset(arbiter_reset),
    .io_ifu_araddr(arbiter_io_ifu_araddr),
    .io_ifu_arvalid(arbiter_io_ifu_arvalid),
    .io_ifu_arready(arbiter_io_ifu_arready),
    .io_ifu_rdata(arbiter_io_ifu_rdata),
    .io_ifu_rvalid(arbiter_io_ifu_rvalid),
    .io_ifu_rready(arbiter_io_ifu_rready),
    .io_lsu_araddr(arbiter_io_lsu_araddr),
    .io_lsu_arvalid(arbiter_io_lsu_arvalid),
    .io_lsu_arready(arbiter_io_lsu_arready),
    .io_lsu_rdata(arbiter_io_lsu_rdata),
    .io_lsu_rvalid(arbiter_io_lsu_rvalid),
    .io_lsu_rready(arbiter_io_lsu_rready),
    .io_lsu_awaddr(arbiter_io_lsu_awaddr),
    .io_lsu_awvalid(arbiter_io_lsu_awvalid),
    .io_lsu_awready(arbiter_io_lsu_awready),
    .io_lsu_wdata(arbiter_io_lsu_wdata),
    .io_lsu_wvalid(arbiter_io_lsu_wvalid),
    .io_lsu_wready(arbiter_io_lsu_wready),
    .io_lsu_bvalid(arbiter_io_lsu_bvalid),
    .io_lsu_bready(arbiter_io_lsu_bready),
    .io_lsu_func3(arbiter_io_lsu_func3),
    .io_m_awvalid(arbiter_io_m_awvalid),
    .io_m_awready(arbiter_io_m_awready),
    .io_m_awaddr(arbiter_io_m_awaddr),
    .io_m_awsize(arbiter_io_m_awsize),
    .io_m_wvalid(arbiter_io_m_wvalid),
    .io_m_wready(arbiter_io_m_wready),
    .io_m_wdata(arbiter_io_m_wdata),
    .io_m_wstrb(arbiter_io_m_wstrb),
    .io_m_bvalid(arbiter_io_m_bvalid),
    .io_m_bready(arbiter_io_m_bready),
    .io_m_arvalid(arbiter_io_m_arvalid),
    .io_m_arready(arbiter_io_m_arready),
    .io_m_araddr(arbiter_io_m_araddr),
    .io_m_arsize(arbiter_io_m_arsize),
    .io_m_rvalid(arbiter_io_m_rvalid),
    .io_m_rready(arbiter_io_m_rready),
    .io_m_rdata(arbiter_io_m_rdata),
    .io_inst_active(arbiter_io_inst_active)
  );
  ysyx_22040080_clint_axi clint_mod ( // @[scala/ysyx/ysyx_22040080_cpu.scala 106:25]
    .clock(clint_mod_clock),
    .reset(clint_mod_reset),
    .io_araddr(clint_mod_io_araddr),
    .io_arvalid(clint_mod_io_arvalid),
    .io_arready(clint_mod_io_arready),
    .io_rdata(clint_mod_io_rdata),
    .io_rvalid(clint_mod_io_rvalid),
    .io_rready(clint_mod_io_rready),
    .io_awvalid(clint_mod_io_awvalid),
    .io_awready(clint_mod_io_awready),
    .io_wvalid(clint_mod_io_wvalid),
    .io_wready(clint_mod_io_wready),
    .io_bvalid(clint_mod_io_bvalid),
    .io_bready(clint_mod_io_bready)
  );
  ysyx_22040080_csr csr ( // @[scala/ysyx/ysyx_22040080_cpu.scala 107:25]
    .clock(csr_clock),
    .reset(csr_reset),
    .io_wen(csr_io_wen),
    .io_csr_addr(csr_io_csr_addr),
    .io_rdata(csr_io_rdata),
    .io_wdata(csr_io_wdata),
    .io_mepc(csr_io_mepc),
    .io_mtvec(csr_io_mtvec),
    .io_trap_valid(csr_io_trap_valid),
    .io_trap_mepc(csr_io_trap_mepc),
    .io_trap_mcause(csr_io_trap_mcause)
  );
  ysyx_22040080_lsu lsu ( // @[scala/ysyx/ysyx_22040080_cpu.scala 108:25]
    .clock(lsu_clock),
    .reset(lsu_reset),
    .io_mem_addr(lsu_io_mem_addr),
    .io_mem_wdata(lsu_io_mem_wdata),
    .io_func3(lsu_io_func3),
    .io_is_load(lsu_io_is_load),
    .io_is_store(lsu_io_is_store),
    .io_load_data(lsu_io_load_data),
    .io_lsu_func3(lsu_io_lsu_func3),
    .io_lsu_reqValid(lsu_io_lsu_reqValid),
    .io_lsu_reqReady(lsu_io_lsu_reqReady),
    .io_lsu_respValid(lsu_io_lsu_respValid),
    .io_lsu_respReady(lsu_io_lsu_respReady),
    .io_araddr(lsu_io_araddr),
    .io_arvalid(lsu_io_arvalid),
    .io_arready(lsu_io_arready),
    .io_rdata(lsu_io_rdata),
    .io_rvalid(lsu_io_rvalid),
    .io_rready(lsu_io_rready),
    .io_awaddr(lsu_io_awaddr),
    .io_awvalid(lsu_io_awvalid),
    .io_awready(lsu_io_awready),
    .io_wdata(lsu_io_wdata),
    .io_wvalid(lsu_io_wvalid),
    .io_wready(lsu_io_wready),
    .io_bvalid(lsu_io_bvalid),
    .io_bready(lsu_io_bready),
    .io_access_fault(lsu_io_access_fault)
  );
  ysyx_22040080_idu idu ( // @[scala/ysyx/ysyx_22040080_cpu.scala 109:25]
    .io_rdata(idu_io_rdata),
    .io_inst_active(idu_io_inst_active),
    .io_rs1(idu_io_rs1),
    .io_rs2(idu_io_rs2),
    .io_rd(idu_io_rd),
    .io_func3(idu_io_func3),
    .io_imm_ext(idu_io_imm_ext),
    .io_op(idu_io_op),
    .io_func7(idu_io_func7),
    .io_shamt(idu_io_shamt),
    .io_csr_addr(idu_io_csr_addr),
    .io_is_jal(idu_io_is_jal),
    .io_is_jalr(idu_io_is_jalr),
    .io_is_branch(idu_io_is_branch),
    .io_is_load(idu_io_is_load),
    .io_is_store(idu_io_is_store),
    .io_lsu_reqValid(idu_io_lsu_reqValid)
  );
  ysyx_22040080_alu alu ( // @[scala/ysyx/ysyx_22040080_cpu.scala 110:25]
    .io_rs1_data(alu_io_rs1_data),
    .io_rs2_data(alu_io_rs2_data),
    .io_imm_ext(alu_io_imm_ext),
    .io_func3(alu_io_func3),
    .io_func7(alu_io_func7),
    .io_op(alu_io_op),
    .io_pc(alu_io_pc),
    .io_shamt(alu_io_shamt),
    .io_inst_active(alu_io_inst_active),
    .io_result(alu_io_result),
    .io_wen(alu_io_wen),
    .io_branch_taken(alu_io_branch_taken),
    .io_jal_target(alu_io_jal_target),
    .io_mem_addr(alu_io_mem_addr),
    .io_mem_wdata(alu_io_mem_wdata),
    .io_csr_rdata(alu_io_csr_rdata),
    .io_csr_wen(alu_io_csr_wen),
    .io_csr_wdata(alu_io_csr_wdata),
    .io_trap_valid(alu_io_trap_valid),
    .io_is_mret(alu_io_is_mret),
    .io_trap_mepc(alu_io_trap_mepc),
    .io_trap_mcause(alu_io_trap_mcause)
  );
  RegisterFile regfile ( // @[scala/ysyx/ysyx_22040080_cpu.scala 111:25]
    .clock(regfile_clock),
    .reset(regfile_reset),
    .io_wen(regfile_io_wen),
    .io_raddr1(regfile_io_raddr1),
    .io_raddr2(regfile_io_raddr2),
    .io_waddr(regfile_io_waddr),
    .io_wdata(regfile_io_wdata),
    .io_rdata1(regfile_io_rdata1),
    .io_rdata2(regfile_io_rdata2),
    .io_wb_done(regfile_io_wb_done),
    .io_is_branch(regfile_io_is_branch),
    .io_is_load(regfile_io_is_load),
    .io_is_store(regfile_io_is_store),
    .io_load_data(regfile_io_load_data),
    .io_lsu_reqReady(regfile_io_lsu_reqReady),
    .io_lsu_respValid(regfile_io_lsu_respValid),
    .io_lsu_respReady(regfile_io_lsu_respReady)
  );
  assign io_master_awvalid = ~writeRouted & arbiter_io_m_awvalid & _GEN_48; // @[scala/ysyx/ysyx_22040080_cpu.scala 216:21 299:46]
  assign io_master_awaddr = ~writeRouted & arbiter_io_m_awvalid ? _GEN_49 : 32'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 217:21 299:46]
  assign io_master_awid = 4'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 218:21 299:46]
  assign io_master_awlen = 8'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 219:21 299:46]
  assign io_master_awsize = arbiter_io_m_awsize; // @[scala/ysyx/ysyx_22040080_cpu.scala 220:21]
  assign io_master_awburst = 2'h1; // @[scala/ysyx/ysyx_22040080_cpu.scala 221:21]
  assign io_master_wvalid = writeRouted & writeToClint ? 1'h0 : _GEN_64; // @[scala/ysyx/ysyx_22040080_cpu.scala 222:21 327:37]
  assign io_master_wdata = writeRouted & writeToClint ? 32'h0 : _GEN_63; // @[scala/ysyx/ysyx_22040080_cpu.scala 223:21 327:37]
  assign io_master_wstrb = writeRouted & writeToClint ? arbiter_io_m_wstrb : _GEN_65; // @[scala/ysyx/ysyx_22040080_cpu.scala 224:21 327:37]
  assign io_master_wlast = 1'h1; // @[scala/ysyx/ysyx_22040080_cpu.scala 225:21 327:37]
  assign io_master_bready = writeRouted & writeToClint ? 1'h0 : _GEN_71; // @[scala/ysyx/ysyx_22040080_cpu.scala 226:21 327:37]
  assign io_master_arvalid = ~readRouted & arbiter_io_m_arvalid & _GEN_9; // @[scala/ysyx/ysyx_22040080_cpu.scala 208:21 236:45]
  assign io_master_araddr = ~readRouted & arbiter_io_m_arvalid ? _GEN_10 : 32'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 209:21 236:45]
  assign io_master_arid = 4'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 210:21 236:45]
  assign io_master_arlen = 8'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 211:21 236:45]
  assign io_master_arsize = arbiter_io_m_arsize; // @[scala/ysyx/ysyx_22040080_cpu.scala 212:21]
  assign io_master_arburst = 2'h1; // @[scala/ysyx/ysyx_22040080_cpu.scala 213:21]
  assign io_master_rready = readRouted & readToClint ? 1'h0 : _GEN_29; // @[scala/ysyx/ysyx_22040080_cpu.scala 214:21 264:35]
  assign io_slave_awready = 1'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 362:20]
  assign io_slave_wready = 1'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 363:20]
  assign io_slave_bvalid = 1'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 364:20]
  assign io_slave_bresp = 2'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 365:20]
  assign io_slave_bid = 4'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 366:20]
  assign io_slave_arready = 1'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 367:20]
  assign io_slave_rvalid = 1'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 368:20]
  assign io_slave_rresp = 2'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 369:20]
  assign io_slave_rdata = 32'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 370:20]
  assign io_slave_rlast = 1'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 371:20]
  assign io_slave_rid = 4'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 372:20]
  assign gpc_clock = clock;
  assign gpc_reset = reset;
  assign gpc_io_pc = pc_mod_io_pc; // @[scala/ysyx/ysyx_22040080_cpu.scala 122:23]
  assign gpc_io_is_jal = idu_io_is_jal; // @[scala/ysyx/ysyx_22040080_cpu.scala 123:23]
  assign gpc_io_is_jalr = idu_io_is_jalr; // @[scala/ysyx/ysyx_22040080_cpu.scala 124:23]
  assign gpc_io_branch_taken = alu_io_branch_taken; // @[scala/ysyx/ysyx_22040080_cpu.scala 125:23]
  assign gpc_io_jal_target = alu_io_jal_target; // @[scala/ysyx/ysyx_22040080_cpu.scala 126:23]
  assign pc_mod_clock = clock;
  assign pc_mod_reset = reset;
  assign pc_mod_io_trap_valid = alu_io_trap_valid; // @[scala/ysyx/ysyx_22040080_cpu.scala 131:26]
  assign pc_mod_io_access_fault = accessFaultLatched; // @[scala/ysyx/ysyx_22040080_cpu.scala 132:26]
  assign pc_mod_io_is_mret = alu_io_is_mret; // @[scala/ysyx/ysyx_22040080_cpu.scala 133:26]
  assign pc_mod_io_mtvec = csr_io_mtvec; // @[scala/ysyx/ysyx_22040080_cpu.scala 134:26]
  assign pc_mod_io_mepc = csr_io_mepc; // @[scala/ysyx/ysyx_22040080_cpu.scala 135:26]
  assign pc_mod_io_next_pc = gpc_io_next_pc; // @[scala/ysyx/ysyx_22040080_cpu.scala 136:26]
  assign pc_mod_io_pc_update_en = regfile_io_wb_done | accessFaultLatched; // @[scala/ysyx/ysyx_22040080_cpu.scala 117:41]
  assign ifu_clock = clock;
  assign ifu_reset = reset;
  assign ifu_io_pc = pc_mod_io_pc; // @[scala/ysyx/ysyx_22040080_cpu.scala 142:23]
  assign ifu_io_pc_valid = pc_mod_io_pc_valid; // @[scala/ysyx/ysyx_22040080_cpu.scala 144:23]
  assign ifu_io_arready = arbiter_io_ifu_arready; // @[scala/ysyx/ysyx_22040080_cpu.scala 151:26]
  assign ifu_io_rvalid = arbiter_io_ifu_rvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 153:26]
  assign arbiter_clock = clock;
  assign arbiter_reset = reset;
  assign arbiter_io_ifu_araddr = ifu_io_araddr; // @[scala/ysyx/ysyx_22040080_cpu.scala 149:26]
  assign arbiter_io_ifu_arvalid = ifu_io_arvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 150:26]
  assign arbiter_io_ifu_rready = ifu_io_rready; // @[scala/ysyx/ysyx_22040080_cpu.scala 154:26]
  assign arbiter_io_lsu_araddr = lsu_io_araddr; // @[scala/ysyx/ysyx_22040080_cpu.scala 159:26]
  assign arbiter_io_lsu_arvalid = lsu_io_arvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 160:26]
  assign arbiter_io_lsu_rready = lsu_io_rready; // @[scala/ysyx/ysyx_22040080_cpu.scala 164:26]
  assign arbiter_io_lsu_awaddr = lsu_io_awaddr; // @[scala/ysyx/ysyx_22040080_cpu.scala 169:26]
  assign arbiter_io_lsu_awvalid = lsu_io_awvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 170:26]
  assign arbiter_io_lsu_wdata = lsu_io_wdata; // @[scala/ysyx/ysyx_22040080_cpu.scala 172:26]
  assign arbiter_io_lsu_wvalid = lsu_io_wvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 173:26]
  assign arbiter_io_lsu_bready = lsu_io_bready; // @[scala/ysyx/ysyx_22040080_cpu.scala 176:26]
  assign arbiter_io_lsu_func3 = lsu_io_lsu_func3; // @[scala/ysyx/ysyx_22040080_cpu.scala 178:26]
  assign arbiter_io_m_awready = ~writeRouted & arbiter_io_m_awvalid & _GEN_45; // @[scala/ysyx/ysyx_22040080_cpu.scala 293:24 299:46]
  assign arbiter_io_m_wready = writeRouted & writeToClint ? clint_mod_io_wready : _GEN_67; // @[scala/ysyx/ysyx_22040080_cpu.scala 327:37 330:26]
  assign arbiter_io_m_bvalid = writeRouted & writeToClint ? clint_mod_io_bvalid : _GEN_68; // @[scala/ysyx/ysyx_22040080_cpu.scala 327:37 331:26]
  assign arbiter_io_m_arready = ~readRouted & arbiter_io_m_arvalid & _GEN_6; // @[scala/ysyx/ysyx_22040080_cpu.scala 229:24 236:45]
  assign arbiter_io_m_rvalid = readRouted & readToClint ? clint_mod_io_rvalid : _GEN_25; // @[scala/ysyx/ysyx_22040080_cpu.scala 264:35 266:25]
  assign arbiter_io_m_rdata = readRouted & readToClint ? clint_mod_io_rdata : _GEN_24; // @[scala/ysyx/ysyx_22040080_cpu.scala 264:35 265:25]
  assign clint_mod_clock = clock;
  assign clint_mod_reset = reset;
  assign clint_mod_io_araddr = ~readRouted & arbiter_io_m_arvalid ? _GEN_4 : 32'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 198:24 236:45]
  assign clint_mod_io_arvalid = ~readRouted & arbiter_io_m_arvalid & arClint; // @[scala/ysyx/ysyx_22040080_cpu.scala 199:24 236:45]
  assign clint_mod_io_rready = readRouted & readToClint & arbiter_io_m_rready; // @[scala/ysyx/ysyx_22040080_cpu.scala 200:24 264:35 270:25]
  assign clint_mod_io_awvalid = ~writeRouted & arbiter_io_m_awvalid & awClint; // @[scala/ysyx/ysyx_22040080_cpu.scala 202:24 299:46]
  assign clint_mod_io_wvalid = writeRouted & writeToClint & arbiter_io_m_wvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 204:24 327:37 329:26]
  assign clint_mod_io_bready = writeRouted & writeToClint & arbiter_io_m_bready; // @[scala/ysyx/ysyx_22040080_cpu.scala 205:24 327:37 334:26]
  assign csr_clock = clock;
  assign csr_reset = reset;
  assign csr_io_wen = alu_io_csr_wen; // @[scala/ysyx/ysyx_22040080_cpu.scala 423:22]
  assign csr_io_csr_addr = idu_io_csr_addr; // @[scala/ysyx/ysyx_22040080_cpu.scala 424:22]
  assign csr_io_wdata = alu_io_csr_wdata; // @[scala/ysyx/ysyx_22040080_cpu.scala 425:22]
  assign csr_io_trap_valid = alu_io_trap_valid; // @[scala/ysyx/ysyx_22040080_cpu.scala 426:22]
  assign csr_io_trap_mepc = alu_io_trap_mepc; // @[scala/ysyx/ysyx_22040080_cpu.scala 427:22]
  assign csr_io_trap_mcause = alu_io_trap_mcause; // @[scala/ysyx/ysyx_22040080_cpu.scala 428:22]
  assign lsu_clock = clock;
  assign lsu_reset = reset;
  assign lsu_io_mem_addr = alu_io_mem_addr; // @[scala/ysyx/ysyx_22040080_cpu.scala 433:24]
  assign lsu_io_mem_wdata = alu_io_mem_wdata; // @[scala/ysyx/ysyx_22040080_cpu.scala 434:24]
  assign lsu_io_func3 = idu_io_func3; // @[scala/ysyx/ysyx_22040080_cpu.scala 435:24]
  assign lsu_io_is_load = idu_io_is_load; // @[scala/ysyx/ysyx_22040080_cpu.scala 436:24]
  assign lsu_io_is_store = idu_io_is_store; // @[scala/ysyx/ysyx_22040080_cpu.scala 437:24]
  assign lsu_io_lsu_reqValid = idu_io_lsu_reqValid; // @[scala/ysyx/ysyx_22040080_cpu.scala 439:24]
  assign lsu_io_lsu_respReady = regfile_io_lsu_respReady; // @[scala/ysyx/ysyx_22040080_cpu.scala 440:24]
  assign lsu_io_arready = arbiter_io_lsu_arready; // @[scala/ysyx/ysyx_22040080_cpu.scala 161:26]
  assign lsu_io_rdata = arbiter_io_lsu_rdata; // @[scala/ysyx/ysyx_22040080_cpu.scala 162:26]
  assign lsu_io_rvalid = arbiter_io_lsu_rvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 163:26]
  assign lsu_io_awready = arbiter_io_lsu_awready; // @[scala/ysyx/ysyx_22040080_cpu.scala 171:26]
  assign lsu_io_wready = arbiter_io_lsu_wready; // @[scala/ysyx/ysyx_22040080_cpu.scala 174:26]
  assign lsu_io_bvalid = arbiter_io_lsu_bvalid; // @[scala/ysyx/ysyx_22040080_cpu.scala 175:26]
  assign idu_io_rdata = arbiter_io_ifu_rdata; // @[scala/ysyx/ysyx_22040080_cpu.scala 403:22]
  assign idu_io_inst_active = arbiter_io_inst_active; // @[scala/ysyx/ysyx_22040080_cpu.scala 404:22]
  assign alu_io_rs1_data = regfile_io_rdata1; // @[scala/ysyx/ysyx_22040080_cpu.scala 409:22]
  assign alu_io_rs2_data = regfile_io_rdata2; // @[scala/ysyx/ysyx_22040080_cpu.scala 410:22]
  assign alu_io_imm_ext = idu_io_imm_ext; // @[scala/ysyx/ysyx_22040080_cpu.scala 411:22]
  assign alu_io_func3 = idu_io_func3; // @[scala/ysyx/ysyx_22040080_cpu.scala 412:22]
  assign alu_io_func7 = idu_io_func7; // @[scala/ysyx/ysyx_22040080_cpu.scala 413:22]
  assign alu_io_op = idu_io_op; // @[scala/ysyx/ysyx_22040080_cpu.scala 414:22]
  assign alu_io_pc = pc_mod_io_pc; // @[scala/ysyx/ysyx_22040080_cpu.scala 415:22]
  assign alu_io_shamt = idu_io_shamt; // @[scala/ysyx/ysyx_22040080_cpu.scala 416:22]
  assign alu_io_inst_active = arbiter_io_inst_active; // @[scala/ysyx/ysyx_22040080_cpu.scala 417:22]
  assign alu_io_csr_rdata = csr_io_rdata; // @[scala/ysyx/ysyx_22040080_cpu.scala 418:22]
  assign regfile_clock = clock;
  assign regfile_reset = reset;
  assign regfile_io_wen = alu_io_wen; // @[scala/ysyx/ysyx_22040080_cpu.scala 445:28]
  assign regfile_io_raddr1 = idu_io_rs1; // @[scala/ysyx/ysyx_22040080_cpu.scala 446:28]
  assign regfile_io_raddr2 = idu_io_rs2; // @[scala/ysyx/ysyx_22040080_cpu.scala 447:28]
  assign regfile_io_waddr = idu_io_rd; // @[scala/ysyx/ysyx_22040080_cpu.scala 448:28]
  assign regfile_io_wdata = alu_io_result; // @[scala/ysyx/ysyx_22040080_cpu.scala 449:28]
  assign regfile_io_is_branch = idu_io_is_branch; // @[scala/ysyx/ysyx_22040080_cpu.scala 450:28]
  assign regfile_io_is_load = idu_io_is_load; // @[scala/ysyx/ysyx_22040080_cpu.scala 451:28]
  assign regfile_io_is_store = idu_io_is_store; // @[scala/ysyx/ysyx_22040080_cpu.scala 452:28]
  assign regfile_io_load_data = lsu_io_load_data; // @[scala/ysyx/ysyx_22040080_cpu.scala 453:28]
  assign regfile_io_lsu_reqReady = lsu_io_lsu_reqReady; // @[scala/ysyx/ysyx_22040080_cpu.scala 454:28]
  assign regfile_io_lsu_respValid = lsu_io_lsu_respValid; // @[scala/ysyx/ysyx_22040080_cpu.scala 455:28]
  always @(posedge clock) begin
    if (reset) begin // @[scala/ysyx/ysyx_22040080_cpu.scala 116:35]
      accessFaultLatched <= 1'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 116:35]
    end else begin
      accessFaultLatched <= _GEN_87;
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_cpu.scala 190:29]
      readToClint <= 1'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 190:29]
    end else if (~readRouted & arbiter_io_m_arvalid) begin // @[scala/ysyx/ysyx_22040080_cpu.scala 236:45]
      if (arClint) begin // @[scala/ysyx/ysyx_22040080_cpu.scala 237:19]
        readToClint <= _GEN_0;
      end else if (io_master_arready) begin // @[scala/ysyx/ysyx_22040080_cpu.scala 251:31]
        readToClint <= 1'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 252:21]
      end
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_cpu.scala 191:29]
      readRouted <= 1'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 191:29]
    end else if (readRouted & readToClint) begin // @[scala/ysyx/ysyx_22040080_cpu.scala 264:35]
      if (clint_mod_io_rvalid & arbiter_io_m_rready) begin // @[scala/ysyx/ysyx_22040080_cpu.scala 271:54]
        readRouted <= 1'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 272:18]
      end else begin
        readRouted <= _GEN_17;
      end
    end else if (readRouted & ~readToClint) begin // @[scala/ysyx/ysyx_22040080_cpu.scala 274:43]
      if (io_master_rvalid & arbiter_io_m_rready) begin // @[scala/ysyx/ysyx_22040080_cpu.scala 281:51]
        readRouted <= 1'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 282:18]
      end else begin
        readRouted <= _GEN_17;
      end
    end else begin
      readRouted <= _GEN_17;
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_cpu.scala 194:29]
      writeToClint <= 1'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 194:29]
    end else if (~writeRouted & arbiter_io_m_awvalid) begin // @[scala/ysyx/ysyx_22040080_cpu.scala 299:46]
      if (awClint) begin // @[scala/ysyx/ysyx_22040080_cpu.scala 300:19]
        writeToClint <= _GEN_39;
      end else if (io_master_awready) begin // @[scala/ysyx/ysyx_22040080_cpu.scala 314:31]
        writeToClint <= 1'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 315:22]
      end
    end
    if (reset) begin // @[scala/ysyx/ysyx_22040080_cpu.scala 195:29]
      writeRouted <= 1'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 195:29]
    end else if (writeRouted & writeToClint) begin // @[scala/ysyx/ysyx_22040080_cpu.scala 327:37]
      if (clint_mod_io_bvalid & arbiter_io_m_bready) begin // @[scala/ysyx/ysyx_22040080_cpu.scala 335:54]
        writeRouted <= 1'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 336:19]
      end else begin
        writeRouted <= _GEN_56;
      end
    end else if (writeRouted & ~writeToClint) begin // @[scala/ysyx/ysyx_22040080_cpu.scala 338:45]
      if (io_master_bvalid & arbiter_io_m_bready) begin // @[scala/ysyx/ysyx_22040080_cpu.scala 348:51]
        writeRouted <= 1'h0; // @[scala/ysyx/ysyx_22040080_cpu.scala 349:19]
      end else begin
        writeRouted <= _GEN_56;
      end
    end else begin
      writeRouted <= _GEN_56;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  accessFaultLatched = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  readToClint = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  readRouted = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  writeToClint = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  writeRouted = _RAND_4[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
