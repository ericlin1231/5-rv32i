package CPU_buffer_bus;
  import CPU_profile::*;
  import decode::*;

  /********** IF-ID *****************************************/
  typedef struct packed {logic [XLEN-1:0] pc;} if_pass_ex_t;

  typedef struct packed {logic [XLEN-1:0] pc_next;} if_pass_wb_t;

  typedef struct packed {
    inst_t inst;
    if_pass_ex_t ex;
    if_pass_wb_t wb;
  } if_id_bus_t;

  /********** ID-EX ****************************************/
  typedef struct packed {
    logic [XLEN-1:0]     pc;
    logic [XLEN-1:0]     rs1_data;
    logic [XLEN-1:0]     rs2_data;
    logic [XLEN-1:0]     imm;
    logic                jump_en;
    logic                branch_en;
    alu_op_e             alu_op;
    alu_src1_sel_e       alu_src1_sel;
    alu_src2_sel_e       alu_src2_sel;
    cmp_op_e             cmp_op;
    jump_addr_base_sel_e jump_addr_base_sel;
  } ex_signal_t;

  typedef struct packed {
    logic mem_ren;
    logic [3:0] mem_rmask;
    logic mem_wen;
    logic [3:0] mem_wstrb;
  } id_pass_mem_t;

  typedef struct packed {
    logic [4:0] rd_idx;
    logic reg_wen;
    wb_wdata_sel_e wb_wdata_sel;
    logic [XLEN-1:0] pc_next;
  } id_pass_wb_t;

  typedef struct packed {
    logic [4:0]   rs1_idx;
    logic [4:0]   rs2_idx;
    ex_signal_t   ex;
    id_pass_mem_t mem;
    id_pass_wb_t  wb;
  } id_ex_bus_t;

  /********** EX-MEM ***************************************/
  typedef struct packed {
    logic            mem_ren;
    logic [3:0]      mem_rmask;
    logic            mem_wen;
    logic [3:0]      mem_wstrb;
    logic [XLEN-1:0] mem_wdata;
  } mem_signal_t;

  typedef struct packed {
    logic [4:0]      rd_idx;
    logic            reg_wen;
    wb_wdata_sel_e   wb_wdata_sel;
    logic [XLEN-1:0] pc_next;
  } ex_pass_wb_t;

  typedef struct packed {
    logic [XLEN-1:0] alu_result;  /* share with MEM and WB */
    mem_signal_t mem;
    ex_pass_wb_t wb;
  } ex_mem_bus_t;

  /********** MEM-WB ***************************************/
  typedef struct packed {
    /* rmask shift should be remove
     * after convert word width memory
     * to byte width memory
     */
    logic [1:0]      mem_addr_low_2_bit;
    /* currently in my design the data read
     * from DMEM via AXI read transaction
     * will valid when load instruction
     * at WB stage so keep read data mask
     * control signal to WB
     */
    logic [3:0]      mem_rmask;
    logic [4:0]      rd_idx;
    logic            reg_wen;
    wb_wdata_sel_e   wb_wdata_sel;
    logic [XLEN-1:0] alu_result;
    logic [XLEN-1:0] mem_rdata;
    logic [XLEN-1:0] pc_next;
  } mem_wb_bus_t;

  /********** Other ****************************************/
  typedef struct packed {
    logic [6:0] funct7;
    logic [2:0] funct3;
    logic [6:0] opcode;
  } control_t;

endpackage
