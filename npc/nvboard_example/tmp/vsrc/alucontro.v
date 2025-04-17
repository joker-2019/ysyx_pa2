module alucontro(
	input [4:0] btn,
	output reg [2:0] ALU_sel  // ALU 功能选择
);
	always @(posedge btn[3]or posedge btn[2] or posedge btn[1]
		or posedge btn[0] or posedge btn[4]) begin
		if(btn[4])
			ALU_sel = 3'b000;
		case(btn)
			5'b01000: ALU_sel = ALU_sel+2; //top 
        		5'b00100: ALU_sel = ALU_sel-2; //bottom
        		5'b00010: ALU_sel = ALU_sel+1; //left
        		5'b00001: ALU_sel = ALU_sel-1; //right
			default: ALU_sel = 3'b000;
		endcase
	end
endmodule

