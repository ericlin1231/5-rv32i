module IF (
    /* System */
    input  logic    ACLK,
    input  logic    ARESETn,
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

    always_ff @(posedge ACLK or negedge ARESETn) begin
        if (!ACLK) pc_o <= 32'h00000000;
        else begin
            if (jump_c_i) pc_o <= jump_addr_i;
            else if (stall_c_i) pc_o <= pc_o;
            else pc_o <= pc_o + 32'd4;
        end
    end
    always_comb begin
        instruction_o = instruction_i;
        pc_next_o     = pc_o + 32'd4;
    end

endmodule
