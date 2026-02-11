module ysyx_22040080_axi_arbiter (
  input  clk,
  input  rst,

  // IFU: read-only master
  input  [31:0] ifu_araddr,
  input         ifu_arvalid,
  output reg    ifu_arready,
  output reg [31:0] ifu_rdata,
  output reg    ifu_rvalid,
  input         ifu_rready,

  // LSU: read master
  input  [31:0] lsu_araddr,
  input         lsu_arvalid,
  output reg    lsu_arready,
  output reg [31:0] lsu_rdata,
  output reg    lsu_rvalid,
  input         lsu_rready,

  // LSU: write master
  input  [31:0] lsu_awaddr,
  input         lsu_awvalid,
  output reg    lsu_awready,
  input  [31:0] lsu_wdata,
  input         lsu_wvalid,
  output reg    lsu_wready,
  output reg    lsu_bvalid,
  input         lsu_bready,

  input  [2:0]  lsu_func3,

  // Memory: AXI4-Lite slave
  output reg [31:0] m_araddr,
  output reg        m_arvalid,
  input             m_arready,
  input  [31:0]     m_rdata,
  input             m_rvalid,
  output reg        m_rready,

  output reg [31:0] m_awaddr,
  output reg        m_awvalid,
  input             m_awready,
  output reg [31:0] m_wdata,
  output reg        m_wvalid,
  input             m_wready,

  input             m_bvalid,
  output reg        m_bready,

  output reg [2:0]  m_func3,

  output wire       inst_active
);

  import "DPI-C" function void ebreak_trigger();

  localparam ST_IDLE     = 3'd0;
  localparam ST_READ_IFU = 3'd1;
  localparam ST_READ_LSU = 3'd2;
  localparam ST_WAIT_R   = 3'd3;
  localparam ST_WRITE    = 3'd4;
  localparam ST_WAIT_B   = 3'd5;

  reg [2:0] state;
  reg       read_owner_ifu;
  reg       aw_done;
  reg       w_done;
  reg [2:0] func3_latch;

  wire req_write    = lsu_awvalid || lsu_wvalid;
  wire req_ifu_read = ifu_arvalid;
  wire req_lsu_read = lsu_arvalid;

  // 状态机
  always @(posedge clk) begin
    if (rst) begin
      state <= ST_IDLE;
      read_owner_ifu <= 1'b0;
      aw_done <= 1'b0;
      w_done <= 1'b0;
      func3_latch <= 3'b010;
    end else begin
      case (state)
        ST_IDLE: begin
          aw_done <= 1'b0;
          w_done <= 1'b0;
          if (req_write) begin
            state <= ST_WRITE;
            func3_latch <= lsu_func3;
          end 
          else if (req_ifu_read) begin
            state <= ST_READ_IFU;
            func3_latch <= 3'b010; // IFU 取指等价于 LW
          end 
          else if (req_lsu_read) begin
            state <= ST_READ_LSU;
            func3_latch <= lsu_func3;
          end
        end
        ST_READ_IFU: begin
          if (m_arvalid && m_arready) begin
            read_owner_ifu <= 1'b1;
            state <= ST_WAIT_R;
          end
        end
        ST_READ_LSU: begin
          if (m_arvalid && m_arready) begin
            read_owner_ifu <= 1'b0;
            state <= ST_WAIT_R;
          end
        end
        ST_WAIT_R: begin
          if (m_rvalid && m_rready) begin
            if (read_owner_ifu) begin
              if (m_rdata == 32'b00000000000100000000000001110011) begin
                $display("检测到ebreak, 执行$finish");
                ebreak_trigger();
              end
            end
            state <= ST_IDLE;
          end
        end
        ST_WRITE: begin
          if (m_awvalid && m_awready) begin
            aw_done <= 1'b1;
          end
          if (m_wvalid && m_wready) begin
            w_done <= 1'b1;
          end
          if (aw_done && w_done) begin
            state <= ST_WAIT_B;
          end
        end
        ST_WAIT_B: begin
          if (m_bvalid && m_bready) begin
            state <= ST_IDLE;
          end
        end
        default: state <= ST_IDLE;
      endcase
    end
  end

  // 输出与握手
  always @(*) begin
    // 默认值
    ifu_arready = 1'b0;
    ifu_rdata = 32'b0;
    ifu_rvalid = 1'b0;

    lsu_arready = 1'b0;
    lsu_rdata = 32'b0;
    lsu_rvalid = 1'b0;
    lsu_awready = 1'b0;
    lsu_wready = 1'b0;
    lsu_bvalid = 1'b0;

    m_araddr = 32'b0;
    m_arvalid = 1'b0;
    m_rready = 1'b0;

    m_awaddr = 32'b0;
    m_awvalid = 1'b0;
    m_wdata = 32'b0;
    m_wvalid = 1'b0;
    m_bready = 1'b0;

    m_func3 = func3_latch;

    case (state)
      ST_READ_IFU: begin
        m_araddr  = ifu_araddr;
        m_arvalid = ifu_arvalid;
        ifu_arready = m_arready;
      end
      ST_READ_LSU: begin
        m_araddr  = lsu_araddr;
        m_arvalid = lsu_arvalid;
        lsu_arready = m_arready;
      end
      ST_WAIT_R: begin
        m_rready = read_owner_ifu ? ifu_rready : lsu_rready;
        if (read_owner_ifu) begin
          ifu_rdata = m_rdata;
          ifu_rvalid = m_rvalid;
        end else begin
          lsu_rdata = m_rdata;
          lsu_rvalid = m_rvalid;
        end
      end
      ST_WRITE: begin
        m_awaddr  = lsu_awaddr;
        m_awvalid = lsu_awvalid;
        lsu_awready = m_awready;

        m_wdata  = lsu_wdata;
        m_wvalid = lsu_wvalid;
        lsu_wready = m_wready;
      end
      ST_WAIT_B: begin
        lsu_bvalid = m_bvalid;
        m_bready = lsu_bready;
      end
      default: begin
      end
    endcase
  end

  assign inst_active = (state == ST_WAIT_R) &&
                       read_owner_ifu &&
                       m_rvalid &&
                       m_rready;

endmodule
