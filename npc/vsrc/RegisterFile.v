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
    // input mem_done,
    input is_store,
    input [31:0] load_data,

    // 【新增】访存模块输入到写回的信号（核心握手
    input lsu_reqReady,      // 访存→写回：存储器已接收访存请求
    input lsu_respValid,     // 访存→写回：存储器回复有效（数据就绪）

    output reg lsu_respReady   // 写回→访存：处理器已消费数据（反馈完成）

);
    reg [31:0] rf [0:31];
    reg [4:0] load_waddr_buf;
    reg load_wen_buf;
    reg is_store_latch;

    export "DPI-C" task get_reg_info;
    import "DPI-C" task reg_write_commit(input int addr, input int wdata);

    // 模拟CPU忙碌的随机延迟
	parameter RESP_READY_RAND_DELAY = 2;  // respReady延迟1~2拍
	reg [7:0] wb_resp_ready_cnt;

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
            lsu_respReady <= 1'b0; 
            wb_resp_ready_cnt <= 8'b0;
            is_store_latch <= 1'b0;
        end else begin
            wb_done <= 1'b0;
            lsu_respReady <= 1'b0; // 非Load场景默认就绪
            // 非load指令可以直接写回
            if(wen && !is_load) begin
                if(waddr != 0) begin
                    reg_write_commit({27'b0, waddr}, wdata);
                    rf[waddr] <= wdata;
                end
                wb_done <= 1'b1;
            end
            // 分支指令无写回, 可以直接更新pc
            else if(is_branch) begin
                wb_done <= 1'b1;
            end
            // Load指令 → 第一步：缓存写回信息（避免信号失效）
            else if(wen && is_load) begin  // 此时不写回，因为load_data还没拿到
                load_waddr_buf <= waddr;  // 缓存写回地址（此时waddr有效）
                load_wen_buf <= 1'b1;     // 缓存写回使能
                wb_resp_ready_cnt <= RESP_READY_RAND_DELAY-1; //初始化忙碌信号
            end else if(is_store) begin
                // 锁存有访存信号
                is_store_latch <= 1'b1;
                wb_resp_ready_cnt <= RESP_READY_RAND_DELAY-1; //初始化忙碌信号     
            end
            else if(is_store_latch && lsu_reqReady) begin
                if(wb_resp_ready_cnt > 0) begin
                    wb_resp_ready_cnt <= wb_resp_ready_cnt - 1;
                end else begin
                    if(lsu_respValid) begin
                        lsu_respReady <= 1'b1;
                        wb_done <= 1'b1;
                        is_store_latch <= 1'b0;
                    end
                end
            end
            // Load指令 → 第二步：mem_done有效（拿到load_data），触发写回
            else if(load_wen_buf) begin // 仅当有load缓存时才处理计数器，避免无意义递减
                if(wb_resp_ready_cnt > 0) begin
                    wb_resp_ready_cnt <= wb_resp_ready_cnt - 1;
                    lsu_respReady <= 1'b0;
                end else begin
                    if(lsu_respValid) begin
                        lsu_respReady <= 1'b1;
                        if(load_waddr_buf != 0) begin
                            reg_write_commit({27'b0, load_waddr_buf}, load_data);
                            rf[load_waddr_buf] <= load_data;  // 用有效load_data写回
                        end
                        wb_done <= 1'b1;
                        load_wen_buf <= 1'b0;  // 写回完成，清空缓存
                    end
                end
            end
        end
    end

endmodule
