module RegisterFile (
    input clk,
    input wen,

    input [4:0] raddr1,
    input [4:0] raddr2,

    input [4:0] waddr,
    input [31:0] wdata,
    
    output [31:0] rdata1,
    output [31:0] rdata2
);
    reg [31:0] rf [0:31];

    assign rdata1 = (raddr1 == 0) ? 32'b0 : rf[raddr1];
    assign rdata2 = (raddr2 == 0) ? 32'b0 : rf[raddr2];

    always @(posedge clk) begin
        if (wen && waddr != 0)
            rf[waddr] <= wdata;
    end
endmodule
