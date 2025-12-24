module tb_top_vcs;
  logic ACLK;
  logic ARESETn;

  initial ACLK = 1'b0;
  always #5 ACLK = ~ACLK;

  initial begin
    ARESETn = 1'b0;
    repeat (20) @(posedge ACLK);
    ARESETn = 1'b1;
  end

  top_axi TOP (
      .ACLK,
      .ARESETn
  );

  initial begin
    $fsdbDumpfile("wave.fsdb");
    $fsdbDumpvars(99, "+all", tb_top_vcs.TOP);
  end

  initial begin
    repeat (200000) @(posedge ACLK);
    $display("[TB] Timeout reached, finishing.");
    $finish;
  end

endmodule

