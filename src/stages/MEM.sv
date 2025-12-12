import defs::*;

module MEM (
    /* Input */
    input  enable_t mem_write_c_i,
    input  data_t   mem_addr_i,
    input  data_t   mem_write_data_i,
    input  data_t   mem_read_data_i,
    /* Output */
    output data_t   mem_addr_o,
    output data_t   mem_write_data_o,
    output enable_t mem_wen_o,
    output enable_t mem_ren_o,
    output data_t   mem_read_data_o
);

    always_comb begin
        mem_addr_o       = mem_addr_i;
        mem_write_data_o = mem_write_data_i;
        mem_wen_o        = mem_write_c_i;
        mem_ren_o        = ENABLE;
        mem_read_data_o  = mem_read_data_i;
    end

endmodule
