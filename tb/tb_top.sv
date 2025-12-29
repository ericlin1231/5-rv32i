module tb_top;
  import CPU_profile::*;

  logic ACLK;
  logic ARESETn;
  string testcase;
  string mem_file;
  string golden_file;

  int unsigned idx;
  logic [XLEN-1:0] GOLDEN[1024];

  top_axi TOP (
      .ACLK,
      .ARESETn
  );

  /************************************************************/
  /* initialize memory and golden data */
  /************************************************************/
  initial begin
    $display("\n");
    $display("\n");
    $display("---------------------------------------------------");
    $display("initialize memory and golden data");
    $display("---------------------------------------------------");
    if (!$value$plusargs("TESTCASE=%s", testcase))
      $display("unified memory didn't load program file");
    if (testcase != "") begin
      mem_file = $sformatf("prog/sims/%s_sim.hex", testcase);
      golden_file = $sformatf("prog/golden/%s_golden.txt", testcase);
      $display("[%m] load %s to unified memory", mem_file);
      $readmemh(mem_file, TOP.mem0.mem0.mem);
      $display("use %s as golden data", golden_file);
    end
    $display("---------------------------------------------------");
    $display("\n");
    $display("\n");
  end

  /************************************************************/
  /* simulation */
  /************************************************************/
  initial ACLK = 1'b0;
  always #5 ACLK = ~ACLK;
  initial begin
    ARESETn = 1'b0;
    repeat (20) @(posedge ACLK);
    ARESETn = 1'b1;
    repeat (1000000) @(posedge ACLK);
    $display("[TB] Timeout reached, finishing.");
    $finish;
  end

  /************************************************************/
  /* dump waveform */
  /************************************************************/
  initial begin
    $fsdbDumpfile("wave.fsdb");
    $fsdbDumpvars("+all", tb_top.TOP);
  end

  /************************************************************/
  /* verify simulation result */
  /************************************************************/
  final begin
    int fd;
    int file_exist = 1;
    string golden_str;
    int golden_value;
    int error = 0;
    bit [XLEN-1:0] debug_base;

    $display("\n");
    $display("\n");
    $display("---------------------------------------------------");
    $display("%s simulation result report", testcase);
    $display("---------------------------------------------------");

    if (!$value$plusargs("DEBUG_BASE=%h", debug_base))
      $display("should provide debug base address !");

    fd = $fopen(golden_file, "r");
    if (fd) $display("open %s successfully", golden_file);
    else file_exist = 0;

    idx = 0;
    while (!$feof(
        fd
    )) begin
      void'($fscanf(fd, "%h\n", GOLDEN[idx]));
      idx++;
      if (idx == 1024) break;
    end
    $fclose(fd);

    for (idx = 0; idx < 1024; idx++) begin
      if (TOP.mem0.mem0.mem[debug_base[XLEN-1:2]] !== GOLDEN[idx]) begin
        $display("Mismatch at [%08h], mem = 0x%08h, golden = 0x%08h", debug_base,
                 TOP.mem0.mem0.mem[debug_base[XLEN-1:2]], GOLDEN[idx]);
        error++;
      end
      debug_base += 32'd4;
    end

    if (!file_exist) begin
      $display("\n");
      $display("\n");
      $display("        ****************************               ");
      $display("        **                        **       |\__||  ");
      $display("        **  OOPS!!                **      / X,X  | ");
      $display("        **                        **    /_____   | ");
      $display("        **  Simulation Failed!!   **   /^ ^ ^ \\  |");
      $display("        **                        **  |^ ^ ^ ^ |w| ");
      $display("        ****************************   \\m___m__|_|");
      $display("        There is no file: golden/golden.txt        ");
      $display("\n");
    end else if (error) begin
      $display("\n");
      $display("\n");
      $display("        ****************************               ");
      $display("        **                        **       |\__||  ");
      $display("        **  OOPS!!                **      / X,X  | ");
      $display("        **                        **    /_____   | ");
      $display("        **  Simulation Failed!!   **   /^ ^ ^ \\  |");
      $display("        **                        **  |^ ^ ^ ^ |w| ");
      $display("        ****************************   \\m___m__|_|");
      $display("         Totally has %d errors                     ", error);
      $display("\n");
    end else begin
      $display("\n");
      $display("\n");
      $display("        ****************************               ");
      $display("        **                        **       |\__||  ");
      $display("        **  Congratulations !!    **      / O.O  | ");
      $display("        **                        **    /_____   | ");
      $display("        **  Simulation PASS!!     **   /^ ^ ^ \\  |");
      $display("        **                        **  |^ ^ ^ ^ |w| ");
      $display("        ****************************   \\m___m__|_|");
      $display("\n");
    end
    $finish;
  end
endmodule

