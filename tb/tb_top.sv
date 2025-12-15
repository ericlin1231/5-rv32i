`timescale 1ns / 1ps

module tb_top;

    string vcd_file;

    logic  clk;
    logic  rst_n;

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        rst_n = 1'b0;
        repeat (20) @(posedge clk);
        rst_n = 1'b1;
    end

    top_axi_fixed dut (
        .ACLK   (clk),
        .ARESETn(rst_n)
    );

    initial begin
        if (!$value$plusargs("VCD=%s", vcd_file)) begin
            vcd_file = "wave.vcd";
        end
        $dumpfile(vcd_file);
        $dumpvars(0, tb_top);
    end

    initial begin
        repeat (200000) @(posedge clk);
        $display("[TB] Timeout reached, finishing.");
        $finish;
    end

endmodule

