module WB (
    /* Input */
    input  wb_data_sel_t wb_data_sel_c_i,
    input  data_t        alu_result_i,
    input  data_t        mem_read_data_i,
    input  data_t        pc_next_i,
    /* Output */
    output data_t        rd_data_o
);

    always_comb begin
        unique case (wb_data_sel_c_i)
            alu_result: rd_data_o = alu_result_i;
            mem_read:   rd_data_o = mem_read_data_i;
            pc_next:    rd_data_o = pc_next_i;
            default:    rd_data_o = DATA_UNKNOWN;
        endcase
    end

endmodule
