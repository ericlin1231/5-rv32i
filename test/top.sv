import defs::*;

module top (
    input logic clk,
    input logic rst_n
);

    cpu core_0 (
        .clk  (clk),
        .rst_n(rst_n)
    );

endmodule
