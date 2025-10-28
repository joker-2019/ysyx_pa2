module bcd7seg(
	input  [3:0] b,
	output reg [7:0] h1,
	output reg [7:0] h2
);
// detailed implementation ...
	always @(*) begin 
		/*if(b != 4'b0000) begin*/
			case(b)
				4'b0000: begin
			       		h1=8'b00000011;		//0
					h2=8'b00000011;
				end
				4'b0001: begin 
					h1=8'b10011111;               //1
					h2=8'b00000011;
				end
				4'b0010: begin 
					h1=8'b00100101;		//2
					h2=8'b00000011;
                       		end
				4'b0011: begin 
					h1=8'b00001101;	 	//3
					h2=8'b00000011;
                        	end
				4'b0100: begin 
					h1=8'b10011001;		//4
					h2=8'b00000011;
                        	end
				4'b0101: begin 
					h1=8'b01001001;		//5
					h2=8'b00000011;
                        	end
				4'b0110: begin 
					h1=8'b01000001;	//6
					h2=8'b00000011;
                        	end
				4'b0111: begin
			       		h1=8'b00011111;		//7
					h2=8'b00000011;
                        	end
				4'b1000: begin
			       		h1=8'b00000000;		//8
					h2=8'b11111101;		//-
                        	end
				4'b1111: begin 
					h1=8'b10011111;		//-1
					h2=8'b11111101;
                        	end		
				4'b1110: begin
					h1=8'b00100101;		//-2
					h2=8'b11111101;

				end
				4'b1101: begin 
					h1=8'b00001101;		//-3
					h2=8'b11111101;
                        	end
				4'b1100: begin
					h1=8'b10011001;		//-4
					h2=8'b11111101;
                        	end
				4'b1011: begin
					h1=8'b01001001;		//-5
					h2=8'b11111101;		
                        	end
				4'b1010: begin
					h1=8'b01000001;		//-6
					h2=8'b11111101;
				end
				4'b1001: begin
					h1=8'b00011111;		//-7
					h2=8'b11111101;
				end
				default: begin 
					h1=8'b00000000;
			        	h2=8'b00000000;
				end	
			endcase
	end
endmodule
