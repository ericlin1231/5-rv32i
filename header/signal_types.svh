`ifndef SIGNAL_TYPES_SVH
`define SIGNAL_TYPES_SVH

typedef logic [XLEN-1:0]       data_t;
typedef logic [ADDR_WIDTH-1:0] addr_t;
typedef logic [6:0]            funct7_t;
typedef logic [2:0]            funct3_t;

/* UNKNOWN signal definition */
parameter data_t     DATA_UNKNOWN   = 32'd0;
parameter funct7_t   FUNCT7_UNKNOWN = 7'd0;
parameter funct3_t   FUNCT3_UNKNOWN = 3'd0;

typedef enum logic {
    DISABLE = 0,
    ENABLE  = 1
} enable_t;

typedef enum logic [1:0] {
    id2ex_buf   = 2'd0,
    mem_forward = 2'd1,
    wb_forward  = 2'd2,
    ALU_DATA_SEL_UNKNOWN = 2'd3
} alu_data_sel_t;

typedef enum logic {
    rs1 = 1'b0,
    pc  = 1'b1
} alu_src1_sel_t;

typedef enum logic {
    rs2 = 1'b0,
    imm = 1'b1
} alu_src2_sel_t;

typedef enum logic [1:0] {
    alu_result = 2'd0,
    mem_read   = 2'd1,
    pc_next    = 2'd2,
    WB_DATA_SEL_UNKNOWN = 2'd3
} wb_data_sel_t;

`endif
