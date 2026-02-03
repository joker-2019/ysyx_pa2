module ysyx_22040080_clint_axi (
  input  clk,
  input  rst,

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
  input         bready
);

  localparam CLINT_MTIME_ADDR = 32'hA000_0048;

  reg [63:0] mtime;
  reg [31:0] awaddr_latch;
  reg [31:0] wdata_latch;
  reg        aw_captured;
  reg        w_captured;

  // mtime 每周期加 1
  always @(posedge clk) begin
    if (rst) begin
      mtime <= 64'b0;
    end else begin
      mtime <= mtime + 1'b1;
    end
  end

  // 读通道
  always @(posedge clk) begin
    if (rst) begin
      arready <= 1'b0;
      rvalid <= 1'b0;
      rdata <= 32'b0;
    end else begin
      arready <= 1'b0;
      if (!rvalid) begin
        arready <= 1'b1;
        if (arvalid && arready) begin
          if (araddr == CLINT_MTIME_ADDR) begin
            rdata <= mtime[31:0]; // 返回mtime低32位
          end else if (araddr == (CLINT_MTIME_ADDR + 32'd4)) begin
            rdata <= mtime[63:32]; // 返回mtime高32位
          end else begin
            rdata <= 32'b0; // 其他地址返回0
          end
          rvalid <= 1'b1; // 返回数据有效
          arready <= 1'b0; // 握手完成
        end
      end
      if (rvalid && rready) begin
        rvalid <= 1'b0;
      end
    end
  end

  // 写通道（只响应，不修改mtime）
  always @(posedge clk) begin
    if (rst) begin
      awready <= 1'b0;
      wready <= 1'b0;
      bvalid <= 1'b0;
      awaddr_latch <= 32'b0;
      wdata_latch <= 32'b0;
      aw_captured <= 1'b0;
      w_captured <= 1'b0;
    end else begin
      awready <= 1'b0;
      wready <= 1'b0;

      if (!bvalid) begin
        if (!aw_captured) begin
          awready <= 1'b1;
          if (awvalid && awready) begin
            awaddr_latch <= awaddr;
            aw_captured <= 1'b1;
            awready <= 1'b0;
          end
        end
        if (!w_captured) begin
          wready <= 1'b1;
          if (wvalid && wready) begin
            wdata_latch <= wdata;
            w_captured <= 1'b1;
            wready <= 1'b0;
          end
        end
        if (aw_captured && w_captured) begin
          // 忽略写数据，直接应答
          bvalid <= 1'b1;
          aw_captured <= 1'b0;
          w_captured <= 1'b0;
        end
      end

      if (bvalid && bready) begin
        bvalid <= 1'b0;
      end
    end
  end

endmodule
