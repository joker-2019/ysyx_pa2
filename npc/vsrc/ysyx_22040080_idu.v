module ysyx_22040080_idu(
	input [31:0] instruction, //来自IFU的指令

	output [4:0] rs1, // 源寄存器rs1的地址
	output [4:0] rs2,	// 源寄存器2 new

	output [4:0] rd, // 目标寄存器rd地址
	output [2:0] func3,
	output [31:0] imm_ext, //符号扩展后的立即数
	output [6:0] op,	// 操作符
	
	//ebreak指令检测
	output is_ebreak,

	output [2:0]  instr_type // 新增指令类型标识
	
);
	// 直接从 instruction 中解码字段
    assign rs1    = instruction[19:15];
	assign rs2   = instruction[24:20];     // R/S/B型指令的rs2

    assign rd     = instruction[11:7];
    assign func3  = instruction[14:12];
    assign op   = instruction[6:0]; // 操作码


	//------------------------------------------
    // 指令类型识别（R/I/S/B/U/J型）
    //------------------------------------------
    wire is_r_type = (op == 7'b0110011);  // R型指令（ADD等）
    wire is_i_type = (op == 7'b0010011 ||  // I型（ADDI）
                      op == 7'b0000011);   // LOAD
    wire is_s_type = (op == 7'b0100011);   // S型（SW）
    wire is_b_type = (op == 7'b1100011);   // B型（BEQ）
    wire is_u_type = (op == 7'b0110111);   // U型（LUI）
    wire is_j_type = (op == 7'b1101111);   // J型（JAL）

    assign instr_type = 
    (op == 7'b0110011) ? 3'b000 : // R-type (add/sub/sll/srl...)
    (op == 7'b0010011) ? 3'b001 : // I-type-arithmetic (addi/andi...)
    (op == 7'b0000011) ? 3'b001 : // I-type-load (lw/lh/lb...)
    (op == 7'b1100111) ? 3'b001 : // I-type-jump (jalr)
    (op == 7'b1110011) ? 3'b001 : // I-type-system (ecall/ebreak)
    (op == 7'b0100011) ? 3'b010 : // S-type (sw/sh/sb)
    (op == 7'b1100011) ? 3'b011 : // B-type (beq/bne/blt...)
    (op == 7'b0110111) ? 3'b100 : // U-type (lui)
    (op == 7'b0010111) ? 3'b100 : // U-type (auipc)
    (op == 7'b1101111) ? 3'b101 : // J-type (jal)
    3'b111;

	//------------------------------------------
    // 立即数扩展（按指令类型区分）
    //------------------------------------------
	reg [31:0] imm;
    always @(*) begin
        case (instr_type)
            // I型：ADDI/LB/LH/LW 符号扩展：复制最高位20次  立即数位：31-20（共12位）
            3'b001: assign imm = {{20{instruction[31]}}, instruction[31:20]};
            
            // S型：SW/SH/SB  符号扩展：复制最高位20次  高位：31-25，低位：11-7
            3'b010: assign imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            
            // B型：BEQ/BNE 立即数组成 [31], [7], [30:25], [11:8], 最后1位=0
            3'b011: assign imm = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            
            // U型：LUI/AUIPC // 低位补12个0
            3'b100: assign imm = {instruction[31:12], 12'b0};
            
            // J型：JAL [31], [19:12], [20], [30:21], 最后1位=0
            3'b101: assign imm = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            
            default: assign imm = 32'b0;  // R型不需要立即数
        endcase
    end

	// 符号扩展立即数 (I-type)
    // assign imm_ext = {{20{instruction[31]}}, instruction[31:20]};
	assign imm_ext = imm;

    //------------------------------------------
    // ebreak检测（SYSTEM指令）
    //------------------------------------------
    assign is_ebreak = (op == 7'b1110011) &&   // SYSTEM操作码
                       (func3 == 3'b000) &&    // EBREAK的func3
                       (instruction[31:20] == 12'b000000000001); // EBREAK特征码


endmodule
