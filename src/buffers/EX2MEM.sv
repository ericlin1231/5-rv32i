module EX2MEM
  import CPU_buffer_bus::*;
  import tracer::*;
(
    input  logic        ACLK,
    input  logic        ARESETn,
    input  logic        stall_en,
    input  ex_mem_bus_t ex_mem_bus_in,
    output ex_mem_bus_t ex_mem_bus_out,
`ifdef TRACE
    input  tracer_bus_t ex_mem_bus_in_trace,
    output tracer_bus_t ex_mem_bus_out_trace
`endif
);
  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) ex_mem_bus_out <= '0;
    else if (stall_en) ex_mem_bus_out <= ex_mem_bus_out;
    else ex_mem_bus_out <= ex_mem_bus_in;
  end
`ifdef TRACE
  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) ex_mem_bus_out_trace <= '0;
    else if (stall_en) ex_mem_bus_out_trace <= ex_mem_bus_out_trace;
    else ex_mem_bus_out_trace <= ex_mem_bus_in_trace;
  end
`endif
endmodule
