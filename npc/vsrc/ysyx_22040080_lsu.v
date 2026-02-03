module ysyx_22040080_lsu (
    input  clk,
    input  rst,

    // 来自 ALU 的信号
    input  [31:0] mem_addr,
    input  [31:0] mem_wdata,
    input  [2:0]  func3,
    input         is_load,
    input         is_store,
    input [31:0] alu_result,
   
    // 输出到 WB 阶段
    output reg [31:0] load_data,
    output reg [2:0] lsu_func3,

    input wire lsu_reqValid,    // Req阶段：CPU发起访存请求
    output reg lsu_reqReady,    // Req阶段：存储器就绪, 指令已经被成功接收(告知cpu)

    output reg lsu_respValid,    // resp 存储器响应有效，已经读出数据，返回给cpu 
    input lsu_respReady,        // Resp阶段：CPU就绪 指令已经被cpu执行
    
    // --------------------------
    // AXI4-Lite 主设备接口（LSU→Memory）
    // --------------------------
    // 读地址通道（AR）- Master→Slave
    output reg [31:0] araddr,    // 读地址（load地址）
    output reg        arvalid,   // 读地址有效
    input             arready,   // 从机读地址就绪（Memory返回）

    // 读数据通道（R）- Slave→Master
    input [31:0]      rdata,     // 读数据（Memory返回）
    input             rvalid,    // 读数据有效（Memory返回）
    output reg        rready,    // 主机读数据就绪

    // 写地址通道（AW）- Master→Slave
    output reg [31:0] awaddr,    // 写地址（store地址）
    output reg        awvalid,   // 写地址有效
    input             awready,   // 从机写地址就绪（Memory返回）

     // 写数据通道（W）- Master→Slave
    output reg [31:0] wdata,     // 写数据（store数据）
    output reg        wvalid,    // 写数据有效
    input             wready,    // 从机写数据就绪（Memory返回）

    // 写回复通道（B）- Slave→Master）
    input             bvalid,    // 写回复有效（Memory返回）
    output reg        bready     // 主机写回复就绪
    
);

// parameter READ_DELAY_CFG = 10;  // load读延迟（store写无延迟，符合实际存储器特性）
// parameter REQ_READY_RAND_DELAY = 5;   // 存储器准备延迟信号

// --------------------------
// 2. 核心锁存寄存器（解决lsu_reqValid仅1拍的问题）
// --------------------------
reg [31:0] mem_addr_latch;    // 锁存访存地址（延迟期间不变）
reg [31:0] mem_wdata_latch;   // 锁存写数据（store指令用）
reg [2:0]  func3_latch;       // 锁存func3（宽度控制）
reg        is_load_latch;     // 锁存load标记
reg        is_store_latch;    // 锁存store标记
reg [7:0]  read_delay_cnt;    // 读延迟计数器（独立寄存器）
reg        req_pending;       // 锁存请求状态：标记有未完成的访存请求

// reg [7:0]  req_ready_cnt;     // 存储器忙碌计数器

// AXI握手状态标记
reg        ar_handshake_done; // AR通道握手完成
reg        aw_handshake_done; // AW通道握手完成
reg        w_handshake_done;  // W通道握手完成

