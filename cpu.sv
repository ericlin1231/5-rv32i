import defs::*;

module cpu (
    input logic clk,
    input logic rst_n
);

    /* Instruction Fetch Stage */
    data_t instruction_if2buf;
    data_t pc_if2buf;
    data_t pc_next_if2buf;
    IF IF_stage (
        /* System */
        .clk(clk),
        .rst_n(rst_n),
        /* Control */
        .stall_c_i(stall_c_if),
        .jump_c_i(jump_c_ex),
        /* Input */
        .jump_addr_i(pc_target_ex),
        /* Output */
        .instruction_o(instruction_if2buf),
        .pc_o(pc_if2buf),
        .pc_next_o(pc_next_if2buf)
    );

    /* Instruction Fetch to Instruction Decode Buffer */
    data_t instruction_buf2id;
    data_t pc_buf2id;
    data_t pc_next_buf2id;
    IF2ID IF2ID_buffer (
        /* System */
        .clk(clk),
        /* Control */
        .stall_c_i(stall_c_if2id),
        .flush_c_i(flush_c_if2id),
        /* Input */
        .pc_i(pc_if2buf),
        .pc_next_i(pc_next_if2buf),
        .instruction_i(instruction_if2buf),
        /* Output */
        .pc_o(pc_buf2id),
        .pc_next_o(pc_next_buf2id),
        .instruction_o(instruction_buf2id)
    );

    /* Instruction Decode Stage */
    data_t     pc_id2buf;
    opcode_t   op_id2ctrl;
    funct3_t   funct3_id2ctrl;
    funct7_t   funct7_id2ctrl;
    reg_addr_t rd_id2buf;
    reg_addr_t rs1, rs2;
    reg_addr_t rs1_id2reg, rs2_id2reg;
    reg_addr_t rs1_id2buf, rs2_id2buf;
    data_t     imm_id2buf;
    data_t     pc_next_id2buf;
    ID ID_stage (
        /* Input */
        .instruction_i(instruction_buf2id),
        /* Output */
        .op_o(op_id2ctrl),
        .funct7_o(funct7_id2ctrl),
        .funct3_o(funct3_id2ctrl),
        .rd_o(rd_id2buf),
        .rs1_o(rs1),
        .rs2_o(rs2),
        .imm_o(imm_id2buf)
    );
    /* Pass pc, pc_next and redirect rs signal */
    always_comb
    begin
        pc_id2buf      = pc_buf2id;
        pc_next_id2buf = pc_next_buf2id;
        rs1_id2buf     = rs1;
        rs1_id2reg     = rs1;
        rs2_id2buf     = rs2;
        rs2_id2reg     = rs2;
    end

    /* Register Files */
    data_t rs1_data_reg2buf;
    data_t rs2_data_reg2buf;
    RegFile RegFile_u (
        /* System */
        .clk(clk),
        /* Input */
        .wen_c(reg_write_c_wb),
        .rs1_i(rs1_id2reg),
        .rs2_i(rs2_id2reg),
        .rd_i(rd_wb),
        .rd_data_i(rd_data_wb),
        /* Output */
        .rs1_data_o(rs1_data_reg2buf),
        .rs2_data_o(rs2_data_reg2buf)
    );

    /* Control Logic */
    enable_t       reg_write_c_ctrl2buf;
    enable_t       mem_write_c_ctrl2buf;
    wb_data_sel_t  wb_data_sel_c_ctrl2buf;
    enable_t       jump_c_ctrl2buf;
    enable_t       branch_c_ctrl2buf;
    alu_op_t       alu_op_c_ctrl2buf;
    alu_src1_sel_t alu_src1_sel_c_ctrl2buf;
    alu_src2_sel_t alu_src2_sel_c_ctrl2buf;
    cmp_op_t       cmp_op_c_ctrl2buf;
    Control Control_u (
        /* Input */
        .op_i(op_id2ctrl),
        .funct3_i(funct3_id2ctrl),
        .funct7_i(funct7_id2ctrl),
        /* Output */
        /* EX stage */
        .jump_c_o(jump_c_ctrl2buf),
        .branch_c_o(branch_c_ctrl2buf),
        .alu_op_c_o(alu_op_c_ctrl2buf),
        .alu_src1_sel_c_o(alu_src1_sel_c_ctrl2buf),
        .alu_src2_sel_c_o(alu_src2_sel_c_ctrl2buf),
        .cmp_op_c_o(cmp_op_c_ctrl2buf),
        /* MEM stage */
        .mem_write_c_o(mem_write_c_ctrl2buf),
        /* WB stage */
        .reg_write_c_o(reg_write_c_ctrl2buf),
        .wb_data_sel_c_o(wb_data_sel_c_ctrl2buf)
    );

    /* Instruction Decode to Execution Buffer */
    /* EX stage */
    // data
    data_t         pc_buf2ex;
    data_t         rs1_data_buf2ex;
    data_t         rs2_data_buf2ex; /* also MEM write data */
    data_t         imm_buf2ex;
    // control
    enable_t       jump_c_buf2ex;
    enable_t       branch_c_buf2ex;
    alu_op_t       alu_op_c_buf2ex;
    alu_src1_sel_t alu_src1_sel_c_buf2ex;
    alu_src2_sel_t alu_src2_sel_c_buf2ex;
    cmp_op_t       cmp_op_c_buf2ex;
    // hazard detection
    reg_addr_t     rd_buf2ex;
    reg_addr_t     rs1_buf2ex;
    reg_addr_t     rs2_buf2ex;
    /* MEM stage */
    enable_t       mem_write_c_buf2ex;
    /* WB stage */
    data_t         pc_next_buf2ex;
    enable_t       reg_write_c_buf2ex;
    wb_data_sel_t  wb_data_sel_c_buf2ex;
    ID2EX ID2EX_buffer(
        /***** System *****/
        .clk(clk),
        .flush_c_i(flush_c_id2ex),
        /***** Input *****/
        /* EX stage */
        // data
        .pc_i(pc_id2buf),
        .rs1_data_i(rs1_data_reg2buf),
        .rs2_data_i(rs2_data_reg2buf),
        .imm_i(imm_id2buf),
        // control
        .jump_c_i(jump_c_ctrl2buf),
        .branch_c_i(branch_c_ctrl2buf),
        .alu_op_c_i(alu_op_c_ctrl2buf),
        .alu_src1_sel_c_i(alu_src1_sel_c_ctrl2buf),
        .alu_src2_sel_c_i(alu_src2_sel_c_ctrl2buf),
        .cmp_op_c_i(cmp_op_c_ctrl2buf),
        // hazard detection
        .rd_i(rd_id2buf),
        .rs1_i(rs1_id2buf),
        .rs2_i(rs2_id2buf),
        /* MEM stage */
        .mem_write_c_i(mem_write_c_ctrl2buf),
        /* WB stage */
        .pc_next_i(pc_next_id2buf),
        .reg_write_c_i(reg_write_c_ctrl2buf),
        .wb_data_sel_c_i(wb_data_sel_c_ctrl2buf),
        /***** Output *****/
        /* EX stage */
        // data
        .pc_o(pc_buf2ex),
        .rs1_data_o(rs1_data_buf2ex),
        .rs2_data_o(rs2_data_buf2ex),
        .imm_o(imm_buf2ex),
        // control
        .jump_c_o(jump_c_buf2ex),
        .branch_c_o(branch_c_buf2ex),
        .alu_op_c_o(alu_op_c_buf2ex),
        .alu_src1_sel_c_o(alu_src1_sel_c_buf2ex),
        .alu_src2_sel_c_o(alu_src2_sel_c_buf2ex),
        .cmp_op_c_o(cmp_op_c_buf2ex),
        // hazard detection
        .rd_o(rd_buf2ex),
        .rs1_o(rs1_buf2ex),
        .rs2_o(rs2_buf2ex),
        /* MEM stage */
        .mem_write_c_o(mem_write_c_buf2ex),
        /* WB stage */
        .pc_next_o(pc_next_buf2ex),
        .reg_write_c_o(reg_write_c_buf2ex),
        .wb_data_sel_c_o(wb_data_sel_c_buf2ex)
    );

    /* Execute Stage */
    enable_t      jump_c_ex;
    enable_t      branch_taken_c_ex;
    data_t        alu_result_ex2buf;
    data_t        pc_target_ex;
    enable_t      mem_write_c_ex2buf;
    data_t        mem_write_data_ex2buf; /* from rs2 data */
    reg_addr_t    rd_ex2buf;
    enable_t      reg_write_c_ex2buf;
    wb_data_sel_t wb_data_sel_c_ex2buf;
    data_t        pc_next_ex2buf;
    EX EX_stage(
        /* Input */
        // data
        .pc_i(pc_buf2ex),
        .rs1_data_i(rs1_data_buf2ex),
        .rs2_data_i(rs2_data_buf2ex),
        .imm_i(imm_buf2ex),
        // forwarding data
        .rs1_data_mem_forward_i(alu_result_buf2mem),
        .rs2_data_mem_forward_i(alu_result_buf2mem),
        .rs1_data_wb_forward_i(rd_data_wb),
        .rs2_data_wb_forward_i(rd_data_wb),
        // control
        .alu_op_c_i(alu_op_c_buf2ex),
        .alu_rs1_data_sel_c_i(alu_rs1_data_sel_c_ex),
        .alu_rs2_data_sel_c_i(alu_rs2_data_sel_c_ex),
        .alu_src1_sel_c_i(alu_src1_sel_c_buf2ex),
        .alu_src2_sel_c_i(alu_src2_sel_c_buf2ex),
        .cmp_op_c_i(cmp_op_c_buf2ex),
        /* Output */
        .alu_result_o(alu_result_ex2buf),
        .branch_taken_o(branch_taken_c_ex),
        .pc_target_o(pc_target_ex)
    );
    /* redirection
     * jump, branch control signal
     * pc_next and mem write data (rs2 data)
     */
    always_comb
    begin
        jump_c_ex             = (branch_c_buf2ex & branch_taken_c_ex) | jump_c_buf2ex ? ENABLE : DISABLE;
        mem_write_c_ex2buf    = mem_write_c_buf2ex;
        mem_write_data_ex2buf = rs2_data_buf2ex;
        rd_ex2buf             = rd_buf2ex;
        reg_write_c_ex2buf    = reg_write_c_buf2ex;
        wb_data_sel_c_ex2buf  = wb_data_sel_c_buf2ex;
        pc_next_ex2buf        = pc_next_buf2ex;
    end

    /* Execute to Memory Buffer */
    data_t        alu_result_buf2mem;
    enable_t      mem_write_c_buf2mem;
    data_t        mem_write_data_buf2mem;
    reg_addr_t    rd_buf2mem;
    enable_t      reg_write_c_buf2mem;
    wb_data_sel_t wb_data_sel_c_buf2mem;
    data_t        pc_next_buf2mem;
    EX2MEM EX2MEM_buffer (
        /* System */
        .clk(clk),
        /* Input */
        .alu_result_i(alu_result_ex2buf),
        /* MEM stage */
        .mem_write_c_i(mem_write_c_ex2buf),
        .mem_write_data_i(mem_write_data_ex2buf),
        /* WB stage */
        .rd_i(rd_ex2buf),
        .reg_write_c_i(reg_write_c_ex2buf),
        .wb_data_sel_c_i(wb_data_sel_c_ex2buf),
        .pc_next_i(pc_next_ex2buf),
        /* Output */
        .alu_result_o(alu_result_buf2mem),
        /* MEM stage */
        .mem_write_c_o(mem_write_c_buf2mem),
        .mem_write_data_o(mem_write_data_buf2mem),
        /* WB stage */
        .rd_o(rd_buf2mem),
        .reg_write_c_o(reg_write_c_buf2mem),
        .wb_data_sel_c_o(wb_data_sel_c_buf2mem),
        .pc_next_o(pc_next_buf2mem)
    );

    /* Memory Stage */
    /* data pass to WB */
    reg_addr_t    rd_mem2buf;
    data_t        alu_result_mem2buf;
    data_t        pc_next_mem2buf;
    data_t        mem_read_data_mem2buf;
    /* control signal pass to WB */
    enable_t      reg_write_c_mem2buf;
    wb_data_sel_t wb_data_sel_c_mem2buf;
    MEM MEM_stage (
        /* System */
        .clk(clk),
        /* Input */
        .mem_write_c_i(mem_write_c_buf2mem),
        .mem_addr_i(alu_result_buf2mem),
        .mem_write_data_i(mem_write_data_buf2mem),
        /* Output */
        .mem_read_data_o(mem_read_data_mem2buf)
    );
    /* WB stage signal redirection */
    always_comb
    begin
        /* data */
        rd_mem2buf            = rd_buf2mem;
        alu_result_mem2buf    = alu_result_buf2mem;
        pc_next_mem2buf       = pc_next_buf2mem;
        /* control */
        reg_write_c_mem2buf   = reg_write_c_buf2mem;
        wb_data_sel_c_mem2buf = wb_data_sel_c_buf2mem;
    end

    /* Memory to Write Back Buffer */
    reg_addr_t    rd_buf2wb;
    data_t        alu_result_buf2wb;
    data_t        pc_next_buf2wb;
    data_t        mem_read_data_buf2wb;
    enable_t      reg_write_c_buf2wb;
    wb_data_sel_t wb_data_sel_c_buf2wb;
    MEM2WB MEM2WB_buffer (
        /* System */
        .clk(clk),
        /* Input */
        // data
        .rd_i(rd_mem2buf),
        .alu_result_i(alu_result_mem2buf),
        .pc_next_i(pc_next_mem2buf),
        .mem_read_data_i(mem_read_data_mem2buf),
        // control
        .reg_write_c_i(reg_write_c_mem2buf),
        .wb_data_sel_c_i(wb_data_sel_c_mem2buf),
        /* Output */
        // data
        .rd_o(rd_buf2wb),
        .alu_result_o(alu_result_buf2wb),
        .pc_next_o(pc_next_buf2wb),
        .mem_read_data_o(mem_read_data_buf2wb),
        // control
        .reg_write_c_o(reg_write_c_buf2wb),
        .wb_data_sel_c_o(wb_data_sel_c_buf2wb)
    );
    
    /* Write Back Stage */
    /* signal pass to Register File */
    enable_t   reg_write_c_wb;
    reg_addr_t rd_wb;
    data_t     rd_data_wb;
    WB WB_stage (
        /* Input */
        .wb_data_sel_c_i(wb_data_sel_c_buf2wb),
        .alu_result_i(alu_result_buf2wb),
        .mem_read_data_i(mem_read_data_buf2wb),
        .pc_next_i(pc_next_buf2wb),
        /* Output */
        .rd_data_o(rd_data_wb)
    );
    always_comb
    begin
        reg_write_c_wb = reg_write_c_buf2wb;
        rd_wb          = rd_buf2wb;
    end

    /* Hazard Detection Unit */
    enable_t stall_c_if;
    enable_t stall_c_if2id;
    enable_t flush_c_if2id;
    enable_t flush_c_id2ex;
    alu_data_sel_t alu_rs1_data_sel_c_ex;
    alu_data_sel_t alu_rs2_data_sel_c_ex;
    Hazard Hazard_u (
        .rs1_id(rs1_id2buf),
        .rs2_id(rs2_id2buf),
        .rs1_ex(rs1_buf2ex),
        .rs2_ex(rs2_buf2ex),
        .rd_ex(rd_buf2ex),
        .jump_c_ex(jump_c_ex),
        .wb_data_sel_c_ex(wb_data_sel_c_buf2ex),
        .rd_mem(rd_buf2mem),
        .reg_write_c_mem(reg_write_c_buf2mem),
        .rd_wb(rd_buf2wb),
        .reg_write_c_wb(reg_write_c_buf2wb),
        .stall_c_if(stall_c_if),
        .stall_c_if2id(stall_c_if2id),
        .flush_c_if2id(flush_c_if2id),
        .flush_c_id2ex(flush_c_id2ex),
        .alu_rs1_data_sel_c_ex(alu_rs1_data_sel_c_ex),
        .alu_rs2_data_sel_c_ex(alu_rs2_data_sel_c_ex)
    );

endmodule
