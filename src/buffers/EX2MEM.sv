module EX2MEM
  import CPU_buffer_bus::*;
(
    input  logic              ACLK,
    input  logic              ARESETn,
    input  logic              stall_en,
    input  ex_mem_bus_t       ex_mem_bus_in,
    output ex_mem_bus_t       ex_mem_bus_out,
`ifdef DEBUG
    input  ex_mem_bus_debug_t ex_mem_bus_in_debug,
    output ex_mem_bus_debug_t ex_mem_bus_out_debug
`endif
);
  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) ex_mem_bus_out <= '0;
    else if (stall_en) ex_mem_bus_out <= ex_mem_bus_out;
    else ex_mem_bus_out <= ex_mem_bus_in;
  end
`ifdef DEBUG
  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) ex_mem_bus_out_debug <= '0;
    else if (stall_en) ex_mem_bus_out_debug <= ex_mem_bus_out_debug;
    else ex_mem_bus_out_debug <= ex_mem_bus_in_debug;
  end
`endif
endmodule
