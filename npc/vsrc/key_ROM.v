module key_ROM(
	input [7:0] key_code,
	output reg [7:0] ascill_code
);
	always@(*) begin
		case(key_code)
			8'h1C: ascill_code = 8'h41; //A 
			8'h32: ascill_code = 8'h42; //B
			8'h21: ascill_code = 8'h43; //C
			8'h23: ascill_code = 8'h44; //D
			8'h24: ascill_code = 8'h45; //E
			8'h2B: ascill_code = 8'h46; //F
			8'h34: ascill_code = 8'h47; //G
			8'h33: ascill_code = 8'h48; //H
			8'h43: ascill_code = 8'h49; //I
			8'h3B: ascill_code = 8'h4A; //J
			8'H42: ascill_code = 8'h4B; //K
			8'h4B: ascill_code = 8'h4C; //L
			8'h3A: ascill_code = 8'h4D; //M
			8'h31: ascill_code = 8'h4E; //N
			8'h44: ascill_code = 8'h4F; //O
			8'h4D: ascill_code = 8'h50; //P
			8'h15: ascill_code = 8'h51; //Q
			8'h2D: ascill_code = 8'h52; //R
			8'h1B: ascill_code = 8'h53; //S
			8'h2C: ascill_code = 8'h54; //T
			8'h3C: ascill_code = 8'h55; //U
			8'h2A: ascill_code = 8'h56; //V
			8'h1D: ascill_code = 8'h57; //W
			8'h22: ascill_code = 8'h58; //X
			8'h35: ascill_code = 8'h59; //Y
			8'h1A: ascill_code = 8'h5A; //Z
			//number
			8'h45: ascill_code = 8'h30; //0
			8'h16: ascill_code = 8'h31; //1
			8'h1E: ascill_code = 8'h32; //2
			8'h26: ascill_code = 8'h33; //3
			8'h25: ascill_code = 8'h34; //4
			8'h2E: ascill_code = 8'h35; //5
			8'h36: ascill_code = 8'h36; //6
			8'h3D: ascill_code = 8'h37; //7
			8'h3E: ascill_code = 8'h38; //8
			8'h46: ascill_code = 8'h39; //9
			default: ascill_code = 8'h00;
		endcase
	end
endmodule
