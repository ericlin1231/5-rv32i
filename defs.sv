package defs;

typedef enum {
  DISABLE = 0,
  ENABLE  = 1
} enable_c;

typedef enum {
  zero = 5'd0,
  ra   = 5'd1,
  sp   = 5'd2,
  gp   = 5'd3,
  tp   = 5'd4,
  t0   = 5'd5,
  t1   = 5'd6,
  t2   = 5'd7,
  s0   = 5'd8,   /* fp */
  s1   = 5'd9,
  a0   = 5'd10,  /* return value */
  a1   = 5'd11,  /* return value */
  a2   = 5'd12,
  a3   = 5'd13,
  a4   = 5'd14,
  a5   = 5'd15,
  a6   = 5'd16,
  a7   = 5'd17,
  s2   = 5'd18,
  s3   = 5'd19,
  s4   = 5'd20,
  s5   = 5'd21,
  s6   = 5'd22,
  s7   = 5'd23,
  s8   = 5'd24,
  s9   = 5'd25,
  s10  = 5'd26,
  s11  = 5'd27,
  t3   = 5'd28,
  t4   = 5'd29,
  t5   = 5'd30,
  t6   = 5'd31
} regs;

typedef enum {
  LOAD = 7'b0000011,
  STORE = 7'b0100011,
  ARITHMETIC_IMM = 7'b0010011,
  ARITHMETIC_REG = 7'b0110011,
  BRANCH = 7'b1100011,
  JAL = 7'b1101111,
  JALR = 7'b1100111,
  AUIPC = 7'b0010111,
  LUI = 7'b0110111
} opcode;

typedef enum {
  LB  = 3'b000,
  LH  = 3'b001,
  LW  = 3'b010,
  LBU = 3'b100,
  LHU = 3'h101
} I_LOAD_FUNCT3;

typedef enum {
  SB = 3'b000,
  SH = 3'b001,
  SW = 3'b010
} S_STORE_FUNCT3;

typedef enum {
  JALR  = 3'd0,
  ADDI  = 3'd0,
  SLLI  = 3'd1,
  SLTI  = 3'd2,
  SLTIU = 3'd3,
  XORI  = 3'd4,
  SRLI  = 3'd5,
  SRAI  = 3'd5,
  ORI   = 3'd6,
  ANDI  = 3'd7
} I_ARITHMETIC_IMM_FUNCT3;

typedef enum {
  ADD  = 3'd0,
  SUB  = 3'd0,
  SLL  = 3'd1,
  SLT  = 3'd2,
  SLTU = 3'd3,
  XOR  = 3'd4,
  SRL  = 3'd5,
  SRA  = 3'd5,
  OR   = 3'd6,
  AND  = 3'd7
} R_ARITHMETIC_REG_FUNCT3;

typedef enum {
  BEQ  = 3'b000,
  BNE  = 3'b001,
  BLT  = 3'b100,
  BGE  = 3'b101,
  BLTU = 3'b110,
  BGEU = 3'b111
} B_BRANCH_FUNCT3;

typedef enum {
  SLLI = 7'b0000000,
  SRLI = 7'b0000000,
  SRAI = 7'b0100000
} I_ARITHMETIC_IMM_FUNCT7;

typedef enum {
  ADD  = 7'b0000000,
  SUB  = 7'b0100000,
  SLL  = 7'b0000000,
  SLT  = 7'b0000000,
  SLTU = 7'b0000000,
  XOR  = 7'b0000000,
  SRL  = 7'b0000000,
  SRA  = 7'b0100000,
  OR   = 7'b0000000,
  AND  = 7'b0000000
} R_ARITHMETIC_REG_FUNCT7;
