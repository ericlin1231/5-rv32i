module IF (
    /* System */
    input  logic    clk,
    input  logic    rst_n,
    /* Input */
    input  enable_t stall_c_i,
    input  enable_t jump_c_i,
    input  addr_t   jump_addr_i,
    input  data_t   instruction_i,
    /* Output */
    output data_t   instruction_o,
    output addr_t   pc_o,
    output addr_t   pc_next_o
);
    always_ff @(posedge clk) begin
        if (!rst_n) pc_o <= 32'h0;
        else begin
            if (stall_c_i) pc_o <= pc_o;
            else if (jump_c_i) pc_o <= jump_addr_i;
            else pc_o <= pc_o + 32'd4;
        end
    end
    always_comb begin
        instruction_o = instruction_i;
        pc_next_o     = pc_o + 32'd4;
    end

endmodule
