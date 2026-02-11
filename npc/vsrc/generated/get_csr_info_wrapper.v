module get_csr_info_wrapper(
  input        clk,
  input [31:0] mstatus,
  input [31:0] mepc,
  input [31:0] mcause,
  input [31:0] mtvec,
  input [31:0] mvendorid,
  input [31:0] marchid
);
  export "DPI-C" task get_csr_info;
  task get_csr_info(
    output bit[31:0] out_mstatus,
    output bit[31:0] out_mepc,
    output bit[31:0] out_mcause,
    output bit[31:0] out_mtvec,
    output bit[31:0] out_mvendorid,
    output bit[31:0] out_marchid
  );
  begin
    out_mstatus = mstatus;
    out_mepc = mepc;
    out_mcause = mcause;
    out_mtvec = mtvec;
    out_mvendorid = mvendorid;
    out_marchid = marchid;
    $display("[get_csr_info] called: mtvec=0x%h, mepc=0x%h", out_mtvec, out_mepc);
  end
  endtask
endmodule
