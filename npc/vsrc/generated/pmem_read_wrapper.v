module pmem_read_wrapper(
  input  [31:0] addr,
  input  [31:0] len,
  output reg [31:0] data
);
  import "DPI-C" function int pmem_read(input int addr, input int len);
  always @(*) begin
    data = pmem_read(addr, len);
  end
endmodule
