module Hazard
  import decode::*;
(
    // input
    input logic          [4:0] rs1_idx_id,
    input logic          [4:0] rs2_idx_id,
    input logic          [4:0] rs1_idx_ex,
    input logic          [4:0] rs2_idx_ex,
    input logic          [4:0] rd_idx_ex,
    input logic                jump_en_ex,
    input wb_wdata_sel_e       wb_wdata_sel_ex,
    input logic          [4:0] rd_idx_mem,
    input logic                reg_wen_mem,
    input logic          [4:0] rd_idx_wb,
    input logic                reg_wen_wb,

    // output
    output logic          stall_en_if,
    output logic          stall_en_if2id,
    output logic          flush_en_if2id,
    output logic          flush_en_id2ex,
    output alu_data_sel_e alu_rs1_data_sel_ex,
    output alu_data_sel_e alu_rs2_data_sel_ex
);

  /********** forwarding logic *************************/
  always_comb begin
    if (((rs1_idx_ex == rd_idx_mem) & reg_wen_mem) & rs1_idx_ex != 0) begin
      alu_rs1_data_sel_ex = mem_forward;
    end else if (((rs1_idx_ex == rd_idx_wb) & reg_wen_wb) & rs1_idx_ex != 0) begin
      alu_rs1_data_sel_ex = wb_forward;
    end else alu_rs1_data_sel_ex = id2ex_buf;

    if (((rs2_idx_ex == rd_idx_mem) & reg_wen_mem) & rs2_idx_ex != 0) begin
      alu_rs2_data_sel_ex = mem_forward;
    end else if (((rs2_idx_ex == rd_idx_wb) & reg_wen_wb) & rs2_idx_ex != 0) begin
      alu_rs2_data_sel_ex = wb_forward;
    end else alu_rs2_data_sel_ex = id2ex_buf;
  end

  /********** stall and flush logic ********************/
  logic load_stall;
  always_comb begin
    load_stall    = wb_wdata_sel_ex[0] & (rd_idx_ex != 0) & ((rs1_idx_id == rd_idx_ex) | (rs2_idx_id == rd_idx_ex));
    stall_en_if = load_stall;
    stall_en_if2id = load_stall;
    flush_en_if2id = jump_en_ex;
    flush_en_id2ex = (jump_en_ex | load_stall);
  end

endmodule
