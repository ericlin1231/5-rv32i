module MEM2WB (
    input  logic        ACLK,
    input  logic        ARESETn,
    input  logic        stall_en,
    input  mem_wb_bus_t mem_wb_bus_in,
    output mem_wb_bus_t mem_wb_bus_out
);

  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) mem_wb_bus_out <= '0;
    else if (stall_en) mem_wb_bus_out <= mem_wb_bus_out;
    else mem_wb_bus_out <= mem_wb_bus_in;
  end

endmodule
