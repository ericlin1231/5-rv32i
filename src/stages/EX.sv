module EX (
    // input
    input logic          [XLEN-1:0] pc_i,
    input logic          [XLEN-1:0] rs1_data_i,
    input logic          [XLEN-1:0] rs2_data_i,
    input logic          [XLEN-1:0] imm_i,
    /********** data forward from MEM and WB *********/
    input logic          [XLEN-1:0] rs1_data_mem_forward_i,
    input logic          [XLEN-1:0] rs2_data_mem_forward_i,
    input logic          [XLEN-1:0] rs1_data_wb_forward_i,
    input logic          [XLEN-1:0] rs2_data_wb_forward_i,
    /********** Control ******************************/
    input alu_op_e                  alu_op_i,
    input alu_data_sel_e            alu_rs1_data_sel_i,
    input alu_data_sel_e            alu_rs2_data_sel_i,
    input alu_src1_sel_e            alu_src1_sel_i,
    input alu_src2_sel_e            alu_src2_sel_i,
    input cmp_op_e                  cmp_op_i,

    // output
    output logic [XLEN-1:0] alu_result_o,
    output logic [XLEN-1:0] pc_target_o,
    output logic            branch_taken_o
);

  logic [XLEN-1:0] rs1_data, rs2_data;
  always_comb begin
    unique case (alu_rs1_data_sel_i)
      id2ex_buf:   rs1_data = rs1_data_i;
      mem_forward: rs1_data = rs1_data_mem_forward_i;
      wb_forward:  rs1_data = rs1_data_wb_forward_i;
      default:     rs1_data = '0;
    endcase
    unique case (alu_rs2_data_sel_i)
      id2ex_buf:   rs2_data = rs2_data_i;
      mem_forward: rs2_data = rs2_data_mem_forward_i;
      wb_forward:  rs2_data = rs2_data_wb_forward_i;
      default:     rs2_data = '0;
    endcase
  end

  logic [XLEN-1:0] src1_data;
  always_comb begin
    unique case (alu_src1_sel_i)
      rs1:     src1_data = rs1_data;
      pc:      src1_data = pc_i;
      default: src1_data = 0;
    endcase
  end

  logic [XLEN-1:0] src2_data;
  always_comb begin
    unique case (alu_src2_sel_i)
      rs2:     src2_data = rs2_data;
      imm:     src2_data = imm_i;
      default: src2_data = 0;
    endcase
  end

  ALU ALU_u (
      .alu_op_i    (alu_op_i),
      .data1_i     (src1_data),
      .data2_i     (src2_data),
      .alu_result_o(alu_result_o)
  );

  CMP CMP_u (
      .cmp_op_i      (cmp_op_i),
      .data1_i       (src1_data),
      .data2_i       (src2_data),
      .branch_taken_o(branch_taken_o)
  );

  always_comb pc_target_o = pc_i + imm_i;

endmodule
