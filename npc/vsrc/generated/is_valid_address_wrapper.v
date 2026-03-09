module is_valid_address_wrapper(
  input  [31:0] addr,
  output        valid
);
  import "DPI-C" function int is_valid_address(input bit [31:0] addr);
  assign valid = (is_valid_address(addr) != 0);
endmodule
