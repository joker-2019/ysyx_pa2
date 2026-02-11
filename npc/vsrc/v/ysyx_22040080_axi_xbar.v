module ysyx_22040080_axi_xbar (
  input  clk,
  input  rst,

  // Master side (from arbiter)
  input  [31:0] m_araddr,
  input         m_arvalid,
  output reg    m_arready,
  output reg [31:0] m_rdata,
  output reg        m_rvalid,
  input             m_rready,

  input  [31:0] m_awaddr,
  input         m_awvalid,
  output reg    m_awready,
  input  [31:0] m_wdata,
  input         m_wvalid,
  output reg    m_wready,
  output reg    m_bvalid,
  input         m_bready,

  input  [2:0]  m_func3,

  // Memory slave
  output reg [31:0] mem_araddr,
  output reg        mem_arvalid,
  input             mem_arready,
  input  [31:0]     mem_rdata,
  input             mem_rvalid,
  output reg        mem_rready,

  output reg [31:0] mem_awaddr,
  output reg        mem_awvalid,
  input             mem_awready,
  output reg [31:0] mem_wdata,
  output reg        mem_wvalid,
  input             mem_wready,
  input             mem_bvalid,
  output reg        mem_bready,
  output reg [2:0]  mem_func3,

  // CLINT slave
  output reg [31:0] clint_araddr,
  output reg        clint_arvalid,
  input             clint_arready,
  input  [31:0]     clint_rdata,
  input             clint_rvalid,
  output reg        clint_rready,

  output reg [31:0] clint_awaddr,
  output reg        clint_awvalid,
  input             clint_awready,
  output reg [31:0] clint_wdata,
  output reg        clint_wvalid,
  input             clint_wready,
  input             clint_bvalid,
  output reg        clint_bready,

  // UART slave
  output reg [31:0] uart_araddr,
  output reg        uart_arvalid,
  input             uart_arready,
  input  [31:0]     uart_rdata,
  input             uart_rvalid,
  output reg        uart_rready,

  output reg [31:0] uart_awaddr,
  output reg        uart_awvalid,
  input             uart_awready,
  output reg [31:0] uart_wdata,
  output reg        uart_wvalid,
  input             uart_wready,
  input             uart_bvalid,
  output reg        uart_bready
);

  localparam UART_ADDR       = 32'h1000_0000;
  localparam CLINT_MTIME_ADDR = 32'hA000_0048;

  localparam SEL_MEM  = 2'd0;
  localparam SEL_UART = 2'd1;
  localparam SEL_CLINT= 2'd2;

  reg        read_sel_valid;
  reg [1:0]  read_sel;
  reg        write_sel_valid;
  reg [1:0]  write_sel;


