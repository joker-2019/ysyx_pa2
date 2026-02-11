module get_reg_info_wrapper(
  input          clk,
  input [1023:0] rf_flat
);
  export "DPI-C" task get_reg_info;
  task get_reg_info(output bit [31:0] current_reg [0:31]);
    begin
      for(integer i = 0; i < 32; i++) begin
        current_reg[i] = rf_flat[i*32 +: 32];
      end
    end
  endtask
endmodule
