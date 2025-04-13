module ALU(
	input [4:0] btn,
	input [3:0] x,
	input [3:0] y,
	output reg[7:0] HEX0,
	output reg[7:0] HEX1,
	output reg [3:0] LED1,
	output reg [3:0] LED2,
	output reg [3:0] out,
	output reg overflow,
	output reg zero,
	output reg carry
);
	wire [2:0] ALU_sel; //ALU selection sign
        reg signed [4:0] temp;
	
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
			3'b000: begin
				temp = $signed(x) + $signed(y);
				out = temp[3:0];
				overflow = ((x[3] == y[3]) && (out[3] != x[3]));
				carry = (temp[4] == 1'b1);
				zero = (out == 4'b0000);
			end
			3'b001: begin //a - b
				temp = $signed(x) - $signed(y);
				out = temp[3:0];
				overflow = ((x[3] == y[3]) && (out[3] != x[3]));
                                carry = (x < y);
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




/*(
* 
	input [3:0] x,
	input [3:0] y,
	input [2:0] op,
	input en,
	output reg [3:0] LED1,
	output reg [3:0] LED2,
    	output reg zero,
    	output reg overflow,
    	output reg carry,
    	output reg sign,
    	output reg out,
	output reg [3:0] result
	);

	reg [4:0] temp; 
	always @(*) begn
		if(en) begin
        	// 默认赋值
        	result = 4'b0000;
        	carry = 0;
        	overflow = 0;
        	out = 0;
		temp = 5'b00000;  // 为 temp 设置默认值
        	zero = 1'b0;      // 为 zero 设置默认值
		LED1 = x;
		LED2 = y;
		c ase(op)
			3'b000: begin  //a + b
				temp = x + y;
				result = temp[3:0];
				carry = temp[4];
				overflow = (x[3] == y[3]) && (result[3] != x[3]);
			end
			3'b001: begin //a - b
				temp = x - y;
				result = temp[3:0];
				carry = temp[4];
                                overflow = (x[3] == y[3]) && (result[3] != x[3]);
			end
			3'b010: begin // Not A
				result = ~x;
                		carry = 0;
                		overflow = 0;
			end
			3'b011: begin // A and B
				result = x & y;
                		carry = 0;
                		overflow = 0;
			end
			3'b100: begin // A or B
				result = x | y;
				carry = 0;
				overflow = 0;
			end	
			3'b101: begin //A xor B
				result = x ^ y;
				carry = 0;
				overflow = 0;
			end
			3'b110: begin // If A < B
				result = 0;
				out = (x < y) ? 1 : 0;
				carry = 0;
				overflow = 0;
			end
			3'b111: begin // If A == B
				result = 0;
				out = (x == y) ? 1 : 0;
				carry = 0;
				overflow = 0;
			end
			default: begin
                		result = 4'b0000;
                		carry = 0;
                		overflow = 0;
                		out = 0;
            		end
		endcase
		// 判断是否为零
        	zero = (result == 4'b0000) ? 1 : 0;

        	// 符号位设置
        	sign = result[3];
		else begin

	end
endmodule
*/
