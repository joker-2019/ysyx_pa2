module ysyx_22040080_instr_mem (
    input  wire [31:0] addr,     // 地址
    output wire [31:0] rdata     // 读数据
);

initial begin
    // 需要执行测试的elf文件，然后将其转换成elf格式的hex文件
    $readmemh("prog.hex", mem);
end
    reg [31:0] mem [0:255];      // 1KB 存储器
    wire [31:0] addr_offset = addr - 32'h80000000;
    wire [7:0] index = addr_offset[9:2];
    // 组合读 (当前周期即可读出)
    assign rdata = mem[index];

endmodule