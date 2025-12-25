module cpu
  import CPU_profile::*;
  import CPU_buffer_bus::*;
  import AXI_define::*;
  import decode::*;
(
    input logic ACLK,
    input logic ARESETn,
    input logic global_stall_en,

    /********** IMEM Master 0 Interface ******************/
    output logic [XLEN-1:0] imem_addr,
    output logic            imem_ren,
    input  logic [XLEN-1:0] imem_rdata,
    input  logic            imem_raddr_handshake,
    input  logic            imem_rdata_handshake,

    /********** DMEM Master 1 Interface ******************/
    output logic [           XLEN-1:0] dmem_addr,
    output logic                       dmem_wen,
    output       [AXI_DATA_BITS/8-1:0] dmem_wstrb,
    output logic [           XLEN-1:0] dmem_wdata,
    output logic                       dmem_ren,
    input  logic [           XLEN-1:0] dmem_rdata
);
  // debug pipelined signal declaration
`ifdef DEBUG
  /********** DEBUG ID *********************************/
  if_id_bus_debug_t  if_id_bus_out_debug;
  /********** DEBUG EX *********************************/
  id_ex_bus_debug_t  id_ex_bus_in_debug;
  id_ex_bus_debug_t  id_ex_bus_out_debug;
  /********** DEBUG MEM ********************************/
  ex_mem_bus_debug_t ex_mem_bus_in_debug;
  ex_mem_bus_debug_t ex_mem_bus_out_debug;
  /********** DEBUG WB *********************************/
  mem_wb_bus_debug_t mem_wb_bus_in_debug;
  mem_wb_bus_debug_t mem_wb_bus_out_debug;

  assign id_ex_bus_in_debug  = if_id_bus_out_debug;
  assign ex_mem_bus_in_debug = id_ex_bus_out_debug;
  assign mem_wb_bus_in_debug = ex_mem_bus_out_debug;
`endif

  // interconnect wire declaration
  /********** IF ***************************************/
  logic          [XLEN-1:0] current_pc;
  logic          [XLEN-1:0] pc_keep;
  /* until valid instuction after jump coming
   * the IF-ID buffer should always flush
   */
  logic                     jump_penalty;
  /********** IF-ID Buffer *****************************/
  if_id_bus_t               if_id_bus_in;
  if_id_bus_t               if_id_bus_out;
  /********** Control **********************************/
  control_t                 control;
  /********** ID-EX Buffer *****************************/
  id_ex_bus_t               id_ex_bus_in;
  id_ex_bus_t               id_ex_bus_out;
  /********** EX ***************************************/
  logic                     jump_en_ex;
  logic                     branch_taken_en_ex;
  logic          [XLEN-1:0] pc_target_ex;
  /********** EX-MEM Buffer ****************************/
  ex_mem_bus_t              ex_mem_bus_in;
  ex_mem_bus_t              ex_mem_bus_out;
  /********** MEM-WB Buffer ****************************/
  mem_wb_bus_t              mem_wb_bus_in;
  mem_wb_bus_t              mem_wb_bus_out;
  /********** WB ***************************************/
  logic          [XLEN-1:0] rd_wdata;
  /********** Hazard detection *************************/
  logic                     stall_en_if;
  logic                     stall_en_if2id;
  logic                     flush_en_if2id;
  logic                     flush_en_id2ex;
  alu_data_sel_e            alu_rs1_data_sel_ex;
  alu_data_sel_e            alu_rs2_data_sel_ex;

  /********** IF ***************************************/
  IF IF_stage (
      .ACLK,
      .ARESETn,
      .stall_en(stall_en_if | global_stall_en),
      .jump_en (jump_en_ex),
      .imem_rdata_handshake,
      .jump_penalty,

      // input
      .inst_i     (imem_rdata),
      .jump_addr_i(pc_target_ex),

      // output
      .inst_o   (if_id_bus_in.inst),
      .pc_o     (current_pc),
      .pc_next_o(if_id_bus_in.wb.pc_next)
  );
  /********** IMEM Master 0 Interface ******************/
  assign imem_addr = current_pc;
  assign imem_ren  = 1'b1;
  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) pc_keep <= '0;
    if (imem_raddr_handshake) begin
      pc_keep <= current_pc;
    end
    if (imem_rdata_handshake) begin
      if_id_bus_in.ex.pc <= pc_keep;
    end
  end

  /********** IF-ID Buffer *****************************/
  assign if_id_bus_in.inst = if_id_bus_in.inst;
  IF2ID IF2ID_buffer (
      .ACLK,
      .ARESETn,
      .stall_en(stall_en_if2id | global_stall_en),
      .flush_en(flush_en_if2id | jump_penalty),
      .if_id_bus_in,
      .if_id_bus_out,
`ifdef DEBUG
      .if_id_bus_in_debug,
      .if_id_bus_out_debug
`endif
  );

  /********** ID ***************************************/
  ID ID_stage (
      // input
      .inst_i(if_id_bus_out.inst),

      // output
      .funct7_o (control.funct7),
      .funct3_o (control.funct3),
      .opcode_o (control.opcode),
      .rs2_idx_o(id_ex_bus_in.rs2_idx),
      .rs1_idx_o(id_ex_bus_in.rs1_idx),
      .rd_idx_o (id_ex_bus_in.wb.rd_idx),
      .imm_o    (id_ex_bus_in.ex.imm)
  );
  assign id_ex_bus_in.ex.pc      = if_id_bus_out.ex.pc;
  assign id_ex_bus_in.wb.pc_next = if_id_bus_out.wb.pc_next;

  /********** RegFile **********************************/
  RegFile RegFile_u (
      .ACLK,

      // input
      /********** write data to destination register ***/
      .rd_idx (mem_wb_bus_out.rd_idx),
      .wen    (mem_wb_bus_out.reg_wen),
      .rd_wdata,
      /********** get source register data *************/
      .rs1_idx(id_ex_bus_in.rs1_idx),
      .rs2_idx(id_ex_bus_in.rs2_idx),

      // output
      .rs1_data_o(id_ex_bus_in.ex.rs1_data),
      .rs2_data_o(id_ex_bus_in.ex.rs2_data)
  );

  /********** Control **********************************/
  Control Control_u (
      // input
      .funct7_i(control.funct7),
      .funct3_i(control.funct3),
      .opcode_i(control.opcode),

      // output
      /********** EX ***********************************/
      .jump_en_o     (id_ex_bus_in.ex.jump_en),
      .branch_en_o   (id_ex_bus_in.ex.branch_en),
      .alu_op_o      (id_ex_bus_in.ex.alu_op),
      .alu_src1_sel_o(id_ex_bus_in.ex.alu_src1_sel),
      .alu_src2_sel_o(id_ex_bus_in.ex.alu_src2_sel),
      .cmp_op_o      (id_ex_bus_in.ex.cmp_op),
      /********** MEM **********************************/
      .mem_ren_o     (id_ex_bus_in.mem.mem_ren),
      .mem_wen_o     (id_ex_bus_in.mem.mem_wen),
      /********** WB ***********************************/
      .reg_wen_o     (id_ex_bus_in.wb.reg_wen),
      .wb_wdata_sel_o(id_ex_bus_in.wb.wb_wdata_sel)
  );

  /********** ID-EX Buffer *****************************/
  ID2EX ID2EX_buffer (
      .ACLK,
      .ARESETn,
      .stall_en(global_stall_en),
      .flush_en(flush_en_id2ex),
      .id_ex_bus_in,
      .id_ex_bus_out,
`ifdef DEBUG
      .id_ex_bus_in_debug,
      .id_ex_bus_out_debug
`endif
  );

  /********** EX ***************************************/
  EX EX_stage (
      // input
      .pc_i                  (id_ex_bus_out.ex.pc),
      .rs1_data_i            (id_ex_bus_out.ex.rs1_data),
      .rs2_data_i            (id_ex_bus_out.ex.rs2_data),
      .imm_i                 (id_ex_bus_out.ex.imm),
      /********** data forward from MEM and WB *********/
      .rs1_data_mem_forward_i(ex_mem_bus_out.alu_result),
      .rs2_data_mem_forward_i(ex_mem_bus_out.alu_result),
      .rs1_data_wb_forward_i (rd_wdata),
      .rs2_data_wb_forward_i (rd_wdata),
      /********** Control ******************************/
      .alu_op_i              (id_ex_bus_out.ex.alu_op),
      .alu_rs1_data_sel_i    (alu_rs1_data_sel_ex),
      .alu_rs2_data_sel_i    (alu_rs2_data_sel_ex),
      .alu_src1_sel_i        (id_ex_bus_out.ex.alu_src1_sel),
      .alu_src2_sel_i        (id_ex_bus_out.ex.alu_src2_sel),
      .cmp_op_i              (id_ex_bus_out.ex.cmp_op),

      // output
      .alu_result_o  (ex_mem_bus_in.alu_result),
      .branch_taken_o(branch_taken_en_ex),
      .pc_target_o   (pc_target_ex)
  );
  assign jump_en_ex = (id_ex_bus_out.ex.branch_en & branch_taken_en_ex) | id_ex_bus_out.ex.jump_en;
  assign ex_mem_bus_in.mem.mem_ren = id_ex_bus_out.mem.mem_ren;
  assign ex_mem_bus_in.mem.mem_wen = id_ex_bus_out.mem.mem_wen;
  assign ex_mem_bus_in.mem.mem_wdata = id_ex_bus_out.ex.rs2_data;
  assign ex_mem_bus_in.wb.rd_idx = id_ex_bus_out.wb.rd_idx;
  assign ex_mem_bus_in.wb.reg_wen = id_ex_bus_out.wb.reg_wen;
  assign ex_mem_bus_in.wb.wb_wdata_sel = id_ex_bus_out.wb.wb_wdata_sel;
  assign ex_mem_bus_in.wb.pc_next = id_ex_bus_out.wb.pc_next;

  /********** EX-MEM Buffer ****************************/
  EX2MEM EX2MEM_buffer (
      .ACLK,
      .ARESETn,
      .stall_en(global_stall_en),
      .ex_mem_bus_in,
      .ex_mem_bus_out,
`ifdef DEBUG
      .ex_mem_bus_in_debug,
      .ex_mem_bus_out_debug
`endif
  );

  /********** MEM **************************************/
  MEM MEM_stage (
      // input
      .mem_addr_i (ex_mem_bus_out.alu_result),
      .mem_ren_i  (ex_mem_bus_out.mem.mem_ren),
      .mem_rdata_i(dmem_rdata),
      .mem_wen_i  (ex_mem_bus_out.mem.mem_wen),
      .mem_wdata_i(ex_mem_bus_out.mem.mem_wdata),

      // output
      .mem_addr_o (dmem_addr),
      .mem_ren_o  (dmem_ren),
      .mem_rdata_o(mem_wb_bus_in.mem_rdata),
      .mem_wen_o  (dmem_wen),
      .mem_wstrb_o(dmem_wstrb),
      .mem_wdata_o(dmem_wdata)
  );
  assign mem_wb_bus_in.rd_idx       = ex_mem_bus_out.wb.rd_idx;
  assign mem_wb_bus_in.reg_wen      = ex_mem_bus_out.wb.reg_wen;
  assign mem_wb_bus_in.wb_wdata_sel = ex_mem_bus_out.wb.wb_wdata_sel;
  assign mem_wb_bus_in.pc_next      = ex_mem_bus_out.wb.pc_next;
  assign mem_wb_bus_in.alu_result   = ex_mem_bus_out.alu_result;


  /********** MEM-WB Buffer ****************************/
  MEM2WB MEM2WB_buffer (
      .ACLK,
      .ARESETn,
      .stall_en(global_stall_en),
      .mem_wb_bus_in,
      .mem_wb_bus_out,
`ifdef DEBUG
      .mem_wb_bus_in_debug,
      .mem_wb_bus_out_debug
`endif
  );

  /********** WB ***************************************/
  WB WB_stage (
      // input
      .wb_wdata_sel_i(mem_wb_bus_out.wb_wdata_sel),
      .alu_result_i  (mem_wb_bus_out.alu_result),
      .mem_rdata_i   (mem_wb_bus_out.mem_rdata),
      .pc_next_i     (mem_wb_bus_out.pc_next),

      // output
      .rd_wdata_o(rd_wdata)
  );

  /********** Hazard Detection *************************/
  Hazard Hazard_u (
      // input
      .rs1_idx_id     (id_ex_bus_in.rs1_idx),
      .rs2_idx_id     (id_ex_bus_in.rs2_idx),
      .rs1_idx_ex     (id_ex_bus_out.rs1_idx),
      .rs2_idx_ex     (id_ex_bus_out.rs2_idx),
      .rd_idx_ex      (id_ex_bus_out.wb.rd_idx),
      .jump_en_ex     (jump_en_ex),
      .wb_wdata_sel_ex(id_ex_bus_out.wb.wb_wdata_sel),
      .rd_idx_mem     (ex_mem_bus_out.wb.rd_idx),
      .reg_wen_mem    (ex_mem_bus_out.wb.reg_wen),
      .rd_idx_wb      (mem_wb_bus_out.rd_idx),
      .reg_wen_wb     (mem_wb_bus_out.reg_wen),

      // output
      .stall_en_if,
      .stall_en_if2id,
      .flush_en_if2id,
      .flush_en_id2ex,
      .alu_rs1_data_sel_ex,
      .alu_rs2_data_sel_ex
  );

endmodule
