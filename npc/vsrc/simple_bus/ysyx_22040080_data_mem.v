module ysyx_22040080_data_mem (
    input  wire        clk,
    input  wire        wen,      // 写使能
    input  wire [3:0]  wmask,   // 写掩码: 1 bit per byte
    input  wire [31:0] addr,     // 地址
    input  wire [31:0] wdata,    // 写数据
    output wire [31:0] rdata     // 读数据
);
    reg [31:0] mem [0:255];      // 1KB 存储器
    // wire [7:0] index = addr[9:2]; // 字对齐寻址 (低2位忽略)
    wire [31:0] addr_offset = addr - 32'h80000000;
    wire [7:0] index = addr_offset[9:2];
    // 组合读 (当前周期即可读出)
    assign rdata = mem[index];

    // 同步写
    always @(posedge clk) begin
        if (wen) begin
         if (wmask[0]) mem[index][ 7:0 ] <= wdata[ 7:0 ];
         if (wmask[1]) mem[index][15:8 ] <= wdata[15:8 ];
         if (wmask[2]) mem[index][23:16] <= wdata[23:16];
         if (wmask[3]) mem[index][31:24] <= wdata[31:24];
        end
    end

endmodule