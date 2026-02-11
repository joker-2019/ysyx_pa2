module ysyx_22040080_alu(
	input clk,
	// input rst,

	input [31:0] rs1_data, //来自regFile的rs1数据
	input [31:0] rs2_data,
	input [31:0] imm_ext,  //扩展后的立即数
	input [2:0] func3,
	input [6:0] func7,
	input [6:0] op,			// 新增：指令操作码（用于区分指令类型）
	input [31:0] pc,
	input [4:0] shamt,
	input wire inst_active, // 指令有效信号
	
	output reg [31:0] result, //计算结果
	output reg wen, //传递到写回阶段的写使能端
	output reg jump_flag, 
	output reg branch_taken, // 是否为跳转相关

	output reg [31:0] jal_target, // 新增：跳转目标地址（用于 jal、jalr）
	output reg [31:0] mem_addr,     // 访存地址
 output reg [31:0] mem_wdata,    // SW写入内存数据
 // output reg [31:0] mem_rdata,    // LW读取内存数据

		// CSR
 input 					[31:0] csr_rdata,
	output reg			  			csr_wen,
 output reg [31:0] csr_wdata,
	//exception
	output	reg trap_valid,
	output	reg is_mret,
	output reg [31:0] trap_mepc,
	output reg [31:0] trap_mcause
);

wire [31:0] alu_in1;
wire [31:0] alu_in2;
assign alu_in1 = (op == 7'b0010011 || op == 7'b1100111) ? rs1_data : 
																	(op == 7'b0010111 || op == 7'b1101111) ? pc :
																	32'b0;
assign alu_in2 = imm_ext;
wire [31:0] alu_sum = alu_in1 + alu_in2;  // 共享加法器核心

