import defs::*;

module MEM (
    /* System */
    input logic    clk,
    /* Input */
    input enable_t mem_write_c_i,
    input data_t   mem_addr_i,
    input data_t   mem_write_data_i,
    /* Output */
    output data_t  mem_read_data_o
);

    memory #(
        .MEM_SIZE(DMEM_SIZE),
        .TYPE("DMEM")
    ) DMEM (
        .clk(clk),
        .ren(1'b1),
        .wen(mem_write_c_i),
        .addr_i(mem_addr_i),
        .data_i(mem_write_data_i),
        .data_o(mem_read_data_o)
    );

endmodule
