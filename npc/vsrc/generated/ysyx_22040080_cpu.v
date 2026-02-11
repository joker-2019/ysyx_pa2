module generate_next_pc(
  input         clock,
  input         reset,
  input  [31:0] io_pc,
  input         io_is_jal,
  input         io_is_jalr,
  input         io_branch_taken,
  input  [31:0] io_jal_target,
  output [31:0] io_next_pc
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] nextPcReg; // @[generate_next_pc.scala 16:26]
  wire [31:0] _nextPcReg_T_1 = io_pc + 32'h4; // @[generate_next_pc.scala 21:24]
  assign io_next_pc = nextPcReg; // @[generate_next_pc.scala 24:14]
  always @(posedge clock) begin
    if (reset) begin // @[generate_next_pc.scala 16:26]
      nextPcReg <= 32'h80000000; // @[generate_next_pc.scala 16:26]
    end else if (io_branch_taken | io_is_jal | io_is_jalr) begin // @[generate_next_pc.scala 18:52]
      nextPcReg <= io_jal_target; // @[generate_next_pc.scala 19:15]
    end else begin
      nextPcReg <= _nextPcReg_T_1; // @[generate_next_pc.scala 21:15]
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
  input         io_trap_valid,
  input         io_is_mret,
  input  [31:0] io_mtvec,
  input  [31:0] io_mepc,
  output [31:0] io_pc,
  output        io_pc_valid,
  input  [31:0] io_next_pc,
  input         io_pc_update_en,
  output [31:0] io_trace_pc,
  output [31:0] io_trace_instr,
  output        io_instr_done
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
`endif // RANDOMIZE_REG_INIT
  wire [31:0] pmemReader_addr; // @[ysyx_22040080_pc.scala 59:26]
  wire [31:0] pmemReader_len; // @[ysyx_22040080_pc.scala 59:26]
  wire [31:0] pmemReader_data; // @[ysyx_22040080_pc.scala 59:26]
  reg [31:0] pcReg; // @[ysyx_22040080_pc.scala 50:30]
  reg  pcValidReg; // @[ysyx_22040080_pc.scala 51:30]
  reg [31:0] tracePcReg; // @[ysyx_22040080_pc.scala 52:30]
  reg [31:0] traceInstrReg; // @[ysyx_22040080_pc.scala 53:30]
  reg  instrDoneReg; // @[ysyx_22040080_pc.scala 54:30]
  wire  _GEN_1 = io_is_mret ? pcValidReg : 1'h1; // @[ysyx_22040080_pc.scala 72:29 51:30 79:21]
  wire [31:0] _GEN_3 = io_is_mret ? pcReg : io_next_pc; // @[ysyx_22040080_pc.scala 62:22 72:29 82:26]
  wire  _GEN_5 = io_is_mret ? instrDoneReg : 1'h1; // @[ysyx_22040080_pc.scala 72:29 54:30 84:21]
  wire  _GEN_7 = io_trap_valid ? pcValidReg : _GEN_1; // @[ysyx_22040080_pc.scala 68:25 51:30]
  wire [31:0] _GEN_9 = io_trap_valid ? pcReg : _GEN_3; // @[ysyx_22040080_pc.scala 62:22 68:25]
  wire  _GEN_11 = io_trap_valid ? instrDoneReg : _GEN_5; // @[ysyx_22040080_pc.scala 68:25 54:30]
  wire  _GEN_13 = io_pc_update_en & _GEN_7; // @[ysyx_22040080_pc.scala 67:25 88:19]
  wire  _GEN_17 = io_pc_update_en & _GEN_11; // @[ysyx_22040080_pc.scala 67:25 90:19]
  pmem_read_wrapper pmemReader ( // @[ysyx_22040080_pc.scala 59:26]
    .addr(pmemReader_addr),
    .len(pmemReader_len),
    .data(pmemReader_data)
  );
  assign io_pc = pcReg; // @[ysyx_22040080_pc.scala 96:18]
  assign io_pc_valid = pcValidReg; // @[ysyx_22040080_pc.scala 97:18]
  assign io_trace_pc = tracePcReg; // @[ysyx_22040080_pc.scala 98:18]
  assign io_trace_instr = traceInstrReg; // @[ysyx_22040080_pc.scala 99:18]
  assign io_instr_done = instrDoneReg; // @[ysyx_22040080_pc.scala 100:18]
  assign pmemReader_addr = io_pc_update_en ? _GEN_9 : pcReg; // @[ysyx_22040080_pc.scala 62:22 67:25]
  assign pmemReader_len = 32'h4; // @[ysyx_22040080_pc.scala 60:21]
  always @(posedge clock) begin
    if (reset) begin // @[ysyx_22040080_pc.scala 50:30]
      pcReg <= 32'h80000000; // @[ysyx_22040080_pc.scala 50:30]
    end else if (io_pc_update_en) begin // @[ysyx_22040080_pc.scala 67:25]
      if (io_trap_valid) begin // @[ysyx_22040080_pc.scala 68:25]
        pcReg <= io_mtvec; // @[ysyx_22040080_pc.scala 70:13]
      end else if (io_is_mret) begin // @[ysyx_22040080_pc.scala 72:29]
        pcReg <= io_mepc; // @[ysyx_22040080_pc.scala 74:13]
      end else begin
        pcReg <= io_next_pc; // @[ysyx_22040080_pc.scala 78:21]
      end
    end
    if (reset) begin // @[ysyx_22040080_pc.scala 51:30]
      pcValidReg <= 1'h0; // @[ysyx_22040080_pc.scala 51:30]
    end else begin
      pcValidReg <= _GEN_13;
    end
    if (reset) begin // @[ysyx_22040080_pc.scala 52:30]
      tracePcReg <= 32'h80000000; // @[ysyx_22040080_pc.scala 52:30]
    end else if (io_pc_update_en) begin // @[ysyx_22040080_pc.scala 67:25]
      if (!(io_trap_valid)) begin // @[ysyx_22040080_pc.scala 68:25]
        if (!(io_is_mret)) begin // @[ysyx_22040080_pc.scala 72:29]
          tracePcReg <= io_next_pc; // @[ysyx_22040080_pc.scala 80:21]
        end
      end
    end
    if (reset) begin // @[ysyx_22040080_pc.scala 53:30]
      traceInstrReg <= 32'h0; // @[ysyx_22040080_pc.scala 53:30]
    end else if (io_pc_update_en) begin // @[ysyx_22040080_pc.scala 67:25]
      if (!(io_trap_valid)) begin // @[ysyx_22040080_pc.scala 68:25]
        if (!(io_is_mret)) begin // @[ysyx_22040080_pc.scala 72:29]
          traceInstrReg <= pmemReader_data; // @[ysyx_22040080_pc.scala 83:21]
        end
      end
    end else begin
      traceInstrReg <= pmemReader_data; // @[ysyx_22040080_pc.scala 89:19]
    end
    if (reset) begin // @[ysyx_22040080_pc.scala 54:30]
      instrDoneReg <= 1'h0; // @[ysyx_22040080_pc.scala 54:30]
    end else begin
      instrDoneReg <= _GEN_17;
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
  input  [31:0] io_pc,
  input         io_pc_valid,
  output [31:0] io_araddr,
  output        io_arvalid,
  input         io_arready,
  input         io_rvalid,
  output        io_rready
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
`endif // RANDOMIZE_REG_INIT
  reg  initialStart; // @[ysyx_22040080_ifu.scala 33:29]
  reg [31:0] araddrReg; // @[ysyx_22040080_ifu.scala 34:29]
  reg  arvalidReg; // @[ysyx_22040080_ifu.scala 35:29]
  reg  rreadyReg; // @[ysyx_22040080_ifu.scala 36:29]
  reg [7:0] respReadyCnt; // @[ysyx_22040080_ifu.scala 38:29]
  wire [7:0] _respReadyCnt_T_1 = 8'h3 - 8'h1; // @[ysyx_22040080_ifu.scala 51:43]
  wire  _GEN_1 = io_pc_valid | arvalidReg; // @[ysyx_22040080_ifu.scala 52:28 55:18 35:29]
  wire [7:0] _GEN_2 = io_pc_valid ? _respReadyCnt_T_1 : respReadyCnt; // @[ysyx_22040080_ifu.scala 52:28 56:18 38:29]
  wire  _GEN_3 = initialStart | _GEN_1; // @[ysyx_22040080_ifu.scala 47:22 49:18]
  wire  _GEN_4 = initialStart ? 1'h0 : initialStart; // @[ysyx_22040080_ifu.scala 47:22 50:18 33:29]
  wire [7:0] _GEN_5 = initialStart ? _respReadyCnt_T_1 : _GEN_2; // @[ysyx_22040080_ifu.scala 47:22 51:18]
  wire [7:0] _respReadyCnt_T_5 = respReadyCnt - 8'h1; // @[ysyx_22040080_ifu.scala 67:36]
  wire  _GEN_9 = respReadyCnt > 8'h0 ? 1'h0 : 1'h1; // @[ysyx_22040080_ifu.scala 66:30 68:20 70:17]
  wire  _GEN_11 = io_rvalid & _GEN_9; // @[ysyx_22040080_ifu.scala 45:13 65:19]
  assign io_araddr = araddrReg; // @[ysyx_22040080_ifu.scala 77:14]
  assign io_arvalid = arvalidReg; // @[ysyx_22040080_ifu.scala 78:14]
  assign io_rready = rreadyReg; // @[ysyx_22040080_ifu.scala 79:14]
  always @(posedge clock) begin
    initialStart <= reset | _GEN_4; // @[ysyx_22040080_ifu.scala 33:{29,29}]
    if (reset) begin // @[ysyx_22040080_ifu.scala 34:29]
      araddrReg <= 32'h80000000; // @[ysyx_22040080_ifu.scala 34:29]
    end else if (!(initialStart)) begin // @[ysyx_22040080_ifu.scala 47:22]
      if (io_pc_valid) begin // @[ysyx_22040080_ifu.scala 52:28]
        araddrReg <= io_pc; // @[ysyx_22040080_ifu.scala 54:18]
      end
    end
    if (reset) begin // @[ysyx_22040080_ifu.scala 35:29]
      arvalidReg <= 1'h0; // @[ysyx_22040080_ifu.scala 35:29]
    end else if (arvalidReg & io_arready) begin // @[ysyx_22040080_ifu.scala 60:34]
      arvalidReg <= 1'h0; // @[ysyx_22040080_ifu.scala 61:16]
    end else begin
      arvalidReg <= _GEN_3;
    end
    if (reset) begin // @[ysyx_22040080_ifu.scala 36:29]
      rreadyReg <= 1'h0; // @[ysyx_22040080_ifu.scala 36:29]
    end else begin
      rreadyReg <= _GEN_11;
    end
    if (reset) begin // @[ysyx_22040080_ifu.scala 38:29]
      respReadyCnt <= 8'h0; // @[ysyx_22040080_ifu.scala 38:29]
    end else if (io_rvalid) begin // @[ysyx_22040080_ifu.scala 65:19]
      if (respReadyCnt > 8'h0) begin // @[ysyx_22040080_ifu.scala 66:30]
        respReadyCnt <= _respReadyCnt_T_5; // @[ysyx_22040080_ifu.scala 67:20]
      end else begin
        respReadyCnt <= _GEN_5;
      end
    end else begin
      respReadyCnt <= _GEN_5;
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
  respReadyCnt = _RAND_4[7:0];
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
  input  [31:0] io_ifu_araddr,
  input         io_ifu_arvalid,
  output        io_ifu_arready,
  output [31:0] io_ifu_rdata,
  output        io_ifu_rvalid,
  input         io_ifu_rready,
  input  [31:0] io_lsu_araddr,
  input         io_lsu_arvalid,
  output        io_lsu_arready,
  output [31:0] io_lsu_rdata,
  output        io_lsu_rvalid,
  input         io_lsu_rready,
  input  [31:0] io_lsu_awaddr,
  input         io_lsu_awvalid,
  output        io_lsu_awready,
  input  [31:0] io_lsu_wdata,
  input         io_lsu_wvalid,
  output        io_lsu_wready,
  output        io_lsu_bvalid,
  input         io_lsu_bready,
  input  [2:0]  io_lsu_func3,
  output [31:0] io_m_araddr,
  output        io_m_arvalid,
  input         io_m_arready,
  input  [31:0] io_m_rdata,
  input         io_m_rvalid,
  output        io_m_rready,
  output [31:0] io_m_awaddr,
  output        io_m_awvalid,
  input         io_m_awready,
  output [31:0] io_m_wdata,
  output        io_m_wvalid,
  input         io_m_wready,
  input         io_m_bvalid,
  output        io_m_bready,
  output [2:0]  io_m_func3,
  output        io_inst_active
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
`endif // RANDOMIZE_REG_INIT
  wire  ebreakTrigger_clk; // @[ysyx_22040080_axi_arbiter.scala 122:29]
  wire  ebreakTrigger_en; // @[ysyx_22040080_axi_arbiter.scala 122:29]
  reg [2:0] stateReg; // @[ysyx_22040080_axi_arbiter.scala 101:32]
  reg  readOwnerIfuReg; // @[ysyx_22040080_axi_arbiter.scala 102:32]
  reg  awDoneReg; // @[ysyx_22040080_axi_arbiter.scala 103:32]
  reg  wDoneReg; // @[ysyx_22040080_axi_arbiter.scala 104:32]
  reg [2:0] func3LatchReg; // @[ysyx_22040080_axi_arbiter.scala 105:32]
  wire  reqWrite = io_lsu_awvalid | io_lsu_wvalid; // @[ysyx_22040080_axi_arbiter.scala 110:35]
  wire [2:0] _GEN_0 = io_lsu_arvalid ? 3'h2 : stateReg; // @[ysyx_22040080_axi_arbiter.scala 169:31 170:23 101:32]
  wire [2:0] _GEN_1 = io_lsu_arvalid ? io_lsu_func3 : func3LatchReg; // @[ysyx_22040080_axi_arbiter.scala 169:31 171:23 105:32]
  wire  _GEN_6 = io_ifu_arvalid & io_m_arready | readOwnerIfuReg; // @[ysyx_22040080_axi_arbiter.scala 184:44 185:25 102:32]
  wire  _GEN_8 = io_lsu_arvalid & io_m_arready ? 1'h0 : readOwnerIfuReg; // @[ysyx_22040080_axi_arbiter.scala 199:44 200:25 102:32]
  wire [2:0] _GEN_9 = io_lsu_arvalid & io_m_arready ? 3'h3 : stateReg; // @[ysyx_22040080_axi_arbiter.scala 199:44 201:25 101:32]
  wire  _mRreadyWire_T = readOwnerIfuReg ? io_ifu_rready : io_lsu_rready; // @[ysyx_22040080_axi_arbiter.scala 210:25]
  wire [31:0] _GEN_10 = readOwnerIfuReg ? io_m_rdata : 32'h0; // @[ysyx_22040080_axi_arbiter.scala 131:18 212:29 213:23]
  wire  _GEN_11 = readOwnerIfuReg & io_m_rvalid; // @[ysyx_22040080_axi_arbiter.scala 132:18 212:29 214:23]
  wire [31:0] _GEN_12 = readOwnerIfuReg ? 32'h0 : io_m_rdata; // @[ysyx_22040080_axi_arbiter.scala 135:18 212:29 216:23]
  wire  _GEN_13 = readOwnerIfuReg ? 1'h0 : io_m_rvalid; // @[ysyx_22040080_axi_arbiter.scala 136:18 212:29 217:23]
  wire  _GEN_34 = 3'h3 == stateReg & _mRreadyWire_T; // @[ysyx_22040080_axi_arbiter.scala 155:20 210:19]
  wire  _GEN_56 = 3'h2 == stateReg ? 1'h0 : _GEN_34; // @[ysyx_22040080_axi_arbiter.scala 155:20]
  wire  _GEN_78 = 3'h1 == stateReg ? 1'h0 : _GEN_56; // @[ysyx_22040080_axi_arbiter.scala 155:20]
  wire  mRreadyWire = 3'h0 == stateReg ? 1'h0 : _GEN_78; // @[ysyx_22040080_axi_arbiter.scala 155:20]
  wire  _GEN_14 = io_m_rvalid & mRreadyWire & (readOwnerIfuReg & io_m_rdata == 32'h100073); // @[ysyx_22040080_axi_arbiter.scala 220:40 222:22]
  wire [2:0] _GEN_15 = io_m_rvalid & mRreadyWire ? 3'h0 : stateReg; // @[ysyx_22040080_axi_arbiter.scala 220:40 223:18 101:32]
  wire  _GEN_16 = io_lsu_awvalid & io_m_awready | awDoneReg; // @[ysyx_22040080_axi_arbiter.scala 240:44 241:19 103:32]
  wire  _GEN_17 = io_lsu_wvalid & io_m_wready | wDoneReg; // @[ysyx_22040080_axi_arbiter.scala 243:42 244:18 104:32]
  wire [2:0] _GEN_18 = awDoneReg & wDoneReg ? 3'h5 : stateReg; // @[ysyx_22040080_axi_arbiter.scala 246:35 247:18 101:32]
  wire [2:0] _GEN_19 = io_m_bvalid & io_lsu_bready ? 3'h0 : stateReg; // @[ysyx_22040080_axi_arbiter.scala 259:42 260:18 101:32]
  wire  _GEN_20 = 3'h5 == stateReg & io_m_bvalid; // @[ysyx_22040080_axi_arbiter.scala 139:18 155:20 256:21]
  wire  _GEN_21 = 3'h5 == stateReg & io_lsu_bready; // @[ysyx_22040080_axi_arbiter.scala 148:18 155:20 257:21]
  wire [2:0] _GEN_22 = 3'h5 == stateReg ? _GEN_19 : stateReg; // @[ysyx_22040080_axi_arbiter.scala 155:20 101:32]
  wire [31:0] _GEN_23 = 3'h4 == stateReg ? io_lsu_awaddr : 32'h0; // @[ysyx_22040080_axi_arbiter.scala 144:18 155:20 232:22]
  wire  _GEN_24 = 3'h4 == stateReg & io_lsu_awvalid; // @[ysyx_22040080_axi_arbiter.scala 145:18 155:20 233:22]
  wire  _GEN_25 = 3'h4 == stateReg & io_m_awready; // @[ysyx_22040080_axi_arbiter.scala 137:18 155:20 234:22]
  wire [31:0] _GEN_26 = 3'h4 == stateReg ? io_lsu_wdata : 32'h0; // @[ysyx_22040080_axi_arbiter.scala 146:18 155:20 236:22]
  wire  _GEN_27 = 3'h4 == stateReg & io_lsu_wvalid; // @[ysyx_22040080_axi_arbiter.scala 147:18 155:20 237:22]
  wire  _GEN_28 = 3'h4 == stateReg & io_m_wready; // @[ysyx_22040080_axi_arbiter.scala 138:18 155:20 238:22]
  wire  _GEN_29 = 3'h4 == stateReg ? _GEN_16 : awDoneReg; // @[ysyx_22040080_axi_arbiter.scala 155:20 103:32]
  wire  _GEN_30 = 3'h4 == stateReg ? _GEN_17 : wDoneReg; // @[ysyx_22040080_axi_arbiter.scala 155:20 104:32]
  wire [2:0] _GEN_31 = 3'h4 == stateReg ? _GEN_18 : _GEN_22; // @[ysyx_22040080_axi_arbiter.scala 155:20]
  wire  _GEN_32 = 3'h4 == stateReg ? 1'h0 : _GEN_20; // @[ysyx_22040080_axi_arbiter.scala 139:18 155:20]
  wire  _GEN_33 = 3'h4 == stateReg ? 1'h0 : _GEN_21; // @[ysyx_22040080_axi_arbiter.scala 148:18 155:20]
  wire [31:0] _GEN_35 = 3'h3 == stateReg ? _GEN_10 : 32'h0; // @[ysyx_22040080_axi_arbiter.scala 131:18 155:20]
  wire [31:0] _GEN_37 = 3'h3 == stateReg ? _GEN_12 : 32'h0; // @[ysyx_22040080_axi_arbiter.scala 135:18 155:20]
  wire [2:0] _GEN_40 = 3'h3 == stateReg ? _GEN_15 : _GEN_31; // @[ysyx_22040080_axi_arbiter.scala 155:20]
  wire [31:0] _GEN_41 = 3'h3 == stateReg ? 32'h0 : _GEN_23; // @[ysyx_22040080_axi_arbiter.scala 144:18 155:20]
  wire  _GEN_42 = 3'h3 == stateReg ? 1'h0 : _GEN_24; // @[ysyx_22040080_axi_arbiter.scala 145:18 155:20]
  wire  _GEN_43 = 3'h3 == stateReg ? 1'h0 : _GEN_25; // @[ysyx_22040080_axi_arbiter.scala 137:18 155:20]
  wire [31:0] _GEN_44 = 3'h3 == stateReg ? 32'h0 : _GEN_26; // @[ysyx_22040080_axi_arbiter.scala 146:18 155:20]
  wire  _GEN_45 = 3'h3 == stateReg ? 1'h0 : _GEN_27; // @[ysyx_22040080_axi_arbiter.scala 147:18 155:20]
  wire  _GEN_46 = 3'h3 == stateReg ? 1'h0 : _GEN_28; // @[ysyx_22040080_axi_arbiter.scala 138:18 155:20]
  wire  _GEN_47 = 3'h3 == stateReg ? awDoneReg : _GEN_29; // @[ysyx_22040080_axi_arbiter.scala 155:20 103:32]
  wire  _GEN_48 = 3'h3 == stateReg ? wDoneReg : _GEN_30; // @[ysyx_22040080_axi_arbiter.scala 155:20 104:32]
  wire  _GEN_49 = 3'h3 == stateReg ? 1'h0 : _GEN_32; // @[ysyx_22040080_axi_arbiter.scala 139:18 155:20]
  wire  _GEN_50 = 3'h3 == stateReg ? 1'h0 : _GEN_33; // @[ysyx_22040080_axi_arbiter.scala 148:18 155:20]
  wire [31:0] _GEN_51 = 3'h2 == stateReg ? io_lsu_araddr : 32'h0; // @[ysyx_22040080_axi_arbiter.scala 141:18 155:20 195:22]
  wire  _GEN_52 = 3'h2 == stateReg & io_lsu_arvalid; // @[ysyx_22040080_axi_arbiter.scala 142:18 155:20 196:22]
  wire  _GEN_53 = 3'h2 == stateReg & io_m_arready; // @[ysyx_22040080_axi_arbiter.scala 134:18 155:20 197:22]
  wire [31:0] _GEN_57 = 3'h2 == stateReg ? 32'h0 : _GEN_35; // @[ysyx_22040080_axi_arbiter.scala 131:18 155:20]
  wire  _GEN_58 = 3'h2 == stateReg ? 1'h0 : 3'h3 == stateReg & _GEN_11; // @[ysyx_22040080_axi_arbiter.scala 132:18 155:20]
  wire [31:0] _GEN_59 = 3'h2 == stateReg ? 32'h0 : _GEN_37; // @[ysyx_22040080_axi_arbiter.scala 135:18 155:20]
  wire  _GEN_60 = 3'h2 == stateReg ? 1'h0 : 3'h3 == stateReg & _GEN_13; // @[ysyx_22040080_axi_arbiter.scala 136:18 155:20]
  wire  _GEN_61 = 3'h2 == stateReg ? 1'h0 : 3'h3 == stateReg & _GEN_14; // @[ysyx_22040080_axi_arbiter.scala 155:20]
  wire [31:0] _GEN_62 = 3'h2 == stateReg ? 32'h0 : _GEN_41; // @[ysyx_22040080_axi_arbiter.scala 144:18 155:20]
  wire  _GEN_63 = 3'h2 == stateReg ? 1'h0 : _GEN_42; // @[ysyx_22040080_axi_arbiter.scala 145:18 155:20]
  wire  _GEN_64 = 3'h2 == stateReg ? 1'h0 : _GEN_43; // @[ysyx_22040080_axi_arbiter.scala 137:18 155:20]
  wire [31:0] _GEN_65 = 3'h2 == stateReg ? 32'h0 : _GEN_44; // @[ysyx_22040080_axi_arbiter.scala 146:18 155:20]
  wire  _GEN_66 = 3'h2 == stateReg ? 1'h0 : _GEN_45; // @[ysyx_22040080_axi_arbiter.scala 147:18 155:20]
  wire  _GEN_67 = 3'h2 == stateReg ? 1'h0 : _GEN_46; // @[ysyx_22040080_axi_arbiter.scala 138:18 155:20]
  wire  _GEN_70 = 3'h2 == stateReg ? 1'h0 : _GEN_49; // @[ysyx_22040080_axi_arbiter.scala 139:18 155:20]
  wire  _GEN_71 = 3'h2 == stateReg ? 1'h0 : _GEN_50; // @[ysyx_22040080_axi_arbiter.scala 148:18 155:20]
  wire [31:0] _GEN_72 = 3'h1 == stateReg ? io_ifu_araddr : _GEN_51; // @[ysyx_22040080_axi_arbiter.scala 155:20 180:22]
  wire  _GEN_73 = 3'h1 == stateReg ? io_ifu_arvalid : _GEN_52; // @[ysyx_22040080_axi_arbiter.scala 155:20 181:22]
  wire  _GEN_74 = 3'h1 == stateReg & io_m_arready; // @[ysyx_22040080_axi_arbiter.scala 130:18 155:20 182:22]
  wire  _GEN_77 = 3'h1 == stateReg ? 1'h0 : _GEN_53; // @[ysyx_22040080_axi_arbiter.scala 134:18 155:20]
  wire [31:0] _GEN_79 = 3'h1 == stateReg ? 32'h0 : _GEN_57; // @[ysyx_22040080_axi_arbiter.scala 131:18 155:20]
  wire  _GEN_80 = 3'h1 == stateReg ? 1'h0 : _GEN_58; // @[ysyx_22040080_axi_arbiter.scala 132:18 155:20]
  wire [31:0] _GEN_81 = 3'h1 == stateReg ? 32'h0 : _GEN_59; // @[ysyx_22040080_axi_arbiter.scala 135:18 155:20]
  wire  _GEN_82 = 3'h1 == stateReg ? 1'h0 : _GEN_60; // @[ysyx_22040080_axi_arbiter.scala 136:18 155:20]
  wire  _GEN_83 = 3'h1 == stateReg ? 1'h0 : _GEN_61; // @[ysyx_22040080_axi_arbiter.scala 155:20]
  wire [31:0] _GEN_84 = 3'h1 == stateReg ? 32'h0 : _GEN_62; // @[ysyx_22040080_axi_arbiter.scala 144:18 155:20]
  wire  _GEN_85 = 3'h1 == stateReg ? 1'h0 : _GEN_63; // @[ysyx_22040080_axi_arbiter.scala 145:18 155:20]
  wire  _GEN_86 = 3'h1 == stateReg ? 1'h0 : _GEN_64; // @[ysyx_22040080_axi_arbiter.scala 137:18 155:20]
  wire [31:0] _GEN_87 = 3'h1 == stateReg ? 32'h0 : _GEN_65; // @[ysyx_22040080_axi_arbiter.scala 146:18 155:20]
  wire  _GEN_88 = 3'h1 == stateReg ? 1'h0 : _GEN_66; // @[ysyx_22040080_axi_arbiter.scala 147:18 155:20]
  wire  _GEN_89 = 3'h1 == stateReg ? 1'h0 : _GEN_67; // @[ysyx_22040080_axi_arbiter.scala 138:18 155:20]
  wire  _GEN_92 = 3'h1 == stateReg ? 1'h0 : _GEN_70; // @[ysyx_22040080_axi_arbiter.scala 139:18 155:20]
  wire  _GEN_93 = 3'h1 == stateReg ? 1'h0 : _GEN_71; // @[ysyx_22040080_axi_arbiter.scala 148:18 155:20]
  wire  _io_inst_active_T_1 = stateReg == 3'h3 & readOwnerIfuReg; // @[ysyx_22040080_axi_arbiter.scala 271:46]
  wire  _io_inst_active_T_2 = _io_inst_active_T_1 & io_m_rvalid; // @[ysyx_22040080_axi_arbiter.scala 272:38]
  ebreak_trigger_wrapper ebreakTrigger ( // @[ysyx_22040080_axi_arbiter.scala 122:29]
    .clk(ebreakTrigger_clk),
    .en(ebreakTrigger_en)
  );
  assign io_ifu_arready = 3'h0 == stateReg ? 1'h0 : _GEN_74; // @[ysyx_22040080_axi_arbiter.scala 130:18 155:20]
  assign io_ifu_rdata = 3'h0 == stateReg ? 32'h0 : _GEN_79; // @[ysyx_22040080_axi_arbiter.scala 131:18 155:20]
  assign io_ifu_rvalid = 3'h0 == stateReg ? 1'h0 : _GEN_80; // @[ysyx_22040080_axi_arbiter.scala 132:18 155:20]
  assign io_lsu_arready = 3'h0 == stateReg ? 1'h0 : _GEN_77; // @[ysyx_22040080_axi_arbiter.scala 134:18 155:20]
  assign io_lsu_rdata = 3'h0 == stateReg ? 32'h0 : _GEN_81; // @[ysyx_22040080_axi_arbiter.scala 135:18 155:20]
  assign io_lsu_rvalid = 3'h0 == stateReg ? 1'h0 : _GEN_82; // @[ysyx_22040080_axi_arbiter.scala 136:18 155:20]
  assign io_lsu_awready = 3'h0 == stateReg ? 1'h0 : _GEN_86; // @[ysyx_22040080_axi_arbiter.scala 137:18 155:20]
  assign io_lsu_wready = 3'h0 == stateReg ? 1'h0 : _GEN_89; // @[ysyx_22040080_axi_arbiter.scala 138:18 155:20]
  assign io_lsu_bvalid = 3'h0 == stateReg ? 1'h0 : _GEN_92; // @[ysyx_22040080_axi_arbiter.scala 139:18 155:20]
  assign io_m_araddr = 3'h0 == stateReg ? 32'h0 : _GEN_72; // @[ysyx_22040080_axi_arbiter.scala 141:18 155:20]
  assign io_m_arvalid = 3'h0 == stateReg ? 1'h0 : _GEN_73; // @[ysyx_22040080_axi_arbiter.scala 142:18 155:20]
  assign io_m_rready = 3'h0 == stateReg ? 1'h0 : _GEN_78; // @[ysyx_22040080_axi_arbiter.scala 155:20]
  assign io_m_awaddr = 3'h0 == stateReg ? 32'h0 : _GEN_84; // @[ysyx_22040080_axi_arbiter.scala 144:18 155:20]
  assign io_m_awvalid = 3'h0 == stateReg ? 1'h0 : _GEN_85; // @[ysyx_22040080_axi_arbiter.scala 145:18 155:20]
  assign io_m_wdata = 3'h0 == stateReg ? 32'h0 : _GEN_87; // @[ysyx_22040080_axi_arbiter.scala 146:18 155:20]
  assign io_m_wvalid = 3'h0 == stateReg ? 1'h0 : _GEN_88; // @[ysyx_22040080_axi_arbiter.scala 147:18 155:20]
  assign io_m_bready = 3'h0 == stateReg ? 1'h0 : _GEN_93; // @[ysyx_22040080_axi_arbiter.scala 148:18 155:20]
  assign io_m_func3 = func3LatchReg; // @[ysyx_22040080_axi_arbiter.scala 150:18]
  assign io_inst_active = _io_inst_active_T_2 & mRreadyWire; // @[ysyx_22040080_axi_arbiter.scala 273:34]
  assign ebreakTrigger_clk = clock; // @[ysyx_22040080_axi_arbiter.scala 123:24]
  assign ebreakTrigger_en = 3'h0 == stateReg ? 1'h0 : _GEN_83; // @[ysyx_22040080_axi_arbiter.scala 155:20]
  always @(posedge clock) begin
    if (reset) begin // @[ysyx_22040080_axi_arbiter.scala 101:32]
      stateReg <= 3'h0; // @[ysyx_22040080_axi_arbiter.scala 101:32]
    end else if (3'h0 == stateReg) begin // @[ysyx_22040080_axi_arbiter.scala 155:20]
      if (reqWrite) begin // @[ysyx_22040080_axi_arbiter.scala 163:22]
        stateReg <= 3'h4; // @[ysyx_22040080_axi_arbiter.scala 164:23]
      end else if (io_ifu_arvalid) begin // @[ysyx_22040080_axi_arbiter.scala 166:31]
        stateReg <= 3'h1; // @[ysyx_22040080_axi_arbiter.scala 167:23]
      end else begin
        stateReg <= _GEN_0;
      end
    end else if (3'h1 == stateReg) begin // @[ysyx_22040080_axi_arbiter.scala 155:20]
      if (io_ifu_arvalid & io_m_arready) begin // @[ysyx_22040080_axi_arbiter.scala 184:44]
        stateReg <= 3'h3; // @[ysyx_22040080_axi_arbiter.scala 186:25]
      end
    end else if (3'h2 == stateReg) begin // @[ysyx_22040080_axi_arbiter.scala 155:20]
      stateReg <= _GEN_9;
    end else begin
      stateReg <= _GEN_40;
    end
    if (reset) begin // @[ysyx_22040080_axi_arbiter.scala 102:32]
      readOwnerIfuReg <= 1'h0; // @[ysyx_22040080_axi_arbiter.scala 102:32]
    end else if (!(3'h0 == stateReg)) begin // @[ysyx_22040080_axi_arbiter.scala 155:20]
      if (3'h1 == stateReg) begin // @[ysyx_22040080_axi_arbiter.scala 155:20]
        readOwnerIfuReg <= _GEN_6;
      end else if (3'h2 == stateReg) begin // @[ysyx_22040080_axi_arbiter.scala 155:20]
        readOwnerIfuReg <= _GEN_8;
      end
    end
    if (reset) begin // @[ysyx_22040080_axi_arbiter.scala 103:32]
      awDoneReg <= 1'h0; // @[ysyx_22040080_axi_arbiter.scala 103:32]
    end else if (3'h0 == stateReg) begin // @[ysyx_22040080_axi_arbiter.scala 155:20]
      awDoneReg <= 1'h0; // @[ysyx_22040080_axi_arbiter.scala 161:17]
    end else if (!(3'h1 == stateReg)) begin // @[ysyx_22040080_axi_arbiter.scala 155:20]
      if (!(3'h2 == stateReg)) begin // @[ysyx_22040080_axi_arbiter.scala 155:20]
        awDoneReg <= _GEN_47;
      end
    end
    if (reset) begin // @[ysyx_22040080_axi_arbiter.scala 104:32]
      wDoneReg <= 1'h0; // @[ysyx_22040080_axi_arbiter.scala 104:32]
    end else if (3'h0 == stateReg) begin // @[ysyx_22040080_axi_arbiter.scala 155:20]
      wDoneReg <= 1'h0; // @[ysyx_22040080_axi_arbiter.scala 162:17]
    end else if (!(3'h1 == stateReg)) begin // @[ysyx_22040080_axi_arbiter.scala 155:20]
      if (!(3'h2 == stateReg)) begin // @[ysyx_22040080_axi_arbiter.scala 155:20]
        wDoneReg <= _GEN_48;
      end
    end
    if (reset) begin // @[ysyx_22040080_axi_arbiter.scala 105:32]
      func3LatchReg <= 3'h2; // @[ysyx_22040080_axi_arbiter.scala 105:32]
    end else if (3'h0 == stateReg) begin // @[ysyx_22040080_axi_arbiter.scala 155:20]
      if (reqWrite) begin // @[ysyx_22040080_axi_arbiter.scala 163:22]
        func3LatchReg <= io_lsu_func3; // @[ysyx_22040080_axi_arbiter.scala 165:23]
      end else if (io_ifu_arvalid) begin // @[ysyx_22040080_axi_arbiter.scala 166:31]
        func3LatchReg <= 3'h2; // @[ysyx_22040080_axi_arbiter.scala 168:23]
      end else begin
        func3LatchReg <= _GEN_1;
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
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_22040080_axi_xbar(
  input         clock,
  input         reset,
  input  [31:0] io_m_araddr,
  input         io_m_arvalid,
  output        io_m_arready,
  output [31:0] io_m_rdata,
  output        io_m_rvalid,
  input         io_m_rready,
  input  [31:0] io_m_awaddr,
  input         io_m_awvalid,
  output        io_m_awready,
  input  [31:0] io_m_wdata,
  input         io_m_wvalid,
  output        io_m_wready,
  output        io_m_bvalid,
  input         io_m_bready,
  input  [2:0]  io_m_func3,
  output [31:0] io_mem_araddr,
  output        io_mem_arvalid,
  input         io_mem_arready,
  input  [31:0] io_mem_rdata,
  input         io_mem_rvalid,
  output        io_mem_rready,
  output [31:0] io_mem_awaddr,
  output        io_mem_awvalid,
  input         io_mem_awready,
  output [31:0] io_mem_wdata,
  output        io_mem_wvalid,
  input         io_mem_wready,
  input         io_mem_bvalid,
  output        io_mem_bready,
  output [2:0]  io_mem_func3,
  output [31:0] io_clint_araddr,
  output        io_clint_arvalid,
  input         io_clint_arready,
  input  [31:0] io_clint_rdata,
  input         io_clint_rvalid,
  output        io_clint_rready,
  output        io_clint_awvalid,
  input         io_clint_awready,
  output        io_clint_wvalid,
  input         io_clint_wready,
  input         io_clint_bvalid,
  output        io_clint_bready,
  output [31:0] io_uart_araddr,
  output        io_uart_arvalid,
  input         io_uart_arready,
  input  [31:0] io_uart_rdata,
  input         io_uart_rvalid,
  output        io_uart_rready,
  output [31:0] io_uart_awaddr,
  output        io_uart_awvalid,
  input         io_uart_awready,
  output [31:0] io_uart_wdata,
  output        io_uart_wvalid,
  input         io_uart_wready,
  input         io_uart_bvalid,
  output        io_uart_bready
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg  readSelValid; // @[ysyx_22040080_axi_xbar.scala 99:30]
  reg [1:0] readSel; // @[ysyx_22040080_axi_xbar.scala 100:30]
  reg  writeSelValid; // @[ysyx_22040080_axi_xbar.scala 101:30]
  reg [1:0] writeSel; // @[ysyx_22040080_axi_xbar.scala 102:30]
  wire  selUartRead = io_m_araddr == 32'h10000000; // @[ysyx_22040080_axi_xbar.scala 107:35]
  wire  selUartWrite = io_m_awaddr == 32'h10000000; // @[ysyx_22040080_axi_xbar.scala 108:35]
  wire  _selClintRead_T_3 = io_m_araddr == 32'ha000004c; // @[ysyx_22040080_axi_xbar.scala 110:36]
  wire  selClintRead = io_m_araddr == 32'ha0000048 | _selClintRead_T_3; // @[ysyx_22040080_axi_xbar.scala 109:58]
  wire  _selClintWrite_T_3 = io_m_awaddr == 32'ha000004c; // @[ysyx_22040080_axi_xbar.scala 112:36]
  wire  selClintWrite = io_m_awaddr == 32'ha0000048 | _selClintWrite_T_3; // @[ysyx_22040080_axi_xbar.scala 111:58]
  wire  _T = ~readSelValid; // @[ysyx_22040080_axi_xbar.scala 129:8]
  wire  _GEN_8 = selUartRead ? io_uart_arready : io_mem_arready; // @[ysyx_22040080_axi_xbar.scala 190:30 193:24 197:24]
  wire  _GEN_13 = selClintRead ? io_clint_arready : _GEN_8; // @[ysyx_22040080_axi_xbar.scala 186:24 189:24]
  wire  mArreadyWire = _T & _GEN_13; // @[ysyx_22040080_axi_xbar.scala 185:23]
  wire  _GEN_26 = readSel == 2'h1 ? io_uart_rvalid : io_mem_rvalid; // @[ysyx_22040080_axi_xbar.scala 209:39 211:24 215:24]
  wire  _GEN_30 = readSel == 2'h2 ? io_clint_rvalid : _GEN_26; // @[ysyx_22040080_axi_xbar.scala 205:33 207:24]
  wire  mRvalidWire = readSelValid & _GEN_30; // @[ysyx_22040080_axi_xbar.scala 204:22]
  wire  _GEN_0 = readSelValid & mRvalidWire & io_m_rready ? 1'h0 : readSelValid; // @[ysyx_22040080_axi_xbar.scala 132:59 133:18 99:30]
  wire  _GEN_1 = ~readSelValid & io_m_arvalid & mArreadyWire | _GEN_0; // @[ysyx_22040080_axi_xbar.scala 129:55 130:18]
  wire  _T_6 = ~writeSelValid & io_m_awvalid; // @[ysyx_22040080_axi_xbar.scala 137:23]
  wire  _GEN_41 = selUartWrite ? io_uart_awready : io_mem_awready; // @[ysyx_22040080_axi_xbar.scala 228:31 231:24 235:24]
  wire  _GEN_46 = selClintWrite ? io_clint_awready : _GEN_41; // @[ysyx_22040080_axi_xbar.scala 224:25 227:24]
  wire  mAwreadyWire = _T_6 & _GEN_46; // @[ysyx_22040080_axi_xbar.scala 223:40]
  wire  _GEN_61 = writeSel == 2'h1 ? io_uart_bvalid : io_mem_bvalid; // @[ysyx_22040080_axi_xbar.scala 249:40 253:24 259:24]
  wire  _GEN_69 = writeSel == 2'h2 ? io_clint_bvalid : _GEN_61; // @[ysyx_22040080_axi_xbar.scala 243:34 247:24]
  wire  mBvalidWire = writeSelValid & _GEN_69; // @[ysyx_22040080_axi_xbar.scala 242:23]
  wire  _GEN_3 = writeSelValid & mBvalidWire & io_m_bready ? 1'h0 : writeSelValid; // @[ysyx_22040080_axi_xbar.scala 140:60 141:19 101:30]
  wire  _GEN_4 = ~writeSelValid & io_m_awvalid & mAwreadyWire | _GEN_3; // @[ysyx_22040080_axi_xbar.scala 137:56 138:19]
  wire [31:0] _GEN_6 = selUartRead ? io_m_araddr : 32'h0; // @[ysyx_22040080_axi_xbar.scala 173:19 190:30 191:24]
  wire  _GEN_7 = selUartRead & io_m_arvalid; // @[ysyx_22040080_axi_xbar.scala 174:19 190:30 192:24]
  wire [31:0] _GEN_9 = selUartRead ? 32'h0 : io_m_araddr; // @[ysyx_22040080_axi_xbar.scala 152:18 190:30 195:24]
  wire  _GEN_10 = selUartRead ? 1'h0 : io_m_arvalid; // @[ysyx_22040080_axi_xbar.scala 153:18 190:30 196:24]
  wire [31:0] _GEN_11 = selClintRead ? io_m_araddr : 32'h0; // @[ysyx_22040080_axi_xbar.scala 163:20 186:24 187:24]
  wire  _GEN_12 = selClintRead & io_m_arvalid; // @[ysyx_22040080_axi_xbar.scala 164:20 186:24 188:24]
  wire [31:0] _GEN_14 = selClintRead ? 32'h0 : _GEN_6; // @[ysyx_22040080_axi_xbar.scala 173:19 186:24]
  wire  _GEN_15 = selClintRead ? 1'h0 : _GEN_7; // @[ysyx_22040080_axi_xbar.scala 174:19 186:24]
  wire [31:0] _GEN_16 = selClintRead ? 32'h0 : _GEN_9; // @[ysyx_22040080_axi_xbar.scala 152:18 186:24]
  wire  _GEN_17 = selClintRead ? 1'h0 : _GEN_10; // @[ysyx_22040080_axi_xbar.scala 153:18 186:24]
  wire [31:0] _GEN_25 = readSel == 2'h1 ? io_uart_rdata : io_mem_rdata; // @[ysyx_22040080_axi_xbar.scala 209:39 210:24 214:24]
  wire  _GEN_27 = readSel == 2'h1 & io_m_rready; // @[ysyx_22040080_axi_xbar.scala 175:19 209:39 212:24]
  wire  _GEN_28 = readSel == 2'h1 ? 1'h0 : io_m_rready; // @[ysyx_22040080_axi_xbar.scala 154:18 209:39 216:24]
  wire [31:0] _GEN_29 = readSel == 2'h2 ? io_clint_rdata : _GEN_25; // @[ysyx_22040080_axi_xbar.scala 205:33 206:24]
  wire  _GEN_31 = readSel == 2'h2 & io_m_rready; // @[ysyx_22040080_axi_xbar.scala 165:20 205:33 208:24]
  wire  _GEN_32 = readSel == 2'h2 ? 1'h0 : _GEN_27; // @[ysyx_22040080_axi_xbar.scala 175:19 205:33]
  wire  _GEN_33 = readSel == 2'h2 ? 1'h0 : _GEN_28; // @[ysyx_22040080_axi_xbar.scala 154:18 205:33]
  wire [31:0] _GEN_39 = selUartWrite ? io_m_awaddr : 32'h0; // @[ysyx_22040080_axi_xbar.scala 176:19 228:31 229:24]
  wire  _GEN_40 = selUartWrite & io_m_awvalid; // @[ysyx_22040080_axi_xbar.scala 177:19 228:31 230:24]
  wire [31:0] _GEN_42 = selUartWrite ? 32'h0 : io_m_awaddr; // @[ysyx_22040080_axi_xbar.scala 155:18 228:31 233:24]
  wire  _GEN_43 = selUartWrite ? 1'h0 : io_m_awvalid; // @[ysyx_22040080_axi_xbar.scala 156:18 228:31 234:24]
  wire  _GEN_45 = selClintWrite & io_m_awvalid; // @[ysyx_22040080_axi_xbar.scala 167:20 224:25 226:24]
  wire [31:0] _GEN_47 = selClintWrite ? 32'h0 : _GEN_39; // @[ysyx_22040080_axi_xbar.scala 176:19 224:25]
  wire  _GEN_48 = selClintWrite ? 1'h0 : _GEN_40; // @[ysyx_22040080_axi_xbar.scala 177:19 224:25]
  wire [31:0] _GEN_49 = selClintWrite ? 32'h0 : _GEN_42; // @[ysyx_22040080_axi_xbar.scala 155:18 224:25]
  wire  _GEN_50 = selClintWrite ? 1'h0 : _GEN_43; // @[ysyx_22040080_axi_xbar.scala 156:18 224:25]
  wire [31:0] _GEN_58 = writeSel == 2'h1 ? io_m_wdata : 32'h0; // @[ysyx_22040080_axi_xbar.scala 178:19 249:40 250:24]
  wire  _GEN_59 = writeSel == 2'h1 & io_m_wvalid; // @[ysyx_22040080_axi_xbar.scala 179:19 249:40 251:24]
  wire  _GEN_60 = writeSel == 2'h1 ? io_uart_wready : io_mem_wready; // @[ysyx_22040080_axi_xbar.scala 249:40 252:24 258:24]
  wire  _GEN_62 = writeSel == 2'h1 & io_m_bready; // @[ysyx_22040080_axi_xbar.scala 180:19 249:40 254:24]
  wire [31:0] _GEN_63 = writeSel == 2'h1 ? 32'h0 : io_m_wdata; // @[ysyx_22040080_axi_xbar.scala 157:18 249:40 256:24]
  wire  _GEN_64 = writeSel == 2'h1 ? 1'h0 : io_m_wvalid; // @[ysyx_22040080_axi_xbar.scala 158:18 249:40 257:24]
  wire  _GEN_65 = writeSel == 2'h1 ? 1'h0 : io_m_bready; // @[ysyx_22040080_axi_xbar.scala 159:18 249:40 260:24]
  wire  _GEN_67 = writeSel == 2'h2 & io_m_wvalid; // @[ysyx_22040080_axi_xbar.scala 169:20 243:34 245:24]
  wire  _GEN_68 = writeSel == 2'h2 ? io_clint_wready : _GEN_60; // @[ysyx_22040080_axi_xbar.scala 243:34 246:24]
  wire  _GEN_70 = writeSel == 2'h2 & io_m_bready; // @[ysyx_22040080_axi_xbar.scala 170:20 243:34 248:24]
  wire [31:0] _GEN_71 = writeSel == 2'h2 ? 32'h0 : _GEN_58; // @[ysyx_22040080_axi_xbar.scala 178:19 243:34]
  wire  _GEN_72 = writeSel == 2'h2 ? 1'h0 : _GEN_59; // @[ysyx_22040080_axi_xbar.scala 179:19 243:34]
  wire  _GEN_73 = writeSel == 2'h2 ? 1'h0 : _GEN_62; // @[ysyx_22040080_axi_xbar.scala 180:19 243:34]
  wire [31:0] _GEN_74 = writeSel == 2'h2 ? 32'h0 : _GEN_63; // @[ysyx_22040080_axi_xbar.scala 157:18 243:34]
  wire  _GEN_75 = writeSel == 2'h2 ? 1'h0 : _GEN_64; // @[ysyx_22040080_axi_xbar.scala 158:18 243:34]
  wire  _GEN_76 = writeSel == 2'h2 ? 1'h0 : _GEN_65; // @[ysyx_22040080_axi_xbar.scala 159:18 243:34]
  assign io_m_arready = _T & _GEN_13; // @[ysyx_22040080_axi_xbar.scala 185:23]
  assign io_m_rdata = readSelValid ? _GEN_29 : 32'h0; // @[ysyx_22040080_axi_xbar.scala 204:22]
  assign io_m_rvalid = readSelValid & _GEN_30; // @[ysyx_22040080_axi_xbar.scala 204:22]
  assign io_m_awready = _T_6 & _GEN_46; // @[ysyx_22040080_axi_xbar.scala 223:40]
  assign io_m_wready = writeSelValid & _GEN_68; // @[ysyx_22040080_axi_xbar.scala 242:23]
  assign io_m_bvalid = writeSelValid & _GEN_69; // @[ysyx_22040080_axi_xbar.scala 242:23]
  assign io_mem_araddr = _T ? _GEN_16 : 32'h0; // @[ysyx_22040080_axi_xbar.scala 152:18 185:23]
  assign io_mem_arvalid = _T & _GEN_17; // @[ysyx_22040080_axi_xbar.scala 153:18 185:23]
  assign io_mem_rready = readSelValid & _GEN_33; // @[ysyx_22040080_axi_xbar.scala 154:18 204:22]
  assign io_mem_awaddr = _T_6 ? _GEN_49 : 32'h0; // @[ysyx_22040080_axi_xbar.scala 155:18 223:40]
  assign io_mem_awvalid = _T_6 & _GEN_50; // @[ysyx_22040080_axi_xbar.scala 156:18 223:40]
  assign io_mem_wdata = writeSelValid ? _GEN_74 : 32'h0; // @[ysyx_22040080_axi_xbar.scala 157:18 242:23]
  assign io_mem_wvalid = writeSelValid & _GEN_75; // @[ysyx_22040080_axi_xbar.scala 158:18 242:23]
  assign io_mem_bready = writeSelValid & _GEN_76; // @[ysyx_22040080_axi_xbar.scala 159:18 242:23]
  assign io_mem_func3 = io_m_func3; // @[ysyx_22040080_axi_xbar.scala 160:18]
  assign io_clint_araddr = _T ? _GEN_11 : 32'h0; // @[ysyx_22040080_axi_xbar.scala 163:20 185:23]
  assign io_clint_arvalid = _T & _GEN_12; // @[ysyx_22040080_axi_xbar.scala 164:20 185:23]
  assign io_clint_rready = readSelValid & _GEN_31; // @[ysyx_22040080_axi_xbar.scala 165:20 204:22]
  assign io_clint_awvalid = _T_6 & _GEN_45; // @[ysyx_22040080_axi_xbar.scala 167:20 223:40]
  assign io_clint_wvalid = writeSelValid & _GEN_67; // @[ysyx_22040080_axi_xbar.scala 169:20 242:23]
  assign io_clint_bready = writeSelValid & _GEN_70; // @[ysyx_22040080_axi_xbar.scala 170:20 242:23]
  assign io_uart_araddr = _T ? _GEN_14 : 32'h0; // @[ysyx_22040080_axi_xbar.scala 173:19 185:23]
  assign io_uart_arvalid = _T & _GEN_15; // @[ysyx_22040080_axi_xbar.scala 174:19 185:23]
  assign io_uart_rready = readSelValid & _GEN_32; // @[ysyx_22040080_axi_xbar.scala 175:19 204:22]
  assign io_uart_awaddr = _T_6 ? _GEN_47 : 32'h0; // @[ysyx_22040080_axi_xbar.scala 176:19 223:40]
  assign io_uart_awvalid = _T_6 & _GEN_48; // @[ysyx_22040080_axi_xbar.scala 177:19 223:40]
  assign io_uart_wdata = writeSelValid ? _GEN_71 : 32'h0; // @[ysyx_22040080_axi_xbar.scala 178:19 242:23]
  assign io_uart_wvalid = writeSelValid & _GEN_72; // @[ysyx_22040080_axi_xbar.scala 179:19 242:23]
  assign io_uart_bready = writeSelValid & _GEN_73; // @[ysyx_22040080_axi_xbar.scala 180:19 242:23]
  always @(posedge clock) begin
    if (reset) begin // @[ysyx_22040080_axi_xbar.scala 99:30]
      readSelValid <= 1'h0; // @[ysyx_22040080_axi_xbar.scala 99:30]
    end else begin
      readSelValid <= _GEN_1;
    end
    if (reset) begin // @[ysyx_22040080_axi_xbar.scala 100:30]
      readSel <= 2'h0; // @[ysyx_22040080_axi_xbar.scala 100:30]
    end else if (~readSelValid & io_m_arvalid & mArreadyWire) begin // @[ysyx_22040080_axi_xbar.scala 129:55]
      if (selClintRead) begin // @[ysyx_22040080_axi_xbar.scala 114:25]
        readSel <= 2'h2;
      end else if (selUartRead) begin // @[ysyx_22040080_axi_xbar.scala 114:54]
        readSel <= 2'h1;
      end else begin
        readSel <= 2'h0;
      end
    end
    if (reset) begin // @[ysyx_22040080_axi_xbar.scala 101:30]
      writeSelValid <= 1'h0; // @[ysyx_22040080_axi_xbar.scala 101:30]
    end else begin
      writeSelValid <= _GEN_4;
    end
    if (reset) begin // @[ysyx_22040080_axi_xbar.scala 102:30]
      writeSel <= 2'h0; // @[ysyx_22040080_axi_xbar.scala 102:30]
    end else if (~writeSelValid & io_m_awvalid & mAwreadyWire) begin // @[ysyx_22040080_axi_xbar.scala 137:56]
      if (selClintWrite) begin // @[ysyx_22040080_axi_xbar.scala 115:25]
        writeSel <= 2'h2;
      end else if (selUartWrite) begin // @[ysyx_22040080_axi_xbar.scala 115:55]
        writeSel <= 2'h1;
      end else begin
        writeSel <= 2'h0;
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
  readSelValid = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  readSel = _RAND_1[1:0];
  _RAND_2 = {1{`RANDOM}};
  writeSelValid = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  writeSel = _RAND_3[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module memory(
  input         clock,
  input         reset,
  input  [31:0] io_araddr,
  input         io_arvalid,
  output        io_arready,
  output [31:0] io_rdata,
  output        io_rvalid,
  input         io_rready,
  input  [31:0] io_awaddr,
  input         io_awvalid,
  output        io_awready,
  input  [31:0] io_wdata,
  input         io_wvalid,
  output        io_wready,
  output        io_bvalid,
  input         io_bready,
  input  [2:0]  io_func3
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
`endif // RANDOMIZE_REG_INIT
  wire [31:0] pmemReader_addr; // @[memory.scala 107:26]
  wire [31:0] pmemReader_len; // @[memory.scala 107:26]
  wire [31:0] pmemReader_data; // @[memory.scala 107:26]
  wire  pmemWriter_clk; // @[memory.scala 132:26]
  wire  pmemWriter_en; // @[memory.scala 132:26]
  wire [31:0] pmemWriter_addr; // @[memory.scala 132:26]
  wire [31:0] pmemWriter_len; // @[memory.scala 132:26]
  wire [31:0] pmemWriter_data; // @[memory.scala 132:26]
  reg  arreadyReg; // @[memory.scala 73:31]
  reg [31:0] rdataReg; // @[memory.scala 74:31]
  reg  rvalidReg; // @[memory.scala 75:31]
  reg [31:0] readAddrLatch; // @[memory.scala 76:31]
  reg [2:0] readFunc3Latch; // @[memory.scala 77:31]
  reg [7:0] readDelayCnt; // @[memory.scala 78:31]
  reg [7:0] arReadyCnt; // @[memory.scala 79:31]
  reg  readPending; // @[memory.scala 80:31]
  reg  awreadyReg; // @[memory.scala 85:32]
  reg  wreadyReg; // @[memory.scala 86:32]
  reg  bvalidReg; // @[memory.scala 87:32]
  reg [31:0] writeAddrLatch; // @[memory.scala 88:32]
  reg [31:0] writeDataLatch; // @[memory.scala 89:32]
  reg [2:0] writeFunc3Latch; // @[memory.scala 90:32]
  reg [7:0] awReadyCnt; // @[memory.scala 91:32]
  reg [7:0] wReadyCnt; // @[memory.scala 92:32]
  reg  awPending; // @[memory.scala 93:32]
  reg  wPending; // @[memory.scala 94:32]
  reg  writePending; // @[memory.scala 95:32]
  wire  readBusy = readPending | rvalidReg; // @[memory.scala 100:32]
  wire  writeBusy = awPending | wPending | writePending | bvalidReg; // @[memory.scala 101:58]
  wire  writeBlock = writePending | bvalidReg; // @[memory.scala 102:33]
  wire [31:0] _pmemReader_io_len_T_1 = 3'h0 == readFunc3Latch ? 32'h1 : 32'h4; // @[Mux.scala 81:58]
  wire [31:0] _pmemReader_io_len_T_3 = 3'h1 == readFunc3Latch ? 32'h2 : _pmemReader_io_len_T_1; // @[Mux.scala 81:58]
  wire [31:0] _pmemReader_io_len_T_5 = 3'h2 == readFunc3Latch ? 32'h4 : _pmemReader_io_len_T_3; // @[Mux.scala 81:58]
  wire [31:0] _pmemReader_io_len_T_7 = 3'h4 == readFunc3Latch ? 32'h1 : _pmemReader_io_len_T_5; // @[Mux.scala 81:58]
  wire [23:0] _extendedReadData_T_2 = pmemReader_data[7] ? 24'hffffff : 24'h0; // @[Bitwise.scala 74:12]
  wire [31:0] _extendedReadData_T_4 = {_extendedReadData_T_2,pmemReader_data[7:0]}; // @[Cat.scala 31:58]
  wire [15:0] _extendedReadData_T_7 = pmemReader_data[15] ? 16'hffff : 16'h0; // @[Bitwise.scala 74:12]
  wire [31:0] _extendedReadData_T_9 = {_extendedReadData_T_7,pmemReader_data[15:0]}; // @[Cat.scala 31:58]
  wire [31:0] _extendedReadData_T_10 = pmemReader_data & 32'hff; // @[memory.scala 125:25]
  wire [31:0] _extendedReadData_T_11 = pmemReader_data & 32'hffff; // @[memory.scala 126:25]
  wire [31:0] _extendedReadData_T_13 = 3'h0 == readFunc3Latch ? _extendedReadData_T_4 : 32'h0; // @[Mux.scala 81:58]
  wire [31:0] _extendedReadData_T_15 = 3'h1 == readFunc3Latch ? _extendedReadData_T_9 : _extendedReadData_T_13; // @[Mux.scala 81:58]
  wire [31:0] _extendedReadData_T_17 = 3'h2 == readFunc3Latch ? pmemReader_data : _extendedReadData_T_15; // @[Mux.scala 81:58]
  wire [31:0] _extendedReadData_T_19 = 3'h4 == readFunc3Latch ? _extendedReadData_T_10 : _extendedReadData_T_17; // @[Mux.scala 81:58]
  wire [31:0] _pmemWriter_io_len_T_1 = 3'h0 == writeFunc3Latch ? 32'h1 : 32'h4; // @[Mux.scala 81:58]
  wire [31:0] _pmemWriter_io_len_T_3 = 3'h1 == writeFunc3Latch ? 32'h2 : _pmemWriter_io_len_T_1; // @[Mux.scala 81:58]
  wire  _pmemWriter_io_en_T = ~awPending; // @[memory.scala 141:39]
  wire  _pmemWriter_io_en_T_1 = writePending & ~awPending; // @[memory.scala 141:36]
  wire  _T = ~readBusy; // @[memory.scala 151:22]
  wire [7:0] _GEN_2 = io_arvalid & ~readBusy & ~writeBusy ? 8'h9 : readDelayCnt; // @[memory.scala 151:47 154:20 78:31]
  wire [7:0] _GEN_3 = io_arvalid & ~readBusy & ~writeBusy ? 8'h4 : arReadyCnt; // @[memory.scala 151:47 155:20 79:31]
  wire  _GEN_4 = io_arvalid & ~readBusy & ~writeBusy | readPending; // @[memory.scala 151:47 156:20 80:31]
  wire [7:0] _readDelayCnt_T_1 = readDelayCnt - 8'h1; // @[memory.scala 162:36]
  wire [7:0] _arReadyCnt_T_1 = arReadyCnt - 8'h1; // @[memory.scala 164:34]
  wire  _GEN_6 = arReadyCnt > 8'h0 ? 1'h0 : 1'h1; // @[memory.scala 163:30 165:20 168:22]
  wire  _GEN_10 = readDelayCnt > 8'h0 & _GEN_6; // @[memory.scala 148:14 161:30]
  wire  _GEN_12 = io_arvalid & arreadyReg | rvalidReg; // @[memory.scala 172:36 174:19 75:31]
  wire  _GEN_13 = io_arvalid & arreadyReg ? 1'h0 : _GEN_10; // @[memory.scala 172:36 175:19]
  wire  _GEN_17 = readPending & ~rvalidReg & _GEN_13; // @[memory.scala 148:14 160:35]
  wire  _T_14 = ~writeBlock; // @[memory.scala 196:49]
  wire [7:0] _GEN_23 = io_awvalid & _pmemWriter_io_en_T & _T & ~writeBlock ? 8'h4 : awReadyCnt; // @[memory.scala 196:62 198:20 91:32]
  wire  _GEN_24 = io_awvalid & _pmemWriter_io_en_T & _T & ~writeBlock | awPending; // @[memory.scala 196:62 199:20 93:32]
  wire [7:0] _awReadyCnt_T_1 = awReadyCnt - 8'h1; // @[memory.scala 205:32]
  wire  _GEN_26 = awReadyCnt > 8'h0 ? 1'h0 : 1'h1; // @[memory.scala 190:14 204:28 207:18]
  wire  _GEN_27 = io_awvalid & awreadyReg ? 1'h0 : _GEN_26; // @[memory.scala 209:36 210:18]
  wire  _GEN_30 = awPending & _GEN_27; // @[memory.scala 190:14 203:19]
  wire [7:0] _GEN_34 = io_wvalid & ~wPending & _T & _T_14 ? 8'h4 : wReadyCnt; // @[memory.scala 218:60 221:21 92:32]
  wire  _GEN_35 = io_wvalid & ~wPending & _T & _T_14 | wPending; // @[memory.scala 218:60 222:21 94:32]
  wire [7:0] _wReadyCnt_T_1 = wReadyCnt - 8'h1; // @[memory.scala 228:30]
  wire  _GEN_37 = wReadyCnt > 8'h0 ? 1'h0 : 1'h1; // @[memory.scala 191:14 227:27 230:17]
  wire  _GEN_39 = io_wvalid & wreadyReg ? 1'h0 : _GEN_37; // @[memory.scala 232:34 234:20]
  wire  _GEN_40 = io_wvalid & wreadyReg | writePending; // @[memory.scala 232:34 235:20 95:32]
  wire  _GEN_42 = wPending & _GEN_39; // @[memory.scala 191:14 226:18]
  wire  _GEN_45 = _pmemWriter_io_en_T_1 | bvalidReg; // @[memory.scala 242:36 243:18 87:32]
  pmem_read_wrapper pmemReader ( // @[memory.scala 107:26]
    .addr(pmemReader_addr),
    .len(pmemReader_len),
    .data(pmemReader_data)
  );
  pmem_write_wrapper pmemWriter ( // @[memory.scala 132:26]
    .clk(pmemWriter_clk),
    .en(pmemWriter_en),
    .addr(pmemWriter_addr),
    .len(pmemWriter_len),
    .data(pmemWriter_data)
  );
  assign io_arready = arreadyReg; // @[memory.scala 255:14]
  assign io_rdata = rdataReg; // @[memory.scala 256:14]
  assign io_rvalid = rvalidReg; // @[memory.scala 257:14]
  assign io_awready = awreadyReg; // @[memory.scala 258:14]
  assign io_wready = wreadyReg; // @[memory.scala 259:14]
  assign io_bvalid = bvalidReg; // @[memory.scala 260:14]
  assign pmemReader_addr = readAddrLatch; // @[memory.scala 108:22]
  assign pmemReader_len = 3'h5 == readFunc3Latch ? 32'h2 : _pmemReader_io_len_T_7; // @[Mux.scala 81:58]
  assign pmemWriter_clk = clock; // @[memory.scala 133:22]
  assign pmemWriter_en = writePending & ~awPending; // @[memory.scala 141:36]
  assign pmemWriter_addr = writeAddrLatch; // @[memory.scala 134:22]
  assign pmemWriter_len = 3'h2 == writeFunc3Latch ? 32'h4 : _pmemWriter_io_len_T_3; // @[Mux.scala 81:58]
  assign pmemWriter_data = writeDataLatch; // @[memory.scala 135:22]
  always @(posedge clock) begin
    if (reset) begin // @[memory.scala 73:31]
      arreadyReg <= 1'h0; // @[memory.scala 73:31]
    end else begin
      arreadyReg <= _GEN_17;
    end
    if (reset) begin // @[memory.scala 74:31]
      rdataReg <= 32'h0; // @[memory.scala 74:31]
    end else if (readPending & ~rvalidReg) begin // @[memory.scala 160:35]
      if (io_arvalid & arreadyReg) begin // @[memory.scala 172:36]
        if (3'h5 == readFunc3Latch) begin // @[Mux.scala 81:58]
          rdataReg <= _extendedReadData_T_11;
        end else begin
          rdataReg <= _extendedReadData_T_19;
        end
      end
    end
    if (reset) begin // @[memory.scala 75:31]
      rvalidReg <= 1'h0; // @[memory.scala 75:31]
    end else if (rvalidReg & io_rready) begin // @[memory.scala 181:32]
      rvalidReg <= 1'h0; // @[memory.scala 182:15]
    end else if (readPending & ~rvalidReg) begin // @[memory.scala 160:35]
      rvalidReg <= _GEN_12;
    end
    if (reset) begin // @[memory.scala 76:31]
      readAddrLatch <= 32'h0; // @[memory.scala 76:31]
    end else if (io_arvalid & ~readBusy & ~writeBusy) begin // @[memory.scala 151:47]
      readAddrLatch <= io_araddr; // @[memory.scala 152:20]
    end
    if (reset) begin // @[memory.scala 77:31]
      readFunc3Latch <= 3'h0; // @[memory.scala 77:31]
    end else if (io_arvalid & ~readBusy & ~writeBusy) begin // @[memory.scala 151:47]
      readFunc3Latch <= io_func3; // @[memory.scala 153:20]
    end
    if (reset) begin // @[memory.scala 78:31]
      readDelayCnt <= 8'h0; // @[memory.scala 78:31]
    end else if (readPending & ~rvalidReg) begin // @[memory.scala 160:35]
      if (readDelayCnt > 8'h0) begin // @[memory.scala 161:30]
        if (arReadyCnt > 8'h0) begin // @[memory.scala 163:30]
          readDelayCnt <= _readDelayCnt_T_1; // @[memory.scala 162:20]
        end else begin
          readDelayCnt <= 8'h0; // @[memory.scala 167:22]
        end
      end else begin
        readDelayCnt <= _GEN_2;
      end
    end else begin
      readDelayCnt <= _GEN_2;
    end
    if (reset) begin // @[memory.scala 79:31]
      arReadyCnt <= 8'h0; // @[memory.scala 79:31]
    end else if (readPending & ~rvalidReg) begin // @[memory.scala 160:35]
      if (readDelayCnt > 8'h0) begin // @[memory.scala 161:30]
        if (arReadyCnt > 8'h0) begin // @[memory.scala 163:30]
          arReadyCnt <= _arReadyCnt_T_1; // @[memory.scala 164:20]
        end else begin
          arReadyCnt <= _GEN_3;
        end
      end else begin
        arReadyCnt <= _GEN_3;
      end
    end else begin
      arReadyCnt <= _GEN_3;
    end
    if (reset) begin // @[memory.scala 80:31]
      readPending <= 1'h0; // @[memory.scala 80:31]
    end else if (readPending & ~rvalidReg) begin // @[memory.scala 160:35]
      if (io_arvalid & arreadyReg) begin // @[memory.scala 172:36]
        readPending <= 1'h0; // @[memory.scala 176:19]
      end else begin
        readPending <= _GEN_4;
      end
    end else begin
      readPending <= _GEN_4;
    end
    if (reset) begin // @[memory.scala 85:32]
      awreadyReg <= 1'h0; // @[memory.scala 85:32]
    end else begin
      awreadyReg <= _GEN_30;
    end
    if (reset) begin // @[memory.scala 86:32]
      wreadyReg <= 1'h0; // @[memory.scala 86:32]
    end else begin
      wreadyReg <= _GEN_42;
    end
    if (reset) begin // @[memory.scala 87:32]
      bvalidReg <= 1'h0; // @[memory.scala 87:32]
    end else if (bvalidReg & io_bready) begin // @[memory.scala 248:32]
      bvalidReg <= 1'h0; // @[memory.scala 249:15]
    end else begin
      bvalidReg <= _GEN_45;
    end
    if (reset) begin // @[memory.scala 88:32]
      writeAddrLatch <= 32'h0; // @[memory.scala 88:32]
    end else if (io_awvalid & _pmemWriter_io_en_T & _T & ~writeBlock) begin // @[memory.scala 196:62]
      writeAddrLatch <= io_awaddr; // @[memory.scala 197:20]
    end
    if (reset) begin // @[memory.scala 89:32]
      writeDataLatch <= 32'h0; // @[memory.scala 89:32]
    end else if (io_wvalid & ~wPending & _T & _T_14) begin // @[memory.scala 218:60]
      writeDataLatch <= io_wdata; // @[memory.scala 219:21]
    end
    if (reset) begin // @[memory.scala 90:32]
      writeFunc3Latch <= 3'h0; // @[memory.scala 90:32]
    end else if (io_wvalid & ~wPending & _T & _T_14) begin // @[memory.scala 218:60]
      writeFunc3Latch <= io_func3; // @[memory.scala 220:21]
    end
    if (reset) begin // @[memory.scala 91:32]
      awReadyCnt <= 8'h0; // @[memory.scala 91:32]
    end else if (awPending) begin // @[memory.scala 203:19]
      if (awReadyCnt > 8'h0) begin // @[memory.scala 204:28]
        awReadyCnt <= _awReadyCnt_T_1; // @[memory.scala 205:18]
      end else begin
        awReadyCnt <= _GEN_23;
      end
    end else begin
      awReadyCnt <= _GEN_23;
    end
    if (reset) begin // @[memory.scala 92:32]
      wReadyCnt <= 8'h0; // @[memory.scala 92:32]
    end else if (wPending) begin // @[memory.scala 226:18]
      if (wReadyCnt > 8'h0) begin // @[memory.scala 227:27]
        wReadyCnt <= _wReadyCnt_T_1; // @[memory.scala 228:17]
      end else begin
        wReadyCnt <= _GEN_34;
      end
    end else begin
      wReadyCnt <= _GEN_34;
    end
    if (reset) begin // @[memory.scala 93:32]
      awPending <= 1'h0; // @[memory.scala 93:32]
    end else if (awPending) begin // @[memory.scala 203:19]
      if (io_awvalid & awreadyReg) begin // @[memory.scala 209:36]
        awPending <= 1'h0; // @[memory.scala 211:18]
      end else begin
        awPending <= _GEN_24;
      end
    end else begin
      awPending <= _GEN_24;
    end
    if (reset) begin // @[memory.scala 94:32]
      wPending <= 1'h0; // @[memory.scala 94:32]
    end else if (wPending) begin // @[memory.scala 226:18]
      if (io_wvalid & wreadyReg) begin // @[memory.scala 232:34]
        wPending <= 1'h0; // @[memory.scala 233:20]
      end else begin
        wPending <= _GEN_35;
      end
    end else begin
      wPending <= _GEN_35;
    end
    if (reset) begin // @[memory.scala 95:32]
      writePending <= 1'h0; // @[memory.scala 95:32]
    end else if (_pmemWriter_io_en_T_1) begin // @[memory.scala 242:36]
      writePending <= 1'h0; // @[memory.scala 244:18]
    end else if (wPending) begin // @[memory.scala 226:18]
      writePending <= _GEN_40;
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
  arreadyReg = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  rdataReg = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  rvalidReg = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  readAddrLatch = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  readFunc3Latch = _RAND_4[2:0];
  _RAND_5 = {1{`RANDOM}};
  readDelayCnt = _RAND_5[7:0];
  _RAND_6 = {1{`RANDOM}};
  arReadyCnt = _RAND_6[7:0];
  _RAND_7 = {1{`RANDOM}};
  readPending = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  awreadyReg = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  wreadyReg = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  bvalidReg = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  writeAddrLatch = _RAND_11[31:0];
  _RAND_12 = {1{`RANDOM}};
  writeDataLatch = _RAND_12[31:0];
  _RAND_13 = {1{`RANDOM}};
  writeFunc3Latch = _RAND_13[2:0];
  _RAND_14 = {1{`RANDOM}};
  awReadyCnt = _RAND_14[7:0];
  _RAND_15 = {1{`RANDOM}};
  wReadyCnt = _RAND_15[7:0];
  _RAND_16 = {1{`RANDOM}};
  awPending = _RAND_16[0:0];
  _RAND_17 = {1{`RANDOM}};
  wPending = _RAND_17[0:0];
  _RAND_18 = {1{`RANDOM}};
  writePending = _RAND_18[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_22040080_uart_axi(
  input         clock,
  input         reset,
  input  [31:0] io_araddr,
  input         io_arvalid,
  output        io_arready,
  output [31:0] io_rdata,
  output        io_rvalid,
  input         io_rready,
  input  [31:0] io_awaddr,
  input         io_awvalid,
  output        io_awready,
  input  [31:0] io_wdata,
  input         io_wvalid,
  output        io_wready,
  output        io_bvalid,
  input         io_bready
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
`endif // RANDOMIZE_REG_INIT
  reg [31:0] uartReg; // @[ysyx_22040080_uart_axi.scala 37:24]
  reg  arreadyReg; // @[ysyx_22040080_uart_axi.scala 42:27]
  reg  rvalidReg; // @[ysyx_22040080_uart_axi.scala 43:27]
  reg [31:0] rdataReg; // @[ysyx_22040080_uart_axi.scala 44:27]
  reg  awreadyReg; // @[ysyx_22040080_uart_axi.scala 49:29]
  reg  wreadyReg; // @[ysyx_22040080_uart_axi.scala 50:29]
  reg  bvalidReg; // @[ysyx_22040080_uart_axi.scala 51:29]
  reg [31:0] awaddrLatch; // @[ysyx_22040080_uart_axi.scala 52:29]
  reg [31:0] wdataLatch; // @[ysyx_22040080_uart_axi.scala 53:29]
  reg  awCaptured; // @[ysyx_22040080_uart_axi.scala 54:29]
  reg  wCaptured; // @[ysyx_22040080_uart_axi.scala 55:29]
  wire  _GEN_1 = io_arvalid & arreadyReg | rvalidReg; // @[ysyx_22040080_uart_axi.scala 64:36 66:18 43:27]
  wire  _GEN_2 = io_arvalid & arreadyReg ? 1'h0 : 1'h1; // @[ysyx_22040080_uart_axi.scala 63:16 64:36 67:18]
  wire  _GEN_3 = ~rvalidReg & _GEN_2; // @[ysyx_22040080_uart_axi.scala 60:14 62:20]
  wire  _T_3 = ~bvalidReg; // @[ysyx_22040080_uart_axi.scala 82:8]
  wire  _GEN_8 = io_awvalid & awreadyReg | awCaptured; // @[ysyx_22040080_uart_axi.scala 86:38 88:21 54:29]
  wire  _GEN_9 = io_awvalid & awreadyReg ? 1'h0 : 1'h1; // @[ysyx_22040080_uart_axi.scala 85:18 86:38 89:21]
  wire  _GEN_10 = ~awCaptured & _GEN_9; // @[ysyx_22040080_uart_axi.scala 79:14 84:23]
  wire  _GEN_14 = io_wvalid & wreadyReg | wCaptured; // @[ysyx_22040080_uart_axi.scala 95:36 97:20 55:29]
  wire  _GEN_15 = io_wvalid & wreadyReg ? 1'h0 : 1'h1; // @[ysyx_22040080_uart_axi.scala 94:17 95:36 98:20]
  wire  _GEN_16 = ~wCaptured & _GEN_15; // @[ysyx_22040080_uart_axi.scala 80:14 93:22]
  wire  _T_8 = awCaptured & wCaptured; // @[ysyx_22040080_uart_axi.scala 102:21]
  wire  _T_9 = awaddrLatch == 32'h10000000; // @[ysyx_22040080_uart_axi.scala 103:24]
  wire  _GEN_21 = awCaptured & wCaptured | bvalidReg; // @[ysyx_22040080_uart_axi.scala 102:35 107:18 51:29]
  wire  _GEN_24 = ~bvalidReg & _GEN_10; // @[ysyx_22040080_uart_axi.scala 79:14 82:20]
  wire  _GEN_27 = ~bvalidReg & _GEN_16; // @[ysyx_22040080_uart_axi.scala 80:14 82:20]
  assign io_arready = arreadyReg; // @[ysyx_22040080_uart_axi.scala 121:14]
  assign io_rdata = rdataReg; // @[ysyx_22040080_uart_axi.scala 122:14]
  assign io_rvalid = rvalidReg; // @[ysyx_22040080_uart_axi.scala 123:14]
  assign io_awready = awreadyReg; // @[ysyx_22040080_uart_axi.scala 124:14]
  assign io_wready = wreadyReg; // @[ysyx_22040080_uart_axi.scala 125:14]
  assign io_bvalid = bvalidReg; // @[ysyx_22040080_uart_axi.scala 126:14]
  always @(posedge clock) begin
    if (reset) begin // @[ysyx_22040080_uart_axi.scala 37:24]
      uartReg <= 32'h0; // @[ysyx_22040080_uart_axi.scala 37:24]
    end else if (~bvalidReg) begin // @[ysyx_22040080_uart_axi.scala 82:20]
      if (awCaptured & wCaptured) begin // @[ysyx_22040080_uart_axi.scala 102:35]
        if (awaddrLatch == 32'h10000000) begin // @[ysyx_22040080_uart_axi.scala 103:39]
          uartReg <= wdataLatch; // @[ysyx_22040080_uart_axi.scala 104:17]
        end
      end
    end
    if (reset) begin // @[ysyx_22040080_uart_axi.scala 42:27]
      arreadyReg <= 1'h0; // @[ysyx_22040080_uart_axi.scala 42:27]
    end else begin
      arreadyReg <= _GEN_3;
    end
    if (reset) begin // @[ysyx_22040080_uart_axi.scala 43:27]
      rvalidReg <= 1'h0; // @[ysyx_22040080_uart_axi.scala 43:27]
    end else if (rvalidReg & io_rready) begin // @[ysyx_22040080_uart_axi.scala 72:32]
      rvalidReg <= 1'h0; // @[ysyx_22040080_uart_axi.scala 73:15]
    end else if (~rvalidReg) begin // @[ysyx_22040080_uart_axi.scala 62:20]
      rvalidReg <= _GEN_1;
    end
    if (reset) begin // @[ysyx_22040080_uart_axi.scala 44:27]
      rdataReg <= 32'h0; // @[ysyx_22040080_uart_axi.scala 44:27]
    end else if (~rvalidReg) begin // @[ysyx_22040080_uart_axi.scala 62:20]
      if (io_arvalid & arreadyReg) begin // @[ysyx_22040080_uart_axi.scala 64:36]
        if (io_araddr == 32'h10000000) begin // @[ysyx_22040080_uart_axi.scala 65:24]
          rdataReg <= uartReg;
        end else begin
          rdataReg <= 32'h0;
        end
      end
    end
    if (reset) begin // @[ysyx_22040080_uart_axi.scala 49:29]
      awreadyReg <= 1'h0; // @[ysyx_22040080_uart_axi.scala 49:29]
    end else begin
      awreadyReg <= _GEN_24;
    end
    if (reset) begin // @[ysyx_22040080_uart_axi.scala 50:29]
      wreadyReg <= 1'h0; // @[ysyx_22040080_uart_axi.scala 50:29]
    end else begin
      wreadyReg <= _GEN_27;
    end
    if (reset) begin // @[ysyx_22040080_uart_axi.scala 51:29]
      bvalidReg <= 1'h0; // @[ysyx_22040080_uart_axi.scala 51:29]
    end else if (bvalidReg & io_bready) begin // @[ysyx_22040080_uart_axi.scala 114:32]
      bvalidReg <= 1'h0; // @[ysyx_22040080_uart_axi.scala 115:15]
    end else if (~bvalidReg) begin // @[ysyx_22040080_uart_axi.scala 82:20]
      bvalidReg <= _GEN_21;
    end
    if (reset) begin // @[ysyx_22040080_uart_axi.scala 52:29]
      awaddrLatch <= 32'h0; // @[ysyx_22040080_uart_axi.scala 52:29]
    end else if (~bvalidReg) begin // @[ysyx_22040080_uart_axi.scala 82:20]
      if (~awCaptured) begin // @[ysyx_22040080_uart_axi.scala 84:23]
        if (io_awvalid & awreadyReg) begin // @[ysyx_22040080_uart_axi.scala 86:38]
          awaddrLatch <= io_awaddr; // @[ysyx_22040080_uart_axi.scala 87:21]
        end
      end
    end
    if (reset) begin // @[ysyx_22040080_uart_axi.scala 53:29]
      wdataLatch <= 32'h0; // @[ysyx_22040080_uart_axi.scala 53:29]
    end else if (~bvalidReg) begin // @[ysyx_22040080_uart_axi.scala 82:20]
      if (~wCaptured) begin // @[ysyx_22040080_uart_axi.scala 93:22]
        if (io_wvalid & wreadyReg) begin // @[ysyx_22040080_uart_axi.scala 95:36]
          wdataLatch <= io_wdata; // @[ysyx_22040080_uart_axi.scala 96:20]
        end
      end
    end
    if (reset) begin // @[ysyx_22040080_uart_axi.scala 54:29]
      awCaptured <= 1'h0; // @[ysyx_22040080_uart_axi.scala 54:29]
    end else if (~bvalidReg) begin // @[ysyx_22040080_uart_axi.scala 82:20]
      if (awCaptured & wCaptured) begin // @[ysyx_22040080_uart_axi.scala 102:35]
        awCaptured <= 1'h0; // @[ysyx_22040080_uart_axi.scala 108:18]
      end else if (~awCaptured) begin // @[ysyx_22040080_uart_axi.scala 84:23]
        awCaptured <= _GEN_8;
      end
    end
    if (reset) begin // @[ysyx_22040080_uart_axi.scala 55:29]
      wCaptured <= 1'h0; // @[ysyx_22040080_uart_axi.scala 55:29]
    end else if (~bvalidReg) begin // @[ysyx_22040080_uart_axi.scala 82:20]
      if (awCaptured & wCaptured) begin // @[ysyx_22040080_uart_axi.scala 102:35]
        wCaptured <= 1'h0; // @[ysyx_22040080_uart_axi.scala 109:18]
      end else if (~wCaptured) begin // @[ysyx_22040080_uart_axi.scala 93:22]
        wCaptured <= _GEN_14;
      end
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3 & _T_8 & _T_9 & ~reset) begin
          $fwrite(32'h80000002,"%c",wdataLatch[7:0]); // @[ysyx_22040080_uart_axi.scala 105:15]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
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
  uartReg = _RAND_0[31:0];
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
  awaddrLatch = _RAND_7[31:0];
  _RAND_8 = {1{`RANDOM}};
  wdataLatch = _RAND_8[31:0];
  _RAND_9 = {1{`RANDOM}};
  awCaptured = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  wCaptured = _RAND_10[0:0];
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
  input  [31:0] io_araddr,
  input         io_arvalid,
  output        io_arready,
  output [31:0] io_rdata,
  output        io_rvalid,
  input         io_rready,
  input         io_awvalid,
  output        io_awready,
  input         io_wvalid,
  output        io_wready,
  output        io_bvalid,
  input         io_bready
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
  reg [63:0] mtime; // @[ysyx_22040080_clint_axi.scala 37:22]
  wire [63:0] _mtime_T_1 = mtime + 64'h1; // @[ysyx_22040080_clint_axi.scala 38:18]
  reg  arreadyReg; // @[ysyx_22040080_clint_axi.scala 43:27]
  reg  rvalidReg; // @[ysyx_22040080_clint_axi.scala 44:27]
  reg [31:0] rdataReg; // @[ysyx_22040080_clint_axi.scala 45:27]
  reg  awreadyReg; // @[ysyx_22040080_clint_axi.scala 50:29]
  reg  wreadyReg; // @[ysyx_22040080_clint_axi.scala 51:29]
  reg  bvalidReg; // @[ysyx_22040080_clint_axi.scala 52:29]
  reg  awCaptured; // @[ysyx_22040080_clint_axi.scala 55:29]
  reg  wCaptured; // @[ysyx_22040080_clint_axi.scala 56:29]
  wire [31:0] _GEN_0 = io_araddr == 32'ha000004c ? mtime[63:32] : 32'h0; // @[ysyx_22040080_clint_axi.scala 68:59 69:18 71:18]
  wire  _GEN_3 = io_arvalid & arreadyReg | rvalidReg; // @[ysyx_22040080_clint_axi.scala 65:36 73:18 44:27]
  wire  _GEN_4 = io_arvalid & arreadyReg ? 1'h0 : 1'h1; // @[ysyx_22040080_clint_axi.scala 64:16 65:36 74:18]
  wire  _GEN_5 = ~rvalidReg & _GEN_4; // @[ysyx_22040080_clint_axi.scala 61:14 63:20]
  wire  _GEN_10 = io_awvalid & awreadyReg | awCaptured; // @[ysyx_22040080_clint_axi.scala 93:38 95:21 55:29]
  wire  _GEN_11 = io_awvalid & awreadyReg ? 1'h0 : 1'h1; // @[ysyx_22040080_clint_axi.scala 92:18 93:38 96:21]
  wire  _GEN_12 = ~awCaptured & _GEN_11; // @[ysyx_22040080_clint_axi.scala 86:14 91:23]
  wire  _GEN_16 = io_wvalid & wreadyReg | wCaptured; // @[ysyx_22040080_clint_axi.scala 102:36 104:20 56:29]
  wire  _GEN_17 = io_wvalid & wreadyReg ? 1'h0 : 1'h1; // @[ysyx_22040080_clint_axi.scala 101:17 102:36 105:20]
  wire  _GEN_18 = ~wCaptured & _GEN_17; // @[ysyx_22040080_clint_axi.scala 100:22 87:14]
  wire  _GEN_21 = awCaptured & wCaptured | bvalidReg; // @[ysyx_22040080_clint_axi.scala 109:35 110:18 52:29]
  wire  _GEN_24 = ~bvalidReg & _GEN_12; // @[ysyx_22040080_clint_axi.scala 86:14 89:20]
  wire  _GEN_27 = ~bvalidReg & _GEN_18; // @[ysyx_22040080_clint_axi.scala 87:14 89:20]
  assign io_arready = arreadyReg; // @[ysyx_22040080_clint_axi.scala 124:14]
  assign io_rdata = rdataReg; // @[ysyx_22040080_clint_axi.scala 125:14]
  assign io_rvalid = rvalidReg; // @[ysyx_22040080_clint_axi.scala 126:14]
  assign io_awready = awreadyReg; // @[ysyx_22040080_clint_axi.scala 127:14]
  assign io_wready = wreadyReg; // @[ysyx_22040080_clint_axi.scala 128:14]
  assign io_bvalid = bvalidReg; // @[ysyx_22040080_clint_axi.scala 129:14]
  always @(posedge clock) begin
    if (reset) begin // @[ysyx_22040080_clint_axi.scala 37:22]
      mtime <= 64'h0; // @[ysyx_22040080_clint_axi.scala 37:22]
    end else begin
      mtime <= _mtime_T_1; // @[ysyx_22040080_clint_axi.scala 38:9]
    end
    if (reset) begin // @[ysyx_22040080_clint_axi.scala 43:27]
      arreadyReg <= 1'h0; // @[ysyx_22040080_clint_axi.scala 43:27]
    end else begin
      arreadyReg <= _GEN_5;
    end
    if (reset) begin // @[ysyx_22040080_clint_axi.scala 44:27]
      rvalidReg <= 1'h0; // @[ysyx_22040080_clint_axi.scala 44:27]
    end else if (rvalidReg & io_rready) begin // @[ysyx_22040080_clint_axi.scala 79:32]
      rvalidReg <= 1'h0; // @[ysyx_22040080_clint_axi.scala 80:15]
    end else if (~rvalidReg) begin // @[ysyx_22040080_clint_axi.scala 63:20]
      rvalidReg <= _GEN_3;
    end
    if (reset) begin // @[ysyx_22040080_clint_axi.scala 45:27]
      rdataReg <= 32'h0; // @[ysyx_22040080_clint_axi.scala 45:27]
    end else if (~rvalidReg) begin // @[ysyx_22040080_clint_axi.scala 63:20]
      if (io_arvalid & arreadyReg) begin // @[ysyx_22040080_clint_axi.scala 65:36]
        if (io_araddr == 32'ha0000048) begin // @[ysyx_22040080_clint_axi.scala 66:44]
          rdataReg <= mtime[31:0]; // @[ysyx_22040080_clint_axi.scala 67:18]
        end else begin
          rdataReg <= _GEN_0;
        end
      end
    end
    if (reset) begin // @[ysyx_22040080_clint_axi.scala 50:29]
      awreadyReg <= 1'h0; // @[ysyx_22040080_clint_axi.scala 50:29]
    end else begin
      awreadyReg <= _GEN_24;
    end
    if (reset) begin // @[ysyx_22040080_clint_axi.scala 51:29]
      wreadyReg <= 1'h0; // @[ysyx_22040080_clint_axi.scala 51:29]
    end else begin
      wreadyReg <= _GEN_27;
    end
    if (reset) begin // @[ysyx_22040080_clint_axi.scala 52:29]
      bvalidReg <= 1'h0; // @[ysyx_22040080_clint_axi.scala 52:29]
    end else if (bvalidReg & io_bready) begin // @[ysyx_22040080_clint_axi.scala 117:32]
      bvalidReg <= 1'h0; // @[ysyx_22040080_clint_axi.scala 118:15]
    end else if (~bvalidReg) begin // @[ysyx_22040080_clint_axi.scala 89:20]
      bvalidReg <= _GEN_21;
    end
    if (reset) begin // @[ysyx_22040080_clint_axi.scala 55:29]
      awCaptured <= 1'h0; // @[ysyx_22040080_clint_axi.scala 55:29]
    end else if (~bvalidReg) begin // @[ysyx_22040080_clint_axi.scala 89:20]
      if (awCaptured & wCaptured) begin // @[ysyx_22040080_clint_axi.scala 109:35]
        awCaptured <= 1'h0; // @[ysyx_22040080_clint_axi.scala 111:18]
      end else if (~awCaptured) begin // @[ysyx_22040080_clint_axi.scala 91:23]
        awCaptured <= _GEN_10;
      end
    end
    if (reset) begin // @[ysyx_22040080_clint_axi.scala 56:29]
      wCaptured <= 1'h0; // @[ysyx_22040080_clint_axi.scala 56:29]
    end else if (~bvalidReg) begin // @[ysyx_22040080_clint_axi.scala 89:20]
      if (awCaptured & wCaptured) begin // @[ysyx_22040080_clint_axi.scala 109:35]
        wCaptured <= 1'h0; // @[ysyx_22040080_clint_axi.scala 112:18]
      end else if (~wCaptured) begin // @[ysyx_22040080_clint_axi.scala 100:22]
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
  input         io_wen,
  input  [11:0] io_csr_addr,
  output [31:0] io_rdata,
  input  [31:0] io_wdata,
  output [31:0] io_mepc,
  output [31:0] io_mtvec,
  input         io_trap_valid,
  input  [31:0] io_trap_mepc,
  input  [31:0] io_trap_mcause
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
`endif // RANDOMIZE_REG_INIT
  wire  csrWriteCommit_clk; // @[ysyx_22040080_csr.scala 131:30]
  wire  csrWriteCommit_en; // @[ysyx_22040080_csr.scala 131:30]
  wire [31:0] csrWriteCommit_addr; // @[ysyx_22040080_csr.scala 131:30]
  wire [31:0] csrWriteCommit_wdata; // @[ysyx_22040080_csr.scala 131:30]
  wire  getCsrInfo_clk; // @[ysyx_22040080_csr.scala 140:26]
  wire [31:0] getCsrInfo_mstatus; // @[ysyx_22040080_csr.scala 140:26]
  wire [31:0] getCsrInfo_mepc; // @[ysyx_22040080_csr.scala 140:26]
  wire [31:0] getCsrInfo_mcause; // @[ysyx_22040080_csr.scala 140:26]
  wire [31:0] getCsrInfo_mtvec; // @[ysyx_22040080_csr.scala 140:26]
  wire [31:0] getCsrInfo_mvendorid; // @[ysyx_22040080_csr.scala 140:26]
  wire [31:0] getCsrInfo_marchid; // @[ysyx_22040080_csr.scala 140:26]
  reg [63:0] mcycleFullReg; // @[ysyx_22040080_csr.scala 120:30]
  reg [31:0] mepcReg; // @[ysyx_22040080_csr.scala 123:30]
  reg [31:0] mcauseReg; // @[ysyx_22040080_csr.scala 124:30]
  reg [31:0] mstatusReg; // @[ysyx_22040080_csr.scala 125:30]
  reg [31:0] mtvecReg; // @[ysyx_22040080_csr.scala 126:30]
  wire  _io_rdata_T_2 = 12'hb00 == io_csr_addr; // @[Mux.scala 81:61]
  wire [31:0] _io_rdata_T_3 = 12'hb00 == io_csr_addr ? mcycleFullReg[31:0] : 32'h0; // @[Mux.scala 81:58]
  wire  _io_rdata_T_4 = 12'hb80 == io_csr_addr; // @[Mux.scala 81:61]
  wire [31:0] _io_rdata_T_5 = 12'hb80 == io_csr_addr ? mcycleFullReg[63:32] : _io_rdata_T_3; // @[Mux.scala 81:58]
  wire [31:0] _io_rdata_T_7 = 12'hf11 == io_csr_addr ? 32'h79737978 : _io_rdata_T_5; // @[Mux.scala 81:58]
  wire [31:0] _io_rdata_T_9 = 12'hf12 == io_csr_addr ? 32'h78797368 : _io_rdata_T_7; // @[Mux.scala 81:58]
  wire  _io_rdata_T_10 = 12'h341 == io_csr_addr; // @[Mux.scala 81:61]
  wire [31:0] _io_rdata_T_11 = 12'h341 == io_csr_addr ? mepcReg : _io_rdata_T_9; // @[Mux.scala 81:58]
  wire  _io_rdata_T_12 = 12'h342 == io_csr_addr; // @[Mux.scala 81:61]
  wire [31:0] _io_rdata_T_13 = 12'h342 == io_csr_addr ? mcauseReg : _io_rdata_T_11; // @[Mux.scala 81:58]
  wire  _io_rdata_T_14 = 12'h305 == io_csr_addr; // @[Mux.scala 81:61]
  wire [31:0] _io_rdata_T_15 = 12'h305 == io_csr_addr ? mtvecReg : _io_rdata_T_13; // @[Mux.scala 81:58]
  wire  _io_rdata_T_16 = 12'h300 == io_csr_addr; // @[Mux.scala 81:61]
  wire [63:0] _mcycleFullReg_T_1 = mcycleFullReg + 64'h1; // @[ysyx_22040080_csr.scala 166:34]
  wire [31:0] _csrWriteCommit_io_addr_T = {20'h0,io_csr_addr}; // @[Cat.scala 31:58]
  wire [63:0] _mcycleFullReg_T_3 = {mcycleFullReg[63:32],io_wdata}; // @[Cat.scala 31:58]
  wire [63:0] _mcycleFullReg_T_5 = {io_wdata,mcycleFullReg[31:0]}; // @[Cat.scala 31:58]
  wire [31:0] _GEN_0 = _io_rdata_T_16 ? io_wdata : mstatusReg; // @[ysyx_22040080_csr.scala 178:25 125:30 184:36]
  wire [31:0] _GEN_1 = _io_rdata_T_14 ? io_wdata : mtvecReg; // @[ysyx_22040080_csr.scala 178:25 126:30 183:36]
  wire [31:0] _GEN_2 = _io_rdata_T_14 ? mstatusReg : _GEN_0; // @[ysyx_22040080_csr.scala 178:25 125:30]
  wire [31:0] _GEN_3 = _io_rdata_T_12 ? io_wdata : mcauseReg; // @[ysyx_22040080_csr.scala 178:25 124:30 182:36]
  wire [31:0] _GEN_4 = _io_rdata_T_12 ? mtvecReg : _GEN_1; // @[ysyx_22040080_csr.scala 178:25 126:30]
  wire [31:0] _GEN_5 = _io_rdata_T_12 ? mstatusReg : _GEN_2; // @[ysyx_22040080_csr.scala 178:25 125:30]
  wire [31:0] _GEN_6 = _io_rdata_T_10 ? io_wdata : mepcReg; // @[ysyx_22040080_csr.scala 178:25 123:30 181:36]
  wire [31:0] _GEN_7 = _io_rdata_T_10 ? mcauseReg : _GEN_3; // @[ysyx_22040080_csr.scala 178:25 124:30]
  wire [31:0] _GEN_8 = _io_rdata_T_10 ? mtvecReg : _GEN_4; // @[ysyx_22040080_csr.scala 178:25 126:30]
  wire [31:0] _GEN_9 = _io_rdata_T_10 ? mstatusReg : _GEN_5; // @[ysyx_22040080_csr.scala 178:25 125:30]
  wire [31:0] _GEN_11 = _io_rdata_T_4 ? mepcReg : _GEN_6; // @[ysyx_22040080_csr.scala 178:25 123:30]
  wire [31:0] _GEN_12 = _io_rdata_T_4 ? mcauseReg : _GEN_7; // @[ysyx_22040080_csr.scala 178:25 124:30]
  csr_write_commit_wrapper csrWriteCommit ( // @[ysyx_22040080_csr.scala 131:30]
    .clk(csrWriteCommit_clk),
    .en(csrWriteCommit_en),
    .addr(csrWriteCommit_addr),
    .wdata(csrWriteCommit_wdata)
  );
  get_csr_info_wrapper getCsrInfo ( // @[ysyx_22040080_csr.scala 140:26]
    .clk(getCsrInfo_clk),
    .mstatus(getCsrInfo_mstatus),
    .mepc(getCsrInfo_mepc),
    .mcause(getCsrInfo_mcause),
    .mtvec(getCsrInfo_mtvec),
    .mvendorid(getCsrInfo_mvendorid),
    .marchid(getCsrInfo_marchid)
  );
  assign io_rdata = 12'h300 == io_csr_addr ? mstatusReg : _io_rdata_T_15; // @[Mux.scala 81:58]
  assign io_mepc = mepcReg; // @[ysyx_22040080_csr.scala 205:18]
  assign io_mtvec = mtvecReg; // @[ysyx_22040080_csr.scala 208:18]
  assign csrWriteCommit_clk = clock; // @[ysyx_22040080_csr.scala 132:27]
  assign csrWriteCommit_en = io_wen & io_csr_addr != 12'h0; // @[ysyx_22040080_csr.scala 172:16 133:27 174:29]
  assign csrWriteCommit_addr = io_wen ? _csrWriteCommit_io_addr_T : 32'h0; // @[ysyx_22040080_csr.scala 172:16 134:27 175:29]
  assign csrWriteCommit_wdata = io_wen ? io_wdata : 32'h0; // @[ysyx_22040080_csr.scala 172:16 135:27 176:29]
  assign getCsrInfo_clk = clock; // @[ysyx_22040080_csr.scala 141:27]
  assign getCsrInfo_mstatus = mstatusReg; // @[ysyx_22040080_csr.scala 142:27]
  assign getCsrInfo_mepc = mepcReg; // @[ysyx_22040080_csr.scala 143:27]
  assign getCsrInfo_mcause = mcauseReg; // @[ysyx_22040080_csr.scala 144:27]
  assign getCsrInfo_mtvec = mtvecReg; // @[ysyx_22040080_csr.scala 145:27]
  assign getCsrInfo_mvendorid = 32'h79737978; // @[ysyx_22040080_csr.scala 146:27]
  assign getCsrInfo_marchid = 32'h78797368; // @[ysyx_22040080_csr.scala 147:27]
  always @(posedge clock) begin
    if (reset) begin // @[ysyx_22040080_csr.scala 120:30]
      mcycleFullReg <= 64'h0; // @[ysyx_22040080_csr.scala 120:30]
    end else if (io_wen) begin // @[ysyx_22040080_csr.scala 172:16]
      if (_io_rdata_T_2) begin // @[ysyx_22040080_csr.scala 178:25]
        mcycleFullReg <= _mcycleFullReg_T_3; // @[ysyx_22040080_csr.scala 179:39]
      end else if (_io_rdata_T_4) begin // @[ysyx_22040080_csr.scala 178:25]
        mcycleFullReg <= _mcycleFullReg_T_5; // @[ysyx_22040080_csr.scala 180:39]
      end else begin
        mcycleFullReg <= _mcycleFullReg_T_1; // @[ysyx_22040080_csr.scala 166:17]
      end
    end else begin
      mcycleFullReg <= _mcycleFullReg_T_1; // @[ysyx_22040080_csr.scala 166:17]
    end
    if (reset) begin // @[ysyx_22040080_csr.scala 123:30]
      mepcReg <= 32'h0; // @[ysyx_22040080_csr.scala 123:30]
    end else if (io_trap_valid) begin // @[ysyx_22040080_csr.scala 192:23]
      mepcReg <= io_trap_mepc; // @[ysyx_22040080_csr.scala 193:15]
    end else if (io_wen) begin // @[ysyx_22040080_csr.scala 172:16]
      if (!(_io_rdata_T_2)) begin // @[ysyx_22040080_csr.scala 178:25]
        mepcReg <= _GEN_11;
      end
    end
    if (reset) begin // @[ysyx_22040080_csr.scala 124:30]
      mcauseReg <= 32'h0; // @[ysyx_22040080_csr.scala 124:30]
    end else if (io_trap_valid) begin // @[ysyx_22040080_csr.scala 192:23]
      mcauseReg <= io_trap_mcause; // @[ysyx_22040080_csr.scala 194:15]
    end else if (io_wen) begin // @[ysyx_22040080_csr.scala 172:16]
      if (!(_io_rdata_T_2)) begin // @[ysyx_22040080_csr.scala 178:25]
        mcauseReg <= _GEN_12;
      end
    end
    if (reset) begin // @[ysyx_22040080_csr.scala 125:30]
      mstatusReg <= 32'h1800; // @[ysyx_22040080_csr.scala 125:30]
    end else if (io_wen) begin // @[ysyx_22040080_csr.scala 172:16]
      if (!(_io_rdata_T_2)) begin // @[ysyx_22040080_csr.scala 178:25]
        if (!(_io_rdata_T_4)) begin // @[ysyx_22040080_csr.scala 178:25]
          mstatusReg <= _GEN_9;
        end
      end
    end
    if (reset) begin // @[ysyx_22040080_csr.scala 126:30]
      mtvecReg <= 32'h0; // @[ysyx_22040080_csr.scala 126:30]
    end else if (io_wen) begin // @[ysyx_22040080_csr.scala 172:16]
      if (!(_io_rdata_T_2)) begin // @[ysyx_22040080_csr.scala 178:25]
        if (!(_io_rdata_T_4)) begin // @[ysyx_22040080_csr.scala 178:25]
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
  input  [31:0] io_mem_addr,
  input  [31:0] io_mem_wdata,
  input  [2:0]  io_func3,
  input         io_is_load,
  input         io_is_store,
  output [31:0] io_load_data,
  output [2:0]  io_lsu_func3,
  input         io_lsu_reqValid,
  output        io_lsu_reqReady,
  output        io_lsu_respValid,
  input         io_lsu_respReady,
  output [31:0] io_araddr,
  output        io_arvalid,
  input         io_arready,
  input  [31:0] io_rdata,
  input         io_rvalid,
  output        io_rready,
  output [31:0] io_awaddr,
  output        io_awvalid,
  input         io_awready,
  output [31:0] io_wdata,
  output        io_wvalid,
  input         io_wready,
  input         io_bvalid,
  output        io_bready
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
`endif // RANDOMIZE_REG_INIT
  reg [31:0] loadDataReg; // @[ysyx_22040080_lsu.scala 54:32]
  reg [2:0] lsuFunc3Reg; // @[ysyx_22040080_lsu.scala 55:32]
  reg  lsuReqReadyReg; // @[ysyx_22040080_lsu.scala 56:32]
  reg  lsuRespValidReg; // @[ysyx_22040080_lsu.scala 57:32]
  reg [31:0] araddrReg; // @[ysyx_22040080_lsu.scala 62:27]
  reg  arvalidReg; // @[ysyx_22040080_lsu.scala 63:27]
  reg  rreadyReg; // @[ysyx_22040080_lsu.scala 64:27]
  reg [31:0] awaddrReg; // @[ysyx_22040080_lsu.scala 65:27]
  reg  awvalidReg; // @[ysyx_22040080_lsu.scala 66:27]
  reg [31:0] wdataReg; // @[ysyx_22040080_lsu.scala 67:27]
  reg  wvalidReg; // @[ysyx_22040080_lsu.scala 68:27]
  reg  breadyReg; // @[ysyx_22040080_lsu.scala 69:27]
  reg  isLoadLatch; // @[ysyx_22040080_lsu.scala 77:30]
  reg  isStoreLatch; // @[ysyx_22040080_lsu.scala 78:30]
  reg  reqPending; // @[ysyx_22040080_lsu.scala 79:30]
  reg  awHandshakeDone; // @[ysyx_22040080_lsu.scala 85:32]
  reg  wHandshakeDone; // @[ysyx_22040080_lsu.scala 86:32]
  wire  _GEN_1 = io_is_load | arvalidReg; // @[ysyx_22040080_lsu.scala 107:22 109:18 63:27]
  wire  _GEN_3 = io_is_store | awvalidReg; // @[ysyx_22040080_lsu.scala 113:23 115:18 66:27]
  wire  _GEN_5 = io_is_store | wvalidReg; // @[ysyx_22040080_lsu.scala 113:23 117:18 68:27]
  wire  _GEN_6 = io_is_store | breadyReg; // @[ysyx_22040080_lsu.scala 113:23 118:18 69:27]
  wire  _GEN_13 = io_lsu_reqValid & ~reqPending | reqPending; // @[ysyx_22040080_lsu.scala 104:19 79:30 96:40]
  wire  _GEN_15 = io_lsu_reqValid & ~reqPending ? _GEN_1 : arvalidReg; // @[ysyx_22040080_lsu.scala 63:27 96:40]
  wire  _GEN_17 = io_lsu_reqValid & ~reqPending ? _GEN_3 : awvalidReg; // @[ysyx_22040080_lsu.scala 66:27 96:40]
  wire  _GEN_19 = io_lsu_reqValid & ~reqPending ? _GEN_5 : wvalidReg; // @[ysyx_22040080_lsu.scala 68:27 96:40]
  wire  _GEN_20 = io_lsu_reqValid & ~reqPending ? _GEN_6 : breadyReg; // @[ysyx_22040080_lsu.scala 69:27 96:40]
  wire  _T_2 = arvalidReg & io_arready; // @[ysyx_22040080_lsu.scala 126:21]
  wire  _GEN_23 = arvalidReg & io_arready | rreadyReg; // @[ysyx_22040080_lsu.scala 126:36 129:22 64:27]
  wire  _GEN_25 = io_rvalid & rreadyReg | lsuRespValidReg; // @[ysyx_22040080_lsu.scala 135:34 137:23 57:32]
  wire  _GEN_28 = isLoadLatch & _T_2; // @[ysyx_22040080_lsu.scala 125:21 91:18]
  wire  _GEN_31 = isLoadLatch ? _GEN_25 : lsuRespValidReg; // @[ysyx_22040080_lsu.scala 125:21 57:32]
  wire  _GEN_33 = awvalidReg & io_awready | awHandshakeDone; // @[ysyx_22040080_lsu.scala 146:36 148:23 85:32]
  wire  _GEN_35 = wvalidReg & io_wready | _GEN_28; // @[ysyx_22040080_lsu.scala 154:34 156:23]
  wire  _GEN_36 = wvalidReg & io_wready | wHandshakeDone; // @[ysyx_22040080_lsu.scala 154:34 157:23 86:32]
  wire  _GEN_42 = io_bvalid & breadyReg | _GEN_31; // @[ysyx_22040080_lsu.scala 167:34 168:23]
  assign io_load_data = loadDataReg; // @[ysyx_22040080_lsu.scala 190:20]
  assign io_lsu_func3 = lsuFunc3Reg; // @[ysyx_22040080_lsu.scala 191:20]
  assign io_lsu_reqReady = lsuReqReadyReg; // @[ysyx_22040080_lsu.scala 192:20]
  assign io_lsu_respValid = lsuRespValidReg; // @[ysyx_22040080_lsu.scala 193:20]
  assign io_araddr = araddrReg; // @[ysyx_22040080_lsu.scala 195:14]
  assign io_arvalid = arvalidReg; // @[ysyx_22040080_lsu.scala 196:14]
  assign io_rready = rreadyReg; // @[ysyx_22040080_lsu.scala 197:14]
  assign io_awaddr = awaddrReg; // @[ysyx_22040080_lsu.scala 199:14]
  assign io_awvalid = awvalidReg; // @[ysyx_22040080_lsu.scala 200:14]
  assign io_wdata = wdataReg; // @[ysyx_22040080_lsu.scala 201:14]
  assign io_wvalid = wvalidReg; // @[ysyx_22040080_lsu.scala 202:14]
  assign io_bready = breadyReg; // @[ysyx_22040080_lsu.scala 203:14]
  always @(posedge clock) begin
    if (reset) begin // @[ysyx_22040080_lsu.scala 54:32]
      loadDataReg <= 32'h0; // @[ysyx_22040080_lsu.scala 54:32]
    end else if (isLoadLatch) begin // @[ysyx_22040080_lsu.scala 125:21]
      if (io_rvalid & rreadyReg) begin // @[ysyx_22040080_lsu.scala 135:34]
        loadDataReg <= io_rdata; // @[ysyx_22040080_lsu.scala 136:23]
      end
    end
    if (reset) begin // @[ysyx_22040080_lsu.scala 55:32]
      lsuFunc3Reg <= 3'h0; // @[ysyx_22040080_lsu.scala 55:32]
    end else if (io_lsu_reqValid & ~reqPending) begin // @[ysyx_22040080_lsu.scala 96:40]
      lsuFunc3Reg <= io_func3; // @[ysyx_22040080_lsu.scala 101:19]
    end
    if (reset) begin // @[ysyx_22040080_lsu.scala 56:32]
      lsuReqReadyReg <= 1'h0; // @[ysyx_22040080_lsu.scala 56:32]
    end else if (isStoreLatch) begin // @[ysyx_22040080_lsu.scala 145:22]
      lsuReqReadyReg <= _GEN_35;
    end else begin
      lsuReqReadyReg <= _GEN_28;
    end
    if (reset) begin // @[ysyx_22040080_lsu.scala 57:32]
      lsuRespValidReg <= 1'h0; // @[ysyx_22040080_lsu.scala 57:32]
    end else if (reqPending & lsuRespValidReg & io_lsu_respReady) begin // @[ysyx_22040080_lsu.scala 177:59]
      lsuRespValidReg <= 1'h0; // @[ysyx_22040080_lsu.scala 178:21]
    end else if (isStoreLatch & awHandshakeDone & wHandshakeDone) begin // @[ysyx_22040080_lsu.scala 166:59]
      lsuRespValidReg <= _GEN_42;
    end else if (isLoadLatch) begin // @[ysyx_22040080_lsu.scala 125:21]
      lsuRespValidReg <= _GEN_25;
    end
    if (reset) begin // @[ysyx_22040080_lsu.scala 62:27]
      araddrReg <= 32'h0; // @[ysyx_22040080_lsu.scala 62:27]
    end else if (io_lsu_reqValid & ~reqPending) begin // @[ysyx_22040080_lsu.scala 96:40]
      if (io_is_load) begin // @[ysyx_22040080_lsu.scala 107:22]
        araddrReg <= io_mem_addr; // @[ysyx_22040080_lsu.scala 108:18]
      end
    end
    if (reset) begin // @[ysyx_22040080_lsu.scala 63:27]
      arvalidReg <= 1'h0; // @[ysyx_22040080_lsu.scala 63:27]
    end else if (isLoadLatch) begin // @[ysyx_22040080_lsu.scala 125:21]
      if (arvalidReg & io_arready) begin // @[ysyx_22040080_lsu.scala 126:36]
        arvalidReg <= 1'h0; // @[ysyx_22040080_lsu.scala 127:22]
      end else begin
        arvalidReg <= _GEN_15;
      end
    end else begin
      arvalidReg <= _GEN_15;
    end
    if (reset) begin // @[ysyx_22040080_lsu.scala 64:27]
      rreadyReg <= 1'h0; // @[ysyx_22040080_lsu.scala 64:27]
    end else if (isLoadLatch) begin // @[ysyx_22040080_lsu.scala 125:21]
      if (io_rvalid & rreadyReg) begin // @[ysyx_22040080_lsu.scala 135:34]
        rreadyReg <= 1'h0; // @[ysyx_22040080_lsu.scala 138:23]
      end else begin
        rreadyReg <= _GEN_23;
      end
    end
    if (reset) begin // @[ysyx_22040080_lsu.scala 65:27]
      awaddrReg <= 32'h0; // @[ysyx_22040080_lsu.scala 65:27]
    end else if (io_lsu_reqValid & ~reqPending) begin // @[ysyx_22040080_lsu.scala 96:40]
      if (io_is_store) begin // @[ysyx_22040080_lsu.scala 113:23]
        awaddrReg <= io_mem_addr; // @[ysyx_22040080_lsu.scala 114:18]
      end
    end
    if (reset) begin // @[ysyx_22040080_lsu.scala 66:27]
      awvalidReg <= 1'h0; // @[ysyx_22040080_lsu.scala 66:27]
    end else if (isStoreLatch) begin // @[ysyx_22040080_lsu.scala 145:22]
      if (awvalidReg & io_awready) begin // @[ysyx_22040080_lsu.scala 146:36]
        awvalidReg <= 1'h0; // @[ysyx_22040080_lsu.scala 147:23]
      end else begin
        awvalidReg <= _GEN_17;
      end
    end else begin
      awvalidReg <= _GEN_17;
    end
    if (reset) begin // @[ysyx_22040080_lsu.scala 67:27]
      wdataReg <= 32'h0; // @[ysyx_22040080_lsu.scala 67:27]
    end else if (io_lsu_reqValid & ~reqPending) begin // @[ysyx_22040080_lsu.scala 96:40]
      if (io_is_store) begin // @[ysyx_22040080_lsu.scala 113:23]
        wdataReg <= io_mem_wdata; // @[ysyx_22040080_lsu.scala 116:18]
      end
    end
    if (reset) begin // @[ysyx_22040080_lsu.scala 68:27]
      wvalidReg <= 1'h0; // @[ysyx_22040080_lsu.scala 68:27]
    end else if (isStoreLatch) begin // @[ysyx_22040080_lsu.scala 145:22]
      if (wvalidReg & io_wready) begin // @[ysyx_22040080_lsu.scala 154:34]
        wvalidReg <= 1'h0; // @[ysyx_22040080_lsu.scala 155:23]
      end else begin
        wvalidReg <= _GEN_19;
      end
    end else begin
      wvalidReg <= _GEN_19;
    end
    if (reset) begin // @[ysyx_22040080_lsu.scala 69:27]
      breadyReg <= 1'h0; // @[ysyx_22040080_lsu.scala 69:27]
    end else if (isStoreLatch & awHandshakeDone & wHandshakeDone) begin // @[ysyx_22040080_lsu.scala 166:59]
      if (io_bvalid & breadyReg) begin // @[ysyx_22040080_lsu.scala 167:34]
        breadyReg <= 1'h0; // @[ysyx_22040080_lsu.scala 169:23]
      end else begin
        breadyReg <= _GEN_20;
      end
    end else begin
      breadyReg <= _GEN_20;
    end
    if (reset) begin // @[ysyx_22040080_lsu.scala 77:30]
      isLoadLatch <= 1'h0; // @[ysyx_22040080_lsu.scala 77:30]
    end else if (reqPending & lsuRespValidReg & io_lsu_respReady) begin // @[ysyx_22040080_lsu.scala 177:59]
      isLoadLatch <= 1'h0; // @[ysyx_22040080_lsu.scala 180:21]
    end else if (io_lsu_reqValid & ~reqPending) begin // @[ysyx_22040080_lsu.scala 96:40]
      isLoadLatch <= io_is_load; // @[ysyx_22040080_lsu.scala 102:19]
    end
    if (reset) begin // @[ysyx_22040080_lsu.scala 78:30]
      isStoreLatch <= 1'h0; // @[ysyx_22040080_lsu.scala 78:30]
    end else if (reqPending & lsuRespValidReg & io_lsu_respReady) begin // @[ysyx_22040080_lsu.scala 177:59]
      isStoreLatch <= 1'h0; // @[ysyx_22040080_lsu.scala 181:21]
    end else if (io_lsu_reqValid & ~reqPending) begin // @[ysyx_22040080_lsu.scala 96:40]
      isStoreLatch <= io_is_store; // @[ysyx_22040080_lsu.scala 103:19]
    end
    if (reset) begin // @[ysyx_22040080_lsu.scala 79:30]
      reqPending <= 1'h0; // @[ysyx_22040080_lsu.scala 79:30]
    end else if (reqPending & lsuRespValidReg & io_lsu_respReady) begin // @[ysyx_22040080_lsu.scala 177:59]
      reqPending <= 1'h0; // @[ysyx_22040080_lsu.scala 179:21]
    end else begin
      reqPending <= _GEN_13;
    end
    if (reset) begin // @[ysyx_22040080_lsu.scala 85:32]
      awHandshakeDone <= 1'h0; // @[ysyx_22040080_lsu.scala 85:32]
    end else if (reqPending & lsuRespValidReg & io_lsu_respReady) begin // @[ysyx_22040080_lsu.scala 177:59]
      awHandshakeDone <= 1'h0; // @[ysyx_22040080_lsu.scala 183:21]
    end else if (isStoreLatch) begin // @[ysyx_22040080_lsu.scala 145:22]
      awHandshakeDone <= _GEN_33;
    end
    if (reset) begin // @[ysyx_22040080_lsu.scala 86:32]
      wHandshakeDone <= 1'h0; // @[ysyx_22040080_lsu.scala 86:32]
    end else if (reqPending & lsuRespValidReg & io_lsu_respReady) begin // @[ysyx_22040080_lsu.scala 177:59]
      wHandshakeDone <= 1'h0; // @[ysyx_22040080_lsu.scala 184:21]
    end else if (isStoreLatch) begin // @[ysyx_22040080_lsu.scala 145:22]
      wHandshakeDone <= _GEN_36;
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
  isLoadLatch = _RAND_12[0:0];
  _RAND_13 = {1{`RANDOM}};
  isStoreLatch = _RAND_13[0:0];
  _RAND_14 = {1{`RANDOM}};
  reqPending = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  awHandshakeDone = _RAND_15[0:0];
  _RAND_16 = {1{`RANDOM}};
  wHandshakeDone = _RAND_16[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ysyx_22040080_idu(
  input  [31:0] io_rdata,
  input         io_inst_active,
  output [4:0]  io_rs1,
  output [4:0]  io_rs2,
  output [4:0]  io_rd,
  output [2:0]  io_func3,
  output [31:0] io_imm_ext,
  output [6:0]  io_op,
  output [6:0]  io_func7,
  output [4:0]  io_shamt,
  output [11:0] io_csr_addr,
  output        io_is_jal,
  output        io_is_jalr,
  output        io_is_branch,
  output        io_is_load,
  output        io_is_store,
  output        io_lsu_reqValid
);
  wire [6:0] opcode = io_inst_active ? io_rdata[6:0] : 7'h0; // @[ysyx_22040080_idu.scala 84:24 93:12]
  wire  _io_shamt_T = opcode == 7'h13; // @[ysyx_22040080_idu.scala 99:28]
  wire [2:0] funct3 = io_inst_active ? io_rdata[14:12] : 3'h0; // @[ysyx_22040080_idu.scala 84:24 94:12]
  wire [4:0] _io_shamt_T_5 = opcode == 7'h13 & funct3[1:0] == 2'h1 ? io_rdata[24:20] : 5'h0; // @[ysyx_22040080_idu.scala 99:20]
  wire  _instrType_T = opcode == 7'h33; // @[ysyx_22040080_idu.scala 106:15]
  wire  _instrType_T_2 = opcode == 7'h3; // @[ysyx_22040080_idu.scala 108:15]
  wire  _instrType_T_3 = opcode == 7'h67; // @[ysyx_22040080_idu.scala 109:15]
  wire  _instrType_T_4 = opcode == 7'h73; // @[ysyx_22040080_idu.scala 110:15]
  wire  _instrType_T_5 = opcode == 7'h23; // @[ysyx_22040080_idu.scala 111:15]
  wire  _instrType_T_6 = opcode == 7'h63; // @[ysyx_22040080_idu.scala 112:15]
  wire  _instrType_T_7 = opcode == 7'h37; // @[ysyx_22040080_idu.scala 113:15]
  wire  _instrType_T_8 = opcode == 7'h17; // @[ysyx_22040080_idu.scala 114:15]
  wire  _instrType_T_9 = opcode == 7'h6f; // @[ysyx_22040080_idu.scala 115:15]
  wire [2:0] _instrType_T_10 = _instrType_T_9 ? 3'h5 : 3'h7; // @[Mux.scala 101:16]
  wire [2:0] _instrType_T_11 = _instrType_T_8 ? 3'h4 : _instrType_T_10; // @[Mux.scala 101:16]
  wire [2:0] _instrType_T_12 = _instrType_T_7 ? 3'h4 : _instrType_T_11; // @[Mux.scala 101:16]
  wire [2:0] _instrType_T_13 = _instrType_T_6 ? 3'h3 : _instrType_T_12; // @[Mux.scala 101:16]
  wire [2:0] _instrType_T_14 = _instrType_T_5 ? 3'h2 : _instrType_T_13; // @[Mux.scala 101:16]
  wire [2:0] _instrType_T_15 = _instrType_T_4 ? 3'h1 : _instrType_T_14; // @[Mux.scala 101:16]
  wire [2:0] _instrType_T_16 = _instrType_T_3 ? 3'h1 : _instrType_T_15; // @[Mux.scala 101:16]
  wire [2:0] _instrType_T_17 = _instrType_T_2 ? 3'h1 : _instrType_T_16; // @[Mux.scala 101:16]
  wire [2:0] _instrType_T_18 = _io_shamt_T ? 3'h1 : _instrType_T_17; // @[Mux.scala 101:16]
  wire [2:0] _instrType_T_19 = _instrType_T ? 3'h0 : _instrType_T_18; // @[Mux.scala 101:16]
  wire [2:0] instrType = io_inst_active ? _instrType_T_19 : 3'h7; // @[ysyx_22040080_idu.scala 105:15 84:24]
  wire [19:0] _immExt_T_2 = io_rdata[31] ? 20'hfffff : 20'h0; // @[Bitwise.scala 74:12]
  wire [31:0] _immExt_T_4 = {_immExt_T_2,io_rdata[31:20]}; // @[Cat.scala 31:58]
  wire [31:0] _immExt_T_10 = {_immExt_T_2,io_rdata[31:25],io_rdata[11:7]}; // @[Cat.scala 31:58]
  wire [31:0] _immExt_T_17 = {_immExt_T_2,io_rdata[7],io_rdata[30:25],io_rdata[11:8],1'h0}; // @[Cat.scala 31:58]
  wire [31:0] _immExt_T_19 = {io_rdata[31:12],12'h0}; // @[Cat.scala 31:58]
  wire [11:0] _immExt_T_22 = io_rdata[31] ? 12'hfff : 12'h0; // @[Bitwise.scala 74:12]
  wire [31:0] _immExt_T_26 = {_immExt_T_22,io_rdata[19:12],io_rdata[20],io_rdata[30:21],1'h0}; // @[Cat.scala 31:58]
  wire [31:0] _GEN_0 = 3'h5 == instrType ? _immExt_T_26 : 32'h0; // @[ysyx_22040080_idu.scala 132:23 151:16]
  wire [31:0] _GEN_1 = 3'h4 == instrType ? _immExt_T_19 : _GEN_0; // @[ysyx_22040080_idu.scala 132:23 147:16]
  wire [31:0] _GEN_2 = 3'h3 == instrType ? _immExt_T_17 : _GEN_1; // @[ysyx_22040080_idu.scala 132:23 143:16]
  wire [31:0] _GEN_3 = 3'h2 == instrType ? _immExt_T_10 : _GEN_2; // @[ysyx_22040080_idu.scala 132:23 139:16]
  wire [31:0] _GEN_4 = 3'h1 == instrType ? _immExt_T_4 : _GEN_3; // @[ysyx_22040080_idu.scala 132:23 135:16]
  wire [31:0] immExt = io_inst_active ? _GEN_4 : 32'h0; // @[ysyx_22040080_idu.scala 84:24]
  wire [11:0] _io_csr_addr_T_2 = _instrType_T_4 ? immExt[11:0] : 12'h0; // @[ysyx_22040080_idu.scala 157:23]
  assign io_rs1 = io_inst_active ? io_rdata[19:15] : 5'h0; // @[ysyx_22040080_idu.scala 84:24 88:14 64:18]
  assign io_rs2 = io_inst_active ? io_rdata[24:20] : 5'h0; // @[ysyx_22040080_idu.scala 84:24 89:14 65:18]
  assign io_rd = io_inst_active ? io_rdata[11:7] : 5'h0; // @[ysyx_22040080_idu.scala 84:24 91:14 67:18]
  assign io_func3 = io_inst_active ? funct3 : 3'h0; // @[ysyx_22040080_idu.scala 84:24 96:14 68:18]
  assign io_imm_ext = io_inst_active ? immExt : 32'h0; // @[ysyx_22040080_idu.scala 154:16 75:18 84:24]
  assign io_op = io_inst_active ? opcode : 7'h0; // @[ysyx_22040080_idu.scala 84:24 95:14 69:18]
  assign io_func7 = io_inst_active ? io_rdata[31:25] : 7'h0; // @[ysyx_22040080_idu.scala 84:24 90:14 66:18]
  assign io_shamt = io_inst_active ? _io_shamt_T_5 : 5'h0; // @[ysyx_22040080_idu.scala 84:24 99:14 70:18]
  assign io_csr_addr = io_inst_active ? _io_csr_addr_T_2 : 12'h0; // @[ysyx_22040080_idu.scala 157:17 76:18 84:24]
  assign io_is_jal = io_inst_active & _instrType_T_9; // @[ysyx_22040080_idu.scala 122:20 72:18 84:24]
  assign io_is_jalr = io_inst_active & _instrType_T_3; // @[ysyx_22040080_idu.scala 123:20 73:18 84:24]
  assign io_is_branch = io_inst_active & _instrType_T_6; // @[ysyx_22040080_idu.scala 124:20 74:18 84:24]
  assign io_is_load = io_inst_active & _instrType_T_2; // @[ysyx_22040080_idu.scala 125:20 77:18 84:24]
  assign io_is_store = io_inst_active & _instrType_T_5; // @[ysyx_22040080_idu.scala 126:20 78:18 84:24]
  assign io_lsu_reqValid = io_inst_active & (_instrType_T_2 | _instrType_T_5); // @[ysyx_22040080_idu.scala 127:21 79:19 84:24]
endmodule
module ysyx_22040080_alu(
  input  [31:0] io_rs1_data,
  input  [31:0] io_rs2_data,
  input  [31:0] io_imm_ext,
  input  [2:0]  io_func3,
  input  [6:0]  io_func7,
  input  [6:0]  io_op,
  input  [31:0] io_pc,
  input  [4:0]  io_shamt,
  input         io_inst_active,
  output [31:0] io_result,
  output        io_wen,
  output        io_branch_taken,
  output [31:0] io_jal_target,
  output [31:0] io_mem_addr,
  output [31:0] io_mem_wdata,
  input  [31:0] io_csr_rdata,
  output        io_csr_wen,
  output [31:0] io_csr_wdata,
  output        io_trap_valid,
  output        io_is_mret,
  output [31:0] io_trap_mepc,
  output [31:0] io_trap_mcause
);
  wire  _alu_in1_T_2 = io_op == 7'h13 | io_op == 7'h67; // @[ysyx_22040080_alu.scala 57:26]
  wire  _alu_in1_T_5 = io_op == 7'h17 | io_op == 7'h6f; // @[ysyx_22040080_alu.scala 58:26]
  wire [31:0] _alu_in1_T_6 = _alu_in1_T_5 ? io_pc : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] alu_in1 = _alu_in1_T_2 ? io_rs1_data : _alu_in1_T_6; // @[Mux.scala 101:16]
  wire [31:0] alu_sum = alu_in1 + io_imm_ext; // @[ysyx_22040080_alu.scala 61:25]
  wire  _T_1 = 3'h0 == io_func3; // @[ysyx_22040080_alu.scala 90:26]
  wire  _T_2 = 3'h1 == io_func3; // @[ysyx_22040080_alu.scala 90:26]
  wire [62:0] _GEN_50 = {{31'd0}, io_rs1_data}; // @[ysyx_22040080_alu.scala 96:38]
  wire [62:0] _io_result_T = _GEN_50 << io_shamt; // @[ysyx_22040080_alu.scala 96:38]
  wire  _T_3 = 3'h3 == io_func3; // @[ysyx_22040080_alu.scala 90:26]
  wire  _T_4 = 3'h4 == io_func3; // @[ysyx_22040080_alu.scala 90:26]
  wire [31:0] _io_result_T_3 = io_rs1_data ^ io_imm_ext; // @[ysyx_22040080_alu.scala 104:38]
  wire  _T_5 = 3'h5 == io_func3; // @[ysyx_22040080_alu.scala 90:26]
  wire  _T_6 = io_func7 == 7'h0; // @[ysyx_22040080_alu.scala 108:27]
  wire [31:0] _io_result_T_4 = io_rs1_data >> io_shamt; // @[ysyx_22040080_alu.scala 109:40]
  wire  _T_7 = io_func7 == 7'h20; // @[ysyx_22040080_alu.scala 111:34]
  wire [31:0] _io_result_T_5 = io_rs1_data; // @[ysyx_22040080_alu.scala 112:41]
  wire [31:0] _io_result_T_7 = $signed(io_rs1_data) >>> io_shamt; // @[ysyx_22040080_alu.scala 112:61]
  wire [31:0] _GEN_0 = io_func7 == 7'h20 ? _io_result_T_7 : 32'h0; // @[ysyx_22040080_alu.scala 111:52 112:25 66:19]
  wire [31:0] _GEN_2 = io_func7 == 7'h0 ? _io_result_T_4 : _GEN_0; // @[ysyx_22040080_alu.scala 108:45 109:25]
  wire  _GEN_3 = io_func7 == 7'h0 | _T_7; // @[ysyx_22040080_alu.scala 108:45 110:22]
  wire  _T_8 = 3'h6 == io_func3; // @[ysyx_22040080_alu.scala 90:26]
  wire [31:0] _io_result_T_8 = io_rs1_data | io_imm_ext; // @[ysyx_22040080_alu.scala 117:38]
  wire  _T_9 = 3'h7 == io_func3; // @[ysyx_22040080_alu.scala 90:26]
  wire [31:0] _io_result_T_9 = io_rs1_data & io_imm_ext; // @[ysyx_22040080_alu.scala 121:38]
  wire [31:0] _GEN_4 = 3'h7 == io_func3 ? _io_result_T_9 : 32'h0; // @[ysyx_22040080_alu.scala 121:23 66:19 90:26]
  wire [31:0] _GEN_6 = 3'h6 == io_func3 ? _io_result_T_8 : _GEN_4; // @[ysyx_22040080_alu.scala 117:23 90:26]
  wire  _GEN_7 = 3'h6 == io_func3 | 3'h7 == io_func3; // @[ysyx_22040080_alu.scala 118:20 90:26]
  wire [31:0] _GEN_8 = 3'h5 == io_func3 ? _GEN_2 : _GEN_6; // @[ysyx_22040080_alu.scala 90:26]
  wire  _GEN_9 = 3'h5 == io_func3 ? _GEN_3 : _GEN_7; // @[ysyx_22040080_alu.scala 90:26]
  wire [31:0] _GEN_10 = 3'h4 == io_func3 ? _io_result_T_3 : _GEN_8; // @[ysyx_22040080_alu.scala 104:23 90:26]
  wire  _GEN_11 = 3'h4 == io_func3 | _GEN_9; // @[ysyx_22040080_alu.scala 105:20 90:26]
  wire [31:0] _GEN_12 = 3'h3 == io_func3 ? {{31'd0}, io_rs1_data < io_imm_ext} : _GEN_10; // @[ysyx_22040080_alu.scala 100:23 90:26]
  wire  _GEN_13 = 3'h3 == io_func3 | _GEN_11; // @[ysyx_22040080_alu.scala 101:20 90:26]
  wire [62:0] _GEN_14 = 3'h1 == io_func3 ? _io_result_T : {{31'd0}, _GEN_12}; // @[ysyx_22040080_alu.scala 90:26 96:23]
  wire  _GEN_15 = 3'h1 == io_func3 | _GEN_13; // @[ysyx_22040080_alu.scala 90:26 97:20]
  wire [62:0] _GEN_16 = 3'h0 == io_func3 ? {{31'd0}, alu_sum} : _GEN_14; // @[ysyx_22040080_alu.scala 90:26 92:23]
  wire  _GEN_17 = 3'h0 == io_func3 | _GEN_15; // @[ysyx_22040080_alu.scala 90:26 93:20]
  wire [31:0] _io_result_T_11 = io_rs1_data + io_rs2_data; // @[ysyx_22040080_alu.scala 134:40]
  wire [31:0] _io_result_T_13 = io_rs1_data - io_rs2_data; // @[ysyx_22040080_alu.scala 137:40]
  wire [31:0] _GEN_18 = _T_7 ? _io_result_T_13 : 32'h0; // @[ysyx_22040080_alu.scala 136:52 137:25 66:19]
  wire [31:0] _GEN_20 = _T_6 ? _io_result_T_11 : _GEN_18; // @[ysyx_22040080_alu.scala 133:45 134:25]
  wire [62:0] _GEN_78 = {{31'd0}, io_rs1_data}; // @[ysyx_22040080_alu.scala 142:38]
  wire [62:0] _io_result_T_15 = _GEN_78 << io_rs2_data[4:0]; // @[ysyx_22040080_alu.scala 142:38]
  wire  _T_15 = 3'h2 == io_func3; // @[ysyx_22040080_alu.scala 131:26]
  wire [31:0] _io_result_T_17 = io_rs2_data; // @[ysyx_22040080_alu.scala 146:63]
  wire  _io_result_T_18 = $signed(io_rs1_data) < $signed(io_rs2_data); // @[ysyx_22040080_alu.scala 146:49]
  wire  _io_result_T_20 = io_rs1_data < io_rs2_data; // @[ysyx_22040080_alu.scala 151:44]
  wire  _GEN_22 = _T_6 & io_rs1_data < io_rs2_data; // @[ysyx_22040080_alu.scala 150:45 151:25 66:19]
  wire [31:0] _io_result_T_22 = io_rs1_data ^ io_rs2_data; // @[ysyx_22040080_alu.scala 156:38]
  wire [31:0] _io_result_T_24 = io_rs1_data >> io_rs2_data[4:0]; // @[ysyx_22040080_alu.scala 161:40]
  wire [31:0] _io_result_T_28 = $signed(io_rs1_data) >>> io_rs2_data[4:0]; // @[ysyx_22040080_alu.scala 164:70]
  wire [31:0] _GEN_24 = _T_7 ? _io_result_T_28 : 32'h0; // @[ysyx_22040080_alu.scala 163:52 164:25 66:19]
  wire [31:0] _GEN_26 = _T_6 ? _io_result_T_24 : _GEN_24; // @[ysyx_22040080_alu.scala 160:45 161:25]
  wire [31:0] _io_result_T_29 = io_rs1_data | io_rs2_data; // @[ysyx_22040080_alu.scala 169:38]
  wire [31:0] _io_result_T_30 = io_rs1_data & io_rs2_data; // @[ysyx_22040080_alu.scala 173:38]
  wire [31:0] _GEN_28 = _T_9 ? _io_result_T_30 : 32'h0; // @[ysyx_22040080_alu.scala 131:26 173:23 66:19]
  wire [31:0] _GEN_30 = _T_8 ? _io_result_T_29 : _GEN_28; // @[ysyx_22040080_alu.scala 131:26 169:23]
  wire [31:0] _GEN_32 = _T_5 ? _GEN_26 : _GEN_30; // @[ysyx_22040080_alu.scala 131:26]
  wire [31:0] _GEN_34 = _T_4 ? _io_result_T_22 : _GEN_32; // @[ysyx_22040080_alu.scala 131:26 156:23]
  wire [31:0] _GEN_36 = _T_3 ? {{31'd0}, _GEN_22} : _GEN_34; // @[ysyx_22040080_alu.scala 131:26]
  wire  _GEN_37 = _T_3 ? _T_6 : _GEN_11; // @[ysyx_22040080_alu.scala 131:26]
  wire [31:0] _GEN_38 = 3'h2 == io_func3 ? {{31'd0}, $signed(_io_result_T_5) < $signed(_io_result_T_17)} : _GEN_36; // @[ysyx_22040080_alu.scala 131:26 146:23]
  wire  _GEN_39 = 3'h2 == io_func3 | _GEN_37; // @[ysyx_22040080_alu.scala 131:26 147:20]
  wire [62:0] _GEN_40 = _T_2 ? _io_result_T_15 : {{31'd0}, _GEN_38}; // @[ysyx_22040080_alu.scala 131:26 142:23]
  wire  _GEN_41 = _T_2 | _GEN_39; // @[ysyx_22040080_alu.scala 131:26 143:20]
  wire [62:0] _GEN_42 = _T_1 ? {{31'd0}, _GEN_20} : _GEN_40; // @[ysyx_22040080_alu.scala 131:26]
  wire  _GEN_43 = _T_1 ? _GEN_3 : _GEN_41; // @[ysyx_22040080_alu.scala 131:26]
  wire [31:0] _io_mem_addr_T_1 = io_rs1_data + io_imm_ext; // @[ysyx_22040080_alu.scala 183:36]
  wire  _GEN_44 = _T_9 & io_rs1_data >= io_rs2_data; // @[ysyx_22040080_alu.scala 200:26 206:27]
  wire  _GEN_45 = _T_8 ? _io_result_T_20 : _GEN_44; // @[ysyx_22040080_alu.scala 200:26 205:27]
  wire  _GEN_46 = _T_5 ? $signed(io_rs1_data) >= $signed(io_rs2_data) : _GEN_45; // @[ysyx_22040080_alu.scala 200:26 204:27]
  wire  _GEN_47 = _T_4 ? _io_result_T_18 : _GEN_46; // @[ysyx_22040080_alu.scala 200:26 203:27]
  wire  _GEN_48 = _T_2 ? io_rs1_data != io_rs2_data : _GEN_47; // @[ysyx_22040080_alu.scala 200:26 202:27]
  wire  taken = _T_1 ? io_rs1_data == io_rs2_data : _GEN_48; // @[ysyx_22040080_alu.scala 200:26 201:27]
  wire [31:0] _io_jal_target_T_1 = io_pc + io_imm_ext; // @[ysyx_22040080_alu.scala 211:34]
  wire [31:0] _GEN_51 = taken ? _io_jal_target_T_1 : 32'h0; // @[ysyx_22040080_alu.scala 209:21 211:25 70:19]
  wire [31:0] _io_result_T_32 = io_pc + 32'h4; // @[ysyx_22040080_alu.scala 235:31]
  wire [31:0] _io_jal_target_T_4 = _io_mem_addr_T_1 & 32'hfffffffe; // @[ysyx_22040080_alu.scala 247:53]
  wire  _T_40 = io_imm_ext[11:0] == 12'h0; // @[ysyx_22040080_alu.scala 257:36]
  wire  _T_42 = io_imm_ext[11:0] == 12'h302; // @[ysyx_22040080_alu.scala 261:43]
  wire [31:0] _GEN_54 = io_imm_ext[11:0] == 12'h0 ? io_pc : 32'h0; // @[ysyx_22040080_alu.scala 257:50 259:30 76:19]
  wire [3:0] _GEN_55 = io_imm_ext[11:0] == 12'h0 ? 4'hb : 4'h0; // @[ysyx_22040080_alu.scala 257:50 260:30 77:19]
  wire  _GEN_56 = io_imm_ext[11:0] == 12'h0 ? 1'h0 : _T_42; // @[ysyx_22040080_alu.scala 257:50 78:19]
  wire [31:0] _io_csr_wdata_T = io_rs1_data | io_csr_rdata; // @[ysyx_22040080_alu.scala 273:41]
  wire [31:0] _GEN_57 = _T_15 ? io_csr_rdata : 32'h0; // @[ysyx_22040080_alu.scala 255:26 272:26 66:19]
  wire [31:0] _GEN_58 = _T_15 ? _io_csr_wdata_T : 32'h0; // @[ysyx_22040080_alu.scala 255:26 273:26 74:19]
  wire [31:0] _GEN_60 = _T_2 ? io_csr_rdata : _GEN_57; // @[ysyx_22040080_alu.scala 255:26 266:26]
  wire [31:0] _GEN_61 = _T_2 ? io_rs1_data : _GEN_58; // @[ysyx_22040080_alu.scala 255:26 267:26]
  wire  _GEN_62 = _T_2 | _T_15; // @[ysyx_22040080_alu.scala 255:26 268:26]
  wire  _GEN_63 = _T_1 & _T_40; // @[ysyx_22040080_alu.scala 255:26 75:19]
  wire [31:0] _GEN_64 = _T_1 ? _GEN_54 : 32'h0; // @[ysyx_22040080_alu.scala 255:26 76:19]
  wire [3:0] _GEN_65 = _T_1 ? _GEN_55 : 4'h0; // @[ysyx_22040080_alu.scala 255:26 77:19]
  wire  _GEN_66 = _T_1 & _GEN_56; // @[ysyx_22040080_alu.scala 255:26 78:19]
  wire [31:0] _GEN_67 = _T_1 ? 32'h0 : _GEN_60; // @[ysyx_22040080_alu.scala 255:26 66:19]
  wire [31:0] _GEN_68 = _T_1 ? 32'h0 : _GEN_61; // @[ysyx_22040080_alu.scala 255:26 74:19]
  wire  _GEN_69 = _T_1 ? 1'h0 : _GEN_62; // @[ysyx_22040080_alu.scala 255:26 73:19]
  wire [31:0] _GEN_71 = 7'h73 == io_op ? _GEN_64 : 32'h0; // @[ysyx_22040080_alu.scala 76:19 84:19]
  wire [3:0] _GEN_72 = 7'h73 == io_op ? _GEN_65 : 4'h0; // @[ysyx_22040080_alu.scala 77:19 84:19]
  wire [31:0] _GEN_74 = 7'h73 == io_op ? _GEN_67 : 32'h0; // @[ysyx_22040080_alu.scala 66:19 84:19]
  wire [31:0] _GEN_75 = 7'h73 == io_op ? _GEN_68 : 32'h0; // @[ysyx_22040080_alu.scala 74:19 84:19]
  wire  _GEN_76 = 7'h73 == io_op & _GEN_69; // @[ysyx_22040080_alu.scala 73:19 84:19]
  wire [31:0] _GEN_77 = 7'h67 == io_op ? _io_result_T_32 : _GEN_74; // @[ysyx_22040080_alu.scala 84:19 245:22]
  wire [31:0] _GEN_79 = 7'h67 == io_op ? _io_jal_target_T_4 : 32'h0; // @[ysyx_22040080_alu.scala 84:19 247:23 70:19]
  wire  _GEN_80 = 7'h67 == io_op | _GEN_76; // @[ysyx_22040080_alu.scala 248:16 84:19]
  wire  _GEN_81 = 7'h67 == io_op ? 1'h0 : 7'h73 == io_op & _GEN_63; // @[ysyx_22040080_alu.scala 75:19 84:19]
  wire [31:0] _GEN_82 = 7'h67 == io_op ? 32'h0 : _GEN_71; // @[ysyx_22040080_alu.scala 76:19 84:19]
  wire [3:0] _GEN_83 = 7'h67 == io_op ? 4'h0 : _GEN_72; // @[ysyx_22040080_alu.scala 77:19 84:19]
  wire  _GEN_84 = 7'h67 == io_op ? 1'h0 : 7'h73 == io_op & _GEN_66; // @[ysyx_22040080_alu.scala 78:19 84:19]
  wire [31:0] _GEN_85 = 7'h67 == io_op ? 32'h0 : _GEN_75; // @[ysyx_22040080_alu.scala 74:19 84:19]
  wire  _GEN_86 = 7'h67 == io_op ? 1'h0 : 7'h73 == io_op & _GEN_69; // @[ysyx_22040080_alu.scala 73:19 84:19]
  wire [31:0] _GEN_87 = 7'h6f == io_op ? _io_result_T_32 : _GEN_77; // @[ysyx_22040080_alu.scala 84:19 235:22]
  wire [31:0] _GEN_89 = 7'h6f == io_op ? alu_sum : _GEN_79; // @[ysyx_22040080_alu.scala 84:19 237:23]
  wire  _GEN_90 = 7'h6f == io_op | _GEN_80; // @[ysyx_22040080_alu.scala 238:16 84:19]
  wire  _GEN_91 = 7'h6f == io_op ? 1'h0 : _GEN_81; // @[ysyx_22040080_alu.scala 75:19 84:19]
  wire [31:0] _GEN_92 = 7'h6f == io_op ? 32'h0 : _GEN_82; // @[ysyx_22040080_alu.scala 76:19 84:19]
  wire [3:0] _GEN_93 = 7'h6f == io_op ? 4'h0 : _GEN_83; // @[ysyx_22040080_alu.scala 77:19 84:19]
  wire  _GEN_94 = 7'h6f == io_op ? 1'h0 : _GEN_84; // @[ysyx_22040080_alu.scala 78:19 84:19]
  wire [31:0] _GEN_95 = 7'h6f == io_op ? 32'h0 : _GEN_85; // @[ysyx_22040080_alu.scala 74:19 84:19]
  wire  _GEN_96 = 7'h6f == io_op ? 1'h0 : _GEN_86; // @[ysyx_22040080_alu.scala 73:19 84:19]
  wire [31:0] _GEN_97 = 7'h37 == io_op ? io_imm_ext : _GEN_87; // @[ysyx_22040080_alu.scala 227:19 84:19]
  wire  _GEN_98 = 7'h37 == io_op | _GEN_90; // @[ysyx_22040080_alu.scala 228:16 84:19]
  wire [31:0] _GEN_100 = 7'h37 == io_op ? 32'h0 : _GEN_89; // @[ysyx_22040080_alu.scala 70:19 84:19]
  wire  _GEN_101 = 7'h37 == io_op ? 1'h0 : _GEN_91; // @[ysyx_22040080_alu.scala 75:19 84:19]
  wire [31:0] _GEN_102 = 7'h37 == io_op ? 32'h0 : _GEN_92; // @[ysyx_22040080_alu.scala 76:19 84:19]
  wire [3:0] _GEN_103 = 7'h37 == io_op ? 4'h0 : _GEN_93; // @[ysyx_22040080_alu.scala 77:19 84:19]
  wire  _GEN_104 = 7'h37 == io_op ? 1'h0 : _GEN_94; // @[ysyx_22040080_alu.scala 78:19 84:19]
  wire [31:0] _GEN_105 = 7'h37 == io_op ? 32'h0 : _GEN_95; // @[ysyx_22040080_alu.scala 74:19 84:19]
  wire  _GEN_106 = 7'h37 == io_op ? 1'h0 : _GEN_96; // @[ysyx_22040080_alu.scala 73:19 84:19]
  wire [31:0] _GEN_107 = 7'h17 == io_op ? alu_sum : _GEN_97; // @[ysyx_22040080_alu.scala 219:19 84:19]
  wire  _GEN_108 = 7'h17 == io_op | _GEN_98; // @[ysyx_22040080_alu.scala 220:16 84:19]
  wire [31:0] _GEN_110 = 7'h17 == io_op ? 32'h0 : _GEN_100; // @[ysyx_22040080_alu.scala 70:19 84:19]
  wire  _GEN_111 = 7'h17 == io_op ? 1'h0 : _GEN_101; // @[ysyx_22040080_alu.scala 75:19 84:19]
  wire [31:0] _GEN_112 = 7'h17 == io_op ? 32'h0 : _GEN_102; // @[ysyx_22040080_alu.scala 76:19 84:19]
  wire [3:0] _GEN_113 = 7'h17 == io_op ? 4'h0 : _GEN_103; // @[ysyx_22040080_alu.scala 77:19 84:19]
  wire  _GEN_114 = 7'h17 == io_op ? 1'h0 : _GEN_104; // @[ysyx_22040080_alu.scala 78:19 84:19]
  wire [31:0] _GEN_115 = 7'h17 == io_op ? 32'h0 : _GEN_105; // @[ysyx_22040080_alu.scala 74:19 84:19]
  wire  _GEN_116 = 7'h17 == io_op ? 1'h0 : _GEN_106; // @[ysyx_22040080_alu.scala 73:19 84:19]
  wire  _GEN_117 = 7'h63 == io_op & taken; // @[ysyx_22040080_alu.scala 84:19 208:25 69:19]
  wire [31:0] _GEN_119 = 7'h63 == io_op ? _GEN_51 : _GEN_110; // @[ysyx_22040080_alu.scala 84:19]
  wire [31:0] _GEN_120 = 7'h63 == io_op ? 32'h0 : _GEN_107; // @[ysyx_22040080_alu.scala 66:19 84:19]
  wire  _GEN_121 = 7'h63 == io_op ? 1'h0 : _GEN_108; // @[ysyx_22040080_alu.scala 67:19 84:19]
  wire  _GEN_122 = 7'h63 == io_op ? 1'h0 : _GEN_111; // @[ysyx_22040080_alu.scala 75:19 84:19]
  wire [31:0] _GEN_123 = 7'h63 == io_op ? 32'h0 : _GEN_112; // @[ysyx_22040080_alu.scala 76:19 84:19]
  wire [3:0] _GEN_124 = 7'h63 == io_op ? 4'h0 : _GEN_113; // @[ysyx_22040080_alu.scala 77:19 84:19]
  wire  _GEN_125 = 7'h63 == io_op ? 1'h0 : _GEN_114; // @[ysyx_22040080_alu.scala 78:19 84:19]
  wire [31:0] _GEN_126 = 7'h63 == io_op ? 32'h0 : _GEN_115; // @[ysyx_22040080_alu.scala 74:19 84:19]
  wire  _GEN_127 = 7'h63 == io_op ? 1'h0 : _GEN_116; // @[ysyx_22040080_alu.scala 73:19 84:19]
  wire [31:0] _GEN_128 = 7'h23 == io_op ? _io_mem_addr_T_1 : 32'h0; // @[ysyx_22040080_alu.scala 84:19 191:22 71:19]
  wire [31:0] _GEN_129 = 7'h23 == io_op ? io_rs2_data : 32'h0; // @[ysyx_22040080_alu.scala 84:19 192:22 72:19]
  wire  _GEN_130 = 7'h23 == io_op ? 1'h0 : _GEN_117; // @[ysyx_22040080_alu.scala 69:19 84:19]
  wire [31:0] _GEN_132 = 7'h23 == io_op ? 32'h0 : _GEN_119; // @[ysyx_22040080_alu.scala 70:19 84:19]
  wire [31:0] _GEN_133 = 7'h23 == io_op ? 32'h0 : _GEN_120; // @[ysyx_22040080_alu.scala 66:19 84:19]
  wire  _GEN_134 = 7'h23 == io_op ? 1'h0 : _GEN_121; // @[ysyx_22040080_alu.scala 67:19 84:19]
  wire  _GEN_135 = 7'h23 == io_op ? 1'h0 : _GEN_122; // @[ysyx_22040080_alu.scala 75:19 84:19]
  wire [31:0] _GEN_136 = 7'h23 == io_op ? 32'h0 : _GEN_123; // @[ysyx_22040080_alu.scala 76:19 84:19]
  wire [3:0] _GEN_137 = 7'h23 == io_op ? 4'h0 : _GEN_124; // @[ysyx_22040080_alu.scala 77:19 84:19]
  wire  _GEN_138 = 7'h23 == io_op ? 1'h0 : _GEN_125; // @[ysyx_22040080_alu.scala 78:19 84:19]
  wire [31:0] _GEN_139 = 7'h23 == io_op ? 32'h0 : _GEN_126; // @[ysyx_22040080_alu.scala 74:19 84:19]
  wire  _GEN_140 = 7'h23 == io_op ? 1'h0 : _GEN_127; // @[ysyx_22040080_alu.scala 73:19 84:19]
  wire [31:0] _GEN_141 = 7'h3 == io_op ? _io_mem_addr_T_1 : _GEN_128; // @[ysyx_22040080_alu.scala 84:19 183:21]
  wire  _GEN_142 = 7'h3 == io_op | _GEN_134; // @[ysyx_22040080_alu.scala 184:16 84:19]
  wire [31:0] _GEN_143 = 7'h3 == io_op ? 32'h0 : _GEN_129; // @[ysyx_22040080_alu.scala 72:19 84:19]
  wire  _GEN_144 = 7'h3 == io_op ? 1'h0 : _GEN_130; // @[ysyx_22040080_alu.scala 69:19 84:19]
  wire [31:0] _GEN_146 = 7'h3 == io_op ? 32'h0 : _GEN_132; // @[ysyx_22040080_alu.scala 70:19 84:19]
  wire [31:0] _GEN_147 = 7'h3 == io_op ? 32'h0 : _GEN_133; // @[ysyx_22040080_alu.scala 66:19 84:19]
  wire  _GEN_148 = 7'h3 == io_op ? 1'h0 : _GEN_135; // @[ysyx_22040080_alu.scala 75:19 84:19]
  wire [31:0] _GEN_149 = 7'h3 == io_op ? 32'h0 : _GEN_136; // @[ysyx_22040080_alu.scala 76:19 84:19]
  wire [3:0] _GEN_150 = 7'h3 == io_op ? 4'h0 : _GEN_137; // @[ysyx_22040080_alu.scala 77:19 84:19]
  wire  _GEN_151 = 7'h3 == io_op ? 1'h0 : _GEN_138; // @[ysyx_22040080_alu.scala 78:19 84:19]
  wire [31:0] _GEN_152 = 7'h3 == io_op ? 32'h0 : _GEN_139; // @[ysyx_22040080_alu.scala 74:19 84:19]
  wire  _GEN_153 = 7'h3 == io_op ? 1'h0 : _GEN_140; // @[ysyx_22040080_alu.scala 73:19 84:19]
  wire [62:0] _GEN_154 = 7'h33 == io_op ? _GEN_42 : {{31'd0}, _GEN_147}; // @[ysyx_22040080_alu.scala 84:19]
  wire  _GEN_155 = 7'h33 == io_op ? _GEN_43 : _GEN_142; // @[ysyx_22040080_alu.scala 84:19]
  wire [31:0] _GEN_156 = 7'h33 == io_op ? 32'h0 : _GEN_141; // @[ysyx_22040080_alu.scala 71:19 84:19]
  wire [31:0] _GEN_157 = 7'h33 == io_op ? 32'h0 : _GEN_143; // @[ysyx_22040080_alu.scala 72:19 84:19]
  wire  _GEN_158 = 7'h33 == io_op ? 1'h0 : _GEN_144; // @[ysyx_22040080_alu.scala 69:19 84:19]
  wire [31:0] _GEN_160 = 7'h33 == io_op ? 32'h0 : _GEN_146; // @[ysyx_22040080_alu.scala 70:19 84:19]
  wire  _GEN_161 = 7'h33 == io_op ? 1'h0 : _GEN_148; // @[ysyx_22040080_alu.scala 75:19 84:19]
  wire [31:0] _GEN_162 = 7'h33 == io_op ? 32'h0 : _GEN_149; // @[ysyx_22040080_alu.scala 76:19 84:19]
  wire [3:0] _GEN_163 = 7'h33 == io_op ? 4'h0 : _GEN_150; // @[ysyx_22040080_alu.scala 77:19 84:19]
  wire  _GEN_164 = 7'h33 == io_op ? 1'h0 : _GEN_151; // @[ysyx_22040080_alu.scala 78:19 84:19]
  wire [31:0] _GEN_165 = 7'h33 == io_op ? 32'h0 : _GEN_152; // @[ysyx_22040080_alu.scala 74:19 84:19]
  wire  _GEN_166 = 7'h33 == io_op ? 1'h0 : _GEN_153; // @[ysyx_22040080_alu.scala 73:19 84:19]
  wire [62:0] _GEN_167 = 7'h13 == io_op ? _GEN_16 : _GEN_154; // @[ysyx_22040080_alu.scala 84:19]
  wire  _GEN_168 = 7'h13 == io_op ? _GEN_17 : _GEN_155; // @[ysyx_22040080_alu.scala 84:19]
  wire [31:0] _GEN_169 = 7'h13 == io_op ? 32'h0 : _GEN_156; // @[ysyx_22040080_alu.scala 71:19 84:19]
  wire [31:0] _GEN_170 = 7'h13 == io_op ? 32'h0 : _GEN_157; // @[ysyx_22040080_alu.scala 72:19 84:19]
  wire  _GEN_171 = 7'h13 == io_op ? 1'h0 : _GEN_158; // @[ysyx_22040080_alu.scala 69:19 84:19]
  wire [31:0] _GEN_173 = 7'h13 == io_op ? 32'h0 : _GEN_160; // @[ysyx_22040080_alu.scala 70:19 84:19]
  wire  _GEN_174 = 7'h13 == io_op ? 1'h0 : _GEN_161; // @[ysyx_22040080_alu.scala 75:19 84:19]
  wire [31:0] _GEN_175 = 7'h13 == io_op ? 32'h0 : _GEN_162; // @[ysyx_22040080_alu.scala 76:19 84:19]
  wire [3:0] _GEN_176 = 7'h13 == io_op ? 4'h0 : _GEN_163; // @[ysyx_22040080_alu.scala 77:19 84:19]
  wire  _GEN_177 = 7'h13 == io_op ? 1'h0 : _GEN_164; // @[ysyx_22040080_alu.scala 78:19 84:19]
  wire [31:0] _GEN_178 = 7'h13 == io_op ? 32'h0 : _GEN_165; // @[ysyx_22040080_alu.scala 74:19 84:19]
  wire  _GEN_179 = 7'h13 == io_op ? 1'h0 : _GEN_166; // @[ysyx_22040080_alu.scala 73:19 84:19]
  wire [62:0] _GEN_180 = io_inst_active ? _GEN_167 : 63'h0; // @[ysyx_22040080_alu.scala 66:19 83:24]
  wire [3:0] _GEN_189 = io_inst_active ? _GEN_176 : 4'h0; // @[ysyx_22040080_alu.scala 77:19 83:24]
  assign io_result = _GEN_180[31:0];
  assign io_wen = io_inst_active & _GEN_168; // @[ysyx_22040080_alu.scala 67:19 83:24]
  assign io_branch_taken = io_inst_active & _GEN_171; // @[ysyx_22040080_alu.scala 69:19 83:24]
  assign io_jal_target = io_inst_active ? _GEN_173 : 32'h0; // @[ysyx_22040080_alu.scala 70:19 83:24]
  assign io_mem_addr = io_inst_active ? _GEN_169 : 32'h0; // @[ysyx_22040080_alu.scala 71:19 83:24]
  assign io_mem_wdata = io_inst_active ? _GEN_170 : 32'h0; // @[ysyx_22040080_alu.scala 72:19 83:24]
  assign io_csr_wen = io_inst_active & _GEN_179; // @[ysyx_22040080_alu.scala 73:19 83:24]
  assign io_csr_wdata = io_inst_active ? _GEN_178 : 32'h0; // @[ysyx_22040080_alu.scala 74:19 83:24]
  assign io_trap_valid = io_inst_active & _GEN_174; // @[ysyx_22040080_alu.scala 75:19 83:24]
  assign io_is_mret = io_inst_active & _GEN_177; // @[ysyx_22040080_alu.scala 78:19 83:24]
  assign io_trap_mepc = io_inst_active ? _GEN_175 : 32'h0; // @[ysyx_22040080_alu.scala 76:19 83:24]
  assign io_trap_mcause = {{28'd0}, _GEN_189};
endmodule
module RegisterFile(
  input         clock,
  input         reset,
  input         io_wen,
  input  [4:0]  io_raddr1,
  input  [4:0]  io_raddr2,
  input  [4:0]  io_waddr,
  input  [31:0] io_wdata,
  output [31:0] io_rdata1,
  output [31:0] io_rdata2,
  output        io_wb_done,
  input         io_is_branch,
  input         io_is_load,
  input         io_is_store,
  input  [31:0] io_load_data,
  input         io_lsu_reqReady,
  input         io_lsu_respValid,
  output        io_lsu_respReady
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
  wire  regWriteCommit_clk; // @[RegisterFile.scala 109:30]
  wire  regWriteCommit_en; // @[RegisterFile.scala 109:30]
  wire [31:0] regWriteCommit_addr; // @[RegisterFile.scala 109:30]
  wire [31:0] regWriteCommit_wdata; // @[RegisterFile.scala 109:30]
  wire  getRegInfo_clk; // @[RegisterFile.scala 118:26]
  wire [1023:0] getRegInfo_rf_flat; // @[RegisterFile.scala 118:26]
  reg [31:0] rf_0; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_1; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_2; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_3; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_4; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_5; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_6; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_7; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_8; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_9; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_10; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_11; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_12; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_13; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_14; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_15; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_16; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_17; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_18; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_19; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_20; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_21; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_22; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_23; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_24; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_25; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_26; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_27; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_28; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_29; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_30; // @[RegisterFile.scala 95:19]
  reg [31:0] rf_31; // @[RegisterFile.scala 95:19]
  reg [4:0] load_waddr_buf; // @[RegisterFile.scala 97:35]
  reg  load_wen_buf; // @[RegisterFile.scala 98:35]
  reg  is_store_latch; // @[RegisterFile.scala 99:35]
  reg  store_req_accepted; // @[RegisterFile.scala 100:35]
  reg [7:0] wb_resp_ready_cnt; // @[RegisterFile.scala 101:35]
  reg  wbDoneReg; // @[RegisterFile.scala 103:32]
  reg  lsuRespReadyReg; // @[RegisterFile.scala 104:32]
  wire [255:0] getRegInfo_io_rf_flat_lo_lo = {rf_7,rf_6,rf_5,rf_4,rf_3,rf_2,rf_1,rf_0}; // @[Cat.scala 31:58]
  wire [511:0] getRegInfo_io_rf_flat_lo = {rf_15,rf_14,rf_13,rf_12,rf_11,rf_10,rf_9,rf_8,getRegInfo_io_rf_flat_lo_lo}; // @[Cat.scala 31:58]
  wire [255:0] getRegInfo_io_rf_flat_hi_lo = {rf_23,rf_22,rf_21,rf_20,rf_19,rf_18,rf_17,rf_16}; // @[Cat.scala 31:58]
  wire [511:0] getRegInfo_io_rf_flat_hi = {rf_31,rf_30,rf_29,rf_28,rf_27,rf_26,rf_25,rf_24,getRegInfo_io_rf_flat_hi_lo}; // @[Cat.scala 31:58]
  wire [31:0] _GEN_1 = 5'h1 == io_raddr1 ? rf_1 : rf_0; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_2 = 5'h2 == io_raddr1 ? rf_2 : _GEN_1; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_3 = 5'h3 == io_raddr1 ? rf_3 : _GEN_2; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_4 = 5'h4 == io_raddr1 ? rf_4 : _GEN_3; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_5 = 5'h5 == io_raddr1 ? rf_5 : _GEN_4; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_6 = 5'h6 == io_raddr1 ? rf_6 : _GEN_5; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_7 = 5'h7 == io_raddr1 ? rf_7 : _GEN_6; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_8 = 5'h8 == io_raddr1 ? rf_8 : _GEN_7; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_9 = 5'h9 == io_raddr1 ? rf_9 : _GEN_8; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_10 = 5'ha == io_raddr1 ? rf_10 : _GEN_9; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_11 = 5'hb == io_raddr1 ? rf_11 : _GEN_10; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_12 = 5'hc == io_raddr1 ? rf_12 : _GEN_11; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_13 = 5'hd == io_raddr1 ? rf_13 : _GEN_12; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_14 = 5'he == io_raddr1 ? rf_14 : _GEN_13; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_15 = 5'hf == io_raddr1 ? rf_15 : _GEN_14; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_16 = 5'h10 == io_raddr1 ? rf_16 : _GEN_15; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_17 = 5'h11 == io_raddr1 ? rf_17 : _GEN_16; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_18 = 5'h12 == io_raddr1 ? rf_18 : _GEN_17; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_19 = 5'h13 == io_raddr1 ? rf_19 : _GEN_18; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_20 = 5'h14 == io_raddr1 ? rf_20 : _GEN_19; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_21 = 5'h15 == io_raddr1 ? rf_21 : _GEN_20; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_22 = 5'h16 == io_raddr1 ? rf_22 : _GEN_21; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_23 = 5'h17 == io_raddr1 ? rf_23 : _GEN_22; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_24 = 5'h18 == io_raddr1 ? rf_24 : _GEN_23; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_25 = 5'h19 == io_raddr1 ? rf_25 : _GEN_24; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_26 = 5'h1a == io_raddr1 ? rf_26 : _GEN_25; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_27 = 5'h1b == io_raddr1 ? rf_27 : _GEN_26; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_28 = 5'h1c == io_raddr1 ? rf_28 : _GEN_27; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_29 = 5'h1d == io_raddr1 ? rf_29 : _GEN_28; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_30 = 5'h1e == io_raddr1 ? rf_30 : _GEN_29; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_31 = 5'h1f == io_raddr1 ? rf_31 : _GEN_30; // @[RegisterFile.scala 125:{19,19}]
  wire [31:0] _GEN_33 = 5'h1 == io_raddr2 ? rf_1 : rf_0; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_34 = 5'h2 == io_raddr2 ? rf_2 : _GEN_33; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_35 = 5'h3 == io_raddr2 ? rf_3 : _GEN_34; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_36 = 5'h4 == io_raddr2 ? rf_4 : _GEN_35; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_37 = 5'h5 == io_raddr2 ? rf_5 : _GEN_36; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_38 = 5'h6 == io_raddr2 ? rf_6 : _GEN_37; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_39 = 5'h7 == io_raddr2 ? rf_7 : _GEN_38; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_40 = 5'h8 == io_raddr2 ? rf_8 : _GEN_39; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_41 = 5'h9 == io_raddr2 ? rf_9 : _GEN_40; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_42 = 5'ha == io_raddr2 ? rf_10 : _GEN_41; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_43 = 5'hb == io_raddr2 ? rf_11 : _GEN_42; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_44 = 5'hc == io_raddr2 ? rf_12 : _GEN_43; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_45 = 5'hd == io_raddr2 ? rf_13 : _GEN_44; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_46 = 5'he == io_raddr2 ? rf_14 : _GEN_45; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_47 = 5'hf == io_raddr2 ? rf_15 : _GEN_46; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_48 = 5'h10 == io_raddr2 ? rf_16 : _GEN_47; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_49 = 5'h11 == io_raddr2 ? rf_17 : _GEN_48; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_50 = 5'h12 == io_raddr2 ? rf_18 : _GEN_49; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_51 = 5'h13 == io_raddr2 ? rf_19 : _GEN_50; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_52 = 5'h14 == io_raddr2 ? rf_20 : _GEN_51; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_53 = 5'h15 == io_raddr2 ? rf_21 : _GEN_52; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_54 = 5'h16 == io_raddr2 ? rf_22 : _GEN_53; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_55 = 5'h17 == io_raddr2 ? rf_23 : _GEN_54; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_56 = 5'h18 == io_raddr2 ? rf_24 : _GEN_55; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_57 = 5'h19 == io_raddr2 ? rf_25 : _GEN_56; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_58 = 5'h1a == io_raddr2 ? rf_26 : _GEN_57; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_59 = 5'h1b == io_raddr2 ? rf_27 : _GEN_58; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_60 = 5'h1c == io_raddr2 ? rf_28 : _GEN_59; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_61 = 5'h1d == io_raddr2 ? rf_29 : _GEN_60; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_62 = 5'h1e == io_raddr2 ? rf_30 : _GEN_61; // @[RegisterFile.scala 126:{19,19}]
  wire [31:0] _GEN_63 = 5'h1f == io_raddr2 ? rf_31 : _GEN_62; // @[RegisterFile.scala 126:{19,19}]
  wire  _T_2 = io_waddr != 5'h0; // @[RegisterFile.scala 140:19]
  wire [31:0] _regWriteCommit_io_addr_T = {27'h0,io_waddr}; // @[Cat.scala 31:58]
  wire [31:0] _GEN_97 = io_waddr != 5'h0 ? _regWriteCommit_io_addr_T : 32'h0; // @[RegisterFile.scala 112:27 140:28 142:31]
  wire [31:0] _GEN_98 = io_waddr != 5'h0 ? io_wdata : 32'h0; // @[RegisterFile.scala 113:27 140:28 143:31]
  wire [7:0] _wb_resp_ready_cnt_T_1 = 8'h2 - 8'h1; // @[RegisterFile.scala 160:48]
  wire  _GEN_131 = io_lsu_reqReady | store_req_accepted; // @[RegisterFile.scala 176:29 177:28 100:35]
  wire  _T_5 = wb_resp_ready_cnt > 8'h0; // @[RegisterFile.scala 181:30]
  wire [7:0] _wb_resp_ready_cnt_T_5 = wb_resp_ready_cnt - 8'h1; // @[RegisterFile.scala 182:48]
  wire  _GEN_133 = io_lsu_respValid ? 1'h0 : is_store_latch; // @[RegisterFile.scala 184:32 187:30 99:35]
  wire  _GEN_134 = io_lsu_respValid ? 1'h0 : store_req_accepted; // @[RegisterFile.scala 184:32 188:30 100:35]
  wire [7:0] _GEN_135 = wb_resp_ready_cnt > 8'h0 ? _wb_resp_ready_cnt_T_5 : wb_resp_ready_cnt; // @[RegisterFile.scala 181:37 182:27 101:35]
  wire  _GEN_136 = wb_resp_ready_cnt > 8'h0 ? 1'h0 : io_lsu_respValid; // @[RegisterFile.scala 134:19 181:37]
  wire  _GEN_137 = wb_resp_ready_cnt > 8'h0 ? is_store_latch : _GEN_133; // @[RegisterFile.scala 181:37 99:35]
  wire  _GEN_138 = wb_resp_ready_cnt > 8'h0 ? store_req_accepted : _GEN_134; // @[RegisterFile.scala 100:35 181:37]
  wire  _GEN_139 = ~store_req_accepted ? _GEN_131 : _GEN_138; // @[RegisterFile.scala 174:31]
  wire [7:0] _GEN_140 = ~store_req_accepted ? wb_resp_ready_cnt : _GEN_135; // @[RegisterFile.scala 174:31 101:35]
  wire  _GEN_141 = ~store_req_accepted ? 1'h0 : _GEN_136; // @[RegisterFile.scala 134:19 174:31]
  wire  _GEN_142 = ~store_req_accepted ? is_store_latch : _GEN_137; // @[RegisterFile.scala 174:31 99:35]
  wire  _T_7 = load_waddr_buf != 5'h0; // @[RegisterFile.scala 203:29]
  wire [31:0] _regWriteCommit_io_addr_T_1 = {27'h0,load_waddr_buf}; // @[Cat.scala 31:58]
  wire [31:0] _GEN_143 = 5'h0 == load_waddr_buf ? io_load_data : rf_0; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_144 = 5'h1 == load_waddr_buf ? io_load_data : rf_1; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_145 = 5'h2 == load_waddr_buf ? io_load_data : rf_2; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_146 = 5'h3 == load_waddr_buf ? io_load_data : rf_3; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_147 = 5'h4 == load_waddr_buf ? io_load_data : rf_4; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_148 = 5'h5 == load_waddr_buf ? io_load_data : rf_5; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_149 = 5'h6 == load_waddr_buf ? io_load_data : rf_6; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_150 = 5'h7 == load_waddr_buf ? io_load_data : rf_7; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_151 = 5'h8 == load_waddr_buf ? io_load_data : rf_8; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_152 = 5'h9 == load_waddr_buf ? io_load_data : rf_9; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_153 = 5'ha == load_waddr_buf ? io_load_data : rf_10; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_154 = 5'hb == load_waddr_buf ? io_load_data : rf_11; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_155 = 5'hc == load_waddr_buf ? io_load_data : rf_12; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_156 = 5'hd == load_waddr_buf ? io_load_data : rf_13; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_157 = 5'he == load_waddr_buf ? io_load_data : rf_14; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_158 = 5'hf == load_waddr_buf ? io_load_data : rf_15; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_159 = 5'h10 == load_waddr_buf ? io_load_data : rf_16; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_160 = 5'h11 == load_waddr_buf ? io_load_data : rf_17; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_161 = 5'h12 == load_waddr_buf ? io_load_data : rf_18; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_162 = 5'h13 == load_waddr_buf ? io_load_data : rf_19; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_163 = 5'h14 == load_waddr_buf ? io_load_data : rf_20; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_164 = 5'h15 == load_waddr_buf ? io_load_data : rf_21; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_165 = 5'h16 == load_waddr_buf ? io_load_data : rf_22; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_166 = 5'h17 == load_waddr_buf ? io_load_data : rf_23; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_167 = 5'h18 == load_waddr_buf ? io_load_data : rf_24; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_168 = 5'h19 == load_waddr_buf ? io_load_data : rf_25; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_169 = 5'h1a == load_waddr_buf ? io_load_data : rf_26; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_170 = 5'h1b == load_waddr_buf ? io_load_data : rf_27; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_171 = 5'h1c == load_waddr_buf ? io_load_data : rf_28; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_172 = 5'h1d == load_waddr_buf ? io_load_data : rf_29; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_173 = 5'h1e == load_waddr_buf ? io_load_data : rf_30; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_174 = 5'h1f == load_waddr_buf ? io_load_data : rf_31; // @[RegisterFile.scala 207:{30,30} 95:19]
  wire [31:0] _GEN_176 = load_waddr_buf != 5'h0 ? _regWriteCommit_io_addr_T_1 : 32'h0; // @[RegisterFile.scala 112:27 203:38 205:35]
  wire [31:0] _GEN_177 = load_waddr_buf != 5'h0 ? io_load_data : 32'h0; // @[RegisterFile.scala 113:27 203:38 206:35]
  wire [31:0] _GEN_178 = load_waddr_buf != 5'h0 ? _GEN_143 : rf_0; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_179 = load_waddr_buf != 5'h0 ? _GEN_144 : rf_1; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_180 = load_waddr_buf != 5'h0 ? _GEN_145 : rf_2; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_181 = load_waddr_buf != 5'h0 ? _GEN_146 : rf_3; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_182 = load_waddr_buf != 5'h0 ? _GEN_147 : rf_4; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_183 = load_waddr_buf != 5'h0 ? _GEN_148 : rf_5; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_184 = load_waddr_buf != 5'h0 ? _GEN_149 : rf_6; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_185 = load_waddr_buf != 5'h0 ? _GEN_150 : rf_7; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_186 = load_waddr_buf != 5'h0 ? _GEN_151 : rf_8; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_187 = load_waddr_buf != 5'h0 ? _GEN_152 : rf_9; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_188 = load_waddr_buf != 5'h0 ? _GEN_153 : rf_10; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_189 = load_waddr_buf != 5'h0 ? _GEN_154 : rf_11; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_190 = load_waddr_buf != 5'h0 ? _GEN_155 : rf_12; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_191 = load_waddr_buf != 5'h0 ? _GEN_156 : rf_13; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_192 = load_waddr_buf != 5'h0 ? _GEN_157 : rf_14; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_193 = load_waddr_buf != 5'h0 ? _GEN_158 : rf_15; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_194 = load_waddr_buf != 5'h0 ? _GEN_159 : rf_16; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_195 = load_waddr_buf != 5'h0 ? _GEN_160 : rf_17; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_196 = load_waddr_buf != 5'h0 ? _GEN_161 : rf_18; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_197 = load_waddr_buf != 5'h0 ? _GEN_162 : rf_19; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_198 = load_waddr_buf != 5'h0 ? _GEN_163 : rf_20; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_199 = load_waddr_buf != 5'h0 ? _GEN_164 : rf_21; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_200 = load_waddr_buf != 5'h0 ? _GEN_165 : rf_22; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_201 = load_waddr_buf != 5'h0 ? _GEN_166 : rf_23; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_202 = load_waddr_buf != 5'h0 ? _GEN_167 : rf_24; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_203 = load_waddr_buf != 5'h0 ? _GEN_168 : rf_25; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_204 = load_waddr_buf != 5'h0 ? _GEN_169 : rf_26; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_205 = load_waddr_buf != 5'h0 ? _GEN_170 : rf_27; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_206 = load_waddr_buf != 5'h0 ? _GEN_171 : rf_28; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_207 = load_waddr_buf != 5'h0 ? _GEN_172 : rf_29; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_208 = load_waddr_buf != 5'h0 ? _GEN_173 : rf_30; // @[RegisterFile.scala 203:38 95:19]
  wire [31:0] _GEN_209 = load_waddr_buf != 5'h0 ? _GEN_174 : rf_31; // @[RegisterFile.scala 203:38 95:19]
  wire  _GEN_210 = io_lsu_respValid & _T_7; // @[RegisterFile.scala 111:27 201:30]
  wire [31:0] _GEN_211 = io_lsu_respValid ? _GEN_176 : 32'h0; // @[RegisterFile.scala 112:27 201:30]
  wire [31:0] _GEN_212 = io_lsu_respValid ? _GEN_177 : 32'h0; // @[RegisterFile.scala 113:27 201:30]
  wire [31:0] _GEN_213 = io_lsu_respValid ? _GEN_178 : rf_0; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_214 = io_lsu_respValid ? _GEN_179 : rf_1; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_215 = io_lsu_respValid ? _GEN_180 : rf_2; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_216 = io_lsu_respValid ? _GEN_181 : rf_3; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_217 = io_lsu_respValid ? _GEN_182 : rf_4; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_218 = io_lsu_respValid ? _GEN_183 : rf_5; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_219 = io_lsu_respValid ? _GEN_184 : rf_6; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_220 = io_lsu_respValid ? _GEN_185 : rf_7; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_221 = io_lsu_respValid ? _GEN_186 : rf_8; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_222 = io_lsu_respValid ? _GEN_187 : rf_9; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_223 = io_lsu_respValid ? _GEN_188 : rf_10; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_224 = io_lsu_respValid ? _GEN_189 : rf_11; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_225 = io_lsu_respValid ? _GEN_190 : rf_12; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_226 = io_lsu_respValid ? _GEN_191 : rf_13; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_227 = io_lsu_respValid ? _GEN_192 : rf_14; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_228 = io_lsu_respValid ? _GEN_193 : rf_15; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_229 = io_lsu_respValid ? _GEN_194 : rf_16; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_230 = io_lsu_respValid ? _GEN_195 : rf_17; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_231 = io_lsu_respValid ? _GEN_196 : rf_18; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_232 = io_lsu_respValid ? _GEN_197 : rf_19; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_233 = io_lsu_respValid ? _GEN_198 : rf_20; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_234 = io_lsu_respValid ? _GEN_199 : rf_21; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_235 = io_lsu_respValid ? _GEN_200 : rf_22; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_236 = io_lsu_respValid ? _GEN_201 : rf_23; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_237 = io_lsu_respValid ? _GEN_202 : rf_24; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_238 = io_lsu_respValid ? _GEN_203 : rf_25; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_239 = io_lsu_respValid ? _GEN_204 : rf_26; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_240 = io_lsu_respValid ? _GEN_205 : rf_27; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_241 = io_lsu_respValid ? _GEN_206 : rf_28; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_242 = io_lsu_respValid ? _GEN_207 : rf_29; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_243 = io_lsu_respValid ? _GEN_208 : rf_30; // @[RegisterFile.scala 201:30 95:19]
  wire [31:0] _GEN_244 = io_lsu_respValid ? _GEN_209 : rf_31; // @[RegisterFile.scala 201:30 95:19]
  wire  _GEN_245 = io_lsu_respValid ? 1'h0 : load_wen_buf; // @[RegisterFile.scala 201:30 210:22 98:35]
  wire  _GEN_248 = _T_5 ? 1'h0 : _GEN_210; // @[RegisterFile.scala 111:27 197:35]
  wire [31:0] _GEN_249 = _T_5 ? 32'h0 : _GEN_211; // @[RegisterFile.scala 112:27 197:35]
  wire [31:0] _GEN_250 = _T_5 ? 32'h0 : _GEN_212; // @[RegisterFile.scala 113:27 197:35]
  wire [31:0] _GEN_251 = _T_5 ? rf_0 : _GEN_213; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_252 = _T_5 ? rf_1 : _GEN_214; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_253 = _T_5 ? rf_2 : _GEN_215; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_254 = _T_5 ? rf_3 : _GEN_216; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_255 = _T_5 ? rf_4 : _GEN_217; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_256 = _T_5 ? rf_5 : _GEN_218; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_257 = _T_5 ? rf_6 : _GEN_219; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_258 = _T_5 ? rf_7 : _GEN_220; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_259 = _T_5 ? rf_8 : _GEN_221; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_260 = _T_5 ? rf_9 : _GEN_222; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_261 = _T_5 ? rf_10 : _GEN_223; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_262 = _T_5 ? rf_11 : _GEN_224; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_263 = _T_5 ? rf_12 : _GEN_225; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_264 = _T_5 ? rf_13 : _GEN_226; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_265 = _T_5 ? rf_14 : _GEN_227; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_266 = _T_5 ? rf_15 : _GEN_228; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_267 = _T_5 ? rf_16 : _GEN_229; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_268 = _T_5 ? rf_17 : _GEN_230; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_269 = _T_5 ? rf_18 : _GEN_231; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_270 = _T_5 ? rf_19 : _GEN_232; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_271 = _T_5 ? rf_20 : _GEN_233; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_272 = _T_5 ? rf_21 : _GEN_234; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_273 = _T_5 ? rf_22 : _GEN_235; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_274 = _T_5 ? rf_23 : _GEN_236; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_275 = _T_5 ? rf_24 : _GEN_237; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_276 = _T_5 ? rf_25 : _GEN_238; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_277 = _T_5 ? rf_26 : _GEN_239; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_278 = _T_5 ? rf_27 : _GEN_240; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_279 = _T_5 ? rf_28 : _GEN_241; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_280 = _T_5 ? rf_29 : _GEN_242; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_281 = _T_5 ? rf_30 : _GEN_243; // @[RegisterFile.scala 197:35 95:19]
  wire [31:0] _GEN_282 = _T_5 ? rf_31 : _GEN_244; // @[RegisterFile.scala 197:35 95:19]
  wire  _GEN_283 = _T_5 ? load_wen_buf : _GEN_245; // @[RegisterFile.scala 197:35 98:35]
  wire [7:0] _GEN_284 = load_wen_buf ? _GEN_135 : wb_resp_ready_cnt; // @[RegisterFile.scala 196:27 101:35]
  wire  _GEN_285 = load_wen_buf & _GEN_136; // @[RegisterFile.scala 134:19 196:27]
  wire  _GEN_286 = load_wen_buf & _GEN_248; // @[RegisterFile.scala 111:27 196:27]
  wire [31:0] _GEN_287 = load_wen_buf ? _GEN_249 : 32'h0; // @[RegisterFile.scala 112:27 196:27]
  wire [31:0] _GEN_288 = load_wen_buf ? _GEN_250 : 32'h0; // @[RegisterFile.scala 113:27 196:27]
  wire [31:0] _GEN_289 = load_wen_buf ? _GEN_251 : rf_0; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_290 = load_wen_buf ? _GEN_252 : rf_1; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_291 = load_wen_buf ? _GEN_253 : rf_2; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_292 = load_wen_buf ? _GEN_254 : rf_3; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_293 = load_wen_buf ? _GEN_255 : rf_4; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_294 = load_wen_buf ? _GEN_256 : rf_5; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_295 = load_wen_buf ? _GEN_257 : rf_6; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_296 = load_wen_buf ? _GEN_258 : rf_7; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_297 = load_wen_buf ? _GEN_259 : rf_8; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_298 = load_wen_buf ? _GEN_260 : rf_9; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_299 = load_wen_buf ? _GEN_261 : rf_10; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_300 = load_wen_buf ? _GEN_262 : rf_11; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_301 = load_wen_buf ? _GEN_263 : rf_12; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_302 = load_wen_buf ? _GEN_264 : rf_13; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_303 = load_wen_buf ? _GEN_265 : rf_14; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_304 = load_wen_buf ? _GEN_266 : rf_15; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_305 = load_wen_buf ? _GEN_267 : rf_16; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_306 = load_wen_buf ? _GEN_268 : rf_17; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_307 = load_wen_buf ? _GEN_269 : rf_18; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_308 = load_wen_buf ? _GEN_270 : rf_19; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_309 = load_wen_buf ? _GEN_271 : rf_20; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_310 = load_wen_buf ? _GEN_272 : rf_21; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_311 = load_wen_buf ? _GEN_273 : rf_22; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_312 = load_wen_buf ? _GEN_274 : rf_23; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_313 = load_wen_buf ? _GEN_275 : rf_24; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_314 = load_wen_buf ? _GEN_276 : rf_25; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_315 = load_wen_buf ? _GEN_277 : rf_26; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_316 = load_wen_buf ? _GEN_278 : rf_27; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_317 = load_wen_buf ? _GEN_279 : rf_28; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_318 = load_wen_buf ? _GEN_280 : rf_29; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_319 = load_wen_buf ? _GEN_281 : rf_30; // @[RegisterFile.scala 196:27 95:19]
  wire [31:0] _GEN_320 = load_wen_buf ? _GEN_282 : rf_31; // @[RegisterFile.scala 196:27 95:19]
  wire  _GEN_321 = load_wen_buf ? _GEN_283 : load_wen_buf; // @[RegisterFile.scala 196:27 98:35]
  wire  _GEN_322 = is_store_latch ? _GEN_139 : store_req_accepted; // @[RegisterFile.scala 173:29 100:35]
  wire [7:0] _GEN_323 = is_store_latch ? _GEN_140 : _GEN_284; // @[RegisterFile.scala 173:29]
  wire  _GEN_324 = is_store_latch ? _GEN_141 : _GEN_285; // @[RegisterFile.scala 173:29]
  wire  _GEN_325 = is_store_latch ? _GEN_142 : is_store_latch; // @[RegisterFile.scala 173:29 99:35]
  wire  _GEN_326 = is_store_latch ? 1'h0 : _GEN_286; // @[RegisterFile.scala 111:27 173:29]
  wire [31:0] _GEN_327 = is_store_latch ? 32'h0 : _GEN_287; // @[RegisterFile.scala 112:27 173:29]
  wire [31:0] _GEN_328 = is_store_latch ? 32'h0 : _GEN_288; // @[RegisterFile.scala 113:27 173:29]
  wire [31:0] _GEN_329 = is_store_latch ? rf_0 : _GEN_289; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_330 = is_store_latch ? rf_1 : _GEN_290; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_331 = is_store_latch ? rf_2 : _GEN_291; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_332 = is_store_latch ? rf_3 : _GEN_292; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_333 = is_store_latch ? rf_4 : _GEN_293; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_334 = is_store_latch ? rf_5 : _GEN_294; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_335 = is_store_latch ? rf_6 : _GEN_295; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_336 = is_store_latch ? rf_7 : _GEN_296; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_337 = is_store_latch ? rf_8 : _GEN_297; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_338 = is_store_latch ? rf_9 : _GEN_298; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_339 = is_store_latch ? rf_10 : _GEN_299; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_340 = is_store_latch ? rf_11 : _GEN_300; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_341 = is_store_latch ? rf_12 : _GEN_301; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_342 = is_store_latch ? rf_13 : _GEN_302; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_343 = is_store_latch ? rf_14 : _GEN_303; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_344 = is_store_latch ? rf_15 : _GEN_304; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_345 = is_store_latch ? rf_16 : _GEN_305; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_346 = is_store_latch ? rf_17 : _GEN_306; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_347 = is_store_latch ? rf_18 : _GEN_307; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_348 = is_store_latch ? rf_19 : _GEN_308; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_349 = is_store_latch ? rf_20 : _GEN_309; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_350 = is_store_latch ? rf_21 : _GEN_310; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_351 = is_store_latch ? rf_22 : _GEN_311; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_352 = is_store_latch ? rf_23 : _GEN_312; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_353 = is_store_latch ? rf_24 : _GEN_313; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_354 = is_store_latch ? rf_25 : _GEN_314; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_355 = is_store_latch ? rf_26 : _GEN_315; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_356 = is_store_latch ? rf_27 : _GEN_316; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_357 = is_store_latch ? rf_28 : _GEN_317; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_358 = is_store_latch ? rf_29 : _GEN_318; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_359 = is_store_latch ? rf_30 : _GEN_319; // @[RegisterFile.scala 173:29 95:19]
  wire [31:0] _GEN_360 = is_store_latch ? rf_31 : _GEN_320; // @[RegisterFile.scala 173:29 95:19]
  wire  _GEN_361 = is_store_latch ? load_wen_buf : _GEN_321; // @[RegisterFile.scala 173:29 98:35]
  wire  _GEN_362 = io_is_store | _GEN_325; // @[RegisterFile.scala 165:26 166:24]
  wire  _GEN_363 = io_is_store ? 1'h0 : _GEN_322; // @[RegisterFile.scala 165:26 167:24]
  wire [7:0] _GEN_364 = io_is_store ? _wb_resp_ready_cnt_T_1 : _GEN_323; // @[RegisterFile.scala 165:26 168:24]
  wire  _GEN_365 = io_is_store ? 1'h0 : _GEN_324; // @[RegisterFile.scala 134:19 165:26]
  wire  _GEN_366 = io_is_store ? 1'h0 : _GEN_326; // @[RegisterFile.scala 165:26 111:27]
  wire [31:0] _GEN_367 = io_is_store ? 32'h0 : _GEN_327; // @[RegisterFile.scala 165:26 112:27]
  wire [31:0] _GEN_368 = io_is_store ? 32'h0 : _GEN_328; // @[RegisterFile.scala 165:26 113:27]
  wire [31:0] _GEN_369 = io_is_store ? rf_0 : _GEN_329; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_370 = io_is_store ? rf_1 : _GEN_330; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_371 = io_is_store ? rf_2 : _GEN_331; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_372 = io_is_store ? rf_3 : _GEN_332; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_373 = io_is_store ? rf_4 : _GEN_333; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_374 = io_is_store ? rf_5 : _GEN_334; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_375 = io_is_store ? rf_6 : _GEN_335; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_376 = io_is_store ? rf_7 : _GEN_336; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_377 = io_is_store ? rf_8 : _GEN_337; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_378 = io_is_store ? rf_9 : _GEN_338; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_379 = io_is_store ? rf_10 : _GEN_339; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_380 = io_is_store ? rf_11 : _GEN_340; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_381 = io_is_store ? rf_12 : _GEN_341; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_382 = io_is_store ? rf_13 : _GEN_342; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_383 = io_is_store ? rf_14 : _GEN_343; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_384 = io_is_store ? rf_15 : _GEN_344; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_385 = io_is_store ? rf_16 : _GEN_345; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_386 = io_is_store ? rf_17 : _GEN_346; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_387 = io_is_store ? rf_18 : _GEN_347; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_388 = io_is_store ? rf_19 : _GEN_348; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_389 = io_is_store ? rf_20 : _GEN_349; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_390 = io_is_store ? rf_21 : _GEN_350; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_391 = io_is_store ? rf_22 : _GEN_351; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_392 = io_is_store ? rf_23 : _GEN_352; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_393 = io_is_store ? rf_24 : _GEN_353; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_394 = io_is_store ? rf_25 : _GEN_354; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_395 = io_is_store ? rf_26 : _GEN_355; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_396 = io_is_store ? rf_27 : _GEN_356; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_397 = io_is_store ? rf_28 : _GEN_357; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_398 = io_is_store ? rf_29 : _GEN_358; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_399 = io_is_store ? rf_30 : _GEN_359; // @[RegisterFile.scala 165:26 95:19]
  wire [31:0] _GEN_400 = io_is_store ? rf_31 : _GEN_360; // @[RegisterFile.scala 165:26 95:19]
  wire  _GEN_401 = io_is_store ? load_wen_buf : _GEN_361; // @[RegisterFile.scala 165:26 98:35]
  wire  _GEN_403 = io_wen & io_is_load | _GEN_401; // @[RegisterFile.scala 157:35 159:23]
  wire  _GEN_407 = io_wen & io_is_load ? 1'h0 : _GEN_365; // @[RegisterFile.scala 134:19 157:35]
  wire  _GEN_408 = io_wen & io_is_load ? 1'h0 : _GEN_366; // @[RegisterFile.scala 111:27 157:35]
  wire [31:0] _GEN_409 = io_wen & io_is_load ? 32'h0 : _GEN_367; // @[RegisterFile.scala 112:27 157:35]
  wire [31:0] _GEN_410 = io_wen & io_is_load ? 32'h0 : _GEN_368; // @[RegisterFile.scala 113:27 157:35]
  wire  _GEN_443 = io_is_branch | _GEN_407; // @[RegisterFile.scala 151:27 152:15]
  wire  _GEN_450 = io_is_branch ? 1'h0 : _GEN_408; // @[RegisterFile.scala 111:27 151:27]
  wire [31:0] _GEN_451 = io_is_branch ? 32'h0 : _GEN_409; // @[RegisterFile.scala 112:27 151:27]
  wire [31:0] _GEN_452 = io_is_branch ? 32'h0 : _GEN_410; // @[RegisterFile.scala 113:27 151:27]
  wire  _GEN_520 = io_wen & ~io_is_load | _GEN_443; // @[RegisterFile.scala 139:31 146:15]
  reg_write_commit_wrapper regWriteCommit ( // @[RegisterFile.scala 109:30]
    .clk(regWriteCommit_clk),
    .en(regWriteCommit_en),
    .addr(regWriteCommit_addr),
    .wdata(regWriteCommit_wdata)
  );
  get_reg_info_wrapper getRegInfo ( // @[RegisterFile.scala 118:26]
    .clk(getRegInfo_clk),
    .rf_flat(getRegInfo_rf_flat)
  );
  assign io_rdata1 = io_raddr1 == 5'h0 ? 32'h0 : _GEN_31; // @[RegisterFile.scala 125:19]
  assign io_rdata2 = io_raddr2 == 5'h0 ? 32'h0 : _GEN_63; // @[RegisterFile.scala 126:19]
  assign io_wb_done = wbDoneReg; // @[RegisterFile.scala 218:20]
  assign io_lsu_respReady = lsuRespReadyReg; // @[RegisterFile.scala 219:20]
  assign regWriteCommit_clk = clock; // @[RegisterFile.scala 110:27]
  assign regWriteCommit_en = io_wen & ~io_is_load ? _T_2 : _GEN_450; // @[RegisterFile.scala 139:31]
  assign regWriteCommit_addr = io_wen & ~io_is_load ? _GEN_97 : _GEN_451; // @[RegisterFile.scala 139:31]
  assign regWriteCommit_wdata = io_wen & ~io_is_load ? _GEN_98 : _GEN_452; // @[RegisterFile.scala 139:31]
  assign getRegInfo_clk = clock; // @[RegisterFile.scala 119:25]
  assign getRegInfo_rf_flat = {getRegInfo_io_rf_flat_hi,getRegInfo_io_rf_flat_lo}; // @[Cat.scala 31:58]
  always @(posedge clock) begin
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_0 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'h0 == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_0 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_0 <= _GEN_369;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_1 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'h1 == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_1 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_1 <= _GEN_370;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_2 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'h2 == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_2 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_2 <= _GEN_371;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_3 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'h3 == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_3 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_3 <= _GEN_372;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_4 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'h4 == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_4 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_4 <= _GEN_373;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_5 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'h5 == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_5 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_5 <= _GEN_374;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_6 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'h6 == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_6 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_6 <= _GEN_375;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_7 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'h7 == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_7 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_7 <= _GEN_376;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_8 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'h8 == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_8 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_8 <= _GEN_377;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_9 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'h9 == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_9 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_9 <= _GEN_378;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_10 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'ha == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_10 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_10 <= _GEN_379;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_11 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'hb == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_11 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_11 <= _GEN_380;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_12 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'hc == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_12 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_12 <= _GEN_381;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_13 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'hd == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_13 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_13 <= _GEN_382;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_14 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'he == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_14 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_14 <= _GEN_383;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_15 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'hf == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_15 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_15 <= _GEN_384;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_16 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'h10 == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_16 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_16 <= _GEN_385;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_17 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'h11 == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_17 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_17 <= _GEN_386;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_18 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'h12 == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_18 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_18 <= _GEN_387;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_19 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'h13 == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_19 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_19 <= _GEN_388;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_20 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'h14 == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_20 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_20 <= _GEN_389;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_21 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'h15 == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_21 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_21 <= _GEN_390;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_22 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'h16 == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_22 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_22 <= _GEN_391;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_23 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'h17 == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_23 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_23 <= _GEN_392;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_24 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'h18 == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_24 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_24 <= _GEN_393;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_25 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'h19 == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_25 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_25 <= _GEN_394;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_26 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'h1a == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_26 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_26 <= _GEN_395;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_27 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'h1b == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_27 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_27 <= _GEN_396;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_28 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'h1c == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_28 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_28 <= _GEN_397;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_29 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'h1d == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_29 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_29 <= _GEN_398;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_30 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'h1e == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_30 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_30 <= _GEN_399;
      end
    end
    if (reset) begin // @[RegisterFile.scala 95:19]
      rf_31 <= 32'h0; // @[RegisterFile.scala 95:19]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      if (io_waddr != 5'h0) begin // @[RegisterFile.scala 140:28]
        if (5'h1f == io_waddr) begin // @[RegisterFile.scala 144:20]
          rf_31 <= io_wdata; // @[RegisterFile.scala 144:20]
        end
      end
    end else if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
      if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
        rf_31 <= _GEN_400;
      end
    end
    if (reset) begin // @[RegisterFile.scala 97:35]
      load_waddr_buf <= 5'h0; // @[RegisterFile.scala 97:35]
    end else if (!(io_wen & ~io_is_load)) begin // @[RegisterFile.scala 139:31]
      if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
        if (io_wen & io_is_load) begin // @[RegisterFile.scala 157:35]
          load_waddr_buf <= io_waddr; // @[RegisterFile.scala 158:23]
        end
      end
    end
    if (reset) begin // @[RegisterFile.scala 98:35]
      load_wen_buf <= 1'h0; // @[RegisterFile.scala 98:35]
    end else if (!(io_wen & ~io_is_load)) begin // @[RegisterFile.scala 139:31]
      if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
        load_wen_buf <= _GEN_403;
      end
    end
    if (reset) begin // @[RegisterFile.scala 99:35]
      is_store_latch <= 1'h0; // @[RegisterFile.scala 99:35]
    end else if (!(io_wen & ~io_is_load)) begin // @[RegisterFile.scala 139:31]
      if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
        if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
          is_store_latch <= _GEN_362;
        end
      end
    end
    if (reset) begin // @[RegisterFile.scala 100:35]
      store_req_accepted <= 1'h0; // @[RegisterFile.scala 100:35]
    end else if (!(io_wen & ~io_is_load)) begin // @[RegisterFile.scala 139:31]
      if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
        if (!(io_wen & io_is_load)) begin // @[RegisterFile.scala 157:35]
          store_req_accepted <= _GEN_363;
        end
      end
    end
    if (reset) begin // @[RegisterFile.scala 101:35]
      wb_resp_ready_cnt <= 8'h0; // @[RegisterFile.scala 101:35]
    end else if (!(io_wen & ~io_is_load)) begin // @[RegisterFile.scala 139:31]
      if (!(io_is_branch)) begin // @[RegisterFile.scala 151:27]
        if (io_wen & io_is_load) begin // @[RegisterFile.scala 157:35]
          wb_resp_ready_cnt <= _wb_resp_ready_cnt_T_1; // @[RegisterFile.scala 160:23]
        end else begin
          wb_resp_ready_cnt <= _GEN_364;
        end
      end
    end
    if (reset) begin // @[RegisterFile.scala 103:32]
      wbDoneReg <= 1'h0; // @[RegisterFile.scala 103:32]
    end else begin
      wbDoneReg <= _GEN_520;
    end
    if (reset) begin // @[RegisterFile.scala 104:32]
      lsuRespReadyReg <= 1'h0; // @[RegisterFile.scala 104:32]
    end else if (io_wen & ~io_is_load) begin // @[RegisterFile.scala 139:31]
      lsuRespReadyReg <= 1'h0; // @[RegisterFile.scala 134:19]
    end else if (io_is_branch) begin // @[RegisterFile.scala 151:27]
      lsuRespReadyReg <= 1'h0; // @[RegisterFile.scala 134:19]
    end else if (io_wen & io_is_load) begin // @[RegisterFile.scala 157:35]
      lsuRespReadyReg <= 1'h0; // @[RegisterFile.scala 134:19]
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
  output [31:0] io_trace_pc,
  output [31:0] io_trace_instr,
  output        io_instr_done
);
  wire  gpc_clock; // @[ysyx_22040080_cpu.scala 28:25]
  wire  gpc_reset; // @[ysyx_22040080_cpu.scala 28:25]
  wire [31:0] gpc_io_pc; // @[ysyx_22040080_cpu.scala 28:25]
  wire  gpc_io_is_jal; // @[ysyx_22040080_cpu.scala 28:25]
  wire  gpc_io_is_jalr; // @[ysyx_22040080_cpu.scala 28:25]
  wire  gpc_io_branch_taken; // @[ysyx_22040080_cpu.scala 28:25]
  wire [31:0] gpc_io_jal_target; // @[ysyx_22040080_cpu.scala 28:25]
  wire [31:0] gpc_io_next_pc; // @[ysyx_22040080_cpu.scala 28:25]
  wire  pc_mod_clock; // @[ysyx_22040080_cpu.scala 29:25]
  wire  pc_mod_reset; // @[ysyx_22040080_cpu.scala 29:25]
  wire  pc_mod_io_trap_valid; // @[ysyx_22040080_cpu.scala 29:25]
  wire  pc_mod_io_is_mret; // @[ysyx_22040080_cpu.scala 29:25]
  wire [31:0] pc_mod_io_mtvec; // @[ysyx_22040080_cpu.scala 29:25]
  wire [31:0] pc_mod_io_mepc; // @[ysyx_22040080_cpu.scala 29:25]
  wire [31:0] pc_mod_io_pc; // @[ysyx_22040080_cpu.scala 29:25]
  wire  pc_mod_io_pc_valid; // @[ysyx_22040080_cpu.scala 29:25]
  wire [31:0] pc_mod_io_next_pc; // @[ysyx_22040080_cpu.scala 29:25]
  wire  pc_mod_io_pc_update_en; // @[ysyx_22040080_cpu.scala 29:25]
  wire [31:0] pc_mod_io_trace_pc; // @[ysyx_22040080_cpu.scala 29:25]
  wire [31:0] pc_mod_io_trace_instr; // @[ysyx_22040080_cpu.scala 29:25]
  wire  pc_mod_io_instr_done; // @[ysyx_22040080_cpu.scala 29:25]
  wire  ifu_clock; // @[ysyx_22040080_cpu.scala 30:25]
  wire  ifu_reset; // @[ysyx_22040080_cpu.scala 30:25]
  wire [31:0] ifu_io_pc; // @[ysyx_22040080_cpu.scala 30:25]
  wire  ifu_io_pc_valid; // @[ysyx_22040080_cpu.scala 30:25]
  wire [31:0] ifu_io_araddr; // @[ysyx_22040080_cpu.scala 30:25]
  wire  ifu_io_arvalid; // @[ysyx_22040080_cpu.scala 30:25]
  wire  ifu_io_arready; // @[ysyx_22040080_cpu.scala 30:25]
  wire  ifu_io_rvalid; // @[ysyx_22040080_cpu.scala 30:25]
  wire  ifu_io_rready; // @[ysyx_22040080_cpu.scala 30:25]
  wire  arbiter_clock; // @[ysyx_22040080_cpu.scala 31:25]
  wire  arbiter_reset; // @[ysyx_22040080_cpu.scala 31:25]
  wire [31:0] arbiter_io_ifu_araddr; // @[ysyx_22040080_cpu.scala 31:25]
  wire  arbiter_io_ifu_arvalid; // @[ysyx_22040080_cpu.scala 31:25]
  wire  arbiter_io_ifu_arready; // @[ysyx_22040080_cpu.scala 31:25]
  wire [31:0] arbiter_io_ifu_rdata; // @[ysyx_22040080_cpu.scala 31:25]
  wire  arbiter_io_ifu_rvalid; // @[ysyx_22040080_cpu.scala 31:25]
  wire  arbiter_io_ifu_rready; // @[ysyx_22040080_cpu.scala 31:25]
  wire [31:0] arbiter_io_lsu_araddr; // @[ysyx_22040080_cpu.scala 31:25]
  wire  arbiter_io_lsu_arvalid; // @[ysyx_22040080_cpu.scala 31:25]
  wire  arbiter_io_lsu_arready; // @[ysyx_22040080_cpu.scala 31:25]
  wire [31:0] arbiter_io_lsu_rdata; // @[ysyx_22040080_cpu.scala 31:25]
  wire  arbiter_io_lsu_rvalid; // @[ysyx_22040080_cpu.scala 31:25]
  wire  arbiter_io_lsu_rready; // @[ysyx_22040080_cpu.scala 31:25]
  wire [31:0] arbiter_io_lsu_awaddr; // @[ysyx_22040080_cpu.scala 31:25]
  wire  arbiter_io_lsu_awvalid; // @[ysyx_22040080_cpu.scala 31:25]
  wire  arbiter_io_lsu_awready; // @[ysyx_22040080_cpu.scala 31:25]
  wire [31:0] arbiter_io_lsu_wdata; // @[ysyx_22040080_cpu.scala 31:25]
  wire  arbiter_io_lsu_wvalid; // @[ysyx_22040080_cpu.scala 31:25]
  wire  arbiter_io_lsu_wready; // @[ysyx_22040080_cpu.scala 31:25]
  wire  arbiter_io_lsu_bvalid; // @[ysyx_22040080_cpu.scala 31:25]
  wire  arbiter_io_lsu_bready; // @[ysyx_22040080_cpu.scala 31:25]
  wire [2:0] arbiter_io_lsu_func3; // @[ysyx_22040080_cpu.scala 31:25]
  wire [31:0] arbiter_io_m_araddr; // @[ysyx_22040080_cpu.scala 31:25]
  wire  arbiter_io_m_arvalid; // @[ysyx_22040080_cpu.scala 31:25]
  wire  arbiter_io_m_arready; // @[ysyx_22040080_cpu.scala 31:25]
  wire [31:0] arbiter_io_m_rdata; // @[ysyx_22040080_cpu.scala 31:25]
  wire  arbiter_io_m_rvalid; // @[ysyx_22040080_cpu.scala 31:25]
  wire  arbiter_io_m_rready; // @[ysyx_22040080_cpu.scala 31:25]
  wire [31:0] arbiter_io_m_awaddr; // @[ysyx_22040080_cpu.scala 31:25]
  wire  arbiter_io_m_awvalid; // @[ysyx_22040080_cpu.scala 31:25]
  wire  arbiter_io_m_awready; // @[ysyx_22040080_cpu.scala 31:25]
  wire [31:0] arbiter_io_m_wdata; // @[ysyx_22040080_cpu.scala 31:25]
  wire  arbiter_io_m_wvalid; // @[ysyx_22040080_cpu.scala 31:25]
  wire  arbiter_io_m_wready; // @[ysyx_22040080_cpu.scala 31:25]
  wire  arbiter_io_m_bvalid; // @[ysyx_22040080_cpu.scala 31:25]
  wire  arbiter_io_m_bready; // @[ysyx_22040080_cpu.scala 31:25]
  wire [2:0] arbiter_io_m_func3; // @[ysyx_22040080_cpu.scala 31:25]
  wire  arbiter_io_inst_active; // @[ysyx_22040080_cpu.scala 31:25]
  wire  xbar_clock; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_reset; // @[ysyx_22040080_cpu.scala 32:25]
  wire [31:0] xbar_io_m_araddr; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_m_arvalid; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_m_arready; // @[ysyx_22040080_cpu.scala 32:25]
  wire [31:0] xbar_io_m_rdata; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_m_rvalid; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_m_rready; // @[ysyx_22040080_cpu.scala 32:25]
  wire [31:0] xbar_io_m_awaddr; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_m_awvalid; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_m_awready; // @[ysyx_22040080_cpu.scala 32:25]
  wire [31:0] xbar_io_m_wdata; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_m_wvalid; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_m_wready; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_m_bvalid; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_m_bready; // @[ysyx_22040080_cpu.scala 32:25]
  wire [2:0] xbar_io_m_func3; // @[ysyx_22040080_cpu.scala 32:25]
  wire [31:0] xbar_io_mem_araddr; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_mem_arvalid; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_mem_arready; // @[ysyx_22040080_cpu.scala 32:25]
  wire [31:0] xbar_io_mem_rdata; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_mem_rvalid; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_mem_rready; // @[ysyx_22040080_cpu.scala 32:25]
  wire [31:0] xbar_io_mem_awaddr; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_mem_awvalid; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_mem_awready; // @[ysyx_22040080_cpu.scala 32:25]
  wire [31:0] xbar_io_mem_wdata; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_mem_wvalid; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_mem_wready; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_mem_bvalid; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_mem_bready; // @[ysyx_22040080_cpu.scala 32:25]
  wire [2:0] xbar_io_mem_func3; // @[ysyx_22040080_cpu.scala 32:25]
  wire [31:0] xbar_io_clint_araddr; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_clint_arvalid; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_clint_arready; // @[ysyx_22040080_cpu.scala 32:25]
  wire [31:0] xbar_io_clint_rdata; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_clint_rvalid; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_clint_rready; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_clint_awvalid; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_clint_awready; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_clint_wvalid; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_clint_wready; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_clint_bvalid; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_clint_bready; // @[ysyx_22040080_cpu.scala 32:25]
  wire [31:0] xbar_io_uart_araddr; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_uart_arvalid; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_uart_arready; // @[ysyx_22040080_cpu.scala 32:25]
  wire [31:0] xbar_io_uart_rdata; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_uart_rvalid; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_uart_rready; // @[ysyx_22040080_cpu.scala 32:25]
  wire [31:0] xbar_io_uart_awaddr; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_uart_awvalid; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_uart_awready; // @[ysyx_22040080_cpu.scala 32:25]
  wire [31:0] xbar_io_uart_wdata; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_uart_wvalid; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_uart_wready; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_uart_bvalid; // @[ysyx_22040080_cpu.scala 32:25]
  wire  xbar_io_uart_bready; // @[ysyx_22040080_cpu.scala 32:25]
  wire  mem_clock; // @[ysyx_22040080_cpu.scala 33:25]
  wire  mem_reset; // @[ysyx_22040080_cpu.scala 33:25]
  wire [31:0] mem_io_araddr; // @[ysyx_22040080_cpu.scala 33:25]
  wire  mem_io_arvalid; // @[ysyx_22040080_cpu.scala 33:25]
  wire  mem_io_arready; // @[ysyx_22040080_cpu.scala 33:25]
  wire [31:0] mem_io_rdata; // @[ysyx_22040080_cpu.scala 33:25]
  wire  mem_io_rvalid; // @[ysyx_22040080_cpu.scala 33:25]
  wire  mem_io_rready; // @[ysyx_22040080_cpu.scala 33:25]
  wire [31:0] mem_io_awaddr; // @[ysyx_22040080_cpu.scala 33:25]
  wire  mem_io_awvalid; // @[ysyx_22040080_cpu.scala 33:25]
  wire  mem_io_awready; // @[ysyx_22040080_cpu.scala 33:25]
  wire [31:0] mem_io_wdata; // @[ysyx_22040080_cpu.scala 33:25]
  wire  mem_io_wvalid; // @[ysyx_22040080_cpu.scala 33:25]
  wire  mem_io_wready; // @[ysyx_22040080_cpu.scala 33:25]
  wire  mem_io_bvalid; // @[ysyx_22040080_cpu.scala 33:25]
  wire  mem_io_bready; // @[ysyx_22040080_cpu.scala 33:25]
  wire [2:0] mem_io_func3; // @[ysyx_22040080_cpu.scala 33:25]
  wire  uart_clock; // @[ysyx_22040080_cpu.scala 34:25]
  wire  uart_reset; // @[ysyx_22040080_cpu.scala 34:25]
  wire [31:0] uart_io_araddr; // @[ysyx_22040080_cpu.scala 34:25]
  wire  uart_io_arvalid; // @[ysyx_22040080_cpu.scala 34:25]
  wire  uart_io_arready; // @[ysyx_22040080_cpu.scala 34:25]
  wire [31:0] uart_io_rdata; // @[ysyx_22040080_cpu.scala 34:25]
  wire  uart_io_rvalid; // @[ysyx_22040080_cpu.scala 34:25]
  wire  uart_io_rready; // @[ysyx_22040080_cpu.scala 34:25]
  wire [31:0] uart_io_awaddr; // @[ysyx_22040080_cpu.scala 34:25]
  wire  uart_io_awvalid; // @[ysyx_22040080_cpu.scala 34:25]
  wire  uart_io_awready; // @[ysyx_22040080_cpu.scala 34:25]
  wire [31:0] uart_io_wdata; // @[ysyx_22040080_cpu.scala 34:25]
  wire  uart_io_wvalid; // @[ysyx_22040080_cpu.scala 34:25]
  wire  uart_io_wready; // @[ysyx_22040080_cpu.scala 34:25]
  wire  uart_io_bvalid; // @[ysyx_22040080_cpu.scala 34:25]
  wire  uart_io_bready; // @[ysyx_22040080_cpu.scala 34:25]
  wire  clint_mod_clock; // @[ysyx_22040080_cpu.scala 35:25]
  wire  clint_mod_reset; // @[ysyx_22040080_cpu.scala 35:25]
  wire [31:0] clint_mod_io_araddr; // @[ysyx_22040080_cpu.scala 35:25]
  wire  clint_mod_io_arvalid; // @[ysyx_22040080_cpu.scala 35:25]
  wire  clint_mod_io_arready; // @[ysyx_22040080_cpu.scala 35:25]
  wire [31:0] clint_mod_io_rdata; // @[ysyx_22040080_cpu.scala 35:25]
  wire  clint_mod_io_rvalid; // @[ysyx_22040080_cpu.scala 35:25]
  wire  clint_mod_io_rready; // @[ysyx_22040080_cpu.scala 35:25]
  wire  clint_mod_io_awvalid; // @[ysyx_22040080_cpu.scala 35:25]
  wire  clint_mod_io_awready; // @[ysyx_22040080_cpu.scala 35:25]
  wire  clint_mod_io_wvalid; // @[ysyx_22040080_cpu.scala 35:25]
  wire  clint_mod_io_wready; // @[ysyx_22040080_cpu.scala 35:25]
  wire  clint_mod_io_bvalid; // @[ysyx_22040080_cpu.scala 35:25]
  wire  clint_mod_io_bready; // @[ysyx_22040080_cpu.scala 35:25]
  wire  csr_clock; // @[ysyx_22040080_cpu.scala 36:25]
  wire  csr_reset; // @[ysyx_22040080_cpu.scala 36:25]
  wire  csr_io_wen; // @[ysyx_22040080_cpu.scala 36:25]
  wire [11:0] csr_io_csr_addr; // @[ysyx_22040080_cpu.scala 36:25]
  wire [31:0] csr_io_rdata; // @[ysyx_22040080_cpu.scala 36:25]
  wire [31:0] csr_io_wdata; // @[ysyx_22040080_cpu.scala 36:25]
  wire [31:0] csr_io_mepc; // @[ysyx_22040080_cpu.scala 36:25]
  wire [31:0] csr_io_mtvec; // @[ysyx_22040080_cpu.scala 36:25]
  wire  csr_io_trap_valid; // @[ysyx_22040080_cpu.scala 36:25]
  wire [31:0] csr_io_trap_mepc; // @[ysyx_22040080_cpu.scala 36:25]
  wire [31:0] csr_io_trap_mcause; // @[ysyx_22040080_cpu.scala 36:25]
  wire  lsu_clock; // @[ysyx_22040080_cpu.scala 37:25]
  wire  lsu_reset; // @[ysyx_22040080_cpu.scala 37:25]
  wire [31:0] lsu_io_mem_addr; // @[ysyx_22040080_cpu.scala 37:25]
  wire [31:0] lsu_io_mem_wdata; // @[ysyx_22040080_cpu.scala 37:25]
  wire [2:0] lsu_io_func3; // @[ysyx_22040080_cpu.scala 37:25]
  wire  lsu_io_is_load; // @[ysyx_22040080_cpu.scala 37:25]
  wire  lsu_io_is_store; // @[ysyx_22040080_cpu.scala 37:25]
  wire [31:0] lsu_io_load_data; // @[ysyx_22040080_cpu.scala 37:25]
  wire [2:0] lsu_io_lsu_func3; // @[ysyx_22040080_cpu.scala 37:25]
  wire  lsu_io_lsu_reqValid; // @[ysyx_22040080_cpu.scala 37:25]
  wire  lsu_io_lsu_reqReady; // @[ysyx_22040080_cpu.scala 37:25]
  wire  lsu_io_lsu_respValid; // @[ysyx_22040080_cpu.scala 37:25]
  wire  lsu_io_lsu_respReady; // @[ysyx_22040080_cpu.scala 37:25]
  wire [31:0] lsu_io_araddr; // @[ysyx_22040080_cpu.scala 37:25]
  wire  lsu_io_arvalid; // @[ysyx_22040080_cpu.scala 37:25]
  wire  lsu_io_arready; // @[ysyx_22040080_cpu.scala 37:25]
  wire [31:0] lsu_io_rdata; // @[ysyx_22040080_cpu.scala 37:25]
  wire  lsu_io_rvalid; // @[ysyx_22040080_cpu.scala 37:25]
  wire  lsu_io_rready; // @[ysyx_22040080_cpu.scala 37:25]
  wire [31:0] lsu_io_awaddr; // @[ysyx_22040080_cpu.scala 37:25]
  wire  lsu_io_awvalid; // @[ysyx_22040080_cpu.scala 37:25]
  wire  lsu_io_awready; // @[ysyx_22040080_cpu.scala 37:25]
  wire [31:0] lsu_io_wdata; // @[ysyx_22040080_cpu.scala 37:25]
  wire  lsu_io_wvalid; // @[ysyx_22040080_cpu.scala 37:25]
  wire  lsu_io_wready; // @[ysyx_22040080_cpu.scala 37:25]
  wire  lsu_io_bvalid; // @[ysyx_22040080_cpu.scala 37:25]
  wire  lsu_io_bready; // @[ysyx_22040080_cpu.scala 37:25]
  wire [31:0] idu_io_rdata; // @[ysyx_22040080_cpu.scala 38:25]
  wire  idu_io_inst_active; // @[ysyx_22040080_cpu.scala 38:25]
  wire [4:0] idu_io_rs1; // @[ysyx_22040080_cpu.scala 38:25]
  wire [4:0] idu_io_rs2; // @[ysyx_22040080_cpu.scala 38:25]
  wire [4:0] idu_io_rd; // @[ysyx_22040080_cpu.scala 38:25]
  wire [2:0] idu_io_func3; // @[ysyx_22040080_cpu.scala 38:25]
  wire [31:0] idu_io_imm_ext; // @[ysyx_22040080_cpu.scala 38:25]
  wire [6:0] idu_io_op; // @[ysyx_22040080_cpu.scala 38:25]
  wire [6:0] idu_io_func7; // @[ysyx_22040080_cpu.scala 38:25]
  wire [4:0] idu_io_shamt; // @[ysyx_22040080_cpu.scala 38:25]
  wire [11:0] idu_io_csr_addr; // @[ysyx_22040080_cpu.scala 38:25]
  wire  idu_io_is_jal; // @[ysyx_22040080_cpu.scala 38:25]
  wire  idu_io_is_jalr; // @[ysyx_22040080_cpu.scala 38:25]
  wire  idu_io_is_branch; // @[ysyx_22040080_cpu.scala 38:25]
  wire  idu_io_is_load; // @[ysyx_22040080_cpu.scala 38:25]
  wire  idu_io_is_store; // @[ysyx_22040080_cpu.scala 38:25]
  wire  idu_io_lsu_reqValid; // @[ysyx_22040080_cpu.scala 38:25]
  wire [31:0] alu_io_rs1_data; // @[ysyx_22040080_cpu.scala 39:25]
  wire [31:0] alu_io_rs2_data; // @[ysyx_22040080_cpu.scala 39:25]
  wire [31:0] alu_io_imm_ext; // @[ysyx_22040080_cpu.scala 39:25]
  wire [2:0] alu_io_func3; // @[ysyx_22040080_cpu.scala 39:25]
  wire [6:0] alu_io_func7; // @[ysyx_22040080_cpu.scala 39:25]
  wire [6:0] alu_io_op; // @[ysyx_22040080_cpu.scala 39:25]
  wire [31:0] alu_io_pc; // @[ysyx_22040080_cpu.scala 39:25]
  wire [4:0] alu_io_shamt; // @[ysyx_22040080_cpu.scala 39:25]
  wire  alu_io_inst_active; // @[ysyx_22040080_cpu.scala 39:25]
  wire [31:0] alu_io_result; // @[ysyx_22040080_cpu.scala 39:25]
  wire  alu_io_wen; // @[ysyx_22040080_cpu.scala 39:25]
  wire  alu_io_branch_taken; // @[ysyx_22040080_cpu.scala 39:25]
  wire [31:0] alu_io_jal_target; // @[ysyx_22040080_cpu.scala 39:25]
  wire [31:0] alu_io_mem_addr; // @[ysyx_22040080_cpu.scala 39:25]
  wire [31:0] alu_io_mem_wdata; // @[ysyx_22040080_cpu.scala 39:25]
  wire [31:0] alu_io_csr_rdata; // @[ysyx_22040080_cpu.scala 39:25]
  wire  alu_io_csr_wen; // @[ysyx_22040080_cpu.scala 39:25]
  wire [31:0] alu_io_csr_wdata; // @[ysyx_22040080_cpu.scala 39:25]
  wire  alu_io_trap_valid; // @[ysyx_22040080_cpu.scala 39:25]
  wire  alu_io_is_mret; // @[ysyx_22040080_cpu.scala 39:25]
  wire [31:0] alu_io_trap_mepc; // @[ysyx_22040080_cpu.scala 39:25]
  wire [31:0] alu_io_trap_mcause; // @[ysyx_22040080_cpu.scala 39:25]
  wire  regfile_clock; // @[ysyx_22040080_cpu.scala 40:25]
  wire  regfile_reset; // @[ysyx_22040080_cpu.scala 40:25]
  wire  regfile_io_wen; // @[ysyx_22040080_cpu.scala 40:25]
  wire [4:0] regfile_io_raddr1; // @[ysyx_22040080_cpu.scala 40:25]
  wire [4:0] regfile_io_raddr2; // @[ysyx_22040080_cpu.scala 40:25]
  wire [4:0] regfile_io_waddr; // @[ysyx_22040080_cpu.scala 40:25]
  wire [31:0] regfile_io_wdata; // @[ysyx_22040080_cpu.scala 40:25]
  wire [31:0] regfile_io_rdata1; // @[ysyx_22040080_cpu.scala 40:25]
  wire [31:0] regfile_io_rdata2; // @[ysyx_22040080_cpu.scala 40:25]
  wire  regfile_io_wb_done; // @[ysyx_22040080_cpu.scala 40:25]
  wire  regfile_io_is_branch; // @[ysyx_22040080_cpu.scala 40:25]
  wire  regfile_io_is_load; // @[ysyx_22040080_cpu.scala 40:25]
  wire  regfile_io_is_store; // @[ysyx_22040080_cpu.scala 40:25]
  wire [31:0] regfile_io_load_data; // @[ysyx_22040080_cpu.scala 40:25]
  wire  regfile_io_lsu_reqReady; // @[ysyx_22040080_cpu.scala 40:25]
  wire  regfile_io_lsu_respValid; // @[ysyx_22040080_cpu.scala 40:25]
  wire  regfile_io_lsu_respReady; // @[ysyx_22040080_cpu.scala 40:25]
  generate_next_pc gpc ( // @[ysyx_22040080_cpu.scala 28:25]
    .clock(gpc_clock),
    .reset(gpc_reset),
    .io_pc(gpc_io_pc),
    .io_is_jal(gpc_io_is_jal),
    .io_is_jalr(gpc_io_is_jalr),
    .io_branch_taken(gpc_io_branch_taken),
    .io_jal_target(gpc_io_jal_target),
    .io_next_pc(gpc_io_next_pc)
  );
  ysyx_22040080_pc pc_mod ( // @[ysyx_22040080_cpu.scala 29:25]
    .clock(pc_mod_clock),
    .reset(pc_mod_reset),
    .io_trap_valid(pc_mod_io_trap_valid),
    .io_is_mret(pc_mod_io_is_mret),
    .io_mtvec(pc_mod_io_mtvec),
    .io_mepc(pc_mod_io_mepc),
    .io_pc(pc_mod_io_pc),
    .io_pc_valid(pc_mod_io_pc_valid),
    .io_next_pc(pc_mod_io_next_pc),
    .io_pc_update_en(pc_mod_io_pc_update_en),
    .io_trace_pc(pc_mod_io_trace_pc),
    .io_trace_instr(pc_mod_io_trace_instr),
    .io_instr_done(pc_mod_io_instr_done)
  );
  ysyx_22040080_ifu ifu ( // @[ysyx_22040080_cpu.scala 30:25]
    .clock(ifu_clock),
    .reset(ifu_reset),
    .io_pc(ifu_io_pc),
    .io_pc_valid(ifu_io_pc_valid),
    .io_araddr(ifu_io_araddr),
    .io_arvalid(ifu_io_arvalid),
    .io_arready(ifu_io_arready),
    .io_rvalid(ifu_io_rvalid),
    .io_rready(ifu_io_rready)
  );
  ysyx_22040080_axi_arbiter arbiter ( // @[ysyx_22040080_cpu.scala 31:25]
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
    .io_m_araddr(arbiter_io_m_araddr),
    .io_m_arvalid(arbiter_io_m_arvalid),
    .io_m_arready(arbiter_io_m_arready),
    .io_m_rdata(arbiter_io_m_rdata),
    .io_m_rvalid(arbiter_io_m_rvalid),
    .io_m_rready(arbiter_io_m_rready),
    .io_m_awaddr(arbiter_io_m_awaddr),
    .io_m_awvalid(arbiter_io_m_awvalid),
    .io_m_awready(arbiter_io_m_awready),
    .io_m_wdata(arbiter_io_m_wdata),
    .io_m_wvalid(arbiter_io_m_wvalid),
    .io_m_wready(arbiter_io_m_wready),
    .io_m_bvalid(arbiter_io_m_bvalid),
    .io_m_bready(arbiter_io_m_bready),
    .io_m_func3(arbiter_io_m_func3),
    .io_inst_active(arbiter_io_inst_active)
  );
  ysyx_22040080_axi_xbar xbar ( // @[ysyx_22040080_cpu.scala 32:25]
    .clock(xbar_clock),
    .reset(xbar_reset),
    .io_m_araddr(xbar_io_m_araddr),
    .io_m_arvalid(xbar_io_m_arvalid),
    .io_m_arready(xbar_io_m_arready),
    .io_m_rdata(xbar_io_m_rdata),
    .io_m_rvalid(xbar_io_m_rvalid),
    .io_m_rready(xbar_io_m_rready),
    .io_m_awaddr(xbar_io_m_awaddr),
    .io_m_awvalid(xbar_io_m_awvalid),
    .io_m_awready(xbar_io_m_awready),
    .io_m_wdata(xbar_io_m_wdata),
    .io_m_wvalid(xbar_io_m_wvalid),
    .io_m_wready(xbar_io_m_wready),
    .io_m_bvalid(xbar_io_m_bvalid),
    .io_m_bready(xbar_io_m_bready),
    .io_m_func3(xbar_io_m_func3),
    .io_mem_araddr(xbar_io_mem_araddr),
    .io_mem_arvalid(xbar_io_mem_arvalid),
    .io_mem_arready(xbar_io_mem_arready),
    .io_mem_rdata(xbar_io_mem_rdata),
    .io_mem_rvalid(xbar_io_mem_rvalid),
    .io_mem_rready(xbar_io_mem_rready),
    .io_mem_awaddr(xbar_io_mem_awaddr),
    .io_mem_awvalid(xbar_io_mem_awvalid),
    .io_mem_awready(xbar_io_mem_awready),
    .io_mem_wdata(xbar_io_mem_wdata),
    .io_mem_wvalid(xbar_io_mem_wvalid),
    .io_mem_wready(xbar_io_mem_wready),
    .io_mem_bvalid(xbar_io_mem_bvalid),
    .io_mem_bready(xbar_io_mem_bready),
    .io_mem_func3(xbar_io_mem_func3),
    .io_clint_araddr(xbar_io_clint_araddr),
    .io_clint_arvalid(xbar_io_clint_arvalid),
    .io_clint_arready(xbar_io_clint_arready),
    .io_clint_rdata(xbar_io_clint_rdata),
    .io_clint_rvalid(xbar_io_clint_rvalid),
    .io_clint_rready(xbar_io_clint_rready),
    .io_clint_awvalid(xbar_io_clint_awvalid),
    .io_clint_awready(xbar_io_clint_awready),
    .io_clint_wvalid(xbar_io_clint_wvalid),
    .io_clint_wready(xbar_io_clint_wready),
    .io_clint_bvalid(xbar_io_clint_bvalid),
    .io_clint_bready(xbar_io_clint_bready),
    .io_uart_araddr(xbar_io_uart_araddr),
    .io_uart_arvalid(xbar_io_uart_arvalid),
    .io_uart_arready(xbar_io_uart_arready),
    .io_uart_rdata(xbar_io_uart_rdata),
    .io_uart_rvalid(xbar_io_uart_rvalid),
    .io_uart_rready(xbar_io_uart_rready),
    .io_uart_awaddr(xbar_io_uart_awaddr),
    .io_uart_awvalid(xbar_io_uart_awvalid),
    .io_uart_awready(xbar_io_uart_awready),
    .io_uart_wdata(xbar_io_uart_wdata),
    .io_uart_wvalid(xbar_io_uart_wvalid),
    .io_uart_wready(xbar_io_uart_wready),
    .io_uart_bvalid(xbar_io_uart_bvalid),
    .io_uart_bready(xbar_io_uart_bready)
  );
  memory mem ( // @[ysyx_22040080_cpu.scala 33:25]
    .clock(mem_clock),
    .reset(mem_reset),
    .io_araddr(mem_io_araddr),
    .io_arvalid(mem_io_arvalid),
    .io_arready(mem_io_arready),
    .io_rdata(mem_io_rdata),
    .io_rvalid(mem_io_rvalid),
    .io_rready(mem_io_rready),
    .io_awaddr(mem_io_awaddr),
    .io_awvalid(mem_io_awvalid),
    .io_awready(mem_io_awready),
    .io_wdata(mem_io_wdata),
    .io_wvalid(mem_io_wvalid),
    .io_wready(mem_io_wready),
    .io_bvalid(mem_io_bvalid),
    .io_bready(mem_io_bready),
    .io_func3(mem_io_func3)
  );
  ysyx_22040080_uart_axi uart ( // @[ysyx_22040080_cpu.scala 34:25]
    .clock(uart_clock),
    .reset(uart_reset),
    .io_araddr(uart_io_araddr),
    .io_arvalid(uart_io_arvalid),
    .io_arready(uart_io_arready),
    .io_rdata(uart_io_rdata),
    .io_rvalid(uart_io_rvalid),
    .io_rready(uart_io_rready),
    .io_awaddr(uart_io_awaddr),
    .io_awvalid(uart_io_awvalid),
    .io_awready(uart_io_awready),
    .io_wdata(uart_io_wdata),
    .io_wvalid(uart_io_wvalid),
    .io_wready(uart_io_wready),
    .io_bvalid(uart_io_bvalid),
    .io_bready(uart_io_bready)
  );
  ysyx_22040080_clint_axi clint_mod ( // @[ysyx_22040080_cpu.scala 35:25]
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
  ysyx_22040080_csr csr ( // @[ysyx_22040080_cpu.scala 36:25]
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
  ysyx_22040080_lsu lsu ( // @[ysyx_22040080_cpu.scala 37:25]
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
    .io_bready(lsu_io_bready)
  );
  ysyx_22040080_idu idu ( // @[ysyx_22040080_cpu.scala 38:25]
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
  ysyx_22040080_alu alu ( // @[ysyx_22040080_cpu.scala 39:25]
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
  RegisterFile regfile ( // @[ysyx_22040080_cpu.scala 40:25]
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
  assign io_trace_pc = pc_mod_io_trace_pc; // @[ysyx_22040080_cpu.scala 69:18]
  assign io_trace_instr = pc_mod_io_trace_instr; // @[ysyx_22040080_cpu.scala 70:18]
  assign io_instr_done = pc_mod_io_instr_done; // @[ysyx_22040080_cpu.scala 71:18]
  assign gpc_clock = clock;
  assign gpc_reset = reset;
  assign gpc_io_pc = pc_mod_io_pc; // @[ysyx_22040080_cpu.scala 52:23]
  assign gpc_io_is_jal = idu_io_is_jal; // @[ysyx_22040080_cpu.scala 53:23]
  assign gpc_io_is_jalr = idu_io_is_jalr; // @[ysyx_22040080_cpu.scala 54:23]
  assign gpc_io_branch_taken = alu_io_branch_taken; // @[ysyx_22040080_cpu.scala 55:23]
  assign gpc_io_jal_target = alu_io_jal_target; // @[ysyx_22040080_cpu.scala 56:23]
  assign pc_mod_clock = clock;
  assign pc_mod_reset = reset;
  assign pc_mod_io_trap_valid = alu_io_trap_valid; // @[ysyx_22040080_cpu.scala 61:26]
  assign pc_mod_io_is_mret = alu_io_is_mret; // @[ysyx_22040080_cpu.scala 62:26]
  assign pc_mod_io_mtvec = csr_io_mtvec; // @[ysyx_22040080_cpu.scala 63:26]
  assign pc_mod_io_mepc = csr_io_mepc; // @[ysyx_22040080_cpu.scala 64:26]
  assign pc_mod_io_next_pc = gpc_io_next_pc; // @[ysyx_22040080_cpu.scala 65:26]
  assign pc_mod_io_pc_update_en = regfile_io_wb_done; // @[ysyx_22040080_cpu.scala 66:26]
  assign ifu_clock = clock;
  assign ifu_reset = reset;
  assign ifu_io_pc = pc_mod_io_pc; // @[ysyx_22040080_cpu.scala 76:23]
  assign ifu_io_pc_valid = pc_mod_io_pc_valid; // @[ysyx_22040080_cpu.scala 78:23]
  assign ifu_io_arready = arbiter_io_ifu_arready; // @[ysyx_22040080_cpu.scala 85:26]
  assign ifu_io_rvalid = arbiter_io_ifu_rvalid; // @[ysyx_22040080_cpu.scala 87:26]
  assign arbiter_clock = clock;
  assign arbiter_reset = reset;
  assign arbiter_io_ifu_araddr = ifu_io_araddr; // @[ysyx_22040080_cpu.scala 83:26]
  assign arbiter_io_ifu_arvalid = ifu_io_arvalid; // @[ysyx_22040080_cpu.scala 84:26]
  assign arbiter_io_ifu_rready = ifu_io_rready; // @[ysyx_22040080_cpu.scala 88:26]
  assign arbiter_io_lsu_araddr = lsu_io_araddr; // @[ysyx_22040080_cpu.scala 93:26]
  assign arbiter_io_lsu_arvalid = lsu_io_arvalid; // @[ysyx_22040080_cpu.scala 94:26]
  assign arbiter_io_lsu_rready = lsu_io_rready; // @[ysyx_22040080_cpu.scala 98:26]
  assign arbiter_io_lsu_awaddr = lsu_io_awaddr; // @[ysyx_22040080_cpu.scala 103:26]
  assign arbiter_io_lsu_awvalid = lsu_io_awvalid; // @[ysyx_22040080_cpu.scala 104:26]
  assign arbiter_io_lsu_wdata = lsu_io_wdata; // @[ysyx_22040080_cpu.scala 106:26]
  assign arbiter_io_lsu_wvalid = lsu_io_wvalid; // @[ysyx_22040080_cpu.scala 107:26]
  assign arbiter_io_lsu_bready = lsu_io_bready; // @[ysyx_22040080_cpu.scala 110:26]
  assign arbiter_io_lsu_func3 = lsu_io_lsu_func3; // @[ysyx_22040080_cpu.scala 112:26]
  assign arbiter_io_m_arready = xbar_io_m_arready; // @[ysyx_22040080_cpu.scala 119:25]
  assign arbiter_io_m_rdata = xbar_io_m_rdata; // @[ysyx_22040080_cpu.scala 120:25]
  assign arbiter_io_m_rvalid = xbar_io_m_rvalid; // @[ysyx_22040080_cpu.scala 121:25]
  assign arbiter_io_m_awready = xbar_io_m_awready; // @[ysyx_22040080_cpu.scala 126:25]
  assign arbiter_io_m_wready = xbar_io_m_wready; // @[ysyx_22040080_cpu.scala 129:25]
  assign arbiter_io_m_bvalid = xbar_io_m_bvalid; // @[ysyx_22040080_cpu.scala 130:25]
  assign xbar_clock = clock;
  assign xbar_reset = reset;
  assign xbar_io_m_araddr = arbiter_io_m_araddr; // @[ysyx_22040080_cpu.scala 117:25]
  assign xbar_io_m_arvalid = arbiter_io_m_arvalid; // @[ysyx_22040080_cpu.scala 118:25]
  assign xbar_io_m_rready = arbiter_io_m_rready; // @[ysyx_22040080_cpu.scala 122:25]
  assign xbar_io_m_awaddr = arbiter_io_m_awaddr; // @[ysyx_22040080_cpu.scala 124:25]
  assign xbar_io_m_awvalid = arbiter_io_m_awvalid; // @[ysyx_22040080_cpu.scala 125:25]
  assign xbar_io_m_wdata = arbiter_io_m_wdata; // @[ysyx_22040080_cpu.scala 127:25]
  assign xbar_io_m_wvalid = arbiter_io_m_wvalid; // @[ysyx_22040080_cpu.scala 128:25]
  assign xbar_io_m_bready = arbiter_io_m_bready; // @[ysyx_22040080_cpu.scala 131:25]
  assign xbar_io_m_func3 = arbiter_io_m_func3; // @[ysyx_22040080_cpu.scala 133:25]
  assign xbar_io_mem_arready = mem_io_arready; // @[ysyx_22040080_cpu.scala 140:25]
  assign xbar_io_mem_rdata = mem_io_rdata; // @[ysyx_22040080_cpu.scala 141:25]
  assign xbar_io_mem_rvalid = mem_io_rvalid; // @[ysyx_22040080_cpu.scala 142:25]
  assign xbar_io_mem_awready = mem_io_awready; // @[ysyx_22040080_cpu.scala 147:25]
  assign xbar_io_mem_wready = mem_io_wready; // @[ysyx_22040080_cpu.scala 150:25]
  assign xbar_io_mem_bvalid = mem_io_bvalid; // @[ysyx_22040080_cpu.scala 151:25]
  assign xbar_io_clint_arready = clint_mod_io_arready; // @[ysyx_22040080_cpu.scala 160:27]
  assign xbar_io_clint_rdata = clint_mod_io_rdata; // @[ysyx_22040080_cpu.scala 161:27]
  assign xbar_io_clint_rvalid = clint_mod_io_rvalid; // @[ysyx_22040080_cpu.scala 162:27]
  assign xbar_io_clint_awready = clint_mod_io_awready; // @[ysyx_22040080_cpu.scala 167:27]
  assign xbar_io_clint_wready = clint_mod_io_wready; // @[ysyx_22040080_cpu.scala 170:27]
  assign xbar_io_clint_bvalid = clint_mod_io_bvalid; // @[ysyx_22040080_cpu.scala 171:27]
  assign xbar_io_uart_arready = uart_io_arready; // @[ysyx_22040080_cpu.scala 179:25]
  assign xbar_io_uart_rdata = uart_io_rdata; // @[ysyx_22040080_cpu.scala 180:25]
  assign xbar_io_uart_rvalid = uart_io_rvalid; // @[ysyx_22040080_cpu.scala 181:25]
  assign xbar_io_uart_awready = uart_io_awready; // @[ysyx_22040080_cpu.scala 186:25]
  assign xbar_io_uart_wready = uart_io_wready; // @[ysyx_22040080_cpu.scala 189:25]
  assign xbar_io_uart_bvalid = uart_io_bvalid; // @[ysyx_22040080_cpu.scala 190:25]
  assign mem_clock = clock;
  assign mem_reset = reset;
  assign mem_io_araddr = xbar_io_mem_araddr; // @[ysyx_22040080_cpu.scala 138:25]
  assign mem_io_arvalid = xbar_io_mem_arvalid; // @[ysyx_22040080_cpu.scala 139:25]
  assign mem_io_rready = xbar_io_mem_rready; // @[ysyx_22040080_cpu.scala 143:25]
  assign mem_io_awaddr = xbar_io_mem_awaddr; // @[ysyx_22040080_cpu.scala 145:25]
  assign mem_io_awvalid = xbar_io_mem_awvalid; // @[ysyx_22040080_cpu.scala 146:25]
  assign mem_io_wdata = xbar_io_mem_wdata; // @[ysyx_22040080_cpu.scala 148:25]
  assign mem_io_wvalid = xbar_io_mem_wvalid; // @[ysyx_22040080_cpu.scala 149:25]
  assign mem_io_bready = xbar_io_mem_bready; // @[ysyx_22040080_cpu.scala 152:25]
  assign mem_io_func3 = xbar_io_mem_func3; // @[ysyx_22040080_cpu.scala 153:25]
  assign uart_clock = clock;
  assign uart_reset = reset;
  assign uart_io_araddr = xbar_io_uart_araddr; // @[ysyx_22040080_cpu.scala 177:25]
  assign uart_io_arvalid = xbar_io_uart_arvalid; // @[ysyx_22040080_cpu.scala 178:25]
  assign uart_io_rready = xbar_io_uart_rready; // @[ysyx_22040080_cpu.scala 182:25]
  assign uart_io_awaddr = xbar_io_uart_awaddr; // @[ysyx_22040080_cpu.scala 184:25]
  assign uart_io_awvalid = xbar_io_uart_awvalid; // @[ysyx_22040080_cpu.scala 185:25]
  assign uart_io_wdata = xbar_io_uart_wdata; // @[ysyx_22040080_cpu.scala 187:25]
  assign uart_io_wvalid = xbar_io_uart_wvalid; // @[ysyx_22040080_cpu.scala 188:25]
  assign uart_io_bready = xbar_io_uart_bready; // @[ysyx_22040080_cpu.scala 191:25]
  assign clint_mod_clock = clock;
  assign clint_mod_reset = reset;
  assign clint_mod_io_araddr = xbar_io_clint_araddr; // @[ysyx_22040080_cpu.scala 158:27]
  assign clint_mod_io_arvalid = xbar_io_clint_arvalid; // @[ysyx_22040080_cpu.scala 159:27]
  assign clint_mod_io_rready = xbar_io_clint_rready; // @[ysyx_22040080_cpu.scala 163:27]
  assign clint_mod_io_awvalid = xbar_io_clint_awvalid; // @[ysyx_22040080_cpu.scala 166:27]
  assign clint_mod_io_wvalid = xbar_io_clint_wvalid; // @[ysyx_22040080_cpu.scala 169:27]
  assign clint_mod_io_bready = xbar_io_clint_bready; // @[ysyx_22040080_cpu.scala 172:27]
  assign csr_clock = clock;
  assign csr_reset = reset;
  assign csr_io_wen = alu_io_csr_wen; // @[ysyx_22040080_cpu.scala 216:22]
  assign csr_io_csr_addr = idu_io_csr_addr; // @[ysyx_22040080_cpu.scala 217:22]
  assign csr_io_wdata = alu_io_csr_wdata; // @[ysyx_22040080_cpu.scala 218:22]
  assign csr_io_trap_valid = alu_io_trap_valid; // @[ysyx_22040080_cpu.scala 219:22]
  assign csr_io_trap_mepc = alu_io_trap_mepc; // @[ysyx_22040080_cpu.scala 220:22]
  assign csr_io_trap_mcause = alu_io_trap_mcause; // @[ysyx_22040080_cpu.scala 221:22]
  assign lsu_clock = clock;
  assign lsu_reset = reset;
  assign lsu_io_mem_addr = alu_io_mem_addr; // @[ysyx_22040080_cpu.scala 226:24]
  assign lsu_io_mem_wdata = alu_io_mem_wdata; // @[ysyx_22040080_cpu.scala 227:24]
  assign lsu_io_func3 = idu_io_func3; // @[ysyx_22040080_cpu.scala 228:24]
  assign lsu_io_is_load = idu_io_is_load; // @[ysyx_22040080_cpu.scala 229:24]
  assign lsu_io_is_store = idu_io_is_store; // @[ysyx_22040080_cpu.scala 230:24]
  assign lsu_io_lsu_reqValid = idu_io_lsu_reqValid; // @[ysyx_22040080_cpu.scala 232:24]
  assign lsu_io_lsu_respReady = regfile_io_lsu_respReady; // @[ysyx_22040080_cpu.scala 233:24]
  assign lsu_io_arready = arbiter_io_lsu_arready; // @[ysyx_22040080_cpu.scala 95:26]
  assign lsu_io_rdata = arbiter_io_lsu_rdata; // @[ysyx_22040080_cpu.scala 96:26]
  assign lsu_io_rvalid = arbiter_io_lsu_rvalid; // @[ysyx_22040080_cpu.scala 97:26]
  assign lsu_io_awready = arbiter_io_lsu_awready; // @[ysyx_22040080_cpu.scala 105:26]
  assign lsu_io_wready = arbiter_io_lsu_wready; // @[ysyx_22040080_cpu.scala 108:26]
  assign lsu_io_bvalid = arbiter_io_lsu_bvalid; // @[ysyx_22040080_cpu.scala 109:26]
  assign idu_io_rdata = arbiter_io_ifu_rdata; // @[ysyx_22040080_cpu.scala 196:22]
  assign idu_io_inst_active = arbiter_io_inst_active; // @[ysyx_22040080_cpu.scala 197:22]
  assign alu_io_rs1_data = regfile_io_rdata1; // @[ysyx_22040080_cpu.scala 202:22]
  assign alu_io_rs2_data = regfile_io_rdata2; // @[ysyx_22040080_cpu.scala 203:22]
  assign alu_io_imm_ext = idu_io_imm_ext; // @[ysyx_22040080_cpu.scala 204:22]
  assign alu_io_func3 = idu_io_func3; // @[ysyx_22040080_cpu.scala 205:22]
  assign alu_io_func7 = idu_io_func7; // @[ysyx_22040080_cpu.scala 206:22]
  assign alu_io_op = idu_io_op; // @[ysyx_22040080_cpu.scala 207:22]
  assign alu_io_pc = pc_mod_io_pc; // @[ysyx_22040080_cpu.scala 208:22]
  assign alu_io_shamt = idu_io_shamt; // @[ysyx_22040080_cpu.scala 209:22]
  assign alu_io_inst_active = arbiter_io_inst_active; // @[ysyx_22040080_cpu.scala 210:22]
  assign alu_io_csr_rdata = csr_io_rdata; // @[ysyx_22040080_cpu.scala 211:22]
  assign regfile_clock = clock;
  assign regfile_reset = reset;
  assign regfile_io_wen = alu_io_wen; // @[ysyx_22040080_cpu.scala 238:28]
  assign regfile_io_raddr1 = idu_io_rs1; // @[ysyx_22040080_cpu.scala 239:28]
  assign regfile_io_raddr2 = idu_io_rs2; // @[ysyx_22040080_cpu.scala 240:28]
  assign regfile_io_waddr = idu_io_rd; // @[ysyx_22040080_cpu.scala 241:28]
  assign regfile_io_wdata = alu_io_result; // @[ysyx_22040080_cpu.scala 242:28]
  assign regfile_io_is_branch = idu_io_is_branch; // @[ysyx_22040080_cpu.scala 243:28]
  assign regfile_io_is_load = idu_io_is_load; // @[ysyx_22040080_cpu.scala 244:28]
  assign regfile_io_is_store = idu_io_is_store; // @[ysyx_22040080_cpu.scala 245:28]
  assign regfile_io_load_data = lsu_io_load_data; // @[ysyx_22040080_cpu.scala 246:28]
  assign regfile_io_lsu_reqReady = lsu_io_lsu_reqReady; // @[ysyx_22040080_cpu.scala 247:28]
  assign regfile_io_lsu_respValid = lsu_io_lsu_respValid; // @[ysyx_22040080_cpu.scala 248:28]
endmodule
