module ebreak_trigger_wrapper(
  input clk,
  input en
);
  import "DPI-C" function void ebreak_trigger();
  always @(posedge clk) begin
    if (en) begin
      $display("检测到ebreak, 执行$finish");
      ebreak_trigger();
    end
  end
endmodule
