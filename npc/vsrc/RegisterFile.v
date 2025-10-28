module RegisterFile (
    input clk,
    input wen,
    input rst,
    input [4:0] raddr1,
    input [4:0] raddr2,

    input [4:0] waddr,
    input [31:0] wdata,
    
    output [31:0] rdata1,
    output [31:0] rdata2
);
    reg [31:0] rf [0:31];
    export "DPI-C" task get_reg_info;
    import "DPI-C" task reg_write_commit(input int addr, input int wdata);
    task get_reg_info(output bit [31:0] current_reg [0:31]);
        begin
            for(integer i = 0; i < 32; i++) begin
                current_reg[i] = rf[i];
            end

        end
    endtask


    assign rdata1 = (raddr1 == 0) ? 32'b0 : rf[raddr1];
    assign rdata2 = (raddr2 == 0) ? 32'b0 : rf[raddr2];

    always @(posedge clk) begin
        if (wen && waddr != 0) begin
            reg_write_commit({27'b0, waddr}, wdata);  // 立即DPI-C同步
        end
    end

    always @(posedge clk) begin
        if(rst) begin
            rf[0] <= 32'b0;
        end else if (wen && waddr != 0) begin
             // $display("[WB] write: waddr=%0d wen=%b wdata=0x%08h",waddr, wen, wdata);
            rf[waddr] <= wdata;
            // reg_write_commit(waddr, wdata); // DPI-C调用，同步给C端
            // reg_write_commit({27'b0, waddr}, wdata); // DPI-C调用，同步给C端
            //$display("RegFile Write: x%0d <= 0x%08h at time %t", waddr, wdata, $time);
            //$display("wen = %b", wen);
        end
    end

endmodule
