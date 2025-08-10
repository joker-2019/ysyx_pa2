module ysyx_22040080_cpu(
	input  clk,
	input  rst,
  output reg [31:0] trace_pc, // 输出当前PC值
  output [31:0] trace_instr // 输出当前指令
);
  reg [31:0] pc;
  wire [31:0] alu_result;
  wire [31:0] instruction;
  wire [4:0] rs1, rd, rs2; // rs1 rs2 和 rd 寄存器地址 
  wire [2:0] func3;
  wire [6:0] func7;
  wire [31:0] imm_ext; // 立即数扩展
  wire [4:0] shamt;
  wire [6:0] op;
  wire [31:0] rs1_data, rs2_data; // rs1 寄存器数据
  wire wen;
  wire is_ebreak; 
  wire [2:0] instr_type; // 指令类型
  wire [31:0] jal_target; //跳转目标
  wire [31:0] next_pc;
  wire jump_flag;
  // wire branch_taken;
  // reg [31:0] next_pc;
  wire [31:0] mem_addr;     // 访存地址
  wire [31:0] mem_wdata;    // SW写入内存数据
  wire [31:0] mem_rdata;    // LW读取内存数据
  wire        is_load;      // LW指令标志
  wire        is_store;     // SW指令标志
  reg [31:0] load_data;

// import "DPI-C" function void ebreak_trigger();  // 声明 DPI-C 函数
import "DPI-C" function int lw_mem_read(input int addr, input int len);
import "DPI-C" function void sw_mem_write(input int addr, input int data, input int len);

  // PC更新逻辑：新增分支、jal、jalr判断
  wire is_jal   = (op == 7'b1101111);
  wire is_jalr   = (op == 7'b1100111);
  wire is_branch = (op == 7'b1100011);

  wire branch_taken = is_branch && (
    (func3 == 3'b000 && rs1_data == rs2_data) ||       // beq
    (func3 == 3'b001 && rs1_data != rs2_data) ||       // bne
    (func3 == 3'b100 && $signed(rs1_data) < $signed(rs2_data)) || // blt
    (func3 == 3'b101 && $signed(rs1_data) >= $signed(rs2_data)) ||   // bge
    (func3 == 3'b110 && $unsigned(rs1_data) < $unsigned(rs2_data))  ||   // BLTU
    (func3 == 3'b111 && $unsigned(rs1_data) >= $unsigned(rs2_data))  // BGEU
  );
           
assign next_pc = (branch_taken || is_jal || is_jalr) ? jal_target : pc + 4;
// assign load_data = is_load ? lw_mem_read(mem_addr, 4) : alu_result; //组合逻辑，直接加载数据

// ----------------------
//  LOAD 数据读取逻辑
// ----------------------
always @(*) begin
  if(is_load) begin
    case (func3)
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
  // 初始化
  if(rst) begin 
    pc <= 32'h80000000;
  end else begin
    pc <= next_pc;
    // $display("PC=0x%8h", pc);
  end
  // 只支持 SW (一次写4字节)
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

assign trace_pc = pc;
assign trace_instr = instruction;


ysyx_22040080_ifu ifu(
  .clk(clk),
  .rst(rst),
  .pc(pc),
  .instruction(instruction)
);

  //译码
ysyx_22040080_idu idu(
  .instruction(instruction),
  .rs1(rs1),
  .rs2(rs2),
  .rd(rd),
  .func3(func3),
  .func7(func7),
  .imm_ext(imm_ext),
  .op(op),
  .shamt(shamt),
  .is_ebreak(is_ebreak),
  .instr_type(instr_type)
);

  //执行
ysyx_22040080_alu alu(
  .clk(clk),
  .rs1_data(rs1_data),
  .rs2_data(rs2_data),
  .imm_ext(imm_ext),
  .func3(func3),
  .func7(func7),
  .op(op),
  .pc(pc),
  .shamt(shamt),
  .jal_target(jal_target),
  .result(alu_result),
  .wen(wen),
  // .branch_taken(branch_taken).
  .mem_addr(mem_addr),   // 新增: 访存地址
  .mem_wdata(mem_wdata), // 新增: SW写入内存数据
  .mem_rdata(mem_rdata),
  .is_load(is_load),     // 新增: LW标志
  .is_store(is_store)    // 新增: SW标志
);


 //寄存器堆实例
RegisterFile regfile(
  .clk(clk),
  .wen(wen),
  .rst(rst),
  .raddr1(rs1),
  .raddr2(rs2), // 未使用，默认设为 x0
  .waddr(rd),
  // .wdata(alu_result),
  .wdata(load_data),
  .rdata1(rs1_data),
  .rdata2(rs2_data) // 未使用，可忽略或接空
);

endmodule
