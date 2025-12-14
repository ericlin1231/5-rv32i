module RegFile (
    /* System */
    input  logic      clk,
    /* Input */
    input  enable_t   wen_c,
    input  reg_addr_t rs1_i,
    input  reg_addr_t rs2_i,
    input  reg_addr_t rd_i,
    input  data_t     rd_data_i,
    /* Output */
    output data_t     rs1_data_o,
    output data_t     rs2_data_o
);

    data_t regs[0:XLEN-1];
    always_ff @(posedge clk) begin
        if (wen_c & rd_i != 0) regs[rd_i] <= rd_data_i;
    end

    always_comb begin
        rs1_data_o = (rs1_i != 0) ? regs[rs1_i] : 0;
        rs2_data_o = (rs2_i != 0) ? regs[rs2_i] : 0;
    end

endmodule
