module IF2ID
  import CPU_buffer_bus::*;
  import tracer::*;
(
    input  logic        ACLK,
    input  logic        ARESETn,
    input  logic        stall_en,
    input  logic        flush_en,
    input  if_id_bus_t  if_id_bus_in,
    output if_id_bus_t  if_id_bus_out,
`ifdef TRACE
    input  tracer_bus_t if_id_bus_in_trace,
    output tracer_bus_t if_id_bus_out_trace
`endif
);
  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn || flush_en) if_id_bus_out <= '0;
    else if (stall_en) if_id_bus_out <= if_id_bus_out;
    else if_id_bus_out <= if_id_bus_in;
  end
  /* trace signal */
`ifdef TRACE
  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn || flush_en) if_id_bus_out_trace <= '0;
    else if (stall_en) if_id_bus_out_trace <= if_id_bus_out_trace;
    else if_id_bus_out_trace <= if_id_bus_in_trace;
  end
`endif
endmodule
