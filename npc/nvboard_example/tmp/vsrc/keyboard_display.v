module keyboard_display(
	input reset,
	input clk,
	input ps2_clk,
	input ps2_data,
	output reg [7:0] keycode,   // 键盘输入的扫码
	output [7:0] ascii_code, //ASCII
	output reg [7:0] key_count,
	output [15:0] seg_key,
	output [15:0] seg_ascii,
	output [15:0] seg_count
	);

	reg key_down;
	reg keyup_flag;

	reg [9:0] buffer;  	// 1. 键盘扫描模块（获取键码）
	reg [3:0] count;      // PS2 数据位
	reg [2:0] ps2_clk_sync; // 计数器用于 PS2 数据位

	always @(posedge clk) begin
		ps2_clk_sync <= {ps2_clk_sync[1:0], ps2_clk};
	end
	wire sampling = ps2_clk_sync[2] & ~ps2_clk_sync[1];
	assign keycode = buffer[8:1];
	key_ROM u_key_rom (
                .key_code(keycode),
                .ascill_code(ascii_code)
        );
	always @(posedge clk) begin
		if (!reset == 0) begin //reset
			count <= 0;
			key_down <= 0;
			keyup_flag <= 0;
                end
		else begin
			if (sampling) begin
				if (count == 4'd10) begin
					if ((buffer[0] == 0)    &&      // 起位
						(ps2_data)      &&      // 停止位
						(^buffer[9:1])) begin   // 奇校验
						//keycode <= buffer[8:1]; // 接收键码
						$display("receive %x", buffer[8:1]);
						if(keycode == 8'hF0) begin //检测到按键松开
							key_down <= 0;
							keyup_flag <= 1;
						end else if(keyup_flag) begin
							buffer[8:1] <= 8'b00000000;
							keyup_flag <= 0;
						end else if(!key_down) begin
							key_down <= 1;
							key_count <= key_count + 1;
						end
					end
					count <= 0;     // 重新计数
					end else begin
						buffer[count] <= ps2_data;  // 存储 PS2 数据
						count <= count + 3'b1;
					end
				end
			end
		end
   	// 键码的显示 (实例化 seg_Display, 用于低两位显示)
	seg_Display u_seg_key (
	        .key_code(keycode[3:0]),
	        .seg(seg_key[7:0])
	    );
	seg_Display u_seg_key_1(
		.key_code(keycode[7:4]),
		.seg(seg_key[15:8])
	);
    	// ASCII 码的显示 (实例化 seg_Display，用于中间两位显示)
	seg_Display u_seg_ascii (
        	.key_code(ascii_code[3:0]),
		.seg(seg_ascii[7:0])
    	);
	seg_Display u_seg_ascii_1(
		.key_code(ascii_code[7:4]),
		.seg(seg_ascii[15:8])
	);
	// count display
	seg_Display u_seg_count (
        	.key_code(key_count[3:0]),
		.seg(seg_count[7:0])
    	);
	seg_Display u_seg_count_1(
		.key_code(key_count[7:4]),
		.seg(seg_count[15:8])
	);

	 
endmodule


