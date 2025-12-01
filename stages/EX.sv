import defs::*;

module EX (
    /* Input */
    // data
    input data_t         pc_i,
    input data_t         rs1_data_i,
    input data_t         rs2_data_i,
    input data_t         imm_i,
    // forwarding data
    input data_t         rs1_data_mem_forward_i,
    input data_t         rs2_data_mem_forward_i,
    input data_t         rs1_data_wb_forward_i,
    input data_t         rs2_data_wb_forward_i,
    // control
    input alu_op_t       alu_op_c_i,
    input alu_data_sel_t alu_rs1_data_sel_c_i,
    input alu_data_sel_t alu_rs2_data_sel_c_i,
    input alu_src1_sel_t alu_src1_sel_c_i,
    input alu_src2_sel_t alu_src2_sel_c_i,
    input cmp_op_t       cmp_op_c_i,
    /* Output */
    output data_t        alu_result_o,
    output data_t        pc_target_o,
    output enable_t      branch_taken_o
);

    data_t rs1_data, rs2_data;
    always_comb
    begin
        unique case (alu_rs1_data_sel_c_i)
            id2ex_buf:   rs1_data = rs1_data_i;
            mem_forward: rs1_data = rs1_data_mem_forward_i;
            wb_forward:  rs1_data = rs1_data_wb_forward_i;
            default:     rs1_data = DATA_UNKNOWN;
        endcase
        unique case (alu_rs2_data_sel_c_i)
            id2ex_buf:   rs2_data = rs2_data_i;
            mem_forward: rs2_data = rs2_data_mem_forward_i;
            wb_forward:  rs2_data = rs2_data_wb_forward_i;
            default:     rs2_data = DATA_UNKNOWN;
        endcase
    end

    data_t src1_data;
    always_comb
    begin
        unique case (alu_src1_sel_c_i)
            rs1: src1_data = rs1_data;
            pc : src1_data = pc_i;
            default: src1_data = 0;
        endcase
    end

    data_t src2_data;
    always_comb
    begin
        unique case (alu_src2_sel_c_i)
            rs2: src2_data = rs2_data;
            imm: src2_data = imm_i;
            default: src2_data = 0;
        endcase
    end

    ALU ALU_u (
        .alu_op_i(alu_op_c_i),
        .data1_i(src1_data),
        .data2_i(src2_data),
        .alu_result_o(alu_result_o)
    );

    CMP CMP_u (
        .cmp_op_c_i(cmp_op_c_i),
        .data1_i(src1_data),
        .data2_i(src2_data),
        .branch_taken_o(branch_taken_o)
    );

    always_comb pc_target_o = pc_i + imm_i;

endmodule
