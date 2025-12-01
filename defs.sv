package defs;

parameter XLEN = 32;
parameter ADDR_WIDTH = 32;
parameter REG_ADDR_WIDTH = 5;

typedef logic [XLEN-1:0]       data_t;
typedef logic [ADDR_WIDTH-1:0] addr_t
typedef logic [6:0]            funct7_t;
typedef logic [2:0]            funct3_t;

typedef enum logic {
    DISABLE = 0,
    ENABLE  = 1
} enable_t;

typedef enum logic [1:0] {
    id2ex_buf   = 2'd0,
    mem_forward = 2'd1,
    wb_forward  = 2'd2,
    UNKNOWN     = 2'dx
} alu_data_sel_t;

typedef enum logic {
    rs1 = 1'b0,
    pc  = 1'b1,
    UNKNOWN = 1'bx
} alu_src1_sel_t;

typedef enum logic {
    rs2 = 1'b0,
    imm = 1'b1,
    UNKNOWN = 1'bx
} alu_src2_sel_t;

typedef enum logic [1:0] {
    alu_result = 2'd0,
    mem_read   = 2'd1,
    pc_next    = 2'd2,
    UNKNOWN    = 2'dx
} wb_data_sel_t;

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
    t6   = 5'd31,
    UNKNOWN = 5'dx
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
    LUI            = 7'b0110111,
    UNKNOWN        = 7'bx
} opcode_t;

typedef enum logic [2:0] {
    IMM_I_TYPE = 3'd0,
    IMM_S_TYPE = 3'd1,
    IMM_B_TYPE = 3'd2,
    IMM_U_TYPE = 3'd3,
    IMM_J_TYPE = 3'd4,
    UNKNOWN = 3'bx
} imm_sel_t;

typedef enum logic [2:0] {
    FUNCT3_LB  = 3'b000,
    FUNCT3_LH  = 3'b001,
    FUNCT3_LW  = 3'b010,
    FUNCT3_LBU = 3'b100,
    FUNCT3_LHU = 3'b101,
    UNKNOWN    = 3'bx
} LOAD_FUNCT3;

typedef enum logic [2:0] {
    FUNCT3_SB = 3'b000,
    FUNCT3_SH = 3'b001,
    FUNCT3_SW = 3'b010,
    UNKNOWN   = 3'bx
} STORE_FUNCT3;

typedef enum logic [2:0] {
    FUNCT3_ADDI_JALR = 3'd0,
    FUNCT3_SLLI      = 3'd1,
    FUNCT3_SLTI      = 3'd2,
    FUNCT3_SLTIU     = 3'd3,
    FUNCT3_XORI      = 3'd4,
    FUNCT3_SRXI      = 3'd5, /* SRLI, SRAI */
    FUNCT3_ORI       = 3'd6,
    FUNCT3_ANDI      = 3'd7,
    UNKNOWN          = 3'dx
} ARITHMETIC_IMM_FUNCT3;

typedef enum logic [2:0] {
    FUNCT3_ADD_SUB = 3'd0,
    FUNCT3_SLL     = 3'd1,
    FUNCT3_SLT     = 3'd2,
    FUNCT3_SLTU    = 3'd3,
    FUNCT3_XOR     = 3'd4,
    FUNCT3_SRX     = 3'd5,   /* SRL, SRA */
    FUNCT3_OR      = 3'd6,
    FUNCT3_AND     = 3'd7,
    UNKNOWN        = 3'dx
} ARITHMETIC_REG_FUNCT3;

typedef enum logic [2:0] {
    FUNCT3_BEQ  = 3'b000,
    FUNCT3_BNE  = 3'b001,
    FUNCT3_BLT  = 3'b100,
    FUNCT3_BGE  = 3'b101,
    FUNCT3_BLTU = 3'b110,
    FUNCT3_BGEU = 3'b111,
    UNKNOWN     = 3'bx
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
    UNKNOWN = 4'dx
} alu_op_t;

typedef enum logic [2:0] {
    BEQ  = 4'd0,
    BNE  = 4'd1,
    BLT  = 4'd2,
    BGE  = 4'd3,
    BLTU = 4'd4,
    BGEU = 4'd5,
    UNKNOWN = 4'dx
} cmp_op_t;

/* UNKNOWN signal definition */
parameter reg_addr_t     REG_UNKNOWN          = '0;
parameter data_t         DATA_UNKNOWN         = '0;

endpackage
