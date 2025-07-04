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

// 通用加法器输入信号
reg [31:0] alu_in1;
reg [31:0] alu_in2;
wire [31:0] alu_sum = alu_in1 + alu_in2;
//ALU 逻辑

//ALU操作
always @(*) begin
	// 默认输出
	alu_in1 <= 0;
	alu_in2 <= 0;
 result <= 0;
 jal_target <= 0;
 wen <= 1'b0;

	case(op)
		// I型指令:ADDI
		7'b0010011: begin
			alu_in1 = rs1_data;
			alu_in2 = imm_ext;
			result <= alu_sum; //addi
			wen <= 1'b1; // 写使能
			end

		// U型指令：AUIPC AUIPC: PC + (立即数 << 12)
		7'b0010111: begin
			alu_in1 = pc;
			alu_in2 = imm_ext;
			result <= alu_sum;
			wen <= 1'b1;
			end

		// U型指令：LUI		       
		7'b0110111: begin
			result <= imm_ext;
			wen <= 1'b1;		       
			end

		// JAL指令
		7'b1101111: begin
			result <= pc + 4;
			jal_target <= pc + imm_ext;
		end

		// JALR指令
		7'b1100111: begin
			result <= pc + 4;
			jal_target <= (rs1_data + imm_ext) & ~32'b1; // 低位清零
		end
		
		// Ebreak 指令
		7'b1110011: begin
			 $display("EBREAK at PC: 0x%08h", pc);
				// 可在此添加中断处理逻辑
		end
		default: begin
			result <= 32'b0;
			wen <= 1'b0;
			$display("ERROR: Unsupported opcode %b for func3=000", op);
			end
	endcase
	end

endmodule
