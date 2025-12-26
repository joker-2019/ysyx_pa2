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
    output reg mem_done,
    // 输出到 WB 阶段
    output reg [31:0] load_data
);
 import "DPI-C" function int pmem_read(input int addr, input int len);
 import "DPI-C" function void pmem_write(input int addr, input int len, input int data);

// --------------------------
// 握手信号+数据锁存控制（时序逻辑）
// --------------------------
always @(posedge clk) begin
  if(rst) begin
    load_data <= 32'b0;
    mem_done <= 1'b0;  // 复位初始化：避免不定态
  end else begin
    mem_done <= 1'b0;
    if (is_load) begin
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
    end
  end
end

// ----------------------
//  LOAD 数据读取逻辑
// ----------------------
/*   always @(*) begin
   if (rst) begin
   load_data = 32'b0;
   mem_done = 1'b0;
   end 
   else if (inst_active) begin
      if(is_load) begin
      // $display("[EX] lw: mem_addr=0x%08h func3=%b", mem_addr, func3);
      case (func3)
        3'b000: begin //LB 加载1字节 有符号扩展
          load_data = $signed(pmem_read(mem_addr, 1) << 24) >>> 24;
        end
        3'b010: begin //LW指令 加载 4 字节
          load_data = pmem_read(mem_addr, 4);
        end
        3'b100: begin // LBU: 加载 1 字节，无符号扩展
          load_data = pmem_read(mem_addr, 1) & 32'hFF;
        end
        3'b101: begin // Lhu: 加载 2 字节，零扩展
          load_data = pmem_read(mem_addr, 2) & 32'hFFFF;
        end
        3'b001: begin // Lh: 加载 2 字节，有符号扩展
          load_data = $signed(pmem_read(mem_addr, 2) << 16) >>> 16; // >>> 16：算术右移16位，高位填充​​符号位​
        end
        default: load_data = 32'b0; // 未支持的 load 类型 
      endcase
      mem_done = 1'b1;
      end
    end else begin
    mem_done =1'b0;
    end
  end

 always @(posedge clk) begin
  if (rst) begin
   load_data = 32'b0;
   end else begin
    if(is_store) begin
     // $display("[MEM] store addr=%h data=%h", mem_addr, mem_wdata);
      case (func3)
      3'b000: begin //sb 存2字节
        pmem_write(mem_addr, 1, mem_wdata);
      end 
      3'b001: begin // SH: 存 2 字节
        pmem_write(mem_addr, 2, mem_wdata);
      end
      3'b010: begin //sw 存4字节
        pmem_write(mem_addr, 4, mem_wdata);
      end
      default: $display("ERROR: Unsupported store func3 %b", func3);
      endcase
    end
   end
 end */

endmodule
