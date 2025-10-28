module simplememory(
 input wire clk,
 input wire wen, // 写使能
 input wire [31:0] addr, // 地址
 input wire [31:0] wdata, // 写数据
 output wire [31:0] rdata  //读数据
);
 // 定义一个大小为1KB的内存
 reg[31:0] mem[0:255]; // 256 * 4 = 1024 bytes
 wire [7:0] index = addr[9:2]; // 1KB内存，地址低10位有效，按字对齐取高8位作为索引
 // 读操作
 assign rdata = mem[index];

 // 同步写
 always(posedge clk) begin
  if(wen) begin
   mem[index] <= wdata;
  end
 end
endmodule