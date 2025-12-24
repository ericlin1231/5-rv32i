module RegFile
  import CPU_profile::*;
(
    input logic ACLK,

    // input
    /********** write data to destination register ***/
    input logic            wen,
    input logic [     4:0] rd_idx,
    input logic [XLEN-1:0] rd_wdata,
    /********** get source register data *************/
    input logic [     4:0] rs1_idx,
    input logic [     4:0] rs2_idx,

    // output
    output logic [XLEN-1:0] rs1_data_o,
    output logic [XLEN-1:0] rs2_data_o
);

  logic [XLEN-1:0] regs[32];
  always_ff @(posedge ACLK) begin
    if (wen & rd_idx != 0) regs[rd_idx] <= rd_wdata;
  end

  always_comb begin
    rs1_data_o = (rs1_idx != 0) ? regs[rs1_idx] : 0;
    rs2_data_o = (rs2_idx != 0) ? regs[rs2_idx] : 0;
  end

endmodule
