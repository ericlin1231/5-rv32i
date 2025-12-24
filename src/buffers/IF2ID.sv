module IF2ID
  import CPU_buffer_bus::*;
(
    input  logic       ACLK,
    input  logic       ARESETn,
    input  logic       stall_en_i,
    input  logic       flush_en_i,
    input  if_id_bus_t if_id_bus_in,
    output if_id_bus_t if_id_bus_out
);

  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn || flush_en_i) if_id_bus_out <= '0;
    else if (stall_en_i) if_id_bus_out <= if_id_bus_out;
    else if_id_bus_out <= if_id_bus_in;
  end

endmodule
