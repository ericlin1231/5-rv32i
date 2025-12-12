module Hazard (
    /* Input */
    /* ID stage signal */
    input  reg_addr_t     rs1_id,
    input  reg_addr_t     rs2_id,
    /* EX stage signal */
    input  reg_addr_t     rs1_ex,
    input  reg_addr_t     rs2_ex,
    input  reg_addr_t     rd_ex,
    input  enable_t       jump_c_ex,
    input  wb_data_sel_t  wb_data_sel_c_ex,
    /* MEM stage signal */
    input  reg_addr_t     rd_mem,
    input  enable_t       reg_write_c_mem,
    /* WB stage signal */
    input  reg_addr_t     rd_wb,
    input  enable_t       reg_write_c_wb,
    /* Output */
    /* stall and flush signal */
    output enable_t       stall_c_if,
    output enable_t       stall_c_if2id,
    output enable_t       flush_c_if2id,
    output enable_t       flush_c_id2ex,
    /* data src selectio in EX stage */
    output alu_data_sel_t alu_rs1_data_sel_c_ex,
    output alu_data_sel_t alu_rs2_data_sel_c_ex
);

    /* forwarding logic */
    always_comb begin
        if (((rs1_ex == rd_mem) & reg_write_c_mem) & rs1_ex != 0) begin
            alu_rs1_data_sel_c_ex = mem_forward;
        end else if (((rs1_ex == rd_wb) & reg_write_c_wb) & rs1_ex != 0) begin
            alu_rs1_data_sel_c_ex = wb_forward;
        end else alu_rs1_data_sel_c_ex = id2ex_buf;

        if (((rs2_ex == rd_mem) & reg_write_c_mem) & rs2_ex != 0) begin
            alu_rs2_data_sel_c_ex = mem_forward;
        end else if (((rs2_ex == rd_wb) & reg_write_c_wb) & rs2_ex != 0) begin
            alu_rs2_data_sel_c_ex = wb_forward;
        end else alu_rs2_data_sel_c_ex = id2ex_buf;
    end

    /* stall and flush logic */
    logic load_stall;
    always_comb begin
        load_stall = wb_data_sel_c_ex[0] & (rd_ex != 0) & ((rs1_id == rd_ex) | (rs2_id == rd_ex));
        stall_c_if = load_stall ? ENABLE : DISABLE;
        stall_c_if2id = load_stall ? ENABLE : DISABLE;
        flush_c_if2id = jump_c_ex ? ENABLE : DISABLE;
        flush_c_id2ex = (jump_c_ex | load_stall) ? ENABLE : DISABLE;
    end

endmodule
