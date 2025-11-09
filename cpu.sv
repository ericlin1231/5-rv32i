import defs::*;

module cpu #(
    parameter XLEN = 32,
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter IMEM_SIZE = 4096,
    parameter DMEM_SIZE = 4096
) (
    input logic clk,
    input logic rst_n
);

    /* Instruction Fetch Stage */
    data_t instruction_if2buf;
    data_t pc_if2buf;
    IF #(
        .XLEN(XLEN),
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .IMEM_SIZE(IMEM_SIZE)
    ) IF_stage (
        /* System */
        .clk(clk),
        .rst_n(rst_n),
        /* Control */
        .stall_c(0),
        .jump_c(0),
        /* Input */
        .jump_addr_i(0),
        /* Output */
        .instruction_o(instruction_if2buf),
        .pc_o(pc_if2buf)
    );

    /* Instruction Fetch to Instruction Decode Buffer */
    data_t instruction_buf2id;
    data_t pc_buf2id;
    IF2ID IF2ID_buffer (
        /* System */
        .clk(clk),
        /* Control */
        .stall_c(0),
        .flush_c(0),
        /* Input */
        .instruction_i(instruction_if2buf),
        .pc_i(pc_if2buf),
        /* Output */
        .instruction_o(instruction_buf2id),
        .pc_o(pc_buf2id)
    );

    /* Instruction Decode Stage */
    data_t     pc_id2buf;
    opcode_t   op_id2control;
    funct3_t   funct3_id2control;
    reg_addr_t rd_id2buf;
    reg_addr_t rs1, rs2;
    reg_addr_t rs1_id2control, rs1_id2regfile;
    reg_addr_t rs2_id2control, rs2_id2regfile;
    funct7_t   funct7_id2control;
    imm_t      imm_id2buf;
    ID #(
        .XLEN(XLEN),
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .REG_ADDR_WIDTH(REG_ADDR_WIDTH)
    ) ID_stage (
        /* System */
        .clk(clk),
        /* Input */
        .instruction_i(instruction_buf2id),
        /* Output */
        .op_o(op_id2control),
        .funct3_o(funct3_id2control),
        .rd_o(rd_id2buf),
        .rs1_o(rs1),
        .rs2_o(rs2),
        .funct7_o(funct7_id2control),
        .imm_o(imm_id2buf)
    );
    /* Pass PC and Redirect Register Source Address */
    always_comb
    begin
        pc_id2buf      = pc_buf2id;
        rs1_id2control = rs1;
        rs1_id2regfile = rs1;
        rs2_id2control = rs2;
        rs2_id2regfile = rs2;
    end

    /* Register Files */
    data_t rs1_data_regfile2buf;
    data_t rs2_data_regfile2buf;
    RegFile RegFile_u (
        /* System */
        .clk(clk),
        .rst_n(rst_n),
        /* Input */
        .wen_c(0),
        .rs1_i(rs1_id2regfile),
        .rs2_i(rs2_id2regfile),
        .rd_i(rd_wb),
        .rd_data_i(rd_data_wb),
        /* Output */
        .rs1_data_o(rs1_data_regfile2buf),
        .rs2_data_o(rs2_data_regfile2buf)
    );

    /* Control Logic */
    alu_data_sel_t alu_data1_sel_c_control2buf;
    alu_data_sel_t alu_data2_sel_c_control2buf;

    /* Instruction Decode to Execution Buffer */
    data_t          pc_buf2ex;
    reg_addr_t      rd_buf2ex;
    alu_data_sel_t  alu_data1_sel_c_buf2ex;
    alu_data_sel_t  alu_data2_sel_c_buf2ex;
    data_t          rs1_data_buf2ex;
    data_t          rs2_data_buf2ex;
    imm_t           imm_buf2ex;
    ID2EX ID2EX_buffer (
        /* System */
        .clk(clk),
        .stall_c(0),
        .flush_c(0),
        /* Input */
        .pc_i(pc_id2buf),
        .rd_i(rd_id2buf),
        .alu_data1_sel_c_i(alu_data1_sel_c_control2buf),
        .alu_data2_sel_c_i(alu_data2_sel_c_control2buf),
        .rs1_data_i(rs1_data_regfile2buf),
        .rs2_data_i(rs2_data_regfile2buf),
        .imm_i(imm_id2buf),
        /* Output */
        .pc_o(pc_buf2ex),
        .rd_o(rd_buf2ex),
        .alu_data1_sel_c_o(alu_data1_sel_c_buf2ex),
        .alu_data2_sel_c_o(alu_data2_sel_c_buf2ex),
        .rs1_data_o(rs1_data_buf2ex),
        .rs2_data_o(rs2_data_buf2ex),
        .imm_o(imm_buf2ex)
    );

    /* Write Back Stage */
    reg_addr_t rd_wb;
    data_t     rd_data_wb;

endmodule
