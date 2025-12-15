module MEM (
    /* Input */
    input  enable_t                       mem_write_c_i,
    input  enable_t                       mem_read_c_i,
    input  data_t                         mem_addr_i,
    input  data_t                         mem_write_data_i,
    input  data_t                         mem_read_data_i,
    /* Output */
    output data_t                         mem_addr_o,
    output data_t                         mem_write_data_o,
    output enable_t                       mem_wen_o,
    output          [AXI_DATA_BITS/8-1:0] mem_wstrb_o,
    output enable_t                       mem_ren_o,
    output data_t                         mem_read_data_o
);

    always_comb begin
        mem_addr_o       = mem_addr_i;
        mem_write_data_o = mem_write_data_i;
        mem_wen_o        = mem_write_c_i;
        mem_wstrb_o      = 4'b1111;
        mem_ren_o        = mem_read_c_i;
        mem_read_data_o  = mem_read_data_i;
    end

endmodule
