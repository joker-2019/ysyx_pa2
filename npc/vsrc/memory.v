module memory(
 input clk,
 input rst,
 output reg inst_active,

 // ========================================
 // IFU专用：AXI4-Lite 读通道（Master -> Slave）
 // ========================================
  // 读地址通道（AR）
  input [31:0] ifu_araddr,
  input ifu_arvalid,
  output reg ifu_arready,
  
  // 读数据通道（R）
  output reg [31:0] ifu_rdata,
  output reg ifu_rvalid,
  input ifu_rready,   

  // ========================================
  // LSU AXI4-Lite 读通道
  // ========================================
  input [31:0] lsu_araddr,
  input lsu_arvalid,
  output reg lsu_arready,
  input [2:0] lsu_func3,
  
  output reg [31:0] lsu_rdata,
  output reg lsu_rvalid,
  input lsu_rready,

// ========================================
// LSU专用：AXI4-Lite 写地址通道（AW）
// ========================================
input [31:0] lsu_awaddr,     // 写地址（LSU store）
input lsu_awvalid,           // 写地址有效
output reg lsu_awready,      // 从机写地址就绪

// ========================================
// LSU专用：AXI4-Lite 写数据通道（W）
// ========================================
input [31:0] lsu_wdata,      // 写数据（LSU store）
// input [3:0] lsu_wstrb,        // 新增：写选通
input lsu_wvalid,            // 写数据有效
output reg lsu_wready,       // 从机写数据就绪

// ========================================
// LSU专用：AXI4-Lite 写回复通道（B）
// ========================================
output reg lsu_bvalid,
input lsu_bready

);

// 只读延迟参数（编译期常量，仅配置，运行时不修改）
parameter READ_DELAY_CFG = 10;  // 读延迟：5个时钟周期（可改为10）
parameter REQ_READY_RAND_DELAY = 5;   // reqReady随机延迟范围（1~5周期）

// ========================================
// IFU 读请求状态机
// ========================================
reg [31:0] ifu_addr_latch;
reg [7:0] ifu_delay_cnt;
reg [7:0] ifu_ready_cnt;
reg ifu_req_pending;
reg [31:0] ifu_curr_instr;

// ========================================
// LSU 读请求状态机
// ========================================
reg [31:0] lsu_read_addr_latch;
reg [2:0] lsu_func3_latch;
reg [7:0] lsu_read_delay_cnt;
reg [7:0] lsu_ar_ready_cnt;
reg lsu_read_pending;

// ========================================
// LSU 写请求状态机
// ========================================
reg [31:0] lsu_write_addr_latch;
reg [31:0] lsu_write_data_latch;
reg [2:0] lsu_wstrb_latch;
reg [7:0] lsu_aw_ready_cnt;
reg [7:0] lsu_w_ready_cnt;
reg lsu_aw_pending;
reg lsu_w_pending;
reg lsu_write_pending;

import "DPI-C" function int pmem_read(input int addr, input int len);
import "DPI-C" function void ebreak_trigger();  // 声明 DPI-C 函数	
import "DPI-C" function void pmem_write(input int addr, input int len, input int data);


