module memory #(
    parameter WIDTH = 32,
    parameter MEM_SIZE = 4096
) (
    input logic clk,
    input logic ren,
    input logic wen,
    input logic [WIDTH-1:0] addr_i,
    input logic [WIDTH-1:0] data_i,
    output logic [WIDTH-1:0] data_o
);

  localparam BYTES = WIDTH / 8;
  localparam ADDR_BITS = $clog2(MEM_SIZE);

  bit [ADDR_BITS-1:0] offset;
  logic [7:0] mem[0:MEM_SIZE-1];
  always_ff @(negedge clk) begin
    if (wen) begin
      for (offset = 0; offset < BYTES; offset++) begin
        mem[addr_i[ADDR_BITS-1:0]+offset] <= data_i[8*offset+:8];
      end
    end
    if (ren) begin
      for (offset = 0; offset < BYTES; offset++) begin
        data_o[8*offset+:8] <= mem[addr_i[ADDR_BITS-1:0]+offset];
      end
    end else begin
      data_o <= data_o;
    end
  end

endmodule
