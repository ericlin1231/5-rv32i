module ID2EX
  import CPU_buffer_bus::*;
(
    input  logic             ACLK,
    input  logic             ARESETn,
    input  logic             stall_en,
    input  logic             flush_en,
    input  id_ex_bus_t       id_ex_bus_in,
    output id_ex_bus_t       id_ex_bus_out,
`ifdef DEBUG
    input  id_ex_bus_debug_t id_ex_bus_in_debug,
    output id_ex_bus_debug_t id_ex_bus_out_debug
`endif
);
  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn || flush_en) id_ex_bus_out <= '0;
    else if (stall_en) id_ex_bus_out <= id_ex_bus_out;
    else id_ex_bus_out <= id_ex_bus_in;
  end
`ifdef DEBUG
  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn || flush_en) id_ex_bus_out_debug <= '0;
    else if (stall_en) id_ex_bus_out_debug <= id_ex_bus_out_debug;
    else id_ex_bus_out_debug <= id_ex_bus_in_debug;
  end
`endif
endmodule
