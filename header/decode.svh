`ifndef DECODE_SVH
`define DECODE_SVH

typedef enum logic [6:0] {
    LOAD           = 7'b0000011,
    STORE          = 7'b0100011,
    ARITHMETIC_IMM = 7'b0010011,
    ARITHMETIC_REG = 7'b0110011,
    BRANCH         = 7'b1100011,
    JAL            = 7'b1101111,
    JALR           = 7'b1100111,
    AUIPC          = 7'b0010111,
    LUI            = 7'b0110111
} opcode_t;

typedef enum logic [2:0] {
    IMM_I_TYPE = 3'd0,
    IMM_S_TYPE = 3'd1,
    IMM_B_TYPE = 3'd2,
    IMM_U_TYPE = 3'd3,
    IMM_J_TYPE = 3'd4,
    IMM_UNKNOWN = 3'd7
} imm_sel_t;

typedef enum logic [2:0] {
    FUNCT3_LB  = 3'b000,
    FUNCT3_LH  = 3'b001,
    FUNCT3_LW  = 3'b010,
    FUNCT3_LBU = 3'b100,
    FUNCT3_LHU = 3'b101
} LOAD_FUNCT3;

typedef enum logic [2:0] {
    FUNCT3_SB = 3'b000,
    FUNCT3_SH = 3'b001,
    FUNCT3_SW = 3'b010
} STORE_FUNCT3;

typedef enum logic [2:0] {
    FUNCT3_ADDI  = 3'd0,
    FUNCT3_SLLI  = 3'd1,
    FUNCT3_SLTI  = 3'd2,
    FUNCT3_SLTIU = 3'd3,
    FUNCT3_XORI  = 3'd4,
    FUNCT3_SRXI  = 3'd5, /* SRLI, SRAI */
    FUNCT3_ORI   = 3'd6,
    FUNCT3_ANDI  = 3'd7
} ARITHMETIC_IMM_FUNCT3;

typedef enum logic [2:0] {
    FUNCT3_ADD_SUB = 3'd0,
    FUNCT3_SLL     = 3'd1,
    FUNCT3_SLT     = 3'd2,
    FUNCT3_SLTU    = 3'd3,
    FUNCT3_XOR     = 3'd4,
    FUNCT3_SRX     = 3'd5,   /* SRL, SRA */
    FUNCT3_OR      = 3'd6,
    FUNCT3_AND     = 3'd7
} ARITHMETIC_REG_FUNCT3;

typedef enum logic [2:0] {
    FUNCT3_BEQ  = 3'b000,
    FUNCT3_BNE  = 3'b001,
    FUNCT3_BLT  = 3'b100,
    FUNCT3_BGE  = 3'b101,
    FUNCT3_BLTU = 3'b110,
    FUNCT3_BGEU = 3'b111
} BRANCH_FUNCT3;

/*
 * Standard
 * ADD, SRL, SRLI
 * 
 * Alternative
 * SUB  (Correspond to ADD)
 * SRA  (Correspond to SRL)
 * SRAI (Correspond to SRLI)
 */
typedef enum logic [6:0] {
    FUNCT7_STD  = 7'b0000000,
    FUNCT7_ALT  = 7'b0100000
} ARITHMETIC_FUNCT7;

typedef enum logic [3:0] {
    ADD     = 4'd0,
    SUB     = 4'd1,
    SLL     = 4'd2,
    SRL     = 4'd3,
    SRA     = 4'd4,
    AND     = 4'd5,
    OR      = 4'd6,
    XOR     = 4'd7,
    SLT     = 4'd8,
    SLTU    = 4'd9,
    PASS    = 4'd10,
    ALU_OP_UNKNOWN = 4'd15 /* don't care */
} alu_op_t;

typedef enum logic [2:0] {
    BEQ  = 3'd0,
    BNE  = 3'd1,
    BLT  = 3'd2,
    BGE  = 3'd3,
    BLTU = 3'd4,
    BGEU = 3'd5,
    CMP_OP_UNKNOWN = 3'd7
} cmp_op_t;

`endif
