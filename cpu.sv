import defs::*;

module cpu (
    input  logic    clk,
    input  logic    rst_n,
    output addr_t   imem_addr_o,
    output enable_t imem_ren_o,
    input  data_t   imem_data_i,
    output addr_t   dmem_addr_o,
    output enable_t dmem_wen_o,
    output data_t   dmem_write_data_o,
    output enable_t dmem_ren_o,
    input  data_t   dmem_read_data_i
);

    /* Instruction Fetch Stage */
    if_id_bus_t if_stage_bus;
    IF IF_stage (
        /* System */
        .clk          (clk),
        .rst_n        (rst_n),
        /* Control */
        .stall_c_i    (stall_c_if),
        .jump_c_i     (jump_c_ex),
        /* Input */
        .instruction_i(imem_data_i),
        .jump_addr_i  (pc_target_ex),
        /* Output */
        .instruction_o(if_stage_bus.instruction),
        .pc_o         (if_stage_bus.pc),
        .pc_next_o    (if_stage_bus.pc_next)
    );

    /* Instruction Fetch to Instruction Decode Buffer */
    if_id_bus_t if_id_bus;
    IF2ID IF2ID_buffer (
        /* System */
        .clk          (clk),
        /* Control */
        .stall_c_i    (stall_c_if2id),
        .flush_c_i    (flush_c_if2id),
        /* Input */
        .pc_i         (if_stage_bus.pc),
        .pc_next_i    (if_stage_bus.pc_next),
        .instruction_i(if_stage_bus.instruction),
        /* Output */
        .pc_o         (if_id_bus.pc),
        .pc_next_o    (if_id_bus.pc_next),
        .instruction_o(if_id_bus.instruction)
    );

    /* Instruction Decode Stage */
    opcode_t op_id2ctrl;
    funct3_t funct3_id2ctrl;
    funct7_t funct7_id2ctrl;
    reg_addr_t rs1, rs2;
    reg_addr_t rs1_id2reg, rs2_id2reg;
    ID ID_stage (
        /* Input */
        .instruction_i(if_id_bus.instruction),
        /* Output */
        .op_o         (op_id2ctrl),
        .funct7_o     (funct7_id2ctrl),
        .funct3_o     (funct3_id2ctrl),
        .rd_o         (id_ex_buf_in.rd),
        .rs1_o        (rs1),
        .rs2_o        (rs2),
        .imm_o        (id_ex_buf_in.imm)
    );
    /* Pass pc, pc_next and redirect rs signal */
    always_comb begin
        id_ex_buf_in.pc      = if_id_bus.pc;
        id_ex_buf_in.pc_next = if_id_bus.pc_next;
        id_ex_buf_in.rs1     = rs1;
        rs1_id2reg           = rs1;
        id_ex_buf_in.rs2     = rs2;
        rs2_id2reg           = rs2;
    end

    /* Register Files */
    data_t rs1_data_reg2buf;
    data_t rs2_data_reg2buf;
    RegFile RegFile_u (
        /* System */
        .clk       (clk),
        /* Input */
        .wen_c     (reg_write_c_wb),
        .rs1_i     (rs1_id2reg),
        .rs2_i     (rs2_id2reg),
        .rd_i      (mem_wb_bus.rd),
        .rd_data_i (rd_data_wb),
        /* Output */
        .rs1_data_o(rs1_data_reg2buf),
        .rs2_data_o(rs2_data_reg2buf)
    );

    /* Control Logic */
    id_ex_bus_t id_ex_buf_in;
    Control Control_u (
        /* Input */
        .op_i            (op_id2ctrl),
        .funct3_i        (funct3_id2ctrl),
        .funct7_i        (funct7_id2ctrl),
        /* Output */
        /* EX stage */
        .jump_c_o        (id_ex_buf_in.jump_c),
        .branch_c_o      (id_ex_buf_in.branch_c),
        .alu_op_c_o      (id_ex_buf_in.alu_op_c),
        .alu_src1_sel_c_o(id_ex_buf_in.alu_src1_sel_c),
        .alu_src2_sel_c_o(id_ex_buf_in.alu_src2_sel_c),
        .cmp_op_c_o      (id_ex_buf_in.cmp_op_c),
        /* MEM stage */
        .mem_write_c_o   (id_ex_buf_in.mem_write_c),
        /* WB stage */
        .reg_write_c_o   (id_ex_buf_in.reg_write_c),
        .wb_data_sel_c_o (id_ex_buf_in.wb_data_sel_c)
    );

    /* Instruction Decode to Execution Buffer */
    id_ex_bus_t id_ex_bus;
    ID2EX ID2EX_buffer (
        /***** System *****/
        .clk             (clk),
        .flush_c_i       (flush_c_id2ex),
        /***** Input *****/
        /* EX stage */
        // data
        .pc_i            (id_ex_buf_in.pc),
        .rs1_data_i      (rs1_data_reg2buf),
        .rs2_data_i      (rs2_data_reg2buf),
        .imm_i           (id_ex_buf_in.imm),
        // control
        .jump_c_i        (id_ex_buf_in.jump_c),
        .branch_c_i      (id_ex_buf_in.branch_c),
        .alu_op_c_i      (id_ex_buf_in.alu_op_c),
        .alu_src1_sel_c_i(id_ex_buf_in.alu_src1_sel_c),
        .alu_src2_sel_c_i(id_ex_buf_in.alu_src2_sel_c),
        .cmp_op_c_i      (id_ex_buf_in.cmp_op_c),
        // hazard detection
        .rd_i            (id_ex_buf_in.rd),
        .rs1_i           (id_ex_buf_in.rs1),
        .rs2_i           (id_ex_buf_in.rs2),
        /* MEM stage */
        .mem_write_c_i   (id_ex_buf_in.mem_write_c),
        /* WB stage */
        .pc_next_i       (id_ex_buf_in.pc_next),
        .reg_write_c_i   (id_ex_buf_in.reg_write_c),
        .wb_data_sel_c_i (id_ex_buf_in.wb_data_sel_c),
        /***** Output *****/
        /* EX stage */
        // data
        .pc_o            (id_ex_bus.pc),
        .rs1_data_o      (id_ex_bus.rs1_data),
        .rs2_data_o      (id_ex_bus.rs2_data),
        .imm_o           (id_ex_bus.imm),
        // control
        .jump_c_o        (id_ex_bus.jump_c),
        .branch_c_o      (id_ex_bus.branch_c),
        .alu_op_c_o      (id_ex_bus.alu_op_c),
        .alu_src1_sel_c_o(id_ex_bus.alu_src1_sel_c),
        .alu_src2_sel_c_o(id_ex_bus.alu_src2_sel_c),
        .cmp_op_c_o      (id_ex_bus.cmp_op_c),
        // hazard detection
        .rd_o            (id_ex_bus.rd),
        .rs1_o           (id_ex_bus.rs1),
        .rs2_o           (id_ex_bus.rs2),
        /* MEM stage */
        .mem_write_c_o   (id_ex_bus.mem_write_c),
        /* WB stage */
        .pc_next_o       (id_ex_bus.pc_next),
        .reg_write_c_o   (id_ex_bus.reg_write_c),
        .wb_data_sel_c_o (id_ex_bus.wb_data_sel_c)
    );

    /* Execute Stage */
    enable_t      jump_c_ex;
    enable_t      branch_taken_c_ex;
    data_t        alu_result_ex2buf;
    data_t        pc_target_ex;
    enable_t      mem_write_c_ex2buf;
    data_t        mem_write_data_ex2buf;  /* from rs2 data */
    reg_addr_t    rd_ex2buf;
    enable_t      reg_write_c_ex2buf;
    wb_data_sel_t wb_data_sel_c_ex2buf;
    data_t        pc_next_ex2buf;
    EX EX_stage (
        /* Input */
        // data
        .pc_i                  (id_ex_bus.pc),
        .rs1_data_i            (id_ex_bus.rs1_data),
        .rs2_data_i            (id_ex_bus.rs2_data),
        .imm_i                 (id_ex_bus.imm),
        // forwarding data
        .rs1_data_mem_forward_i(ex_mem_bus.alu_result),
        .rs2_data_mem_forward_i(ex_mem_bus.alu_result),
        .rs1_data_wb_forward_i (rd_data_wb),
        .rs2_data_wb_forward_i (rd_data_wb),
        // control
        .alu_op_c_i            (id_ex_bus.alu_op_c),
        .alu_rs1_data_sel_c_i  (alu_rs1_data_sel_c_ex),
        .alu_rs2_data_sel_c_i  (alu_rs2_data_sel_c_ex),
        .alu_src1_sel_c_i      (id_ex_bus.alu_src1_sel_c),
        .alu_src2_sel_c_i      (id_ex_bus.alu_src2_sel_c),
        .cmp_op_c_i            (id_ex_bus.cmp_op_c),
        /* Output */
        .alu_result_o          (alu_result_ex2buf),
        .branch_taken_o        (branch_taken_c_ex),
        .pc_target_o           (pc_target_ex)
    );
    /* redirection
     * jump, branch control signal
     * pc_next and mem write data (rs2 data)
     */
    always_comb begin
        jump_c_ex = (id_ex_bus.branch_c & branch_taken_c_ex) | id_ex_bus.jump_c ? ENABLE : DISABLE;
        mem_write_c_ex2buf = id_ex_bus.mem_write_c;
        mem_write_data_ex2buf = id_ex_bus.rs2_data;
        rd_ex2buf = id_ex_bus.rd;
        reg_write_c_ex2buf = id_ex_bus.reg_write_c;
        wb_data_sel_c_ex2buf = id_ex_bus.wb_data_sel_c;
        pc_next_ex2buf = id_ex_bus.pc_next;
    end

    /* Execute to Memory Buffer */
    ex_mem_bus_t ex_mem_bus;
    EX2MEM EX2MEM_buffer (
        /* System */
        .clk             (clk),
        /* Input */
        .alu_result_i    (alu_result_ex2buf),
        /* MEM stage */
        .mem_write_c_i   (mem_write_c_ex2buf),
        .mem_write_data_i(mem_write_data_ex2buf),
        /* WB stage */
        .rd_i            (rd_ex2buf),
        .reg_write_c_i   (reg_write_c_ex2buf),
        .wb_data_sel_c_i (wb_data_sel_c_ex2buf),
        .pc_next_i       (pc_next_ex2buf),
        /* Output */
        .alu_result_o    (ex_mem_bus.alu_result),
        /* MEM stage */
        .mem_write_c_o   (ex_mem_bus.mem_write_c),
        .mem_write_data_o(ex_mem_bus.mem_write_data),
        /* WB stage */
        .rd_o            (ex_mem_bus.rd),
        .reg_write_c_o   (ex_mem_bus.reg_write_c),
        .wb_data_sel_c_o (ex_mem_bus.wb_data_sel_c),
        .pc_next_o       (ex_mem_bus.pc_next)
    );

    /* Memory Stage */
    /* data pass to WB */
    data_t   mem_read_data_mem2buf;
    data_t   mem_addr_memstage;
    data_t   mem_write_data_memstage;
    enable_t mem_wen_memstage;
    enable_t mem_ren_memstage;
    /* control signal pass to WB */
    MEM MEM_stage (
        /* System */
        .clk             (clk),
        /* Input */
        .mem_write_c_i   (ex_mem_bus.mem_write_c),
        .mem_addr_i      (ex_mem_bus.alu_result),
        .mem_write_data_i(ex_mem_bus.mem_write_data),
        .mem_read_data_i (dmem_read_data_i),
        /* Output */
        .mem_addr_o      (mem_addr_memstage),
        .mem_write_data_o(mem_write_data_memstage),
        .mem_wen_o       (mem_wen_memstage),
        .mem_ren_o       (mem_ren_memstage),
        .mem_read_data_o (mem_read_data_mem2buf)
    );
    /* CPU Output Port Pass Through AXI Wrapper */
    assign imem_addr_o       = if_stage_bus.pc;
    assign imem_ren_o        = ENABLE;
    assign dmem_addr_o       = mem_addr_memstage;
    assign dmem_write_data_o = mem_write_data_memstage;
    assign dmem_wen_o        = mem_wen_memstage;
    assign dmem_ren_o        = mem_ren_memstage;
    /* WB stage signal redirection */
    always_comb begin
        mem_wb_buf_in.rd            = ex_mem_bus.rd;
        mem_wb_buf_in.alu_result    = ex_mem_bus.alu_result;
        mem_wb_buf_in.pc_next       = ex_mem_bus.pc_next;
        mem_wb_buf_in.reg_write_c   = ex_mem_bus.reg_write_c;
        mem_wb_buf_in.wb_data_sel_c = ex_mem_bus.wb_data_sel_c;
    end

    /* Memory to Write Back Buffer */
    mem_wb_bus_t mem_wb_bus;
    mem_wb_bus_t mem_wb_buf_in;
    MEM2WB MEM2WB_buffer (
        /* System */
        .clk            (clk),
        /* Input */
        // data
        .rd_i           (mem_wb_buf_in.rd),
        .alu_result_i   (mem_wb_buf_in.alu_result),
        .pc_next_i      (mem_wb_buf_in.pc_next),
        .mem_read_data_i(mem_read_data_mem2buf),
        // control
        .reg_write_c_i  (mem_wb_buf_in.reg_write_c),
        .wb_data_sel_c_i(mem_wb_buf_in.wb_data_sel_c),
        /* Output */
        // data
        .rd_o           (mem_wb_bus.rd),
        .alu_result_o   (mem_wb_bus.alu_result),
        .pc_next_o      (mem_wb_bus.pc_next),
        .mem_read_data_o(mem_wb_bus.mem_read_data),
        // control
        .reg_write_c_o  (mem_wb_bus.reg_write_c),
        .wb_data_sel_c_o(mem_wb_bus.wb_data_sel_c)
    );

    /* Write Back Stage */
    /* signal pass to Register File */
    enable_t   reg_write_c_wb;
    reg_addr_t rd_wb;
    data_t     rd_data_wb;
    WB WB_stage (
        /* Input */
        .wb_data_sel_c_i(mem_wb_bus.wb_data_sel_c),
        .alu_result_i   (mem_wb_bus.alu_result),
        .mem_read_data_i(mem_wb_bus.mem_read_data),
        .pc_next_i      (mem_wb_bus.pc_next),
        /* Output */
        .rd_data_o      (rd_data_wb)
    );
    always_comb begin
        reg_write_c_wb = mem_wb_bus.reg_write_c;
        rd_wb          = mem_wb_bus.rd;
    end

    /* Hazard Detection Unit */
    enable_t       stall_c_if;
    enable_t       stall_c_if2id;
    enable_t       flush_c_if2id;
    enable_t       flush_c_id2ex;
    alu_data_sel_t alu_rs1_data_sel_c_ex;
    alu_data_sel_t alu_rs2_data_sel_c_ex;
    Hazard Hazard_u (
        .rs1_id               (id_ex_buf_in.rs1),
        .rs2_id               (id_ex_buf_in.rs2),
        .rs1_ex               (id_ex_bus.rs1),
        .rs2_ex               (id_ex_bus.rs2),
        .rd_ex                (id_ex_bus.rd),
        .jump_c_ex            (jump_c_ex),
        .wb_data_sel_c_ex     (id_ex_bus.wb_data_sel_c),
        .rd_mem               (ex_mem_bus.rd),
        .reg_write_c_mem      (ex_mem_bus.reg_write_c),
        .rd_wb                (mem_wb_bus.rd),
        .reg_write_c_wb       (mem_wb_bus.reg_write_c),
        .stall_c_if           (stall_c_if),
        .stall_c_if2id        (stall_c_if2id),
        .flush_c_if2id        (flush_c_if2id),
        .flush_c_id2ex        (flush_c_id2ex),
        .alu_rs1_data_sel_c_ex(alu_rs1_data_sel_c_ex),
        .alu_rs2_data_sel_c_ex(alu_rs2_data_sel_c_ex)
    );

endmodule
