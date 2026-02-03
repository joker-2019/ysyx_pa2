module memory(
  input clk,
  input rst,

  // AXI4-Lite 读地址通道（AR）
  input  [31:0] araddr,
  input         arvalid,
  output reg    arready,

  // AXI4-Lite 读数据通道（R）
  output reg [31:0] rdata,
  output reg        rvalid,
  input             rready,

  // AXI4-Lite 写地址通道（AW）
  input  [31:0] awaddr,
  input         awvalid,
  output reg    awready,

  // AXI4-Lite 写数据通道（W）
  input  [31:0] wdata,
  input         wvalid,
  output reg    wready,

  // AXI4-Lite 写回复通道（B）
  output reg    bvalid,
  input         bready,

  // 访存宽度提示（非AXI信号）
  input  [2:0]  func3
);

// 只读延迟参数（编译期常量，仅配置，运行时不修改）
parameter READ_DELAY_CFG = 10;  // 读延迟：5个时钟周期（可改为10）
parameter REQ_READY_RAND_DELAY = 5;   // reqReady随机延迟范围（1~5周期）

// ========================================
// 读请求状态机
// ========================================
reg [31:0] read_addr_latch;
reg [2:0]  read_func3_latch;
reg [7:0]  read_delay_cnt;
reg [7:0]  ar_ready_cnt;
reg        read_pending;

// ========================================
// 写请求状态机
// ========================================
reg [31:0] write_addr_latch;
reg [31:0] write_data_latch;
reg [2:0]  write_func3_latch;
reg [7:0]  aw_ready_cnt;
reg [7:0]  w_ready_cnt;
reg        aw_pending;
reg        w_pending;
reg        write_pending;

wire read_busy  = read_pending || rvalid;
wire write_busy = aw_pending || w_pending || write_pending || bvalid;
wire write_block = write_pending || bvalid;

import "DPI-C" function int pmem_read(input int addr, input int len);
import "DPI-C" function void pmem_write(input int addr, input int len, input int data);

// ========================================
// 读请求处理
// ========================================
always @(posedge clk) begin
  if (rst) begin
    arready <= 1'b0;
    rdata <= 32'b0;
    rvalid <= 1'b0;
    read_addr_latch <= 32'b0;
    read_func3_latch <= 3'b0;
    read_delay_cnt <= 8'b0;
    ar_ready_cnt <= 8'b0;
    read_pending <= 1'b0;
  end else begin
    arready <= 1'b0;
    // 捕获读请求
    if (arvalid && !read_busy && !write_busy) begin
      read_addr_latch <= araddr;
      read_func3_latch <= func3;
      read_delay_cnt <= READ_DELAY_CFG - 1; // 访存读取延迟
      ar_ready_cnt <= REQ_READY_RAND_DELAY - 1; // 地址读取延迟
      read_pending <= 1'b1;
    end
    // 处理读延迟
    if (read_pending && !rvalid) begin
      if (read_delay_cnt > 0) begin
        read_delay_cnt <= read_delay_cnt - 1;
        if (ar_ready_cnt > 0) begin
          ar_ready_cnt <= ar_ready_cnt - 1;
          arready <= 1'b0;
        end else begin
          read_delay_cnt <= 0;
          arready <= 1'b1;
        end
      end
      if (arvalid && arready) begin
        case (read_func3_latch)
          3'b000: rdata <= $signed(pmem_read(read_addr_latch, 1) << 24) >>> 24; // LB
          3'b001: rdata <= $signed(pmem_read(read_addr_latch, 2) << 16) >>> 16; // LH
          3'b010: rdata <= pmem_read(read_addr_latch, 4);                        // LW
          3'b100: rdata <= pmem_read(read_addr_latch, 1) & 32'hFF;               // LBU
          3'b101: rdata <= pmem_read(read_addr_latch, 2) & 32'hFFFF;             // LHU
          default: rdata <= 32'b0;
        endcase
        rvalid <= 1'b1;
        arready <= 1'b0;
        read_pending <= 1'b0;
      end
    end

    // R 通道握手
    if (rvalid && rready) begin
      rvalid <= 1'b0;
    end
  end
end

// ========================================
// 写请求处理
// ========================================
always @(posedge clk) begin
  if (rst) begin
    awready <= 1'b0;
    wready <= 1'b0;
    bvalid <= 1'b0;
    write_addr_latch <= 32'b0;
    write_data_latch <= 32'b0;
    write_func3_latch <= 3'b0;
    aw_ready_cnt <= 8'b0;
    w_ready_cnt <= 8'b0;
    aw_pending <= 1'b0;
    w_pending <= 1'b0;
    write_pending <= 1'b0;
  end else begin
    awready <= 1'b0;
    wready <= 1'b0;
    // 接收写地址
    if (awvalid && !aw_pending && !read_busy && !write_block) begin
      write_addr_latch <= awaddr;
      aw_ready_cnt <= REQ_READY_RAND_DELAY - 1;
      aw_pending <= 1'b1;
    end
    if (aw_pending) begin
      if (aw_ready_cnt > 0) begin
        aw_ready_cnt <= aw_ready_cnt - 1;
      end else begin
        awready <= 1'b1;
      end
      if (awvalid && awready) begin
        awready <= 1'b0;
        aw_pending <= 1'b0;
      end
    end

    // 接收写数据
    if (wvalid && !w_pending && !read_busy && !write_block) begin
      write_data_latch <= wdata;
      write_func3_latch <= func3;
      w_ready_cnt <= REQ_READY_RAND_DELAY - 1;
      w_pending <= 1'b1;
    end

    // W 通道延迟和握手
    if (w_pending) begin
      if (w_ready_cnt > 0) begin
        w_ready_cnt <= w_ready_cnt - 1;
      end else begin
        wready <= 1'b1;
      end
      if (wvalid && wready) begin
        w_pending <= 1'b0;
        wready <= 1'b0;
        write_pending <= 1'b1;
      end
    end

    // 执行写操作
    if (write_pending && !aw_pending) begin
      case (write_func3_latch)
        3'b000: pmem_write(write_addr_latch, 1, write_data_latch);  // SB
        3'b001: pmem_write(write_addr_latch, 2, write_data_latch);  // SH
        3'b010: pmem_write(write_addr_latch, 4, write_data_latch);  // SW
        default: $display("ERROR: Unsupported wstrb %b", write_func3_latch);
      endcase
      bvalid <= 1'b1;
      write_pending <= 1'b0;
    end
    // B 通道握手
    if (bvalid && bready) begin
      bvalid <= 1'b0;
    end
  end
end
endmodule