always @(*) begin
	// 默认输出
	result = 32'b0;
	wen = 1'b0;
 // 跳转
	jump_flag = 1'b0;
	branch_taken = 1'b0;
	jal_target = 32'b0;
	// 访存
	mem_addr = 32'b0;
	mem_wdata = 32'b0;
	// CSR
	csr_wen = 1'b0;
	csr_wdata = 32'b0;
	// exception
	trap_valid = 1'b0;
	trap_mepc = 32'b0;
	trap_mcause = 32'b0;
	is_mret = 1'b0;
	if(inst_active) begin
		case (op)
			// I型指令
			7'b0010011: begin
				case(func3)
				3'b000: begin result = alu_sum; wen = 1'b1; end	// ADDI
				3'b001: begin result = rs1_data << shamt;  wen = 1'b1; end // slli
				3'b110: begin result = rs1_data | imm_ext; wen = 1'b1; end	// ORI
				3'b100: begin result = rs1_data ^ imm_ext; wen = 1'b1; end	// XORI
				3'b101: begin 
					if(func7 == 7'b0000000) begin
						result = rs1_data >> shamt;                    // SRLI
						wen = 1'b1;
					end
					else	if(func7 == 7'b0100000) begin
						result = $signed(rs1_data) >>> shamt;          // SRAI 算术右移立即数
						wen = 1'b1;
					end
				end
				3'b011: begin result = ($unsigned(rs1_data) < $unsigned(imm_ext)) ? 32'b1 : 32'b0; wen = 1'b1; end// SLTIU
				3'b111: begin result = rs1_data & imm_ext; wen = 1'b1; end // ANDI
				// ... 可扩展 SLLI, SRAI
				default: $display("ERROR: Unsupported func3 %b for I-type instruction", func3);
			endcase
			end

			// R型指令
			7'b0110011: begin
				case (func3)
					3'b000: begin
						//ADD
						if (func7 == 7'b0000000) begin  result = rs1_data + rs2_data; wen = 1'b1; end
						//SUB 
						else if(func7 == 7'b0100000) begin result = rs1_data - rs2_data; wen = 1'b1; end 
					end
					//SLL
					3'b001: begin result = rs1_data << rs2_data[4:0]; wen = 1'b1; end
					//slt
					3'b010: begin result = ($signed(rs1_data) < $signed(rs2_data)) ? 32'b1 : 32'b0; wen = 1'b1; end
					// OR
					3'b110: begin	result = rs1_data | rs2_data; wen = 1'b1; end
					// AND
					3'b111: begin result = rs1_data & rs2_data; wen = 1'b1; end
					// XOR
					3'b100: begin result = rs1_data ^ rs2_data; wen = 1'b1; end
					// SRL  逻辑右移
					3'b101: begin 
						if (func7 == 7'b0000000) begin // 逻辑右移（无符号，高位填0）- R型
							result = rs1_data >> rs2_data[4:0]; wen = 1'b1; 
							end
						else if(func7 == 7'b0100000) begin // 算术右移 最高位填符号位 SRA
							result = $signed(rs1_data) >>> rs2_data[4:0]; wen = 1'b1; 
							end
					end
					3'b011: begin
						// SLTU 无符号小于则置位 
						if (func7 == 7'b0000000) begin result = ($unsigned(rs1_data) < $unsigned(rs2_data)) ? 32'b1 : 32'b0; wen = 1'b1; end
					end					
					default: $display("ERROR: Unsupported func3 %b for R-type", func3);
				endcase
			end
			// LW
			7'b0000011: begin 
				mem_addr = rs1_data + imm_ext; wen = 1'b1;
			end
			// SW
			7'b0100011: begin 
				mem_addr = rs1_data + imm_ext; mem_wdata = rs2_data; 
			end
			// Branch
			7'b1100011: begin 
				case (func3)
					3'b000: branch_taken = (rs1_data == rs2_data);  // BEQ
					3'b001: branch_taken = (rs1_data != rs2_data);  // BNE
					3'b100: branch_taken = ($signed(rs1_data) < $signed(rs2_data));  // BLT
					3'b101: branch_taken = ($signed(rs1_data) >= $signed(rs2_data)); // BGE
					3'b110: branch_taken = ($unsigned(rs1_data) < $unsigned(rs2_data));  // BLTU
					3'b111: branch_taken = ($unsigned(rs1_data) >= $unsigned(rs2_data)); // BGEU
					default: branch_taken = 1'b0;
				endcase
				// 分支目标
				if (branch_taken) begin jump_flag  = 1'b1; jal_target = pc + imm_ext;  end
			end
			// AUPIC
			7'b0010111: begin 
				result = alu_sum; wen = 1'b1;
			end
			// LUI
			7'b0110111: begin 
				result = imm_ext; wen = 1'b1;
			end
			// JAL
			7'b1101111: begin 
				result = pc + 4; jump_flag = 1'b1; jal_target = alu_sum; wen = 1'b1;
			end
			// JALR
			7'b1100111: begin 
				result = pc + 4; jump_flag = 1'b1; jal_target = ($unsigned(rs1_data) + $unsigned(imm_ext)) & ~32'b1; wen = 1'b1;
			end
			// SYSTEM
			7'b1110011: begin 
				case (func3)
				3'b000: begin 
					if(imm_ext[11:0] == 12'h000) begin // ecall
						// $display("ecall at pc=%h", pc);
						trap_valid  = 1'b1; 
						trap_mepc = pc;	// 保存异常发生地址
						trap_mcause = 32'd11;
					end else if(imm_ext[11:0] == 12'h302) //mret
						is_mret = 1'b1; //顶层应从 CSR 的 mepc 恢复 PC
				end
				3'b001: begin	// CSRRW
					result = csr_rdata;      // 将写入的值传递到rd
					csr_wdata = rs1_data;    // 写入CSR的新值
					csr_wen = 1'b1;          // 使能写CSR
					wen = 1'b1;
				end
				3'b010: begin // CSRRS
					result = csr_rdata;
					csr_wdata = rs1_data | csr_rdata; // CSRS: 将rs1与csr_rdata按位相与后写回csr
					csr_wen= 1'b1;
					wen = 1'b1;
				end
				// 额外添加ecall, mret,等特权指令
				default: $display("ERROR: Unsupported SYSTEM instruction %b for R-type", func3);
			endcase
			end

			default: $display("ERROR: Unsupported opcode %b", op);
		endcase
	end
	end

endmodule
