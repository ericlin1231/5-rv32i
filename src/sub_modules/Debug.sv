module Debug
  import CPU_profile::*;
  import decode::*;
  import tracer::*;
(
    input logic ACLK,
    input tracer_bus_t if_trace,
    input tracer_bus_t id_trace,
    input tracer_bus_t ex_trace,
    input tracer_bus_t mem_trace,
    input tracer_bus_t wb_trace
);
  /********** pipeline traced signal for testbench *****/
  string if_disasm;
  string if_rd_abi;
  string if_rs1_abi;
  string if_rs2_abi;
  logic [XLEN-1:0] if_pc;
  assign if_disasm = rv32i_disasm(if_trace.inst, if_trace.pc);
  assign if_rd_abi = reg_idx2abi(if_trace.rd_idx);
  assign if_rs1_abi = reg_idx2abi(if_trace.rs1_idx);
  assign if_rs2_abi = reg_idx2abi(if_trace.rs2_idx);
  assign if_pc = if_trace.pc;

  string id_disasm;
  string id_rd_abi;
  string id_rs1_abi;
  string id_rs2_abi;
  logic [XLEN-1:0] id_pc;
  assign id_disasm = rv32i_disasm(id_trace.inst, id_trace.pc);
  assign id_rd_abi = reg_idx2abi(id_trace.rd_idx);
  assign id_rs1_abi = reg_idx2abi(id_trace.rs1_idx);
  assign id_rs2_abi = reg_idx2abi(id_trace.rs2_idx);
  assign id_pc = id_trace.pc;

  string ex_disasm;
  string ex_rd_abi;
  string ex_rs1_abi;
  string ex_rs2_abi;
  logic [XLEN-1:0] ex_pc;
  logic [XLEN-1:0] ex_rs1_data;
  logic [XLEN-1:0] ex_rs2_data;
  logic [XLEN-1:0] ex_imm;
  assign ex_disasm = rv32i_disasm(ex_trace.inst, ex_trace.pc);
  assign ex_rd_abi = reg_idx2abi(ex_trace.rd_idx);
  assign ex_rs1_abi = reg_idx2abi(ex_trace.rs1_idx);
  assign ex_rs2_abi = reg_idx2abi(ex_trace.rs2_idx);
  assign ex_pc = ex_trace.pc;
  assign ex_rs1_data = ex_trace.rs1_data;
  assign ex_rs2_data = ex_trace.rs2_data;
  assign ex_imm = ex_trace.imm;
  always_ff @(posedge ACLK) begin
    if (ex_trace.inst.opcode == 7'b0010011 && ex_trace.inst.funct3 == 3'd5 && ex_trace.inst.funct7 == 7'b0100000) begin
      $display("pc: 0x%h inst: %s opcode: %b funct3: %b funct7: %b alu_op: %s", ex_trace.pc,
               rv32i_disasm(ex_trace.inst, ex_trace.pc), ex_trace.inst.opcode,
               ex_trace.inst.funct3, ex_trace.inst.funct7, ex_trace.alu_op.name);
    end
  end

  string mem_disasm;
  string mem_rd_abi;
  string mem_rs1_abi;
  string mem_rs2_abi;
  logic [XLEN-1:0] mem_pc;
  assign mem_disasm = rv32i_disasm(mem_trace.inst, mem_trace.pc);
  assign mem_rd_abi = reg_idx2abi(mem_trace.rd_idx);
  assign mem_rs1_abi = reg_idx2abi(mem_trace.rs1_idx);
  assign mem_rs2_abi = reg_idx2abi(mem_trace.rs2_idx);
  assign mem_pc = mem_trace.pc;

  string wb_disasm;
  string wb_rd_abi;
  string wb_rs1_abi;
  string wb_rs2_abi;
  logic [XLEN-1:0] wb_pc;
  assign wb_disasm = rv32i_disasm(wb_trace.inst, wb_trace.pc);
  assign wb_rd_abi = reg_idx2abi(wb_trace.rd_idx);
  assign wb_rs1_abi = reg_idx2abi(wb_trace.rs1_idx);
  assign wb_rs2_abi = reg_idx2abi(wb_trace.rs2_idx);
  assign wb_pc = wb_trace.pc;

endmodule
