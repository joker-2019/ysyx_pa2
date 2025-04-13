module ALU(
	input [4:0] btn, //button
	input [3:0] x, //input data
	input [3:0] y, // input data
	output reg[7:0] HEX0,  //digital display
	output reg[7:0] HEX1,  //
	output reg [3:0] LED1, // LED light display
	output reg [3:0] LED2,
	output reg [3:0] out,  //out data
	output reg overflow,   
	output reg zero,
	output reg carry
);
	wire [2:0] ALU_sel; //ALU selection sign
        reg signed [4:0] temp; //Temporary variable
	
	//led and HEX light
	bcd7seg seg0(
		.b(out),
       		.h1(HEX0),
		.h2(HEX1)
	);
	alucontro alcon(
		.btn(btn),
		.ALU_sel(ALU_sel)
	);
	/*wire [2:0] op; //ALU selection sign
	reg [4:0] temp;
	*/
	always @(*) begin
		LED1 = x;
		LED2 = y;
		out = 4'b0000;
		temp = 5'b00000;  // 为 temp 设置默认值
		carry = 1'b0;
		overflow = 1'b0;
		zero = 1'b0;
		case(ALU_sel)
			3'b000: begin // a + b
				temp = $signed(x) + $signed(y);
				out = temp[3:0];
				overflow = ((x[3] == y[3]) && (out[3] != x[3]));
				carry = (temp[4] == 1'b1);
				zero = (out == 4'b0000);
			end
			3'b001: begin //a - b
				temp = $signed(x) - $signed(y);
				out = temp[3:0];
				overflow = ((x[3] != y[3]) && (out[3] != x[3]));
                                carry = (temp[4] == 1'b1);
                                zero = (out == 4'b0000);

			end
			3'b010: out = ~x;
			3'b011: out = x & y;
			3'b100: out = x | y;
			3'b101: out= x ^ y;
			3'b110: out=(x < y) ? 4'b0001:4'b0000;
			3'b111: out=(x == y) ? 4'b0001:4'b0000;
			default: begin
				out = 4'b0000;
				overflow = 1'b0;
				zero = 1'b0;
				carry = 1'b0;
			end
		endcase
	end
endmodule
