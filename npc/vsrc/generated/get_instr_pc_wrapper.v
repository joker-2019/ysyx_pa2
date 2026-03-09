module get_instr_pc_wrapper(
  input        clk,
  input [31:0] trace_pc,
  input [31:0] trace_instr,
  input        instr_done
);
  export "DPI-C" task get_instr_pc;
  task get_instr_pc(
    output bit [31:0] out_pc,
    output bit [31:0] out_instr,
    output bit        out_done
  );
  begin
    out_pc    = trace_pc;
    out_instr = trace_instr;
    out_done  = instr_done;
  end
  endtask
endmodule
