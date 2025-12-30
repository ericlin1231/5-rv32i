module MEM
  import CPU_profile::*;
  import AXI_define::*;
(
    // input
    input logic [XLEN-1:0] mem_addr_i,
    input logic            mem_ren_i,
    // input logic [     3:0] mem_rmask_i,
    input logic [XLEN-1:0] mem_rdata_i,
    input logic            mem_wen_i,
    input logic [     3:0] mem_wstrb_i,
    input logic [XLEN-1:0] mem_wdata_i,

    // output
    output logic [           XLEN-1:0] mem_addr_o,
    output logic                       mem_ren_o,
    output logic [           XLEN-1:0] mem_rdata_o,
    output logic                       mem_wen_o,
    output logic [AXI_DATA_BITS/8-1:0] mem_wstrb_o,
    output logic [           XLEN-1:0] mem_wdata_o
);

  always_comb begin
    mem_addr_o  = mem_addr_i;
    mem_wdata_o = mem_wdata_i;
    mem_wen_o   = mem_wen_i;
    mem_wstrb_o = mem_wstrb_i;
    mem_ren_o   = mem_ren_i;
    mem_rdata_o = mem_rdata_i;
  end

endmodule
