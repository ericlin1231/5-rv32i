package defs;

parameter XLEN = 32;
parameter ADDR_WIDTH = 32;
parameter REG_ADDR_WIDTH = 5;
parameter FUNCT3_WIDTH = 3;
parameter FUNCT7_WIDTH = 7;

typedef logic [XLEN-1:0] data_t;
typedef logic [XLEN-1:0] imm_t;
typedef logic [6:0]      funct7_t;
typedef logic [2:0]      funct3_t;


typedef enum logic {
    DISABLE = 0,
    ENABLE  = 1
} enable_t;

typedef enum logic [1:0] {
    id2ex_buf   = 2'd0,
    mem_forward = 2'd1,
    wb_forward  = 2'd2,
    UNKNOWN     = 2'd3
} alu_data_sel_t;

typedef enum logic [REG_ADDR_WIDTH-1:0] {
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
} reg_addr_t;

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
    IMM_I_TYPE,
    IMM_S_TYPE,
    IMM_B_TYPE,
    IMM_U_TYPE,
    IMM_J_TYPE,
    IMM_UNKNOWN
} imm_sel_t;

typedef enum logic [2:0] {
    FUNCT3_LB  = 3'b000,
    FUNCT3_LH  = 3'b001,
    FUNCT3_LW  = 3'b010,
    FUNCT3_LBU = 3'b100,
    FUNCT3_LHU = 3'b101
} I_LOAD_FUNCT3;

typedef enum logic [2:0] {
    FUNCT3_SB = 3'b000,
    FUNCT3_SH = 3'b001,
    FUNCT3_SW = 3'b010
} S_STORE_FUNCT3;

typedef enum logic [2:0] {
    FUNCT3_ADDI_JALR = 3'd0,
    FUNCT3_SLLI      = 3'd1,
    FUNCT3_SLTI      = 3'd2,
    FUNCT3_SLTIU     = 3'd3,
    FUNCT3_XORI      = 3'd4,
    FUNCT3_SRXI      = 3'd5, /* SRLI, SRAI */
    FUNCT3_ORI       = 3'd6,
    FUNCT3_ANDI      = 3'd7
} I_ARITHMETIC_IMM_FUNCT3;

typedef enum logic [2:0] {
    FUNCT3_ADD_SUB = 3'd0,
    FUNCT3_SLL     = 3'd1,
    FUNCT3_SLT     = 3'd2,
    FUNCT3_SLTU    = 3'd3,
    FUNCT3_XOR     = 3'd4,
    FUNCT3_SRX     = 3'd5, /* SRL, SRA */
    FUNCT3_OR      = 3'd6,
    FUNCT3_AND     = 3'd7
} R_ARITHMETIC_REG_FUNCT3;

typedef enum logic [2:0] {
    FUNCT3_BEQ  = 3'b000,
    FUNCT3_BNE  = 3'b001,
    FUNCT3_BLT  = 3'b100,
    FUNCT3_BGE  = 3'b101,
    FUNCT3_BLTU = 3'b110,
    FUNCT3_BGEU = 3'b111
} B_BRANCH_FUNCT3;

typedef enum logic [6:0] {
    FUNCT7_SXLI = 7'b0000000, /* SLLI, SRLI */
    FUNCT7_SRAI = 7'b0100000
} I_ARITHMETIC_IMM_FUNCT7;

/*
 * Standard
 * ADD, SLL, SLT, SLTU, XOR, SRL, OR, AND
 * 
 * Alternative
 * SUB (Correspond to ADD)
 * SRA (Correspond to SRL)
 */
typedef enum logic [6:0] {
    FUNCT7_STD  = 7'b0000000,
    FUNCT7_ALT  = 7'b0100000
} R_ARITHMETIC_REG_FUNCT7;

/* Unknown Signal Definition */
parameter reg_addr_t     REG_UNKNOWN          = zero;
parameter data_t         DATA_UNKNOWN         = '0;
parameter funct3_t       FUNCT3_UNKNOWN       = '0;
parameter funct7_t       FUNCT7_UNKNOWN       = '0;
parameter alu_data_sel_t ALU_DATA_SEL_UNKNOWN = UNKNOWN;

endpackage
