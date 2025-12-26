module ysyx_22040080_idu(
    // input clk,
    // input rst,
	input [31:0] instruction, //来自IFU的指令

     // 与 IFU 的握手接口
   /*  input  wire if_id_valid,
    output wire idu_ready,
    // 与 ALU 的握手信号
    output wire idu_alu_valid,
    input  wire alu_ready, */
    input wire inst_active, // 指令有效信号

	output reg [4:0] rs1, // 源寄存器rs1的地址
	output reg [4:0] rs2,	// 源寄存器2 new
	output reg [4:0] rd, // 目标寄存器rd地址
	output reg [2:0] func3,
	output reg [31:0] imm_ext, //符号扩展后的立即数
	output reg [6:0] op,	// 操作符
    output reg [6:0] func7,
	output reg [4:0] shamt, //移位量
    output reg [11:0] csr_addr, //csr寄存器地址
	output reg [2:0]  instr_type, // 新增指令类型标识

    output reg is_jal,
    output reg is_jalr,
    output reg is_branch,
    output reg is_load,
    output reg is_store
);
/*     // ready 定义（是否能接 IFU）
    assign idu_ready = ~idu_alu_valid;
    
    always @(*) begin
        if(rst) begin
            idu_alu_valid = 1'b0;
        end
        else begin
            // 1. 与IFU握手：接收新指令
            if (if_id_valid && idu_ready) begin
                idu_alu_valid = 1'b1; // 指令解码完毕，可以发给 ALU
                // 锁存 instruction 并译码
                rs1   = instruction[19:15];
                rs2   = instruction[24:20];
                rd    = instruction[11:7];
                func3 = instruction[14:12];
                func7 = instruction[31:25];
                op    = instruction[6:0];
                shamt = instruction[24:20];
                // 指令类型
                instr_type =
                    (instruction[6:0] == 7'b0110011) ? 3'b000 :
                    (instruction[6:0] == 7'b0010011) ? 3'b001 :
                    (instruction[6:0] == 7'b0000011) ? 3'b001 :
                    (instruction[6:0] == 7'b1100111) ? 3'b001 :
                    (instruction[6:0] == 7'b1110011) ? 3'b001 :
                    (instruction[6:0] == 7'b0100011) ? 3'b010 :
                    (instruction[6:0] == 7'b1100011) ? 3'b011 :
                    (instruction[6:0] == 7'b0110111) ? 3'b100 :
                    (instruction[6:0] == 7'b0010111) ? 3'b100 :
                    (instruction[6:0] == 7'b1101111) ? 3'b101 :
                    3'b111;

                is_jal    = (instruction[6:0] == 7'b1101111);
                is_jalr   = (instruction[6:0] == 7'b1100111);
                is_branch = (instruction[6:0] == 7'b1100011);
                // 立即数
                case (instruction[6:0])
                    7'b0010011, 7'b0000011, 7'b1100111, 7'b1110011: imm_ext = {{20{instruction[31]}}, instruction[31:20]};
                    7'b0100011: imm_ext = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
                    7'b1100011: imm_ext = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
                    7'b0110111, 7'b0010111: imm_ext = {instruction[31:12], 12'b0};
                    7'b1101111: imm_ext = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
                    default:
                        imm_ext = 32'b0;
                endcase
                csr_addr = (instruction[6:0] == 7'b1110011) ? instruction[31:20] : 12'b0;
            end
            // 2. 与ALU握手：传递译码结果
            else if (idu_alu_valid && alu_ready) begin
                idu_alu_valid = 1'b0; // ALU 接收完毕，拉低 valid
            end
           
        end
    end */

//------------------------------------------
// 立即数扩展（按指令类型区分）
//------------------------------------------
// reg [31:0] imm;
always @(*) begin
// 步骤1：默认值（避免不定态，无延迟）
rs1 = 5'b0;
rs2 = 5'b0;
func7 = 7'b0;
rd = 5'b0;
func3 = 3'b0;
op = 7'b0;
shamt = 5'b0;
instr_type = 3'b111;
is_jal = 1'b0;
is_jalr = 1'b0;
is_branch = 1'b0;
imm_ext = 32'b0;
csr_addr = 12'b0;
is_load = 1'b0;
is_store = 1'b0;

if(inst_active) begin
    rs1 = instruction[19:15];
    rs2 = instruction[24:20];     // R/S/B型指令的rs2
    func7 = instruction[31:25];  // R型指令func7解码
    rd = instruction[11:7];
    func3 = instruction[14:12];  
    op = instruction[6:0]; // 操作码                   
    shamt = (((op == 7'b0010011) && (func3[1:0] == 2'b01)) ? instruction[24:20] : 5'b0);

    instr_type = 
        (op == 7'b0110011) ? 3'b000 :
        (op == 7'b0010011) ? 3'b001 :
        (op == 7'b0000011) ? 3'b001 :
        (op == 7'b1100111) ? 3'b001 :
        (op == 7'b1110011) ? 3'b001 :
        (op == 7'b0100011) ? 3'b010 :
        (op == 7'b1100011) ? 3'b011 :
        (op == 7'b0110111) ? 3'b100 :
        (op == 7'b0010111) ? 3'b100 :
        (op == 7'b1101111) ? 3'b101 :
        3'b111;

    is_jal   = (op == 7'b1101111);
    is_jalr  = (op == 7'b1100111);
    is_branch= (op == 7'b1100011);
    is_load  = (op == 7'b0000011);
    is_store = (op == 7'b0100011);

    case (instr_type)
        // I型：ADDI/LB/LH/LW 符号扩展：复制最高位20次  立即数位：31-20（共12位）
        3'b001: imm_ext = {{20{instruction[31]}}, instruction[31:20]};
        
        // S型：SW/SH/SB  符号扩展：复制最高位20次  高位：31-25，低位：11-7
        3'b010: imm_ext = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

        // B型：BEQ/BNE 立即数组成 [31], [7], [30:25], [11:8], 最后1位=0
        3'b011: imm_ext = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
        
        // U型：LUI/AUIPC // 低位补12个0
        3'b100: imm_ext = {instruction[31:12], 12'b0};
        
        // J型：JAL [31], [19:12], [20], [30:21], 最后1位=0
        3'b101: imm_ext = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
        
        default: imm_ext = 32'b0;  // R型不需要立即数
    endcase

    // 符号扩展立即数 (I-type)
    // assign imm_ext = imm;
    // assign csr_addr = (op == 7'b1110011) ? imm_ext[11:0] : 12'b0; //csr地址
    csr_addr = (op == 7'b1110011) ? imm_ext[11:0] : 12'b0; //csr地址
end
end


endmodule
