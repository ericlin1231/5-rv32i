module MEM #(
    parameter XLEN = 32,
    parameter DMEM_SZIE = 4096
) (
    /* System */
    input logic clk,
    /* Input */
    enable_t    mem_write_c_i,
    data_t      mem_addr_i,
    data_t      mem_write_data_i,
    /* Output */
    data_t      mem_read_data_o
);

    memory #(
        .WIDTH(DATA_WIDTH),
        .MEM_SIZE(DMEM_SIZE),
        .MEM_TYPE("DMEM")
    ) DMEM (
        .clk(clk),
        .ren(1'b1),
        .wen(mem_write_c_i),
        .addr_i(mem_addr_i),
        .data_i(mem_write_data_i),
        .data_o(mem_read_data_o)
    );

endmodule
