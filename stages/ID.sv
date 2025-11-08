import defs::*;

module ID #(
    parameter XLEN = 32,
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
    input logic clk,
    input logic rst_n,
    input logic [DATA_WIDTH-1:0] instruction_i,
    output logic [DATA_WIDTH-1:0] rs1_o,
    output logic [DATA_WIDTH-1:0] rs2_o,
    output logic [6:0] funct7_o,
    output logic [2:0] funct3_o
);

  always_comb
  begin

  end

endmodule
