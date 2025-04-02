module decode38(x, en, y, LED4, HEX0);
	input [7:0] x;
	input en;
	output reg [2:0] y;
	output reg LED4;  // Indicator LED
	output reg [7:0] HEX0; // 7-segment display
	integer i;

	always @(x or en) begin
		if(en) begin
			//初始化
			y = 0;
			LED4 = 0;
			HEX0 = 8'b00000000;
			//高位优先的优先编码器  从最高为开始检测，一旦检测到首个为1的，立刻停止循环，锁定输出
			for( i = 7; i >= 0; i = i-1) 
				if (x[i] == 1) begin 
				       	y = i[2:0];
					LED4 = 1;
					break;
				end
			end
		else begin
			y = 0;
			LED4 = 0;
		end

		case(y)
			3'b000: HEX0 = 8'b00000011; // 0 SEG0A
            		3'b001: HEX0 = 8'b10011111; // 1 SEG0B
            		3'b010: HEX0 = 8'b00100101; // 2 SEG0C
           	 	3'b011: HEX0 = 8'b00001101; // 3 SEG0D
            		3'b100: HEX0 = 8'b10011001; // 4 SEG0E
            		3'b101: HEX0 = 8'b01001001; // 5 SEG0F
            		3'b110: HEX0 = 8'b01000001; // 6 SEG0G
            		3'b111: HEX0 = 8'b00011111; // 7 SEG0P
            		default: HEX0 = 8'b00000000; // Off
		endcase
	end
endmodule


