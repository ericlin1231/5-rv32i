import defs::*;

module EX2MEM (
    /* System */
    input logic clk,
    /* Input */
    data_t        alu_result_i,
    /* MEM stage */
    enable_t      mem_write_c_i,
    data_t        mem_write_data_i,
    /* WB stage */
    reg_addr_t    rd_i,
    enable_t      reg_write_c_i,
    wb_data_sel_t wb_data_sel_c_i,
    data_t        pc_next_i,
    /* Output */
    data_t        alu_result_o,
    /* MEM stage */
    enable_t      mem_write_c_o,
    data_t        mem_write_data_o,
    /* WB stage */
    reg_addr_t    rd_o,
    enable_t      reg_write_c_o,
    wb_data_sel_t wb_data_sel_c_o,
    data_t        pc_next_o,
);

    always_ff @(posedge clk)
    begin
        alu_result_o     = alu_result_i;
        mem_write_c_o    = mem_write_c_i;
        mem_write_data_o = mem_write_data_i;
        rd_o             = rd_i;
        reg_write_c_o    = reg_write_c_i;
        wb_data_sel_c_o  = wb_data_sel_c_i;
        pc_next_o        = pc_next_i;
    end

endmodule
