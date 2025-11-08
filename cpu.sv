import defs::*;

module cpu #(
    parameter XLEN = 32,
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter IMEM_SIZE = 4096,
    parameter DMEM_SIZE = 4096
) (
    input logic clk,
    input logic rst_n
);

  /* Instruction Fetch Stage */
  logic [DATA_WIDTH-1:0] instruction_if2buf;
  logic [ADDR_WIDTH-1:0] pc_if2buf;
  IF #(
      .XLEN(XLEN),
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .IMEM_SIZE(IMEM_SIZE)
  ) IF_stage (
      .clk(clk),
      .rst_n(rst_n),
      .stall_c(0),
      .jump_c(0),
      .jump_addr_i(0),
      .instruction_valid_c(1),
      .instruction_o(instruction_if2buf),
      .pc_o(pc_if2buf)
  );

  /* Instruction Fetch to Instruction Decode Buffer */
  logic [DATA_WIDTH-1:0] instruction_buf2id;
  logic [ADDR_WIDTH-1:0] pc_buf2id;
  IF2ID #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
  ) IF2ID_buffer (
      .clk(clk),
      .stall_c(0),
      .flush_c(0),
      .instruction_i(instruction_if2buf),
      .pc_i(pc_if2buf),
      .instruction_o(instruction_buf2id),
      .pc_o(pc_buf2id)
  );

  /* Instruction Decode Stage */
  logic [ADDR_WIDTH-1:0] pc_id2buf;
  ID #(
      .XLEN(XLEN),
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDHT)
  ) ID_stage (
      .clk(clk),
      .instruction_i(instruction_buf2id),
      .op_o(op_id2buf),
      .rs1_o(rs1_id2buf),
      .rs2_o(rs2_id2buf),
      .funct3_o(funct3_id2buf),
      .funct7_o(funct7_id2buf)
  );

  /* Control Logic */


endmodule