// 地址选择逻辑
  wire sel_uart_read  = (m_araddr == UART_ADDR);
  wire sel_uart_write = (m_awaddr == UART_ADDR);
  wire sel_clint_read  = (m_araddr == CLINT_MTIME_ADDR) ||
                         (m_araddr == (CLINT_MTIME_ADDR + 32'd4));
  wire sel_clint_write = (m_awaddr == CLINT_MTIME_ADDR) ||
                         (m_awaddr == (CLINT_MTIME_ADDR + 32'd4));

  wire [1:0] read_sel_next  = sel_clint_read ? SEL_CLINT :
                              (sel_uart_read ? SEL_UART : SEL_MEM);
  wire [1:0] write_sel_next = sel_clint_write ? SEL_CLINT :
                              (sel_uart_write ? SEL_UART : SEL_MEM);

  // 选择锁存
  always @(posedge clk) begin
    if (rst) begin
      read_sel_valid <= 1'b0;
      read_sel <= SEL_MEM;
      write_sel_valid <= 1'b0;
      write_sel <= SEL_MEM;
    end else begin
      if (!read_sel_valid && m_arvalid && m_arready) begin
        read_sel_valid <= 1'b1;   // 开始读事务
        read_sel <= read_sel_next; // 锁存目标设备
      end else if (read_sel_valid && m_rvalid && m_rready) begin
        read_sel_valid <= 1'b0; // 结束读事务
      end

      if (!write_sel_valid && m_awvalid && m_awready) begin
        write_sel_valid <= 1'b1; // 开始写事务
        write_sel <= write_sel_next; // 锁存目标设备
      end else if (write_sel_valid && m_bvalid && m_bready) begin
        write_sel_valid <= 1'b0; // 结束写事务
      end
    end
  end

  // 路由与握手
  always @(*) begin
    // Master side defaults
    m_arready = 1'b0;
    m_rdata = 32'b0;
    m_rvalid = 1'b0;
    m_awready = 1'b0;
    m_wready = 1'b0;
    m_bvalid = 1'b0;

    // Memory side defaults
    mem_araddr = 32'b0;
    mem_arvalid = 1'b0;
    mem_rready = 1'b0;
    mem_awaddr = 32'b0;
    mem_awvalid = 1'b0;
    mem_wdata = 32'b0;
    mem_wvalid = 1'b0;
    mem_bready = 1'b0;
    mem_func3 = m_func3;

    // UART side defaults
    uart_araddr = 32'b0;
    uart_arvalid = 1'b0;
    uart_rready = 1'b0;
    uart_awaddr = 32'b0;
    uart_awvalid = 1'b0;
    uart_wdata = 32'b0;
    uart_wvalid = 1'b0;
    uart_bready = 1'b0;

    // CLINT side defaults
    clint_araddr = 32'b0;
    clint_arvalid = 1'b0;
    clint_rready = 1'b0;
    clint_awaddr = 32'b0;
    clint_awvalid = 1'b0;
    clint_wdata = 32'b0;
    clint_wvalid = 1'b0;
    clint_bready = 1'b0;

    // Read address channel
    if (!read_sel_valid) begin
      if (sel_clint_read) begin
        clint_araddr = m_araddr;   // 路由到CLINT
        clint_arvalid = m_arvalid;
        m_arready = clint_arready;  // 连接ready信号
      end else if (sel_uart_read) begin
        uart_araddr = m_araddr;   // 路由到UART
        uart_arvalid = m_arvalid;
        m_arready = uart_arready;
      end else begin
        mem_araddr = m_araddr;   // 路由到Memory
        mem_arvalid = m_arvalid;
        m_arready = mem_arready;
      end
    end

    // Read data channel
    if (read_sel_valid) begin
      if (read_sel == SEL_CLINT) begin
        m_rdata = clint_rdata;
        m_rvalid = clint_rvalid;
        clint_rready = m_rready;
      end else if (read_sel == SEL_UART) begin
        m_rdata = uart_rdata;
        m_rvalid = uart_rvalid;
        uart_rready = m_rready;
      end else begin
        m_rdata = mem_rdata;
        m_rvalid = mem_rvalid;
        mem_rready = m_rready;
      end
    end

    // Write address channel
    if (!write_sel_valid && m_awvalid) begin
      if (sel_clint_write) begin
        clint_awaddr = m_awaddr;
        clint_awvalid = m_awvalid;
        m_awready = clint_awready;
      end else if (sel_uart_write) begin
        uart_awaddr = m_awaddr;
        uart_awvalid = m_awvalid;
        m_awready = uart_awready;
      end else begin
        mem_awaddr = m_awaddr;
        mem_awvalid = m_awvalid;
        m_awready = mem_awready;
      end
    end

    // Write data + response channel (after AW握手)
    if (write_sel_valid) begin
      if (write_sel == SEL_CLINT) begin
        clint_wdata = m_wdata;
        clint_wvalid = m_wvalid;
        m_wready = clint_wready;
        m_bvalid = clint_bvalid;
        clint_bready = m_bready;
      end else if (write_sel == SEL_UART) begin
        uart_wdata = m_wdata;
        uart_wvalid = m_wvalid;
        m_wready = uart_wready;
        m_bvalid = uart_bvalid;
        uart_bready = m_bready;
      end else begin
        mem_wdata = m_wdata;
        mem_wvalid = m_wvalid;
        m_wready = mem_wready;
        m_bvalid = mem_bvalid;
        mem_bready = m_bready;
      end
    end
  end

endmodule
