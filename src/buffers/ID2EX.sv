module ID2EX (
    /* System */
    input  logic          clk,
    input  enable_t       flush_c_i,
    /* Input */
    /* EX stage */
    // data
    input  data_t         pc_i,
    input  data_t         rs1_data_i,
    input  data_t         rs2_data_i,
    input  data_t         imm_i,
    // control
    input  enable_t       jump_c_i,
    input  enable_t       branch_c_i,
    input  alu_src1_sel_t alu_src1_sel_c_i,
    input  alu_src2_sel_t alu_src2_sel_c_i,
    input  alu_op_t       alu_op_c_i,
    input  cmp_op_t       cmp_op_c_i,
    // hazard detection
    input  reg_addr_t     rd_i,              /* also for WB */
    input  reg_addr_t     rs1_i,
    input  reg_addr_t     rs2_i,
    /* MEM stage */
    input  enable_t       mem_write_c_i,
    /* WB stage */
    input  data_t         pc_next_i,
    input  enable_t       reg_write_c_i,
    input  wb_data_sel_t  wb_data_sel_c_i,
    /* Output */
    /* EX stage */
    // data
    output data_t         pc_o,
    output data_t         rs1_data_o,
    output data_t         rs2_data_o,
    output data_t         imm_o,
    // control
    output enable_t       jump_c_o,
    output enable_t       branch_c_o,
    output alu_src1_sel_t alu_src1_sel_c_o,
    output alu_src2_sel_t alu_src2_sel_c_o,
    output alu_op_t       alu_op_c_o,
    output cmp_op_t       cmp_op_c_o,
    // hazard detection
    output reg_addr_t     rd_o,
    output reg_addr_t     rs1_o,
    output reg_addr_t     rs2_o,
    /* MEM stage */
    output enable_t       mem_write_c_o,
    /* WB stage */
    output data_t         pc_next_o,
    output enable_t       reg_write_c_o,
    output wb_data_sel_t  wb_data_sel_c_o
);

    always_ff @(posedge clk) begin
        if (flush_c_i) begin
            /* EX stage */
            // data
            pc_o             <= DATA_UNKNOWN;
            rs1_data_o       <= DATA_UNKNOWN;
            rs2_data_o       <= DATA_UNKNOWN;
            imm_o            <= DATA_UNKNOWN;
            // control
            jump_c_o         <= DISABLE;
            branch_c_o       <= DISABLE;
            alu_src1_sel_c_o <= rs1;  /* don't care */
            alu_src2_sel_c_o <= rs2;  /* don't care */
            alu_op_c_o       <= ALU_OP_UNKNOWN;
            cmp_op_c_o       <= CMP_OP_UNKNOWN;
            // hazard detection
            rd_o             <= REG_UNKNOWN;
            rs1_o            <= REG_UNKNOWN;
            rs2_o            <= REG_UNKNOWN;
            /* MEM stage */
            mem_write_c_o    <= DISABLE;
            /* WB stage */
            pc_next_o        <= DATA_UNKNOWN;
            reg_write_c_o    <= DISABLE;
            wb_data_sel_c_o  <= WB_DATA_SEL_UNKNOWN;
        end else begin
            /* EX stage */
            // data
            pc_o             <= pc_i;
            rs1_data_o       <= rs1_data_i;
            rs2_data_o       <= rs2_data_i;
            imm_o            <= imm_i;
            // control
            jump_c_o         <= jump_c_i;
            branch_c_o       <= branch_c_i;
            alu_src1_sel_c_o <= alu_src1_sel_c_i;
            alu_src2_sel_c_o <= alu_src2_sel_c_i;
            alu_op_c_o       <= alu_op_c_i;
            cmp_op_c_o       <= cmp_op_c_i;
            // hazard detection
            rd_o             <= rd_i;
            rs1_o            <= rs1_i;
            rs2_o            <= rs2_i;
            /* MEM stage */
            mem_write_c_o    <= mem_write_c_i;
            /* WB stage */
            pc_next_o        <= pc_next_i;
            reg_write_c_o    <= reg_write_c_i;
            wb_data_sel_c_o  <= wb_data_sel_c_i;
        end
    end

endmodule
