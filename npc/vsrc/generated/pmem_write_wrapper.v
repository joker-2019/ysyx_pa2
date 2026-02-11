module pmem_write_wrapper(
  input        clk,
  input        en,
  input [31:0] addr,
  input [31:0] len,
  input [31:0] data
);
  import "DPI-C" function void pmem_write(input int addr, input int len, input int data);
  always @(posedge clk) begin
    if (en) begin
      pmem_write(addr, len, data);
    end
  end
endmodule
