module ID2EX
  import CPU_buffer_bus::*;
  import tracer::*;
(
    input  logic        ACLK,
    input  logic        ARESETn,
    input  logic        stall_en,
    input  logic        flush_en,
    input  id_ex_bus_t  id_ex_bus_in,
    output id_ex_bus_t  id_ex_bus_out
`ifdef TRACE,
    input  tracer_bus_t id_ex_bus_in_trace,
    output tracer_bus_t id_ex_bus_out_trace
`endif
);
  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn || flush_en) id_ex_bus_out <= '0;
    else if (stall_en) id_ex_bus_out <= id_ex_bus_out;
    else id_ex_bus_out <= id_ex_bus_in;
  end
`ifdef TRACE
  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn || flush_en) id_ex_bus_out_trace <= '0;
    else if (stall_en) id_ex_bus_out_trace <= id_ex_bus_out_trace;
    else id_ex_bus_out_trace <= id_ex_bus_in_trace;
  end
`endif
endmodule
