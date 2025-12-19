module IF (
    input logic ACLK,
    input logic ARESETn,
    input logic stall_en,
    input logic jump_en,

    // input
    input inst_t            inst_i,
    input logic  [XLEN-1:0] jump_addr_i,

    // output
    output inst_t            inst_o,
    output logic  [XLEN-1:0] pc_o,
    output logic  [XLEN-1:0] pc_next_o
);

  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ACLK) pc_o <= 32'h00000000;
    else begin
      if (jump_en) pc_o <= jump_addr_i;
      else if (stall_en) pc_o <= pc_o;
      else pc_o <= pc_o + 32'd4;
    end
  end
  always_comb begin
    inst_o    = inst_i;
    pc_next_o = pc_o + 32'd4;
  end

endmodule
