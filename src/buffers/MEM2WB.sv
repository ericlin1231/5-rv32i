module MEM2WB
  import CPU_buffer_bus::*;
(
    input  logic              ACLK,
    input  logic              ARESETn,
    input  logic              stall_en,
    input  mem_wb_bus_t       mem_wb_bus_in,
    output mem_wb_bus_t       mem_wb_bus_out,
`ifdef DEBUG
    input  mem_wb_bus_debug_t mem_wb_bus_in_debug,
    output mem_wb_bus_debug_t mem_wb_bus_out_debug
`endif
);
  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) mem_wb_bus_out <= '0;
    else if (stall_en) mem_wb_bus_out <= mem_wb_bus_out;
    else mem_wb_bus_out <= mem_wb_bus_in;
  end
`ifdef DEBUG
  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) mem_wb_bus_out_debug <= '0;
    else if (stall_en) mem_wb_bus_out_debug <= mem_wb_bus_out_debug;
    else mem_wb_bus_out_debug <= mem_wb_bus_in_debug;
  end
`endif
endmodule
