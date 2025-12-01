import defs::*;

module EX #(
    parameter XLEN = 32
) (
    /* Input */
    // data
    input data_t         pc_i,
    input data_t         rs1_data_i,
    input data_t         rs2_data_i,
    input data_t         imm_i,
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
    unique case (alu_rs1_data_sel_c_i)
        id2ex_buf:   rs1_data = rs1_data_i;
        mem_forward: rs1_data = mem_data_forward;
        wb_forward:  rs1_data = wb_data_forward;
        default:     rs1_data = DATA_UNKNOWN;
    endcase
    unique case (alu_rs2_data_sel_c_i)
        id2ex_buf:   rs2_data = rs2_data_i;
        mem_forward: rs2_data = mem_data_forward;
        wb_forward:  rs2_data = wb_data_forward;
        default:     rs2_data = DATA_UNKNOWN;
    endcase

    data_t src1_data;
    always_comb
    begin
        unique case (alu_src1_sel_c_i)
            rs1: src1_data = rs1_data;
            pc : src1_data = pc_i;
            default: src1_data = UNKNOWN;
        endcase
    end

    data_t src2_data;
    always_comb
    begin
        unique case (alu_src2_sel_c_i)
            rs2: src2_data = rs2_data;
            imm: src2_data = imm_i;
            default: src2_data = UNKNOWN;
        endcase
    end

    ALU ALU_u (
        .alu_op(alu_op_c_i),
        .data1_i(src1_data),
        .data2_i(src2_data),
        .alu_result_o(alu_result_o)
    );

    CMP CMP_u (
        .cmp_op_c_i(cmp_op_c_i),
        .data1(src1_data),
        .data2(src2_data),
        .branch_taken_o(branch_taken_o)
    );

    always_comb pc_target_o = pc_i + imm_i;

endmodule
