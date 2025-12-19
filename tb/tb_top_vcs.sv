module tb_top_vcs;
  timeunit 1ns; timeprecision 1ps;

  logic clk;
  logic rst_n;

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    rst_n = 1'b0;
    repeat (20) @(posedge clk);
    rst_n = 1'b1;
  end

  top_axi dut (
      .ACLK   (clk),
      .ARESETn(rst_n)
  );

  initial begin
    $fsdbDumpfile("wave.fsdb");
    $fsdbDumpvars(0, dut);
  end

  initial begin
    repeat (200000) @(posedge clk);
    $display("[TB] Timeout reached, finishing.");
    $finish;
  end

endmodule

