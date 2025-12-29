module Control
  import decode::*;
(
    // input
    input logic [6:0] funct7_i,
    input logic [2:0] funct3_i,
    input logic [6:0] opcode_i,

    // output
    /********** EX ***********************************/
    output logic                jump_en_o,
    output logic                branch_en_o,
    output alu_op_e             alu_op_o,
    output alu_src1_sel_e       alu_src1_sel_o,
    output alu_src2_sel_e       alu_src2_sel_o,
    output cmp_op_e             cmp_op_o,
    output jump_addr_base_sel_e jump_addr_base_sel_o,
    /********** MEM **********************************/
    output logic                mem_wen_o,
    output logic                mem_ren_o,
    /********** WB ***********************************/
    output logic                reg_wen_o,
    output wb_wdata_sel_e       wb_wdata_sel_o
);

  always_comb begin
    unique case (opcode_i)
      LOAD: begin
        // EX
        jump_en_o            = 1'b0;
        branch_en_o          = 1'b0;
        alu_src1_sel_o       = rs1;
        alu_src2_sel_o       = imm;
        jump_addr_base_sel_o = JUMP_ADDR_BASE_SEL_UNKNOWN;
        // MEM
        mem_ren_o            = 1'b1;
        mem_wen_o            = 1'b0;
        // WB
        reg_wen_o            = 1'b1;
        wb_wdata_sel_o       = mem_read;
      end
      STORE: begin
        // EX
        jump_en_o            = 1'b0;
        branch_en_o          = 1'b0;
        alu_src1_sel_o       = rs1;
        alu_src2_sel_o       = imm;
        jump_addr_base_sel_o = JUMP_ADDR_BASE_SEL_UNKNOWN;
        // MEM
        mem_ren_o            = 1'b0;
        mem_wen_o            = 1'b1;
        // WB
        reg_wen_o            = 1'b0;
        wb_wdata_sel_o       = WB_WDATA_SEL_UNKNOWN;
      end
      ARITHMETIC_IMM: begin
        // EX
        jump_en_o            = 1'b0;
        branch_en_o          = 1'b0;
        alu_src1_sel_o       = rs1;
        alu_src2_sel_o       = imm;
        jump_addr_base_sel_o = JUMP_ADDR_BASE_SEL_UNKNOWN;
        // MEM
        mem_ren_o            = 1'b0;
        mem_wen_o            = 1'b0;
        // WB
        reg_wen_o            = 1'b1;
        wb_wdata_sel_o       = alu_result;
      end
      ARITHMETIC_REG: begin
        // EX
        jump_en_o            = 1'b0;
        branch_en_o          = 1'b0;
        alu_src1_sel_o       = rs1;
        alu_src2_sel_o       = rs2;
        jump_addr_base_sel_o = JUMP_ADDR_BASE_SEL_UNKNOWN;
        // MEM
        mem_ren_o            = 1'b0;
        mem_wen_o            = 1'b0;
        // WB
        reg_wen_o            = 1'b1;
        wb_wdata_sel_o       = alu_result;
      end
      BRANCH: begin
        // EX
        jump_en_o            = 1'b0;
        branch_en_o          = 1'b1;
        alu_src1_sel_o       = rs1;
        alu_src2_sel_o       = rs2;
        jump_addr_base_sel_o = PC;
        // MEM
        mem_ren_o            = 1'b0;
        mem_wen_o            = 1'b0;
        // WB
        reg_wen_o            = 1'b0;
        wb_wdata_sel_o       = WB_WDATA_SEL_UNKNOWN;
      end
      JAL: begin
        // EX
        jump_en_o            = 1'b1;
        branch_en_o          = 1'b0;
        alu_src1_sel_o       = pc;
        alu_src2_sel_o       = imm;
        jump_addr_base_sel_o = PC;
        // MEM
        mem_ren_o            = 1'b0;
        mem_wen_o            = 1'b0;
        // WB
        reg_wen_o            = 1'b1;
        wb_wdata_sel_o       = pc_next;
      end
      JALR: begin
        // EX
        jump_en_o            = 1'b1;
        branch_en_o          = 1'b0;
        alu_src1_sel_o       = rs1;
        alu_src2_sel_o       = imm;
        jump_addr_base_sel_o = RS1;
        // MEM
        mem_ren_o            = 1'b0;
        mem_wen_o            = 1'b0;
        // WB
        reg_wen_o            = 1'b1;
        wb_wdata_sel_o       = pc_next;
      end
      LUI: begin
        // EX
        jump_en_o            = 1'b0;
        branch_en_o          = 1'b0;
        alu_src1_sel_o       = rs1;
        alu_src2_sel_o       = imm;
        jump_addr_base_sel_o = JUMP_ADDR_BASE_SEL_UNKNOWN;
        // MEM
        mem_ren_o            = 1'b0;
        mem_wen_o            = 1'b0;
        // WB
        reg_wen_o            = 1'b1;
        wb_wdata_sel_o       = alu_result;
      end
      AUIPC: begin
        // EX
        jump_en_o            = 1'b0;
        branch_en_o          = 1'b0;
        alu_src1_sel_o       = pc;
        alu_src2_sel_o       = imm;
        jump_addr_base_sel_o = JUMP_ADDR_BASE_SEL_UNKNOWN;
        // MEM
        mem_ren_o            = 1'b0;
        mem_wen_o            = 1'b0;
        // WB
        reg_wen_o            = 1'b1;
        wb_wdata_sel_o       = alu_result;
      end
      default: begin
        // EX
        jump_en_o            = 1'b0;
        branch_en_o          = 1'b0;
        alu_src1_sel_o       = ALU_SRC1_SEL_UNKNOWN;
        alu_src2_sel_o       = ALU_SRC2_SEL_UNKNOWN;
        jump_addr_base_sel_o = JUMP_ADDR_BASE_SEL_UNKNOWN;
        // MEM
        mem_ren_o            = 1'b0;
        mem_wen_o            = 1'b0;
        // WB
        reg_wen_o            = 1'b0;
        wb_wdata_sel_o       = WB_WDATA_SEL_UNKNOWN;
      end
    endcase
  end

  always_comb begin
    unique case (opcode_i)
      LOAD, STORE: alu_op_o = ADD;
      ARITHMETIC_IMM: begin
        unique case (arithmetic_imm_funct3_e'(funct3_i))
          FUNCT3_ADDI:  alu_op_o = ADD;
          FUNCT3_ANDI:  alu_op_o = AND;
          FUNCT3_ORI:   alu_op_o = OR;
          FUNCT3_XORI:  alu_op_o = XOR;
          FUNCT3_SLLI:  alu_op_o = SLL;
          FUNCT3_SLTI:  alu_op_o = SLT;
          FUNCT3_SLTIU: alu_op_o = SLTU;
          FUNCT3_SRXI: begin
            unique case (arithmetic_funct7_e'(funct7_i))
              FUNCT7_STD: alu_op_o = SRL;
              FUNCT7_ALT: alu_op_o = SRA;
              default:    alu_op_o = ALU_OP_UNKNOWN;
            endcase
          end
        endcase
      end
      ARITHMETIC_REG: begin
        unique case (arithmetic_reg_funct3_e'(funct3_i))
          FUNCT3_ADD_SUB: begin
            unique case (arithmetic_funct7_e'(funct7_i))
              FUNCT7_STD: alu_op_o = ADD;
              FUNCT7_ALT: alu_op_o = SUB;
              default:    alu_op_o = ALU_OP_UNKNOWN;
            endcase
          end
          FUNCT3_AND:  alu_op_o = AND;
          FUNCT3_OR:   alu_op_o = OR;
          FUNCT3_XOR:  alu_op_o = XOR;
          FUNCT3_SLL:  alu_op_o = SLL;
          FUNCT3_SLT:  alu_op_o = SLT;
          FUNCT3_SLTU: alu_op_o = SLTU;
          FUNCT3_SRX: begin
            unique case (arithmetic_funct7_e'(funct7_i))
              FUNCT7_STD: alu_op_o = SRL;
              FUNCT7_ALT: alu_op_o = SRA;
              default:    alu_op_o = ALU_OP_UNKNOWN;
            endcase
          end
        endcase
      end
      BRANCH:      alu_op_o = ADD;
      JAL:         alu_op_o = ADD;
      JALR:        alu_op_o = ADD;
      LUI:         alu_op_o = PASS;
      AUIPC:       alu_op_o = ADD;
      default:     alu_op_o = ALU_OP_UNKNOWN;
    endcase
  end

  always_comb begin
    if (opcode_i == BRANCH) begin
      unique case (branch_funct3_e'(funct3_i))
        FUNCT3_BEQ:  cmp_op_o = BEQ;
        FUNCT3_BNE:  cmp_op_o = BNE;
        FUNCT3_BLT:  cmp_op_o = BLT;
        FUNCT3_BGE:  cmp_op_o = BGE;
        FUNCT3_BLTU: cmp_op_o = BLTU;
        FUNCT3_BGEU: cmp_op_o = BGEU;
        default:     cmp_op_o = CMP_OP_UNKNOWN;
      endcase
    end else cmp_op_o = CMP_OP_UNKNOWN;
  end

endmodule
