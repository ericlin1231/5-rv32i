`ifndef CPU_BUFFER_BUS_SVH
`define CPU_BUFFER_BUS_SVH

typedef struct packed {
    data_t instruction;
    data_t pc;
    data_t pc_next;
} if_id_bus_t;

typedef struct packed {
    data_t         pc;
    data_t         rs1_data;
    data_t         rs2_data;
    data_t         imm;
    enable_t       jump_c;
    enable_t       branch_c;
    alu_op_t       alu_op_c;
    alu_src1_sel_t alu_src1_sel_c;
    alu_src2_sel_t alu_src2_sel_c;
    cmp_op_t       cmp_op_c;
    reg_addr_t     rd;
    reg_addr_t     rs1;
    reg_addr_t     rs2;
    enable_t       mem_write_c;
    data_t         pc_next;
    enable_t       reg_write_c;
    wb_data_sel_t  wb_data_sel_c;
} id_ex_bus_t;

typedef struct packed {
    data_t        alu_result;
    enable_t      mem_write_c;
    data_t        mem_write_data;
    reg_addr_t    rd;
    enable_t      reg_write_c;
    wb_data_sel_t wb_data_sel_c;
    data_t        pc_next;
} ex_mem_bus_t;

typedef struct packed {
    reg_addr_t    rd;
    data_t        alu_result;
    data_t        pc_next;
    data_t        mem_read_data;
    enable_t      reg_write_c;
    wb_data_sel_t wb_data_sel_c;
} mem_wb_bus_t;

`endif
