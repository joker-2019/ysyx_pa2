/*module ps2_keyboard(
	input clk,
    	input rst,
	input ps2_clk,
	input ps2_data,
	output [41:0] dig,
	output [7:0] ascii_code,
	output [7:0] scan_code,
	output reg [7:0] key_count
);
	reg key_released;
	reg key_pressed;
	reg [9:0] buffer;        // ps2_data bits
	reg [3:0] count;  // count ps2_data bits
	reg [2:0] ps2_clk_sync;
	always @(posedge clk) begin
		ps2_clk_sync <=  {ps2_clk_sync[1:0],ps2_clk};
	end
	wire sampling = ps2_clk_sync[2] & ~ps2_clk_sync[1];
	assign scan_code = buffer[8:1];
	scan_to_ascii convert (.scan_code(scan_code), .ascii_code(ascii_code));
	always @(posedge clk) begin
		    if (!rst == 0) begin // reset
			 count <= 0;
			 key_released <= 0;
			 key_pressed <= 0;
		 end
		 else begin
			 if (sampling) begin
				if (count == 4'd10) begin 
					if ((buffer[0] == 0) &&  (ps2_data) && (^buffer[9:1])) begin
						$display("receive %x", buffer[8:1];
					       if(buffer[8:1] == 8'hF0) begin
						       key_pressed <= 0;
						       key_released <= 1;
						end else if(key_released) begin
							 buffer[8:1] <= 8'b00000000;
							  key_released <= 0;
						end else if(!key_pressed) begin
							key_pressed <= 1;
							key_count <= key_count + 1;
						end
					end
*/						       
