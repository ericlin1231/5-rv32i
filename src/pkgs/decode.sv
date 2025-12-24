package decode;

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
  } opcode_e;

  typedef enum logic [2:0] {
    IMM_I_TYPE = 3'd0,
    IMM_S_TYPE = 3'd1,
    IMM_B_TYPE = 3'd2,
    IMM_U_TYPE = 3'd3,
    IMM_J_TYPE = 3'd4
  } imm_sel_e;

  typedef enum logic [2:0] {
    FUNCT3_LB  = 3'b000,
    FUNCT3_LH  = 3'b001,
    FUNCT3_LW  = 3'b010,
    FUNCT3_LBU = 3'b100,
    FUNCT3_LHU = 3'b101
  } load_funct3_e;

  typedef enum logic [2:0] {
    FUNCT3_SB = 3'b000,
    FUNCT3_SH = 3'b001,
    FUNCT3_SW = 3'b010
  } store_funct3_e;

  typedef enum logic [2:0] {
    FUNCT3_ADDI  = 3'd0,
    FUNCT3_SLLI  = 3'd1,
    FUNCT3_SLTI  = 3'd2,
    FUNCT3_SLTIU = 3'd3,
    FUNCT3_XORI  = 3'd4,
    FUNCT3_SRXI  = 3'd5,  /* SRLI, SRAI */
    FUNCT3_ORI   = 3'd6,
    FUNCT3_ANDI  = 3'd7
  } arithmetic_imm_funct3_e;

  typedef enum logic [2:0] {
    FUNCT3_ADD_SUB = 3'd0,
    FUNCT3_SLL     = 3'd1,
    FUNCT3_SLT     = 3'd2,
    FUNCT3_SLTU    = 3'd3,
    FUNCT3_XOR     = 3'd4,
    FUNCT3_SRX     = 3'd5,  /* SRL, SRA */
    FUNCT3_OR      = 3'd6,
    FUNCT3_AND     = 3'd7
  } arithmetic_reg_funct3_e;

  typedef enum logic [2:0] {
    FUNCT3_BEQ  = 3'b000,
    FUNCT3_BNE  = 3'b001,
    FUNCT3_BLT  = 3'b100,
    FUNCT3_BGE  = 3'b101,
    FUNCT3_BLTU = 3'b110,
    FUNCT3_BGEU = 3'b111
  } branch_funct3_e;

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
    FUNCT7_STD = 7'b0000000,
    FUNCT7_ALT = 7'b0100000
  } arithmetic_funct7_e;

  typedef enum logic [3:0] {
    ADD  = 4'd0,
    SUB  = 4'd1,
    SLL  = 4'd2,
    SRL  = 4'd3,
    SRA  = 4'd4,
    AND  = 4'd5,
    OR   = 4'd6,
    XOR  = 4'd7,
    SLT  = 4'd8,
    SLTU = 4'd9,
    PASS = 4'd10
  } alu_op_e;

  typedef enum logic [2:0] {
    BEQ  = 3'd0,
    BNE  = 3'd1,
    BLT  = 3'd2,
    BGE  = 3'd3,
    BLTU = 3'd4,
    BGEU = 3'd5
  } cmp_op_e;

  typedef enum logic [1:0] {
    id2ex_buf   = 2'd0,
    mem_forward = 2'd1,
    wb_forward  = 2'd2
  } alu_data_sel_e;

  typedef enum logic {
    rs1 = 1'b0,
    pc  = 1'b1
  } alu_src1_sel_e;

  typedef enum logic {
    rs2 = 1'b0,
    imm = 1'b1
  } alu_src2_sel_e;

  typedef enum logic [1:0] {
    alu_result = 2'd0,
    mem_read   = 2'd1,
    pc_next    = 2'd2
  } wb_wdata_sel_e;

  parameter imm_sel_e IMM_SEL_UNKNOWN = imm_sel_e'('0);
  parameter alu_op_e ALU_OP_UNKNOWN = alu_op_e'('0);
  parameter cmp_op_e CMP_OP_UNKNOWN = cmp_op_e'('0);
  parameter alu_data_sel_e ALU_DATA_SEL_UNKNOWN = alu_data_sel_e'('0);
  parameter alu_src1_sel_e ALU_SRC1_SEL_UNKNOWN = alu_src1_sel_e'('0);
  parameter alu_src2_sel_e ALU_SRC2_SEL_UNKNOWN = alu_src2_sel_e'('0);
  parameter wb_wdata_sel_e WB_WDATA_SEL_UNKNOWN = wb_wdata_sel_e'('0);

endpackage
