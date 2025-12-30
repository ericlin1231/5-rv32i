module WB
  import CPU_profile::*;
  import decode::*;
(
    // input
    input wb_wdata_sel_e            wb_wdata_sel_i,
    input logic          [XLEN-1:0] alu_result_i,
    input logic          [     1:0] mem_rmask_shift_i,
    input logic          [     3:0] mem_rmask_i,
    input logic          [XLEN-1:0] mem_rdata_i,
    input logic          [XLEN-1:0] pc_next_i,

    // output
    output logic [XLEN-1:0] rd_wdata_o
);
  logic [XLEN-1:0] rmask;
  assign rmask = {
    {8{mem_rmask_i[3]}}, {8{mem_rmask_i[2]}}, {8{mem_rmask_i[1]}}, {8{mem_rmask_i[0]}}
  };
  always_comb begin
    unique case (wb_wdata_sel_i)
      alu_result: rd_wdata_o = alu_result_i;
      mem_read:   rd_wdata_o = mem_rdata_i & (rmask << (mem_rmask_shift_i * 8));
      pc_next:    rd_wdata_o = pc_next_i;
      default:    rd_wdata_o = '0;
    endcase
  end

endmodule
