import defs::*;

module ID2EX #(
    parameter XLEN = 32
) (
    /* System */
    input logic          clk,
    input enable_t       stall_c,
    input enable_t       flush_c,
    /* Input */
    input data_t         pc_i,
    input reg_addr_t     rd_i,
    input alu_data_sel_t alu_data1_sel_c_i,
    input alu_data_sel_t alu_data2_sel_c_i,
    input data_t         rs1_data_i,
    input data_t         rs2_data_i,
    input data_t         imm_i,
    /* Output */
    output data_t         pc_o,
    output reg_addr_t     rd_o,
    output alu_data_sel_t alu_data1_sel_c_o,
    output alu_data_sel_t alu_data2_sel_c_o,
    output data_t         rs1_data_o,
    output data_t         rs2_data_o,
    output data_t         imm_o
);

    always_ff @(posedge clk)
    begin
        if (stall_c) begin
            pc_o              <= pc_o;
            rd_o              <= rd_o;
            alu_data1_sel_c_o <= alu_data1_sel_c_o;
            alu_data2_sel_c_o <= alu_data2_sel_c_o;
            rs1_data_o        <= rs1_data_o;
            rs2_data_o        <= rs2_data_o;
            imm_o             <= imm_o;
        end
        else if (flush_c) begin
            pc_o              <= DATA_UNKNOWN;
            rd_o              <= REG_UNKNOWN;
            alu_data1_sel_c_o <= ALU_DATA_SEL_UNKNOWN;
            alu_data2_sel_c_o <= ALU_DATA_SEL_UNKNOWN;
            rs1_data_o        <= DATA_UNKNOWN;
            rs2_data_o        <= DATA_UNKNOWN;
            imm_o             <= DATA_UNKNOWN;
        end
        else begin
            pc_o              <= pc_i;
            rd_o              <= rd_i;
            alu_data1_sel_c_o <= alu_data1_sel_c_i;
            alu_data2_sel_c_o <= alu_data2_sel_c_i;
            rs1_data_o        <= rs1_data_i;
            rs2_data_o        <= rs2_data_i;
            imm_o             <= imm_i;
        end
    end

endmodule
