module MEM2WB
  import CPU_buffer_bus::*;
  import tracer::*;
(
    input  logic        ACLK,
    input  logic        ARESETn,
    input  logic        stall_en,
    input  mem_wb_bus_t mem_wb_bus_in,
    output mem_wb_bus_t mem_wb_bus_out,
`ifdef TRACE
    input  tracer_bus_t mem_wb_bus_in_trace,
    output tracer_bus_t mem_wb_bus_out_trace
`endif
);
  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) mem_wb_bus_out <= '0;
    else if (stall_en) mem_wb_bus_out <= mem_wb_bus_out;
    else mem_wb_bus_out <= mem_wb_bus_in;
  end
`ifdef TRACE
  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) mem_wb_bus_out_trace <= '0;
    else if (stall_en) mem_wb_bus_out_trace <= mem_wb_bus_out_trace;
    else mem_wb_bus_out_trace <= mem_wb_bus_in_trace;
  end
`endif
endmodule
