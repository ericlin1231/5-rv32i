module IF
  import CPU_profile::*;
(
    input  logic ACLK,
    input  logic ARESETn,
    input  logic stall_en,
    input  logic jump_en,
    input  logic imem_rdata_handshake,
    output logic jump_penalty,

    // input
    input inst_t            inst_i,
    input logic  [XLEN-1:0] jump_addr_i,

    // output
    output inst_t            inst_o,
    output logic  [XLEN-1:0] pc_o,
    output logic  [XLEN-1:0] pc_next_o
);
  /* When jump, the pc should hold for next rvalid
   * while this rvalid is from wrong instruction
   */
  logic [1:0] hold_pc_for_next_rvalid;
  localparam IDLE = 2'd0, WAIT = 2'd1, OKAY = 3'd2;
  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) begin
      pc_o <= 32'h00000000;
      hold_pc_for_next_rvalid <= IDLE;
    end else begin
      if (jump_en) begin
        pc_o <= jump_addr_i;
        hold_pc_for_next_rvalid <= WAIT;
      end else if (stall_en) begin
        pc_o <= pc_o;
        hold_pc_for_next_rvalid <= hold_pc_for_next_rvalid;
      end else begin
        if (hold_pc_for_next_rvalid == WAIT) begin
          pc_o <= pc_o;
          hold_pc_for_next_rvalid <= OKAY;
        end else if (hold_pc_for_next_rvalid == OKAY) begin
          pc_o <= pc_o + 32'd4;
          hold_pc_for_next_rvalid <= IDLE;
        end else begin
          pc_o <= pc_o + 32'd4;
          hold_pc_for_next_rvalid <= hold_pc_for_next_rvalid;
        end
      end
    end
  end
  always_comb begin
    inst_o    = inst_i;
    pc_next_o = pc_o + 32'd4;
  end

  assign jump_penalty = hold_pc_for_next_rvalid == IDLE ? 1'b0 : 1'b1;
endmodule