// ========================================
// IFU 读请求处理
// ========================================
always @(posedge clk) begin
  if (rst) begin
    ifu_arready <= 1'b0;
    ifu_rdata <= 32'b0;
    ifu_rvalid <= 1'b0;
    ifu_addr_latch <= 32'b0;
    ifu_delay_cnt <= 8'b0;
    ifu_ready_cnt <= 8'b0;
    ifu_req_pending <= 1'b0;
    ifu_curr_instr <= 32'b0;
    inst_active <= 1'b0;
  end else begin
    inst_active <= 1'b0;
    ifu_arready <= 1'b0;
    // IFU 读请求处理 初始化
    if(ifu_arvalid && !ifu_req_pending) begin
      ifu_addr_latch <= ifu_araddr;
      ifu_delay_cnt <= READ_DELAY_CFG-1;
      ifu_ready_cnt <= REQ_READY_RAND_DELAY-1;
      ifu_req_pending <= 1'b1;
    end
    if(ifu_req_pending) begin
      if(ifu_delay_cnt > 0) begin
        ifu_delay_cnt <= ifu_delay_cnt - 1;
        if(ifu_ready_cnt > 0) begin
          ifu_ready_cnt <= ifu_ready_cnt - 1;
          ifu_arready <= 1'b0;
        end else begin
          ifu_delay_cnt <= 0;
          ifu_arready <= 1'b1;
        end
      end
      if(ifu_arvalid && ifu_arready) begin
        ifu_rdata <= pmem_read(ifu_addr_latch, 4);
        ifu_rvalid <= 1'b1;
        ifu_arready <= 1'b0;
        ifu_req_pending <= 1'b0;
      end
    end

    // 握手完成
    if(ifu_rvalid && ifu_rready) begin
      ifu_rvalid <= 1'b0;
      if (ifu_rdata == 32'b00000000000100000000000001110011) begin
        $display("检测到ebreak, 执行$finish");
        ebreak_trigger();
      end
      inst_active <= 1'b1;
    end
  end
end

// ========================================
// LSU 读请求处理
// ========================================
always @(posedge clk) begin
  if (rst) begin 
  lsu_arready <= 1'b0;
  lsu_rdata <= 32'b0;
  lsu_rvalid <= 1'b0;

  lsu_read_addr_latch <= 32'b0;
  lsu_func3_latch <= 3'b0;
  lsu_read_delay_cnt <= 8'b0;
  lsu_ar_ready_cnt <= 8'b0;
  lsu_read_pending <= 1'b0;
  end else begin
    lsu_arready <= 1'b0;
    // 捕获 LSU 读请求
    if (lsu_arvalid && !lsu_read_pending && !lsu_write_pending) begin
      lsu_read_addr_latch <= lsu_araddr;
      lsu_func3_latch <= lsu_func3;
      lsu_read_delay_cnt <= READ_DELAY_CFG - 1; // 访存读取延迟
      lsu_ar_ready_cnt <= REQ_READY_RAND_DELAY - 1; // 存储器地址读取延迟
      lsu_read_pending <= 1'b1;
    end
    // 处理 LSU 读延迟 访存读取延迟依赖内存是否准备好
    if (lsu_read_pending && !lsu_rvalid) begin
      if (lsu_read_delay_cnt > 0) begin
        lsu_read_delay_cnt <= lsu_read_delay_cnt -1;
        if(lsu_ar_ready_cnt >0) begin
          lsu_ar_ready_cnt <= lsu_ar_ready_cnt - 1;
          lsu_arready <= 1'b0;
        end else begin
          lsu_read_delay_cnt <= 0;
          lsu_arready <= 1'b1;
        end
      end
      if (lsu_arvalid && lsu_arready) begin
         // 根据 func3 读取数据
            case (lsu_func3_latch)
             3'b000: lsu_rdata <= $signed(pmem_read(lsu_read_addr_latch, 1) << 24) >>> 24; // LB
             3'b001: lsu_rdata <= $signed(pmem_read(lsu_read_addr_latch, 2) << 16) >>> 16; // LH
             3'b010: lsu_rdata <= pmem_read(lsu_read_addr_latch, 4);                        // LW
             3'b100: lsu_rdata <= pmem_read(lsu_read_addr_latch, 1) & 32'hFF;               // LBU
             3'b101: lsu_rdata <= pmem_read(lsu_read_addr_latch, 2) & 32'hFFFF;             // LHU
             default: lsu_rdata <= 32'b0;
            endcase
          lsu_rvalid <= 1'b1;
          lsu_arready <= 1'b0;
          lsu_read_pending <= 1'b0;
        end 
    end

    // R 通道握手
    if (lsu_rvalid && lsu_rready) begin
      lsu_rvalid <= 1'b0;
    end
  end
end

// ========================================
// LSU 写请求处理
// ========================================
always @(posedge clk) begin
  if (rst) begin
    lsu_awready <= 1'b0;
    lsu_wready <= 1'b0;
    lsu_bvalid <= 1'b0;
    lsu_write_addr_latch <= 32'b0;
    lsu_write_data_latch <= 32'b0;
    lsu_wstrb_latch <= 3'b0;
    lsu_aw_ready_cnt <= 8'b0;
    lsu_w_ready_cnt <= 8'b0;
    lsu_aw_pending <= 1'b0;
    lsu_w_pending <= 1'b0;
    lsu_write_pending <= 1'b0;
  end else begin
    lsu_awready <= 1'b0;
    lsu_wready <= 1'b0;
    // 接收写地址
    if (lsu_awvalid && !lsu_aw_pending && !lsu_read_pending) begin
      lsu_write_addr_latch <= lsu_awaddr;
      lsu_aw_ready_cnt <= REQ_READY_RAND_DELAY - 1;
      lsu_aw_pending <= 1'b1;
    end
    if(lsu_aw_pending) begin
      if(lsu_aw_ready_cnt > 0) begin
        lsu_aw_ready_cnt <= lsu_aw_ready_cnt - 1;
      end else begin
        lsu_awready <= 1'b1;
      end
      if(lsu_awvalid && lsu_awready) begin
        lsu_awready <= 1'b0;
        lsu_aw_pending <= 1'b0;
      end
    end

    // 接收写数据
    if (lsu_wvalid && !lsu_w_pending && !lsu_read_pending) begin
      lsu_write_data_latch <= lsu_wdata;
      lsu_wstrb_latch <= lsu_func3;
      lsu_w_ready_cnt <= REQ_READY_RAND_DELAY - 1;
      lsu_w_pending <= 1'b1;
    end

    // W 通道延迟和握手
    if(lsu_w_pending) begin
      if (lsu_w_ready_cnt > 0) begin
        lsu_w_ready_cnt <= lsu_w_ready_cnt - 1;
      end else begin
        lsu_wready <= 1'b1;
      end
      if (lsu_wvalid && lsu_wready) begin
        lsu_w_pending <= 1'b0;
        lsu_wready <= 1'b0;
        lsu_write_pending <= 1'b1;
      end
    end

    // 执行写操作
    if (lsu_write_pending && !lsu_aw_pending) begin
      case(lsu_wstrb_latch)
        3'b000: pmem_write(lsu_write_addr_latch, 1, lsu_write_data_latch);  // SB
        3'b001: pmem_write(lsu_write_addr_latch, 2, lsu_write_data_latch);  // SH
        3'b010: pmem_write(lsu_write_addr_latch, 4, lsu_write_data_latch);  // SW
        default: $display("ERROR: Unsupported wstrb %b", lsu_wstrb_latch);
      endcase
      lsu_bvalid <= 1'b1;
      lsu_write_pending <= 1'b0;
    end
    // B 通道握手
    if (lsu_bvalid && lsu_bready) begin
      lsu_bvalid <= 1'b0;
    end
  end
end
endmodule
  /* 
  // --------------------------
  // 1. 捕获1拍的ifu_valid：锁存地址+初始化计数器+标记请求未完成
  // --------------------------
  if(arvalid && !read_req_pending && !write_req_pending) begin
   read_addr_latch <= araddr; // 锁存当前地址（仅1拍有效，必须存下来）
   read_delay_cnt <= READ_DELAY_CFG-1; // 初始化计数器
   ar_ready_cnt <=REQ_READY_RAND_DELAY-1;
   read_req_pending <= 1'b1;  // 锁存请求状态：标记"有未完成请求"
  end
  // --------------------------
  // 2. 延迟计数：逐周期递减，直到计数为0
  // --------------------------
  else if(read_req_pending) begin
   if(read_delay_cnt > 0) begin
    read_delay_cnt <= read_delay_cnt - 1;
    if(ar_ready_cnt > 0) begin
     ar_ready_cnt <= ar_ready_cnt - 1; 
      arready <= 1'b0; // 读取地址忙
    end else begin
     read_delay_cnt <= 0;  // 存储器已就绪，强制结束读延迟
     arready <= 1'b1; // 读取地址就绪
    end
   end else begin
    // --------------------------
    // 延迟结束：执行读操作
    // --------------------------
    curr_instr = pmem_read(read_addr_latch, 4);
    rvalid <= 1'b1;  // 地址读取完成，发送给ifu告知可以发送读取的数据
    read_req_pending <= 1'b0;       // 清除请求状态：延迟结束
    arready <= 1'b0; // 读取地址忙
    end
  end
  // 握手完成
  else if(rvalid && rready) begin
    rvalid <= 1'b0; // 清除读取数据请求信号， 握手完成可传递数据
    rdata <= curr_instr;
    if(curr_instr == 32'b00000000000100000000000001110011) begin
      $display("检测到ebreak, 执行$finish");
      ebreak_trigger();
    end
    inst_active <= 1'b1;            // 置位响应信号
   end */
