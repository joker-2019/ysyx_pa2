module ysyx_22040080_cpu(
	input  clk,
	input  rst,
  //output [31:0] instruction,  // 确保是 32 位输入
  //output [31:0] pc,              // 输出当前 PC，供指令获取
  //output [31:0] rdata,          // 从数据内存中读取的数据

  //output [31:0] mem_addr,        // 要访问的内存地址
  //output [31:0] wdata,        // 写入数据
  //output [31:0] waddr,           // 写地址（例如用于 debug 或存储）
  //output  wen,           //写使能信号

  output reg[31:0] result    //alu计算结果
);
//声明
reg [31:0]next_pc;
//reg wen;//用来判断是否写入
reg [6:0]op;
reg [4:0]rd;
reg [2:0]func3;
reg[31:0]pc;
wire [31:0]ins;

//rs1,imm保存的是地址，需要取出对应的内容，所以需要扩展到32位
reg [31:0] rs1;
reg [31:0] imm;
reg [31:0] rs1_data;
reg [31:0] imm_data;
//初始化
initial begin
	pc = 32'h8000_0000;
	next_pc = pc + 4;
end

//pc
always @(posedge clk or posedge rst)begin
	if(rst)begin
		pc <= 32'h8000_0000;
		next_pc <= pc + 4;		
	end
	else begin
		pc <= next_pc;
		next_pc <= pc + 4;	
	end
 
end


ysyx_22040080_ifu u_ifu (
    .clk(clk),
    .rst(rst),
    .instruction(ins)
);


//IDU接口
//wire [4:0]  rs1_addr, rd_addr;
//wire [31:0] imm_ext;
//wire [2:0]  op;

ysyx_22040080_idu u_idu (
    .instruction(ins),
    .op(op),
    .rs1(rs1),
    .rd(rd),
    .imm_ext(imm_ext),
    .func3(func3)
);



//alu接口
wire [31:0] rs1_data;  // rs1数据
wire [4:0] rd_addr_out;

assign mem_addr = result; // 或者 rs1_val + imm

ysyx_22040080_alu u_exu (
    .clk(clk),
    .rs1(rs1),
    .imm_ext(imm_ext),
    .rd_addr(rd_addr),

    .op(op),
    .result(result),
    .rd_addr_out(rd_addr_out),
    .wen(wen)
);

RegisterFile #(
  .ADDR_WIDTH(5),
  .DATA_WIDTH(32)
) u_RegisterFile (
  .clk(clk),
  .wen(wen),
  .wdata(result),
  .waddr(rd_addr_out),
  .raddr1(rs1_addr),
  .rdata1(rs1_data)
 
);

endmodule
