module LFSR_8bit(
	input clk,
	input reset,
	output [7:0] q,
	output reg[7:0] hex,
	output reg[7:0] hex1
);
	reg [7:0] lfsr; //8 bit 
	always@(posedge clk) begin
		if(reset)
			lfsr = 8'b00000001;
		else begin
			lfsr = {lfsr[6:0], lfsr[7] ^ lfsr[4] ^ lfsr[3] ^ lfsr[0]};
		end
	end
	assign q = lfsr;

	always @(q) begin
		case (q[3:0]) //low 4 bit
			4'b0000: hex = 8'b00000011;	//0
			4'b0001: hex = 8'b10011111;	//1
			4'b0010: hex = 8'b00100101;	//2
			4'b0011: hex = 8'b00001101;     //3
                        4'b0100: hex = 8'b10011001;     //4
                        4'b0101: hex = 8'b01001001;     //5
                        4'b0110: hex = 8'b01000001;     //6
			4'b0111: hex = 8'b00011111;	//7
			4'b1000: hex = 8'b00000001;	//8
			4'b1001: hex = 8'b00001001;	//9
			4'b1010: hex = 8'b00010001;	//A
			4'b1011: hex = 8'b00000001;	//B
			4'b1100: hex = 8'b01100011;	//C
			4'b1101: hex = 8'b00000011;	//D
			4'b1110: hex = 8'b01100001;	//E
			4'b1111: hex = 8'b01110001;	//F
			default: hex = 8'b11111111;	//null
		endcase
		
		case (q[7:4]) //high  
			4'b0000: hex1 = 8'b00000011;	//0
			4'b0001: hex1 = 8'b10011111;	//1
			4'b0010: hex1 = 8'b00100101;	//2
			4'b0011: hex1 = 8'b00001101;     //3
                        4'b0100: hex1 = 8'b10011001;     //4
                        4'b0101: hex1 = 8'b01001001;     //5
                        4'b0110: hex1 = 8'b01000001;     //6
			4'b0111: hex1 = 8'b00011111;	//7
			4'b1000: hex1 = 8'b00000001;	//8
			4'b1001: hex1 = 8'b00001001;	//9
			4'b1010: hex1 = 8'b00010001;	//A
			4'b1011: hex1 = 8'b00000001;	//B
			4'b1100: hex1 = 8'b01100011;	//C
			4'b1101: hex1 = 8'b00000011;	//D
			4'b1110: hex1 = 8'b01100001;	//E
			4'b1111: hex1 = 8'b01110001;	//F
			default: hex1 = 8'b11111111;	//null
		endcase
		
	end

endmodule