// --------------------------
// 时序逻辑：AXI4-Lite主设备状态机
// --------------------------
always @(posedge clk) begin
  if(rst) begin
    // 输出信号复位
    load_data <= 32'b0;
    lsu_reqReady <= 1'b0;
    lsu_respValid <= 1'b0;

    // AXI信号复位
    araddr <= 32'b0;
    arvalid <= 1'b0;
    rready <= 1'b0;
    awaddr <= 32'b0;
    awvalid <= 1'b0;
    wdata <= 32'b0;
    wvalid <= 1'b0;
    bready <= 1'b0;

    // 锁存寄存器复位
    mem_addr_latch <= 32'b0;
    mem_wdata_latch <= 32'b0;
    func3_latch <= 3'b0;
    is_load_latch <= 1'b0;
    is_store_latch <= 1'b0;
    req_pending <= 1'b0;

    ar_handshake_done <= 1'b0;
    aw_handshake_done <= 1'b0;
    w_handshake_done <= 1'b0;
  end
  else begin
    // 默认值：避免组合逻辑毛刺
    lsu_reqReady <= 1'b0;
    // ==========================
    // 步骤1：捕获CPU的访存请求（lsu_reqValid有效）
    // ==========================
    if(lsu_reqValid && !req_pending) begin
      // 锁存所有访存参数
      mem_addr_latch <= mem_addr;
      mem_wdata_latch <= mem_wdata;
      func3_latch <= func3;
      lsu_func3 <= func3;      // 传递func3到memory
      is_load_latch <= is_load;
      is_store_latch <= is_store;
      req_pending <= 1'b1; // 标记有未完成请求

      // Load：拉起AR通道请求（主设备核心操作）
      if(is_load) begin
        araddr <= mem_addr;    // 地址先就绪（AXI协议要求）
        arvalid <= 1'b1;       // 读地址有效（向Memory发请求）
      end

      // Store：拉起AW+W通道请求（主设备核心操作）
      if(is_store) begin
        awaddr <= mem_addr;    // 写地址先就绪
        awvalid <= 1'b1;       // 写地址有效
        wdata <= mem_wdata;    // 写数据先就绪
        wvalid <= 1'b1;        // 写数据有效
        bready <= 1'b1;
      end
    end

    // ==========================
    // 步骤2：处理AXI读地址通道（AR）握手（Load专用）
    // ==========================
    if(is_load_latch) begin
      if(arvalid && arready) begin
        arvalid <= 1'b0;                // 握手完成，撤销有效信号（AXI协议要求）
        lsu_reqReady <= 1'b1;           // 告知CPU：请求已被Memory接收
        rready <= 1'b1;                 // 告知Memory：LSU已就绪接收读数据
      end 
      // ==========================
      // 步骤3：处理AXI读数据通道（R）响应（Load专用）
      // ==========================
      if(rvalid && rready) begin // 响应成功
        // memory已完成符号/零扩展，这里直接使用rdata
        load_data <= rdata;
        lsu_respValid <= 1'b1; // 告知CPU：Load数据已就绪
        rready <= 1'b0;
      end

    end

    // ==========================
    // 步骤4：处理AXI写地址通道（AW）握手（Store专用）
    // ==========================
    if(is_store_latch) begin
      if(awvalid && awready) begin
        awvalid <= 1'b0;                // 握手完成，撤销有效信号
        aw_handshake_done <= 1'b1;
      end
      // ==========================
      // 步骤5：处理AXI写数据通道（W）握手（Store专用）
      // ==========================
      if(wvalid && wready) begin
        wvalid <= 1'b0;                 // 握手完成，撤销有效信号
        lsu_reqReady <= 1'b1;           // 告知CPU：请求已被Memory接收
        w_handshake_done <= 1'b1;
      end
    end
  end

  // ==========================
  // 步骤6：处理AXI写回复通道（B）响应（Store专用）
  // ==========================
  if(is_store_latch && aw_handshake_done && w_handshake_done) begin
    if(bvalid && bready) begin // 写成功
      lsu_respValid <= 1'b1; // 告知CPU：Store已完成
      bready <= 1'b0;
    end
  end

  // ==========================
  // 步骤7：CPU响应握手（lsu_respReady有效）
  // ==========================
  if(req_pending && lsu_respValid && lsu_respReady) begin
    // 清除所有标记，完成一次访存
    lsu_respValid <= 1'b0;
    req_pending <= 1'b0;
    is_load_latch <= 1'b0;
    is_store_latch <= 1'b0;
    ar_handshake_done <= 1'b0;
    aw_handshake_done <= 1'b0;
    w_handshake_done <= 1'b0;
  end
end

endmodule
 
