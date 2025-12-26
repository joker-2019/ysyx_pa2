module RegisterFile (
    input clk,
    input wen,
    input rst,
    input [4:0] raddr1,
    input [4:0] raddr2,

    input [4:0] waddr,
    input [31:0] wdata,
    
    output [31:0] rdata1,
    output [31:0] rdata2,
    
    output reg wb_done,
    input is_branch,
    input is_load,
    input mem_done,
    input is_store,
    input [31:0] load_data

);
    reg [31:0] rf [0:31];
    reg [4:0] load_waddr_buf;
    reg load_wen_buf;

    export "DPI-C" task get_reg_info;
    import "DPI-C" task reg_write_commit(input int addr, input int wdata);
    
    // WB无未处理数据（写回是组合逻辑，无阻塞），始终就绪（与访存无延迟）
    // assign wb_ready = (rst) ? 1'b0 : 1'b1;

    task get_reg_info(output bit [31:0] current_reg [0:31]);
        begin
            for(integer i = 0; i < 32; i++) begin
                current_reg[i] = rf[i];
            end

        end
    endtask

    assign rdata1 = (raddr1 == 0) ? 32'b0 : rf[raddr1];
    assign rdata2 = (raddr2 == 0) ? 32'b0 : rf[raddr2];

    /* always @(posedge clk) begin
        if(rst) begin
            rf[0] <= 32'b0;
            wb_done <= 1'b0;
        end else begin
            wb_done <= 1'b0;
            if (wen) begin
                if(waddr != 0) begin
                reg_write_commit({27'b0, waddr}, wdata);  // 立即DPI-C同步
                rf[waddr] <= wdata;
                end
                wb_done <= 1'b1;
            end else if(branch_taken) begin
                wb_done <= 1'b1;
            end
        end
    end */
    always @(posedge clk) begin
        if(rst) begin
            rf[0] <= 32'b0;
            wb_done <= 1'b0;
            // 缓存寄存器复位
            load_waddr_buf <= 5'b0;
            load_wen_buf <= 1'b0; 
        end else begin
            wb_done <= 1'b0;
            // 非load指令可以直接写回
            if(wen && !is_load) begin
                if(waddr != 0) begin
                    reg_write_commit({27'b0, waddr}, wdata);
                    rf[waddr] <= wdata;
                end
                wb_done <= 1'b1;
            end
            // Load指令 → 第一步：缓存写回信息（避免信号失效）
            else if(wen && is_load) begin
                load_waddr_buf <= waddr;  // 缓存写回地址（此时waddr有效）
                load_wen_buf <= 1'b1;     // 缓存写回使能
                 // 此时不写回，因为load_data还没拿到
            end else if(is_branch || is_store) begin
                wb_done <= 1'b1;
            end
            // Load指令 → 第二步：mem_done有效（拿到load_data），触发写回
            else if(mem_done && load_wen_buf) begin
                if(load_waddr_buf != 0) begin
                    reg_write_commit({27'b0, load_waddr_buf}, load_data);
                    rf[load_waddr_buf] <= load_data;  // 用有效load_data写回
                end
                wb_done <= 1'b1;
                load_wen_buf <= 1'b0;  // 写回完成，清空缓存
            end 
            /* // store指令完成
            else if(mem_done) begin
                wb_done <= 1'b1;
            end */
        end
    end

endmodule
