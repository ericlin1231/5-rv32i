module memory (
    input logic clk,

    /********** IMEM slave 0 interface ******************/
    input  logic [XLEN-1:0] imem_addr,
    input  logic            imem_ren,
    output logic [XLEN-1:0] imem_rdata,

    /********** DMEM slave 1 interface ******************/
    input  logic [XLEN-1:0] dmem_addr,
    input  logic            dmem_ren,
    output logic [XLEN-1:0] dmem_rdata,
    input  logic            dmem_wen,
    input  logic [     3:0] dmem_wstrb,
    input  logic [XLEN-1:0] dmem_wdata
);
  timeunit 1ns; timeprecision 1ps;

  localparam int unsigned ADDR_BITS = $clog2(MEM_SIZE);
  localparam int unsigned ADDR_MSB = ADDR_BITS + ADDR_SHIFT - 1;
  localparam int unsigned ADDR_LSB = ADDR_SHIFT;

  string            mem_file;
  logic  [XLEN-1:0] mem      [0:MEM_SIZE-1];

  initial begin
    if (!$value$plusargs("IMEM=%s", mem_file)) $display("Unified memory didn't load program file");
    if (mem_file != "") begin
      $display("[%m] load %s to unified memory", mem_file);
      $readmemh(mem_file, mem);
    end
  end

  /* effective address */
  logic [ADDR_BITS-1:0] valid_imem_addr;
  logic [ADDR_BITS-1:0] valid_dmem_addr;
  assign valid_imem_addr = imem_addr[ADDR_MSB:ADDR_LSB];
  assign valid_dmem_addr = dmem_addr[ADDR_MSB:ADDR_LSB];

  always_ff @(posedge clk) begin
    if (imem_ren) imem_rdata <= mem[valid_imem_addr];
    if (dmem_ren) dmem_rdata <= mem[valid_dmem_addr];
  end

  logic [XLEN-1:0] wdata_mask;
  assign wdata_mask = {
    {8{dmem_wstrb[3]}}, {8{dmem_wstrb[2]}}, {8{dmem_wstrb[1]}}, {8{dmem_wstrb[0]}}
  };
  always_ff @(posedge clk) begin
    if (dmem_wen) begin
      mem[valid_dmem_addr] <= (mem[valid_dmem_addr] & ~wdata_mask) | (dmem_wdata & wdata_mask);
    end
  end

endmodule
