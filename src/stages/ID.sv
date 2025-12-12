import defs::*;

module ID (
    /* Input */
    input  data_t     instruction_i,
    /* Output
     * op, funct3, funct7 for control unit to determine control signal
     */
    output opcode_t   op_o,
    output reg_addr_t rd_o,
    output funct3_t   funct3_o,
    output funct7_t   funct7_o,
    output reg_addr_t rs1_o,
    output reg_addr_t rs2_o,
    output data_t     imm_o
);

    opcode_t   op;
    reg_addr_t rd;
    funct3_t   funct3;
    reg_addr_t rs1;
    reg_addr_t rs2;
    funct7_t   funct7;
    imm_sel_t  imm_sel_c;
    always_comb begin
        op     = opcode_t'(instruction_i[6:0]);
        rd     = reg_addr_t'(instruction_i[11:7]);
        funct3 = funct3_t'(instruction_i[14:12]);
        rs1    = reg_addr_t'(instruction_i[19:15]);
        rs2    = reg_addr_t'(instruction_i[24:20]);
        funct7 = funct7_t'(instruction_i[31:25]);
        unique case (op)
            LOAD:           imm_sel_c = IMM_I_TYPE;
            STORE:          imm_sel_c = IMM_S_TYPE;
            ARITHMETIC_IMM: imm_sel_c = IMM_I_TYPE;
            ARITHMETIC_REG: imm_sel_c = IMM_UNKNOWN;
            BRANCH:         imm_sel_c = IMM_B_TYPE;
            JAL:            imm_sel_c = IMM_J_TYPE;
            JALR:           imm_sel_c = IMM_I_TYPE;
            AUIPC:          imm_sel_c = IMM_U_TYPE;
            LUI:            imm_sel_c = IMM_U_TYPE;
            default:        imm_sel_c = IMM_UNKNOWN;
        endcase
        unique case (op)
            /* I Type */
            LOAD: begin
                rd_o     = rd;
                funct3_o = funct3;
                rs1_o    = rs1;
                rs2_o    = REG_UNKNOWN;
                funct7_o = FUNCT7_UNKNOWN;
            end
            /* S Type */
            STORE: begin
                rd_o     = REG_UNKNOWN;
                funct3_o = funct3;
                rs1_o    = rs1;
                rs2_o    = rs2;
                funct7_o = FUNCT7_UNKNOWN;
            end
            /* I Type */
            ARITHMETIC_IMM: begin
                rd_o     = rd;
                funct3_o = funct3;
                rs1_o    = rs1;
                rs2_o    = REG_UNKNOWN;
                funct7_o = FUNCT7_UNKNOWN;
            end
            /* R Type */
            ARITHMETIC_REG: begin
                rd_o     = rd;
                funct3_o = funct3;
                rs1_o    = rs1;
                rs2_o    = rs2;
                funct7_o = funct7;
            end
            /* B Type */
            BRANCH: begin
                rd_o     = REG_UNKNOWN;
                funct3_o = funct3;
                rs1_o    = rs1;
                rs2_o    = rs2;
                funct7_o = FUNCT7_UNKNOWN;
            end
            /* J Type */
            JAL: begin
                rd_o     = rd;
                funct3_o = FUNCT3_UNKNOWN;
                rs1_o    = REG_UNKNOWN;
                rs2_o    = REG_UNKNOWN;
                funct7_o = FUNCT7_UNKNOWN;
            end
            /* I Type */
            JALR: begin
                rd_o     = rd;
                funct3_o = funct3;
                rs1_o    = rs1;
                rs2_o    = REG_UNKNOWN;
                funct7_o = FUNCT7_UNKNOWN;
            end
            /* U Type */
            AUIPC: begin
                rd_o     = rd;
                funct3_o = FUNCT3_UNKNOWN;
                rs1_o    = REG_UNKNOWN;
                rs2_o    = REG_UNKNOWN;
                funct7_o = FUNCT7_UNKNOWN;
            end
            /* U Type */
            LUI: begin
                rd_o     = rd;
                funct3_o = FUNCT3_UNKNOWN;
                rs1_o    = REG_UNKNOWN;
                rs2_o    = REG_UNKNOWN;
                funct7_o = FUNCT7_UNKNOWN;
            end
            default: begin
                rd_o     = REG_UNKNOWN;
                funct3_o = FUNCT3_UNKNOWN;
                rs1_o    = REG_UNKNOWN;
                rs2_o    = REG_UNKNOWN;
                funct7_o = FUNCT7_UNKNOWN;
            end
        endcase
        op_o = op;
    end

    ImmGen ImmGen_u (
        .imm_sel_c(imm_sel_c),
        .imm_i    (instruction_i[31:7]),
        .imm_o    (imm_o)
    );

endmodule
