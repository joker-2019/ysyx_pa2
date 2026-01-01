module ysyx_22040080_mem (
    input  clk,
    input  rst,

    // 来自 ALU 的信号
    input  [31:0] mem_addr,
    input  [31:0] mem_wdata,
    input  [2:0]  func3,
    input         is_load,
    input         is_store,
    input [31:0] alu_result,
    // output reg mem_done,
    // 输出到 WB 阶段
    output reg [31:0] load_data,

    input wire lsu_reqValid,    // Req阶段：CPU发起访存请求
    output reg lsu_reqReady,    // Req阶段：存储器就绪, 指令已经被成功接收(告知cpu)

    output reg lsu_respValid,    // resp 存储器响应有效，已经读出数据，返回给cpu 
    input lsu_respReady        // Resp阶段：CPU就绪 指令已经被cpu执行
    
    
);

parameter READ_DELAY_CFG = 10;  // load读延迟（store写无延迟，符合实际存储器特性）
parameter REQ_READY_RAND_DELAY = 5;   // 存储器准备延迟信号

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

reg [7:0]  req_ready_cnt;     // 存储器忙碌计数器

 import "DPI-C" function int pmem_read(input int addr, input int len);
 import "DPI-C" function void pmem_write(input int addr, input int len, input int data);

// --------------------------
// 握手信号+数据锁存控制（时序逻辑）
// --------------------------
always @(posedge clk) begin
  if(rst) begin
    load_data <= 32'b0;
    // mem_done <= 1'b0;  // 复位初始化：避免不定态
    // latch 
    mem_addr_latch  <= 32'b0;
    mem_wdata_latch <= 32'b0;
    func3_latch    <= 3'b0;
    is_load_latch  <= 1'b0;
    is_store_latch <= 1'b0;
    read_delay_cnt <= 8'b0;
    req_pending    <= 1'b0;
    lsu_reqReady <= 1'b0;
    lsu_respValid <= 1'b0;
    req_ready_cnt  <= 8'b0;
  end else begin
    // mem_done <= 1'b0;
    // lsu_reqReady <= 1'b0;
    // --------------------------
    // 步骤1：Req阶段 - 捕获CPU的访存请求（lsu_reqValid有效）
    // --------------------------
    if(lsu_reqValid && !req_pending) begin
      // 锁存所有访存相关信号（仅1拍有效，必须存下来）
      mem_addr_latch <= mem_addr;
      mem_wdata_latch <= mem_wdata;
      func3_latch <= func3;
      is_load_latch <= is_load;
      is_store_latch <= is_store;

      req_ready_cnt  <= REQ_READY_RAND_DELAY - 1; //初始化存储器忙碌计数器
      req_pending <= 1'b1;  // 标记有未完成请求
      if(is_load) begin
        read_delay_cnt <= READ_DELAY_CFG - 1; // 初始化读延迟计数器
      end
    end
    // --------------------------
    // 步骤2：Req阶段 - 存储器就绪（lsu_reqReady有效）
    // --------------------------
    else if (req_pending && !lsu_respValid) begin
      // Store指令：Req握手完成后，立即执行写操作（无读延迟）
      if(is_store_latch) begin
          if(req_ready_cnt > 0) begin   
          req_ready_cnt <= req_ready_cnt -1; // 存储器忙碌, 递减计数器
        end else begin
        lsu_reqReady <= 1'b1;  // 存储器告知cpu，存储器已经接收，lsu_reqReady置1（完成Req握手）
        case (func3_latch)
          3'b000: pmem_write(mem_addr_latch, 1, mem_wdata_latch); // SB：1字节
          3'b001: pmem_write(mem_addr_latch, 2, mem_wdata_latch); // SH：2字节
          3'b010: pmem_write(mem_addr_latch, 4, mem_wdata_latch); // SW：4字节
          default: $display("ERROR: Unsupported store func3 %b", func3_latch);
        endcase
        lsu_respValid <= 1'b1; // 存储器已经读取完成
        end
      end
      //  Load指令：Req握手完成后，开始读延迟计数
      else if(is_load_latch) begin
        if(read_delay_cnt > 0) begin
          read_delay_cnt <= read_delay_cnt - 1;  // 读延迟递减
          if(req_ready_cnt > 0) begin   
          req_ready_cnt <= req_ready_cnt -1; // 存储器忙碌, 递减计数器
          end else begin
            read_delay_cnt <= 8'b0; //强制终止读延迟信号
          end
        end else begin
          // --------------------------
          // 步骤3：load延迟结束，执行读操作+返回响应
          // --------------------------
          lsu_reqReady <= 1'b1;
          case (func3_latch)
            3'b000: load_data <= $signed(pmem_read(mem_addr_latch, 1) << 24) >>> 24; // LB
            3'b001: load_data <= $signed(pmem_read(mem_addr_latch, 2) << 16) >>> 16; // LH
            3'b010: load_data <= pmem_read(mem_addr_latch, 4);                        // LW
            3'b100: load_data <= pmem_read(mem_addr_latch, 1) & 32'hFF;               // LBU
            3'b101: load_data <= pmem_read(mem_addr_latch, 2) & 32'hFFFF;             // LHU
            default: load_data <= 32'b0;
          endcase
          lsu_respValid <= 1'b1;    // load完成，置位响应
        end
      end
    end
    // --------------------------
    // 【新增】步骤3：Resp阶段 - 等待CPU就绪（lsu_respReady有效）
    // --------------------------
    if(req_pending && lsu_respValid) begin
      if(lsu_respReady) begin
        // CPU就绪，完成Resp握手：置mem_done，清除所有标记
        // mem_done <= 1'b1;
        req_pending <= 1'b0;       // 清除未完成请求
        lsu_respValid <= 1'b0;     // 清空Resp有效信号
        lsu_reqReady <= 1'b0;      // 清空Req就绪信号
      end
    end
  end
end

endmodule
    // --------------------------
    // 步骤1：捕获1拍的lsu_reqValid，锁存所有关键信号
    // --------------------------

    /* if (is_load) begin
      // $display("[MEM] store addr=%h data=%h func3=%b", mem_addr, mem_wdata, func3);
      case (func3)
        3'b000: load_data <= $signed(pmem_read(mem_addr, 1) << 24) >>> 24; // LB
        3'b001: load_data <= $signed(pmem_read(mem_addr, 2) << 16) >>> 16; // LH
        3'b010: load_data <= pmem_read(mem_addr, 4);                        // LW
        3'b100: load_data <= pmem_read(mem_addr, 1) & 32'hFF;               // LBU
        3'b101: load_data <= pmem_read(mem_addr, 2) & 32'hFFFF;             // LHU
        default: load_data <= 32'b0;
      endcase
      mem_done <= 1'b1;
    end else if (is_store) begin
      case (func3)
        3'b000: pmem_write(mem_addr, 1, mem_wdata); // SB：1字节
        3'b001: pmem_write(mem_addr, 2, mem_wdata); // SH：2字节
        3'b010: pmem_write(mem_addr, 4, mem_wdata); // SW：4字节
        default: $display("ERROR: Unsupported store func3 %b", func3);
      endcase
      // mem_done <= 1'b1;
    end */
 
