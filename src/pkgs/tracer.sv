package tracer;
  import CPU_profile::*;

  typedef struct {string asm;} tracer_bus_t;

  /***** helper ****************************************/
  function automatic string xreg_str(input logic [4:0] idx);
    case (idx)
      5'd0: return "zero";
      5'd1: return "ra";
      5'd2: return "sp";
      5'd3: return "gp";
      5'd4: return "tp";

      // temporaries
      5'd5: return "t0";
      5'd6: return "t1";
      5'd7: return "t2";

      // saved
      5'd8: return "s0";
      5'd9: return "s1";

      // arguments
      5'd10: return "a0";
      5'd11: return "a1";
      5'd12: return "a2";
      5'd13: return "a3";
      5'd14: return "a4";
      5'd15: return "a5";
      5'd16: return "a6";
      5'd17: return "a7";

      // saved
      5'd18: return "s2";
      5'd19: return "s3";
      5'd20: return "s4";
      5'd21: return "s5";
      5'd22: return "s6";
      5'd23: return "s7";
      5'd24: return "s8";
      5'd25: return "s9";
      5'd26: return "s10";
      5'd27: return "s11";

      // temporaries
      5'd28: return "t3";
      5'd29: return "t4";
      5'd30: return "t5";
      5'd31: return "t6";

      default: return $sformatf("x%0d", idx);
    endcase
  endfunction

  function automatic int signed sign_ext(input logic [31:0] val, input int width);
    logic sign;
    sign = val[width-1];
    sign_ext = $signed({{(32 - width) {sign}}, val[width-1:0]});
  endfunction

  function automatic int signed imm_i(input inst_t inst);
    imm_i = sign_ext({20'b0, inst[31:20]}, 12);
  endfunction

  function automatic int signed imm_s(input inst_t inst);
    imm_s = sign_ext({20'b0, inst[31:25], inst[11:7]}, 12);
  endfunction

  function automatic int signed imm_b(input inst_t inst);
    logic [12:0] raw;
    raw   = {inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
    imm_b = sign_ext({19'b0, raw}, 13);
  endfunction

  function automatic int signed imm_j(input inst_t inst);
    logic [20:0] raw;
    raw   = {inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
    imm_j = sign_ext({11'b0, raw}, 21);
  endfunction

  function automatic logic [31:0] imm_u(input inst_t inst);
    imm_u = {inst[31:12], 12'b0};
  endfunction

  function automatic string fence_bits_to_str(input logic [3:0] bits);
    string desc;
    desc = "";
    if (bits[3]) desc = {desc, "i"};
    if (bits[2]) desc = {desc, "o"};
    if (bits[1]) desc = {desc, "r"};
    if (bits[0]) desc = {desc, "w"};
    return desc;
  endfunction

  function automatic string rv32i_disasm_fn(input inst_t inst, input logic [31:0] pc);
    string s;

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [4:0] rd, rs1, rs2;

    int signed i_imm, s_imm, b_imm, j_imm;
    logic [31:0] u_imm;

    logic [31:0] target;

    opcode = inst[6:0];
    funct3 = inst[14:12];
    funct7 = inst[31:25];
    rd     = inst[11:7];
    rs1    = inst[19:15];
    rs2    = inst[24:20];

    i_imm  = imm_i(inst);
    s_imm  = imm_s(inst);
    b_imm  = imm_b(inst);
    j_imm  = imm_j(inst);
    u_imm  = imm_u(inst);


    s      = "INVALID";

    unique case (opcode)

      // LUI
      7'b0110111: begin
        s = $sformatf("lui\t%0s,0x%0x", xreg_str(rd), u_imm[31:12]);
      end

      // AUIPC
      7'b0010111: begin
        s = $sformatf("auipc\t%0s,0x%0x", xreg_str(rd), u_imm[31:12]);
      end

      // JAL
      7'b1101111: begin
        target = pc + logic'(j_imm);
        s = $sformatf("jal\t%0s,%0x", xreg_str(rd), target);
      end

      // JALR
      7'b1100111: begin
        if (funct3 == 3'b000) begin
          // Keep ibex_tracer style: "jalr\txd,imm(xs1)"
          s = $sformatf("jalr\t%0s,%0d(%0s)", xreg_str(rd), i_imm, xreg_str(rs1));
        end else begin
          s = "INVALID";
        end
      end

      // BRANCH
      7'b1100011: begin
        target = pc + logic'(b_imm);
        unique case (funct3)
          3'b000:  s = $sformatf("beq\t%0s,%0s,%0x", xreg_str(rs1), xreg_str(rs2), target);
          3'b001:  s = $sformatf("bne\t%0s,%0s,%0x", xreg_str(rs1), xreg_str(rs2), target);
          3'b100:  s = $sformatf("blt\t%0s,%0s,%0x", xreg_str(rs1), xreg_str(rs2), target);
          3'b101:  s = $sformatf("bge\t%0s,%0s,%0x", xreg_str(rs1), xreg_str(rs2), target);
          3'b110:  s = $sformatf("bltu\t%0s,%0s,%0x", xreg_str(rs1), xreg_str(rs2), target);
          3'b111:  s = $sformatf("bgeu\t%0s,%0s,%0x", xreg_str(rs1), xreg_str(rs2), target);
          default: s = "INVALID";
        endcase
      end

      // LOAD
      7'b0000011: begin
        unique case (funct3)
          3'b000:  s = $sformatf("lb\t%0s,%0d(%0s)", xreg_str(rd), i_imm, xreg_str(rs1));
          3'b001:  s = $sformatf("lh\t%0s,%0d(%0s)", xreg_str(rd), i_imm, xreg_str(rs1));
          3'b010:  s = $sformatf("lw\t%0s,%0d(%0s)", xreg_str(rd), i_imm, xreg_str(rs1));
          3'b100:  s = $sformatf("lbu\t%0s,%0d(%0s)", xreg_str(rd), i_imm, xreg_str(rs1));
          3'b101:  s = $sformatf("lhu\t%0s,%0d(%0s)", xreg_str(rd), i_imm, xreg_str(rs1));
          default: s = "INVALID";
        endcase
      end

      // STORE
      7'b0100011: begin
        unique case (funct3)
          3'b000:  s = $sformatf("sb\t%0s,%0d(%0s)", xreg_str(rs2), s_imm, xreg_str(rs1));
          3'b001:  s = $sformatf("sh\t%0s,%0d(%0s)", xreg_str(rs2), s_imm, xreg_str(rs1));
          3'b010:  s = $sformatf("sw\t%0s,%0d(%0s)", xreg_str(rs2), s_imm, xreg_str(rs1));
          default: s = "INVALID";
        endcase
      end

      // OP-IMM
      7'b0010011: begin
        unique case (funct3)
          3'b000: s = $sformatf("addi\t%0s,%0s,%0d", xreg_str(rd), xreg_str(rs1), i_imm);
          3'b010: s = $sformatf("slti\t%0s,%0s,%0d", xreg_str(rd), xreg_str(rs1), i_imm);
          3'b011: s = $sformatf("sltiu\t%0s,%0s,%0d", xreg_str(rd), xreg_str(rs1), i_imm);
          3'b100: s = $sformatf("xori\t%0s,%0s,%0d", xreg_str(rd), xreg_str(rs1), i_imm);
          3'b110: s = $sformatf("ori\t%0s,%0s,%0d", xreg_str(rd), xreg_str(rs1), i_imm);
          3'b111: s = $sformatf("andi\t%0s,%0s,%0d", xreg_str(rd), xreg_str(rs1), i_imm);

          3'b001: begin
            // SLLI: funct7 must be 0000000
            if (funct7 == 7'b0000000) begin
              s = $sformatf("slli\t%0s,%0s,0x%0x", xreg_str(rd), xreg_str(rs1), rs2);
            end else begin
              s = "INVALID";
            end
          end

          3'b101: begin
            // SRLI/SRAI: funct7 0000000 / 0100000
            if (funct7 == 7'b0000000) begin
              s = $sformatf("srli\t%0s,%0s,0x%0x", xreg_str(rd), xreg_str(rs1), rs2);
            end else if (funct7 == 7'b0100000) begin
              s = $sformatf("srai\t%0s,%0s,0x%0x", xreg_str(rd), xreg_str(rs1), rs2);
            end else begin
              s = "INVALID";
            end
          end

          default: s = "INVALID";
        endcase
      end

      // OP
      7'b0110011: begin
        unique case (funct3)
          3'b000: begin
            if (funct7 == 7'b0000000)
              s = $sformatf("add\t%0s,%0s,%0s", xreg_str(rd), xreg_str(rs1), xreg_str(rs2));
            else if (funct7 == 7'b0100000)
              s = $sformatf("sub\t%0s,%0s,%0s", xreg_str(rd), xreg_str(rs1), xreg_str(rs2));
            else s = "INVALID";
          end
          3'b001: begin
            if (funct7 == 7'b0000000)
              s = $sformatf("sll\t%0s,%0s,%0s", xreg_str(rd), xreg_str(rs1), xreg_str(rs2));
            else s = "INVALID";
          end
          3'b010: begin
            if (funct7 == 7'b0000000)
              s = $sformatf("slt\t%0s,%0s,%0s", xreg_str(rd), xreg_str(rs1), xreg_str(rs2));
            else s = "INVALID";
          end
          3'b011: begin
            if (funct7 == 7'b0000000)
              s = $sformatf("sltu\t%0s,%0s,%0s", xreg_str(rd), xreg_str(rs1), xreg_str(rs2));
            else s = "INVALID";
          end
          3'b100: begin
            if (funct7 == 7'b0000000)
              s = $sformatf("xor\t%0s,%0s,%0s", xreg_str(rd), xreg_str(rs1), xreg_str(rs2));
            else s = "INVALID";
          end
          3'b101: begin
            if (funct7 == 7'b0000000)
              s = $sformatf("srl\t%0s,%0s,%0s", xreg_str(rd), xreg_str(rs1), xreg_str(rs2));
            else if (funct7 == 7'b0100000)
              s = $sformatf("sra\t%0s,%0s,%0s", xreg_str(rd), xreg_str(rs1), xreg_str(rs2));
            else s = "INVALID";
          end
          3'b110: begin
            if (funct7 == 7'b0000000)
              s = $sformatf("or\t%0s,%0s,%0s", xreg_str(rd), xreg_str(rs1), xreg_str(rs2));
            else s = "INVALID";
          end
          3'b111: begin
            if (funct7 == 7'b0000000)
              s = $sformatf("and\t%0s,%0s,%0s", xreg_str(rd), xreg_str(rs1), xreg_str(rs2));
            else s = "INVALID";
          end
          default: s = "INVALID";
        endcase
      end

      // MISC-MEM: FENCE / FENCE.I (RV32I base includes these)
      7'b0001111: begin
        // FENCE: funct3=000; FENCE.I: funct3=001
        if (funct3 == 3'b000) begin
          string pred, succ;
          pred = fence_bits_to_str(inst[27:24]);
          succ = fence_bits_to_str(inst[23:20]);
          s = $sformatf("fence\t%s,%s", pred, succ);
        end else if (funct3 == 3'b001) begin
          s = "fence.i";
        end else begin
          s = "INVALID";
        end
      end

      // SYSTEM: in RV32I base we keep ECALL/EBREAK only (no CSR here)
      7'b1110011: begin
        // ECALL = 0x00000073, EBREAK = 0x00100073
        if (inst == 32'h0000_0073) s = "ecall";
        else if (inst == 32'h0010_0073) s = "ebreak";
        else s = "INVALID";
      end

      default: begin
        s = "INVALID";
      end
    endcase

    return s;
  endfunction

  /********** disassemble wrapper **********************/
  task automatic rv32i_disasm(input inst_t inst, input logic [31:0] pc, output string asm_str);
    asm_str = rv32i_disasm_fn(inst, pc);
  endtask

endpackage
