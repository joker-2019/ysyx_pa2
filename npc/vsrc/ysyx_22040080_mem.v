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
    // 输出到 WB 阶段
    output reg [31:0] load_data
);
// import "DPI-C" function void ebreak_trigger();  // 声明 DPI-C 函数
 import "DPI-C" function int lw_mem_read(input int addr, input int len);
 import "DPI-C" function void sw_mem_write(input int addr, input int data, input int len);


// ----------------------
//  LOAD 数据读取逻辑
// ----------------------
always @(*) begin
  if(is_load) begin
    // $display("[EX] lw: mem_addr=0x%08h func3=%b", mem_addr, func3);
    case (func3)
      3'b000: begin
        load_data = $signed(lw_mem_read(mem_addr, 1) << 24) >>> 24;
       end
      3'b010: begin //LW指令 加载 4 字节
        load_data = lw_mem_read(mem_addr, 4);
      end
      3'b100: begin // LBU: 加载 1 字节，无符号扩展
        load_data = lw_mem_read(mem_addr, 1) & 32'hFF;
      end
      3'b101: begin // Lhu: 加载 2 字节，零扩展
         load_data = lw_mem_read(mem_addr, 2) & 32'hFFFF;
      end
      3'b001: begin // Lh: 加载 2 字节，有符号扩展
        load_data = $signed(lw_mem_read(mem_addr, 2) << 16) >>> 16; // >>> 16：算术右移16位，高位填充​​符号位​
      end
      default: load_data = 32'b0; // 未支持的 load 类型 
    endcase
  end else begin
    load_data = alu_result;
    end
end

 always @(posedge clk) begin
  if (rst) begin
   load_data = 32'b0;
   end else begin
    if(is_store) begin
     case (func3)
      3'b000: begin //sb 存2字节
        sw_mem_write(mem_addr, 1, mem_wdata);
      end 
      3'b001: begin // SH: 存 2 字节
        sw_mem_write(mem_addr, 2, mem_wdata);
      end
      3'b010: begin //sw 存4字节
        sw_mem_write(mem_addr, 4, mem_wdata);
      end
      default: $display("ERROR: Unsupported store func3 %b", func3);
     endcase   
    end
   end
 end
   
endmodule
