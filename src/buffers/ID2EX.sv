module ID2EX
  import CPU_buffer_bus::*;
(
    input  logic       ACLK,
    input  logic       ARESETn,
    input  logic       stall_en,
    input  logic       flush_en,
    input  id_ex_bus_t id_ex_bus_in,
    output id_ex_bus_t id_ex_bus_out
);

  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn || flush_en) id_ex_bus_out <= '0;
    else if (stall_en) id_ex_bus_out <= id_ex_bus_out;
    else id_ex_bus_out <= id_ex_bus_in;
  end

endmodule
