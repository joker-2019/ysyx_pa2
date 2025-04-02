module ps2_keyboard(
	input clk,clrn,ps2_clk, ps2_data,
	input nextdata_n, //nextdata_n 信号来读取下一个数据
	output [7:0] data, //输出数据
	output reg ready, //判断队列是否存在数据用于读取
	output reg overflow, //判断队列是否溢出 
	output reg [7:0] key_count, //按键计数
	
	output reg [7:0] keycode,
	output reg [7:0] ascii_code,
	output [15:0] seg_key,
	output [15:0] seg_ascii,
	output [15:0] seg_count
	);

	reg key_down;
	reg key_up;

	// internal signal, for test
	reg [9:0] buffer; // data buffer
	reg [7:0] fifo[7:0];     // data fifo
	reg [2:0] w_ptr,r_ptr;   // fifo write and read pointers
	reg [3:0] count;  // count ps2_data bits
	reg [2:0] ps2_clk_sync; // detect falling edge of ps2_clk
	
	/*在每个系统时钟上升沿，更新 ps2_clk_sync 寄存器，使其包含前两个时钟周期的PS/2时钟值。 这样可以检测PS/2时钟的下降沿。*/
	always @(posedge clk) begin
		ps2_clk_sync = {ps2_clk_sync[1:0],ps2_clk};
	end
	/* sampling 是一个组合逻辑信号，当 ps2_clk_sync[2] 为高电平且ps2_clk_sync[1] 为低电平时，表示检测到PS/2时钟的下降沿。*/
	wire sampling = ps2_clk_sync[2] & ~ps2_clk_sync[1];

	always @(posedge clk) begin
		if (clrn == 1) begin // reset
			count <= 0; w_ptr <= 0; r_ptr <= 0; overflow <= 0; ready<= 0;key_count<=0;
				end
		else begin
			if(ready) begin // read to output next data
				if(nextdata_n == 1'b0) //read next data
				begin
					r_ptr <= r_ptr + 3'b1;
					if(w_ptr==(r_ptr+1'b1)) //检查FIFO是否为空（即 w_ptr 是否等于 r_ptr + 1），如果是，则清除 ready 标志。
						ready <= 1'b0;
				end
			end
			//检测到键盘按键
			if(sampling) begin
				if(count == 4'd10) begin //detect data bit number is 10
                			if ((buffer[0] == 0) &&  // start bit
						(ps2_data) &&	// // stop bit
						(^buffer[9:1])) begin // odd  parity
						assign keycode = buffer[8:1];
						$display("receive %x", buffer[8:1]);
						if (buffer[8:1] == 8'hf0) begin//detect relese keyboard
							key_down <= 0;
							key_up <= 1;
							end
						else if(key_up) begin  // 已标记松开事件
							buffer[8:1] <= 8'b00000000;
							key_up <= 0;
							end
						else if(!key_down) begin  // 新按键按下
							key_down <= 1;
							key_count <= key_count + 1;
							end

						 fifo[w_ptr] <= buffer[8:1];  // kbd scan code
						 w_ptr <= w_ptr+3'b1;
						 ready <= 1'b1;
						 overflow <= overflow | (r_ptr == (w_ptr + 3'b1));
					 	end
					count <= 0; //for next
				end else begin
					buffer[count] <= ps2_data; // store ps2_data
					count <= count + 3'b1;
				end
			end
		end
	end
	 assign data = fifo[r_ptr]; //always set output data
        //ASCLL码转换
	 key_ROM u_key_rom (
		.key_code(keycode),
		.ascill_code(ascii_code)
	);

	//键码显示 低两位显示
	 seg_Display u_seg_key (
		.key_code(keycode[3:0]),
		.seg(seg_key[7:0])
	);
	seg_Display u_seg_key_1(
		.key_code(keycode[7:4]),
		.seg(seg_key[15:8])
	);

	//ASCII码显示 中间两位
        seg_Display u_seg_ascii (
		.key_code(ascii_code[3:0]),
		.seg(seg_ascii[7:0])
	);
	seg_Display u_seg_ascii_1(
		.key_code(ascii_code[7:4]),
		.seg(seg_ascii[15:8])
	);

	//count display
        seg_Display u_seg_count (
		.key_code(key_count[3:0]),
		.seg(seg_count[7:0])
	);
	seg_Display u_seg_count_1(
		.key_code(key_count[7:4]),
		.seg(seg_count[15:8])
	);													              

endmodule
