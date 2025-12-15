module MEM2WB (
    /* System */
    input  logic         clk,
    input  enable_t      stall_c_i,
    /* Input */
    // data
    input  reg_addr_t    rd_i,
    input  data_t        alu_result_i,
    input  data_t        pc_next_i,
    input  data_t        mem_read_data_i,
    // control
    input  enable_t      reg_write_c_i,
    input  wb_data_sel_t wb_data_sel_c_i,
    /* Output */
    // data
    output reg_addr_t    rd_o,
    output data_t        alu_result_o,
    output data_t        pc_next_o,
    output data_t        mem_read_data_o,
    // control
    output enable_t      reg_write_c_o,
    output wb_data_sel_t wb_data_sel_c_o
);

    always_ff @(posedge clk) begin
        if (stall_c_i) begin
            rd_o            <= rd_o;
            alu_result_o    <= alu_result_o;
            mem_read_data_o <= mem_read_data_o;
            pc_next_o       <= pc_next_o;
            reg_write_c_o   <= reg_write_c_o;
            wb_data_sel_c_o <= wb_data_sel_c_o;
        end else begin
            rd_o            <= rd_i;
            alu_result_o    <= alu_result_i;
            mem_read_data_o <= mem_read_data_i;
            pc_next_o       <= pc_next_i;
            reg_write_c_o   <= reg_write_c_i;
            wb_data_sel_c_o <= wb_data_sel_c_i;
        end
    end

endmodule
