module seg_Display(
	input [3:0] key_code,
	output reg[7:0] seg
);
	always@(*) begin
		case(key_code)
			4'b0000: seg = 8'b00000011;	//0
			4'b0001: seg = 8'b10011111;	//1
			4'b0010: seg = 8'b00100101;	//2
			4'b0011: seg = 8'b00001101;    //3
                        4'b0100: seg = 8'b10011001;    //4
                        4'b0101: seg = 8'b01001001;    //5
                        4'b0110: seg = 8'b01000001;    //6
			4'b0111: seg = 8'b00011111;	//7
			4'b1000: seg = 8'b00000001;	//8
			4'b1001: seg = 8'b00001001;	//9
			4'b1010: seg = 8'b00010001;	//A
			4'b1011: seg = 8'b00000001;	//B
			4'b1100: seg = 8'b01100011;	//C
			4'b1101: seg = 8'b00000011;	//D
			4'b1110: seg = 8'b01100001;	//E
			4'b1111: seg = 8'b01110001;	//F
			default: seg = 8'b11111111;	//null
		endcase
	end
endmodule
