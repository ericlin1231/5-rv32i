module Control (
    /* Input */
    input opcode_t op_i,
    input funct3_t funct3_i,
    input funct7_t funct7_i,
    /* Output */
    output enable_t       reg_write_c_o,
    output enable_t       mem_write_c_o,
    output wb_data_sel_t  wb_data_sel_c_o,
    output enable_t       jump_c_o,
    output enable_t       branch_c_o,
    output alu_op_t       alu_op_c_o,
    output alu_src1_sel_t alu_src1_sel_c_o,
    output alu_src2_sel_t alu_src2_sel_c_o,
    output cmp_op_t       cmp_op_c_o
);
    
    always_comb
    begin
        unique case (op_i)
            LOAD: begin
                reg_write_c_o    = ENABLE;
                mem_write_c_o    = DISABLE;
                wb_data_sel_c_o  = mem_read;
                jump_c_o         = DISABLE;
                branch_c_o       = DISABLE;
                alu_src1_sel_c_o = rs1;
                alu_src2_sel_c_o = imm;
            end
            ARITHMETIC_IMM: begin
                reg_write_c_o    = ENABLE;
                mem_write_c_o    = DISABLE;
                wb_data_sel_c_o  = alu_result;
                jump_c_o         = DISABLE;
                branch_c_o       = DISABLE;
                alu_src1_sel_c_o = rs1;
                alu_src2_sel_c_o = imm;
            end
            ARITHMETIC_REG: begin
                reg_write_c_o    = ENABLE;
                mem_write_c_o    = DISABLE;
                wb_data_sel_c_o  = alu_result;
                jump_c_o         = DISABLE;
                branch_c_o       = DISABLE;
                alu_src1_sel_c_o = rs1;
                alu_src2_sel_c_o = rs2;
            end
            BRANCH: begin
                reg_write_c_o    = DISABLE;
                mem_write_c_o    = DISABLE;
                wb_data_sel_c_o  = WB_DATA_SEL_UNKNOWN;
                jump_c_o         = DISABLE;
                branch_c_o       = ENABLE;
                alu_src1_sel_c_o = rs1;
                alu_src2_sel_c_o = rs2;
            end
            JAL: begin
                reg_write_c_o    = ENABLE;
                mem_write_c_o    = DISABLE;
                wb_data_sel_c_o  = pc_next;
                jump_c_o         = ENABLE;
                branch_c_o       = DISABLE;
                alu_src1_sel_c_o = rs1; /* don't care */
                alu_src2_sel_c_o = imm;
            end
            JALR: begin
                reg_write_c_o    = ENABLE;
                mem_write_c_o    = DISABLE;
                wb_data_sel_c_o  = pc_next;
                jump_c_o         = ENABLE;
                branch_c_o       = DISABLE;
                alu_src1_sel_c_o = rs1;
                alu_src2_sel_c_o = imm;
            end
            LUI: begin
                reg_write_c_o    = ENABLE;
                mem_write_c_o    = DISABLE;
                wb_data_sel_c_o  = alu_result;
                jump_c_o         = DISABLE;
                branch_c_o       = DISABLE;
                alu_src1_sel_c_o = rs1;
                alu_src2_sel_c_o = imm;
            end
            AUIPC: begin
                reg_write_c_o    = ENABLE;
                mem_write_c_o    = DISABLE;
                wb_data_sel_c_o  = alu_result;
                jump_c_o         = DISABLE;
                branch_c_o       = DISABLE;
                alu_src1_sel_c_o = pc;
                alu_src2_sel_c_o = imm;
            end
            default: begin
                reg_write_c_o    = DISABLE;
                mem_write_c_o    = DISABLE;
                wb_data_sel_c_o  = WB_DATA_SEL_UNKNOWN;
                jump_c_o         = DISABLE;
                branch_c_o       = DISABLE;
                alu_src1_sel_c_o = rs1; /* don't care */
                alu_src2_sel_c_o = rs2; /* don't care */
            end
        endcase
    end

    always_comb
    begin
        unique case (op_i)
            LOAD: alu_op_c_o = ADD;
            ARITHMETIC_IMM: begin
                unique case (ARITHMETIC_IMM_FUNCT3'(funct3_i))
                    FUNCT3_ADDI  : alu_op_c_o = ADD;
                    FUNCT3_ANDI  : alu_op_c_o = AND;
                    FUNCT3_ORI   : alu_op_c_o = OR;
                    FUNCT3_XORI  : alu_op_c_o = XOR;
                    FUNCT3_SLLI  : alu_op_c_o = SLL;
                    FUNCT3_SLTI  : alu_op_c_o = SLT;
                    FUNCT3_SLTIU : alu_op_c_o = SLTU;
                    FUNCT3_SRXI: begin
                        unique case (ARITHMETIC_FUNCT7'(funct7_i))
                            FUNCT7_STD: alu_op_c_o = SRL;
                            FUNCT7_ALT: alu_op_c_o = SRA;
                            default: alu_op_c_o = SRL; /* don't care */
                        endcase
                    end
                endcase
            end
            ARITHMETIC_REG: begin
                unique case (ARITHMETIC_REG_FUNCT3'(funct3_i))
                    FUNCT3_ADD_SUB: begin
                        unique case (ARITHMETIC_FUNCT7'(funct7_i))
                            FUNCT7_STD: alu_op_c_o = ADD;
                            FUNCT7_ALT: alu_op_c_o = SUB;
                            default: alu_op_c_o = ADD; /* don't care */
                        endcase
                    end
                    FUNCT3_AND:  alu_op_c_o = AND;
                    FUNCT3_OR:   alu_op_c_o = OR;
                    FUNCT3_XOR:  alu_op_c_o = XOR;
                    FUNCT3_SLL:  alu_op_c_o = SLL;
                    FUNCT3_SLT:  alu_op_c_o = SLT;
                    FUNCT3_SLTU: alu_op_c_o = SLTU;
                    FUNCT3_SRX: begin
                        unique case (ARITHMETIC_FUNCT7'(funct7_i))
                            FUNCT7_STD: alu_op_c_o = SRL;
                            FUNCT7_ALT: alu_op_c_o = SRA;
                            default: alu_op_c_o = SRL; /* don't care */
                        endcase
                    end
                endcase
            end
            BRANCH:  alu_op_c_o = ALU_OP_UNKNOWN;
            JAL:     alu_op_c_o = ADD;
            JALR:    alu_op_c_o = ADD;
            LUI:     alu_op_c_o = PASS;
            AUIPC:   alu_op_c_o = ADD;
            default: alu_op_c_o = ADD; /* don't care */
        endcase
    end

    always_comb
    begin
        if (op_i == BRANCH) begin
            unique case (BRANCH_FUNCT3'(funct3_i))
                FUNCT3_BEQ:  cmp_op_c_o = BEQ;
                FUNCT3_BNE:  cmp_op_c_o = BNE;
                FUNCT3_BLT:  cmp_op_c_o = BLT;
                FUNCT3_BGE:  cmp_op_c_o = BGE;
                FUNCT3_BLTU: cmp_op_c_o = BLTU;
                FUNCT3_BGEU: cmp_op_c_o = BGEU;
                default:     cmp_op_c_o = CMP_OP_UNKNOWN;
            endcase
        end
        else cmp_op_c_o = CMP_OP_UNKNOWN;
    end

endmodule
