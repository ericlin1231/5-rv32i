module WB
  import CPU_profile::*;
  import decode::*;
(
    // input
    input wb_wdata_sel_e            wb_wdata_sel_i,
    input logic          [XLEN-1:0] alu_result_i,
    input logic          [XLEN-1:0] mem_rdata_i,
    input logic          [XLEN-1:0] pc_next_i,

    // output
    output logic [XLEN-1:0] rd_wdata_o
);

  always_comb begin
    unique case (wb_wdata_sel_i)
      alu_result: rd_wdata_o = alu_result_i;
      mem_read:   rd_wdata_o = mem_rdata_i;
      pc_next:    rd_wdata_o = pc_next_i;
      default:    rd_wdata_o = '0;
    endcase
  end

endmodule
