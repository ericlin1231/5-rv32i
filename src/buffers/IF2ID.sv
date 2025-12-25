module IF2ID
  import CPU_buffer_bus::*;
(
    input  logic             ACLK,
    input  logic             ARESETn,
    input  logic             stall_en,
    input  logic             flush_en,
    input  if_id_bus_t       if_id_bus_in,
    output if_id_bus_t       if_id_bus_out,
`ifdef DEBUG
    input  if_id_bus_debug_t if_id_bus_in_debug,
    output if_id_bus_debug_t if_id_bus_out_debug
`endif
);
  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn || flush_en) if_id_bus_out <= '0;
    else if (stall_en) if_id_bus_out <= if_id_bus_out;
    else if_id_bus_out <= if_id_bus_in;
  end
  /* debug signal */
`ifdef DEBUG
  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn || flush_en) if_id_bus_out_debug <= '0;
    else if (stall_en) if_id_bus_out_debug <= if_id_bus_out_debug;
    else if_id_bus_out_debug <= if_id_bus_in_debug;
  end
`endif
endmodule
