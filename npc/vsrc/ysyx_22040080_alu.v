module ysyx_22040080_alu(
	input clk,
	input [31:0] rs1_data, //来自regFile的rs1数据
	input [31:0] rs2_data,
	input [31:0] imm_ext,  //扩展后的立即数
	input [2:0] func3,
	input [6:0] func7,
	input [6:0] op,			// 新增：指令操作码（用于区分指令类型）
	input [31:0] pc,
	input [4:0] shamt,
	output reg [31:0] result, //计算结果
	output reg wen, //传递到写回阶段的写使能端
	output reg [31:0] jal_target, // 新增：跳转目标地址（用于 jal、jalr）

	output reg [31:0] mem_addr,     // 访存地址
 output reg [31:0] mem_wdata,    // SW写入内存数据
 // output reg [31:0] mem_rdata,    // LW读取内存数据
 output	reg is_load,      // LW指令标志
 output	reg is_store,     // SW指令标志

		// CSR
 input 					[31:0] csr_rdata,
	output reg			  			csr_wen,
 // output reg [11:0] csr_addr,
 output reg [31:0] csr_wdata
);

// import "DPI-C" function void phys_mem_write(input int addr, input int len, input int data);

// 通用加法器输入信号
wire [31:0] alu_in1;
wire [31:0] alu_in2;
assign alu_in1 = (op == 7'b0010011 || op == 7'b1100111) ?	rs1_data :
																	(op == 7'b0010111 || op == 7'b1101111) ?	pc :
																	32'b0;

assign alu_in2 = imm_ext;

wire [31:0] alu_sum = alu_in1 + alu_in2; // 共享加法器核心
//ALU操作
always @(*) begin
	// 默认输出
 result = 0;
 jal_target = 0;
 wen = 1'b0;

	mem_addr    = 32'b0;
 mem_wdata   = 32'b0;
 // mem_rdata   = 32'b0;
 is_load     = 1'b0;
 is_store    = 1'b0;

 // CSR
	csr_wen = 1'b0;
	csr_wdata = 32'b0;
	// 跳过未初始化指令(全0), 防止输出无意义错误日志
	if (!(op == 7'b0000000 && func3 == 3'b000 && rs1_data == 32'b0 && imm_ext == 32'b0)) begin
		case(op)
			// I型指令:ADDI
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
							result = $signed(rs1_data) >>> shamt;          // SRAI
							wen = 1'b1;
						end
					end
					3'b011: begin result = ($unsigned(rs1_data) < $unsigned(imm_ext)) ? 32'b1 : 32'b0; wen = 1'b1; end// SLTIU
					3'b111: begin result = rs1_data & imm_ext; wen = 1'b1; end // ANDI
					// ... 可扩展 SLLI, SRAI
					default:
						$display("ERROR: Unsupported func3 %b for I-type instruction", func3);
				endcase
			end

			7'b0110011: begin 
				case (func3)
					3'b000: begin
						if (func7 == 7'b0000000) begin  //ADD
							result = rs1_data + rs2_data; 
							wen = 1'b1;
						end else if(func7 == 7'b0100000) begin //SUB
							result = rs1_data - rs2_data;
							wen = 1'b1;
						end 
					end
					3'b001: begin //SLL
						result = rs1_data << rs2_data[4:0];
						wen = 1'b1;
					end
					3'b110: begin	// OR
						result = rs1_data | rs2_data;
						wen = 1'b1;
					end
					3'b111: begin // AND
						result = rs1_data & rs2_data;
						wen = 1'b1;
					end
					3'b100: begin // XOR
						result = rs1_data ^ rs2_data;
						wen = 1'b1;
					end

					3'b101: begin // SRL  逻辑右移
						if (func7 == 7'b0000000) begin
							result = rs1_data >> rs2_data[4:0];
							wen = 1'b1;
						end
					end
					3'b011: begin // SLTU 无符号小于则置位
						if (func7 == 7'b0000000) begin
							result = ($unsigned(rs1_data) < $unsigned(rs2_data)) ? 32'b1 : 32'b0;
							wen = 1'b1;
						end
					end					
					default: 
						$display("ERROR: Unsupported func3 %b for R-type", func3);
				endcase
			end

			7'b0000011: begin	// LW指令 写入内存 lhu lbu lh
				mem_addr = rs1_data + imm_ext;
				is_load = 1'b1;
				wen = 1'b1;
				end
			
			//SW 指令
			7'b0100011: begin
				mem_addr = rs1_data + imm_ext; // 存储地址 = rs1 + offset
				mem_wdata = rs2_data;
				is_store = 1;
				end

			// Branch指令 (BEQ, BNE, BLT, BGE)
			7'b1100011: begin
				jal_target = pc + imm_ext; // 计算跳转目标地址
			end


		// U型指令：AUIPC AUIPC: PC + (立即数 << 12)
		7'b0010111: begin
				result = alu_sum;
				wen = 1'b1;
				// $display("AUIPC: PC=0x%8h, IMM=0x%8h, Result=0x%8h", pc, imm_ext, result);
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
			// $display("jal_target=0x%8h, Result=0x%8h", jal_target, result);
			wen = 1'b1;	
			end

		// JALR指令
		7'b1100111: begin
			result = pc + 4;
			jal_target = ($unsigned(rs1_data) + $unsigned(imm_ext)) & ~32'b1; // 低位清零
			// $display("jalr_target=0x%8h, Result=0x%8h", jal_target, result);
			wen = 1'b1;	
			end
		7'b1110011: begin // SYSTEM 指令
			case (func3)
				3'b001: begin
					// csr_addr = imm_ext[11:0];// CSR地址（通常来自指令[31:20]，这里imm_ext已解码）
					csr_wdata = rs1_data;    // 写入CSR的新值
					result = csr_rdata;      // 将写入的值传递到rd
					csr_wen = 1'b1;          // 使能写CSR
					wen = 1'b1;
				end
				default: ;
			endcase
		end

		default: begin
			$display("ERROR: Unsupported opcode %b", op);
			end
		endcase
	end
end

endmodule
