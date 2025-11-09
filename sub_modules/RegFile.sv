module RegFile (
    input logic clk,
    input logic rst_n,
    input enable_t wen_c,
    input reg_addr_t rs1_i,
    input reg_addr_t rs2_i,
    input reg_addr_t rd_i,
    input data_t rd_data_i,
    output data_t rs1_data_o,
    output data_t rs2_data_o
);
    
    data_t regs [0:XLEN-1];
    always_ff @(posedge clk)
    begin
        if (!rst_n) regs[0] <= 0;
        if (wen_c) regs[rd_i] <= rd_data_i;
    end

    always_comb
    begin
        rs1_data_o = regs[rs1_i];
        rs2_data_o = regs[rs2_i];
    end

endmodule
