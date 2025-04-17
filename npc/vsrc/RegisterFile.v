module RegisterFile #(
	ADDR_WIDTH = 5, //5 默认5位地址(32个寄存器)
	DATA_WIDTH = 32 //32 32位数据
) (
  input clk,
  //写端口
  input [DATA_WIDTH-1:0] wdata, //写数据
  input [ADDR_WIDTH-1:0] waddr, //写地址(rd)
  input wen, // 写使能

  //读端口1
  input [ADDR_WIDTH-1:0]  raddr1,       //读地址（rs1）
  output [DATA_WIDTH-1:0] rdata1       //输出 rs1 数据
);
  reg [DATA_WIDTH-1:0] rf [2**ADDR_WIDTH-1:0]; //寄存器数组
  
  //写操作(时序逻辑)
  always @(posedge clk) begin
    if (wen && waddr != 0) begin //x0恒为0
      rf[waddr] <= wdata;
      end  
  end

  //异步读操作
  assign rdata1 = (raddr1 == 0) ? 32'b0 : rf[raddr1]; //x0恒为0

endmodule
