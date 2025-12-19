`ifndef SIGNAL_TYPES_SVH
`define SIGNAL_TYPES_SVH

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

parameter alu_data_sel_e ALU_DATA_SEL_UNKNOWN = alu_data_sel_e'('0);
parameter alu_src1_sel_e ALU_SRC1_SEL_UNKNOWN = alu_src1_sel_e'('0);
parameter alu_src2_sel_e ALU_SRC2_SEL_UNKNOWN = alu_src2_sel_e'('0);
parameter wb_wdata_sel_e WB_WDATA_SEL_UNKNOWN = wb_wdata_sel_e'('0);

`endif
