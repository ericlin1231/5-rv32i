package tracer;
  import CPU_profile::*;
  import decode::*;

  typedef struct packed {
    inst_t inst;
    logic [4:0] rd_idx;
    logic [4:0] rs1_idx;
    logic [4:0] rs2_idx;
    logic [XLEN-1:0] pc;
    logic [XLEN-1:0] imm;
    logic [XLEN-1:0] rs1_data;
    logic [XLEN-1:0] rs2_data;
    alu_op_e alu_op;
    logic [XLEN-1:0] alu_result;
  } tracer_bus_t;

  /***** helper ****************************************/
  function automatic string reg_idx2abi(input logic [4:0] idx);
    case (idx)
      5'd0: return "zero";
      5'd1: return "ra";
      5'd2: return "sp";
      5'd3: return "gp";
      5'd4: return "tp";
      // Temporary Registers
      5'd5, 5'd6, 5'd7: return $sformatf("t%0d", idx - 5);
      // Saved Registers
      5'd8, 5'd9: return $sformatf("s%0d", idx - 8);
      // Function Arguments / Return Values
      5'd10, 5'd11, 5'd12, 5'd13, 5'd14, 5'd15, 5'd16, 5'd17: return $sformatf("a%0d", idx - 10);
      // Saved Registers
      5'd18, 5'd19, 5'd20, 5'd21, 5'd22, 5'd23, 5'd24, 5'd25, 5'd26, 5'd27:
      return $sformatf("s%0d", idx - 16);
      // Temporary Registers
      5'd28, 5'd29, 5'd30, 5'd31: return $sformatf("t%0d", idx - 25);
      default: return $sformatf("x%0d", idx);
    endcase
  endfunction

  function automatic string rv32i_disasm(input inst_t inst, input logic [XLEN-1:0] pc);
    logic [6:0] funct7;
    logic [4:0] rs2_idx;
    logic [4:0] rs1_idx;
    logic [2:0] funct3;
    logic [4:0] rd_idx;
    logic [6:0] opcode;

    logic signed [XLEN-1:0] imm_i, imm_s, imm_b, imm_j;
    logic [XLEN-1:0] imm_u;
    logic [11:0] csr;

    string rd_abi, rs1_abi, rs2_abi;
    funct7       = inst.funct7;
    rs2_abi      = reg_idx2abi(inst.rs2_idx);
    rs1_abi      = reg_idx2abi(inst.rs1_idx);
    funct3       = inst.funct3;
    rd_abi       = reg_idx2abi(inst.rd_idx);
    opcode       = inst.opcode;

    csr          = inst[31:20];

    imm_i        = $signed({{20{inst[31]}}, inst[31:20]});
    imm_s        = $signed({{20{inst[31]}}, inst[31:25], inst[11:7]});
    imm_b        = $signed({{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0});
    imm_u        = {inst[31:12], 12'b0};
    imm_j        = $signed({{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0});

    rv32i_disasm = "UNKNOWN INSTRUCTION";
    unique case (opcode)
      // LUI
      7'b0110111: begin
        rv32i_disasm = $sformatf("lui %s, 0x%05x # 0x%08x", rd_abi, imm_u[XLEN-1:12], imm_u);
      end
      // AUIPC
      7'b0010111: begin
        rv32i_disasm = $sformatf("auipc %s, 0x%05x # 0x%08x", rd_abi, imm_u[XLEN-1:12], imm_u);
      end
      // JAL
      7'b1101111: begin
        rv32i_disasm = $sformatf("jal %s, %0d  # 0x%08x", rd_abi, imm_j, pc + imm_j);
      end
      // JALR (I-type)
      7'b1100111: begin
        if (funct3 == 3'b000) begin
          rv32i_disasm = $sformatf("jalr %s, %0d(%s)", rd_abi, imm_i, rs1_abi);
        end
      end
      // BRANCH (B-type)
      7'b1100011: begin
        unique case (funct3)
          3'b000:
          rv32i_disasm =
              $sformatf("beq  %s, %s, %0d  # 0x%08x", rs1_abi, rs2_abi, imm_b, pc + imm_b);
          3'b001:
          rv32i_disasm =
              $sformatf("bne  %s, %s, %0d  # 0x%08x", rs1_abi, rs2_abi, imm_b, pc + imm_b);
          3'b100:
          rv32i_disasm =
              $sformatf("blt  %s, %s, %0d  # 0x%08x", rs1_abi, rs2_abi, imm_b, pc + imm_b);
          3'b101:
          rv32i_disasm =
              $sformatf("bge  %s, %s, %0d  # 0x%08x", rs1_abi, rs2_abi, imm_b, pc + imm_b);
          3'b110:
          rv32i_disasm =
              $sformatf("bltu %s, %s, %0d  # 0x%08x", rs1_abi, rs2_abi, imm_b, pc + imm_b);
          3'b111:
          rv32i_disasm =
              $sformatf("bgeu %s, %s, %0d  # 0x%08x", rs1_abi, rs2_abi, imm_b, pc + imm_b);
          default: ;
        endcase
      end
      // LOAD (I-type)
      7'b0000011: begin
        unique case (funct3)
          3'b000:  rv32i_disasm = $sformatf("lb  %s, %0d(%s)", rd_abi, imm_i, rs1_abi);
          3'b001:  rv32i_disasm = $sformatf("lh  %s, %0d(%s)", rd_abi, imm_i, rs1_abi);
          3'b010:  rv32i_disasm = $sformatf("lw  %s, %0d(%s)", rd_abi, imm_i, rs1_abi);
          3'b100:  rv32i_disasm = $sformatf("lbu %s, %0d(%s)", rd_abi, imm_i, rs1_abi);
          3'b101:  rv32i_disasm = $sformatf("lhu %s, %0d(%s)", rd_abi, imm_i, rs1_abi);
          default: ;
        endcase
      end
      // STORE (S-type)
      7'b0100011: begin
        unique case (funct3)
          3'b000:  rv32i_disasm = $sformatf("sb %s, %0d(%s)", rs2_abi, imm_s, rs1_abi);
          3'b001:  rv32i_disasm = $sformatf("sh %s, %0d(%s)", rs2_abi, imm_s, rs1_abi);
          3'b010:  rv32i_disasm = $sformatf("sw %s, %0d(%s)", rs2_abi, imm_s, rs1_abi);
          default: ;
        endcase
      end
      // OP-IMM (I-type ALU)
      7'b0010011: begin
        unique case (funct3)
          3'b000:  rv32i_disasm = $sformatf("addi  %s, %s, %0d", rd_abi, rs1_abi, imm_i);
          3'b010:  rv32i_disasm = $sformatf("slti  %s, %s, %0d", rd_abi, rs1_abi, imm_i);
          3'b011:  rv32i_disasm = $sformatf("sltiu %s, %s, %0d", rd_abi, rs1_abi, imm_i);
          3'b100:  rv32i_disasm = $sformatf("xori  %s, %s, %0d", rd_abi, rs1_abi, imm_i);
          3'b110:  rv32i_disasm = $sformatf("ori   %s, %s, %0d", rd_abi, rs1_abi, imm_i);
          3'b111:  rv32i_disasm = $sformatf("andi  %s, %s, %0d", rd_abi, rs1_abi, imm_i);
          // shifts: shamt in [24:20]
          3'b001: begin
            if (funct7 == 7'b0000000)
              rv32i_disasm = $sformatf("slli  %s, %s, %0d", rd_abi, rs1_abi, inst[24:20]);
          end
          3'b101: begin
            if (funct7 == 7'b0000000)
              rv32i_disasm = $sformatf("srli  %s, %s, %0d", rd_abi, rs1_abi, inst[24:20]);
            else if (funct7 == 7'b0100000)
              rv32i_disasm = $sformatf("srai  %s, %s, %0d", rd_abi, rs1_abi, inst[24:20]);
          end
          default: ;
        endcase
      end
      // OP (R-type ALU)
      7'b0110011: begin
        unique case (funct3)
          3'b000: begin
            if (funct7 == 7'b0000000)
              rv32i_disasm = $sformatf("add  %s, %s, %s", rd_abi, rs1_abi, rs2_abi);
            else if (funct7 == 7'b0100000)
              rv32i_disasm = $sformatf("sub  %s, %s, %s", rd_abi, rs1_abi, rs2_abi);
          end
          3'b001:
          if (funct7 == 7'b0000000)
            rv32i_disasm = $sformatf("sll  %s, %s, %s", rd_abi, rs1_abi, rs2_abi);
          3'b010:
          if (funct7 == 7'b0000000)
            rv32i_disasm = $sformatf("slt  %s, %s, %s", rd_abi, rs1_abi, rs2_abi);
          3'b011:
          if (funct7 == 7'b0000000)
            rv32i_disasm = $sformatf("sltu %s, %s, %s", rd_abi, rs1_abi, rs2_abi);
          3'b100:
          if (funct7 == 7'b0000000)
            rv32i_disasm = $sformatf("xor  %s, %s, %s", rd_abi, rs1_abi, rs2_abi);
          3'b101: begin
            if (funct7 == 7'b0000000)
              rv32i_disasm = $sformatf("srl  %s, %s, %s", rd_abi, rs1_abi, rs2_abi);
            else if (funct7 == 7'b0100000)
              rv32i_disasm = $sformatf("sra  %s, %s, %s", rd_abi, rs1_abi, rs2_abi);
          end
          3'b110:
          if (funct7 == 7'b0000000)
            rv32i_disasm = $sformatf("or   %s, %s, %s", rd_abi, rs1_abi, rs2_abi);
          3'b111:
          if (funct7 == 7'b0000000)
            rv32i_disasm = $sformatf("and  %s, %s, %s", rd_abi, rs1_abi, rs2_abi);
          default: ;
        endcase
      end
      // FENCE / FENCE.I
      7'b0001111: begin
        if (funct3 == 3'b000) rv32i_disasm = "fence";
        else if (funct3 == 3'b001) rv32i_disasm = "fence.i";
      end
      // SYSTEM (ECALL/EBREAK/CSR) - part of RV32I privileged/system space
      7'b1110011: begin
        unique case (funct3)
          3'b000: begin
            if (inst[31:20] == 12'h000) rv32i_disasm = "ecall";
            else if (inst[31:20] == 12'h001) rv32i_disasm = "ebreak";
            else rv32i_disasm = $sformatf("system 0x%03x", inst[31:20]);
          end
          // CSR reg form
          3'b001:  rv32i_disasm = $sformatf("csrrw  %s, 0x%03x, %s", rd_abi, csr, rs1_abi);
          3'b010:  rv32i_disasm = $sformatf("csrrs  %s, 0x%03x, %s", rd_abi, csr, rs1_abi);
          3'b011:  rv32i_disasm = $sformatf("csrrc  %s, 0x%03x, %s", rd_abi, csr, rs1_abi);
          // CSR imm form (zimm is rs1 field)
          3'b101:  rv32i_disasm = $sformatf("csrrwi %s, 0x%03x, %0d", rd_abi, csr, inst.rs1_idx);
          3'b110:  rv32i_disasm = $sformatf("csrrsi %s, 0x%03x, %0d", rd_abi, csr, inst.rs1_idx);
          3'b111:  rv32i_disasm = $sformatf("csrrci %s, 0x%03x, %0d", rd_abi, csr, inst.rs1_idx);
          default: ;
        endcase
      end
      default: begin
      end
    endcase
  endfunction

endpackage
