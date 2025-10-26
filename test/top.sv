module top #(
    parameter XLEN = 32,
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter IMEM_SIZE = 4096,
    parameter DMEM_SIZE = 4096
) (
    input logic clk,
    input logic rst_n
);

  cpu #(
      .XLEN(XLEN),
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .IMEM_SIZE(IMEM_SIZE),
      .DMEM_SIZE(DMEM_SIZE)
  ) core_0 (
      .clk  (clk),
      .rst_n(rst_n)
  );

endmodule
