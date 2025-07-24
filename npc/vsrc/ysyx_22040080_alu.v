module ysyx_22040080_alu(
	input clk,
	input [31:0] rs1_data, //来自regFile的rs1数据
	input [31:0] imm_ext,  //扩展后的立即数
	input [2:0] func3,
	input [6:0] op,			// 新增：指令操作码（用于区分指令类型）
	input [31:0] pc,	 // 新增：当前指令地址
	output reg [31:0] result, //计算结果
	output reg wen, //传递到写回阶段的写使能端
	output reg[31:0] jal_target // 新增：跳转目标地址（用于 jal、jalr）
	
);
import "DPI-C" function void ebreak_trigger();  // 声明 DPI-C 函数
// 通用加法器输入信号
wire [31:0] alu_in1;
wire [31:0] alu_in2;
assign alu_in1 = (op == 7'b0010011) ?	rs1_data :
																	(op == 7'b0010111) ?	pc :
																	(op == 7'b1100111) ? rs1_data : // LUI指令的rs1数据
																	(op == 7'b1101111) ? pc : 32'b0;

assign alu_in2 = imm_ext;

wire [31:0] alu_sum = alu_in1 + alu_in2; // 共享加法器核心
//ALU 逻辑

//ALU操作
always @(*) begin
	// 默认输出
 result = 0;
 jal_target = 0;
 wen = 1'b0;

	// 跳过未初始化指令(全0), 防止输出无意义错误日志
	if (op == 7'b0000000 && func3 == 3'b000 && rs1_data == 32'b0 && imm_ext == 32'b0) begin
		// 不处理，不打印
		end 
		else begin
			case(op)
			// I型指令:ADDI
			7'b0010011: begin
				case(func3)
				3'b000: begin // ADDI
					result = alu_sum; // ADDI
					wen = 1'b1; // 写使能
				end
				3'b111: begin // ANDI
					result = rs1_data & imm_ext; // ANDI
					wen = 1'b1; // 写使能
				end
				3'b110: begin // ORI
					result = rs1_data | imm_ext; // ORI
					wen = 1'b1; // 写使能
				end
				3'b100: begin // XORI
					result = rs1_data ^ imm_ext; // XORI
					wen = 1'b1; // 写使能
				end
				// ... 可扩展 SLLI, SRLI, SRAI
				default:
					$display("ERROR: Unsupported func3 %b for I-type instruction", func3);
				endcase
		end

		// U型指令：AUIPC AUIPC: PC + (立即数 << 12)
		7'b0010111: begin
			result = alu_sum;
			wen = 1'b1;
			end

		// U型指令：LUI		       
		7'b0110111: begin
			result = imm_ext;
			wen = 1'b1;		       
			end

		// JAL指令
		7'b1101111: begin
			result = pc + 4;
			jal_target = alu_sum;
			wen = 1'b1;	
		end

		// JALR指令
		7'b1100111: begin
			result = pc + 4;
			jal_target = (alu_sum) & ~32'b1; // 低位清零
			wen = 1'b1;	
		end
		
		// Ebreak 指令
		7'b1110011: begin
			$display("EBREAK at PC: 0x%08h", pc);
			ebreak_trigger(); //触发ebreak指令
			// 可在此添加中断处理逻辑
		end
		default: 
			$display("ERROR: Unsupported opcode %b for func3=000", op);
		endcase
	end
end

endmodule
