module reg_write_commit_wrapper(
  input        clk,
  input        en,
  input [31:0] addr,
  input [31:0] wdata
);
  import "DPI-C" task reg_write_commit(input int addr, input int wdata);
  always @(posedge clk) begin
    if (en) begin
      reg_write_commit(addr, wdata);
    end
  end
endmodule
