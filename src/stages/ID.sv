module ID
  import CPU_profile::*;
  import decode::*;
(
    // input
    input inst_t inst_i,

    // output
    output logic [     6:0] funct7_o,
    output logic [     4:0] rs2_idx_o,
    output logic [     4:0] rs1_idx_o,
    output logic [     2:0] funct3_o,
    output logic [     4:0] rd_idx_o,
    output logic [     6:0] opcode_o,
    output logic [XLEN-1:0] imm_o
);

  imm_sel_e imm_sel;

  always_comb begin
    opcode_o = inst_i.opcode;

    unique case (inst_i.opcode)
      LOAD: begin
        funct7_o  = '0;
        rs2_idx_o = '0;
        rs1_idx_o = inst_i.rs1_idx;
        funct3_o  = inst_i.funct3;
        rd_idx_o  = inst_i.rd_idx;
        imm_sel   = IMM_I_TYPE;
      end
      STORE: begin
        funct7_o  = '0;
        rs2_idx_o = inst_i.rs2_idx;
        rs1_idx_o = inst_i.rs1_idx;
        funct3_o  = inst_i.funct3;
        rd_idx_o  = '0;
        imm_sel   = IMM_S_TYPE;
      end
      ARITHMETIC_IMM: begin
        funct7_o  = inst_i.funct7;
        rs2_idx_o = '0;
        rs1_idx_o = inst_i.rs1_idx;
        funct3_o  = inst_i.funct3;
        rd_idx_o  = inst_i.rd_idx;
        imm_sel   = IMM_I_TYPE;
      end
      ARITHMETIC_REG: begin
        funct7_o  = inst_i.funct7;
        rs2_idx_o = inst_i.rs2_idx;
        rs1_idx_o = inst_i.rs1_idx;
        funct3_o  = inst_i.funct3;
        rd_idx_o  = inst_i.rd_idx;
        imm_sel   = IMM_SEL_UNKNOWN;
      end
      BRANCH: begin
        funct7_o  = '0;
        rs2_idx_o = inst_i.rs2_idx;
        rs1_idx_o = inst_i.rs1_idx;
        funct3_o  = inst_i.funct3;
        rd_idx_o  = '0;
        imm_sel   = IMM_B_TYPE;
      end
      JAL: begin
        funct7_o  = '0;
        rs2_idx_o = '0;
        rs1_idx_o = '0;
        funct3_o  = '0;
        rd_idx_o  = inst_i.rd_idx;
        imm_sel   = IMM_J_TYPE;
      end
      JALR: begin
        funct7_o  = '0;
        rs2_idx_o = '0;
        rs1_idx_o = inst_i.rs1_idx;
        funct3_o  = inst_i.funct3;
        rd_idx_o  = inst_i.rd_idx;
        imm_sel   = IMM_I_TYPE;
      end
      AUIPC: begin
        funct7_o  = '0;
        rs2_idx_o = '0;
        rs1_idx_o = '0;
        funct3_o  = '0;
        rd_idx_o  = inst_i.rd_idx;
        imm_sel   = IMM_U_TYPE;
      end
      LUI: begin
        funct7_o  = '0;
        rs2_idx_o = '0;
        rs1_idx_o = '0;
        funct3_o  = '0;
        rd_idx_o  = inst_i.rd_idx;
        imm_sel   = IMM_U_TYPE;
      end
      default: begin
        rd_idx_o  = '0;
        funct3_o  = '0;
        rs1_idx_o = '0;
        rs2_idx_o = '0;
        funct7_o  = '0;
        imm_sel   = IMM_SEL_UNKNOWN;
      end
    endcase
  end

  ImmGen ImmGen_u (
      .imm_sel,
      .imm_i(inst_i[31:7]),
      .imm_o
  );

endmodule
