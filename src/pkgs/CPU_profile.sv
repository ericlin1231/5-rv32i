package CPU_profile;

  parameter int unsigned XLEN = 32;
  parameter int unsigned ADDR_SHIFT = 2;

  parameter int unsigned IMEM_BYTES = 256 * 1024;  /* 256 KiB */
  parameter int unsigned DMEM_BYTES = 256 * 1024;  /* 256 KiB */
  parameter int unsigned IMEM_SIZE = IMEM_BYTES >> ADDR_SHIFT;
  parameter int unsigned DMEM_SIZE = DMEM_BYTES >> ADDR_SHIFT;
  parameter int unsigned MEM_SIZE = IMEM_SIZE + DMEM_SIZE;

  typedef struct packed {
    logic [6:0] funct7;
    logic [4:0] rs2_idx;
    logic [4:0] rs1_idx;
    logic [2:0] funct3;
    logic [4:0] rd_idx;
    logic [6:0] opcode;
  } inst_t;

endpackage
