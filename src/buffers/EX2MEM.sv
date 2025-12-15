module EX2MEM (
    /* System */
    input  logic         ACLK,
    input  logic         ARESETn,
    input  enable_t      stall_c_i,
    /* Input */
    input  data_t        alu_result_i,
    /* MEM stage */
    input  enable_t      mem_write_c_i,
    input  data_t        mem_write_data_i,
    /* WB stage */
    input  reg_addr_t    rd_i,
    input  enable_t      reg_write_c_i,
    input  wb_data_sel_t wb_data_sel_c_i,
    input  data_t        pc_next_i,
    /* Output */
    output data_t        alu_result_o,
    /* MEM stage */
    output enable_t      mem_write_c_o,
    output data_t        mem_write_data_o,
    /* WB stage */
    output reg_addr_t    rd_o,
    output enable_t      reg_write_c_o,
    output wb_data_sel_t wb_data_sel_c_o,
    output data_t        pc_next_o
);

    always_ff @(posedge ACLK or negedge ARESETn) begin
        if (!ARESETn) begin
            alu_result_o     <= DATA_UNKNOWN;
            mem_write_c_o    <= DISABLE;
            mem_write_data_o <= DATA_UNKNOWN;
            rd_o             <= REG_UNKNOWN;
            reg_write_c_o    <= DISABLE;
            wb_data_sel_c_o  <= WB_DATA_SEL_UNKNOWN;
            pc_next_o        <= DATA_UNKNOWN;
        end
        begin
            if (stall_c_i) begin
                alu_result_o     <= alu_result_o;
                mem_write_c_o    <= mem_write_c_o;
                mem_write_data_o <= mem_write_data_o;
                rd_o             <= rd_o;
                reg_write_c_o    <= reg_write_c_o;
                wb_data_sel_c_o  <= wb_data_sel_c_o;
                pc_next_o        <= pc_next_o;
            end else begin
                alu_result_o     <= alu_result_i;
                mem_write_c_o    <= mem_write_c_i;
                mem_write_data_o <= mem_write_data_i;
                rd_o             <= rd_i;
                reg_write_c_o    <= reg_write_c_i;
                wb_data_sel_c_o  <= wb_data_sel_c_i;
                pc_next_o        <= pc_next_i;
            end
        end
    end

endmodule
