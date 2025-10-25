module memory_test #(
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

  memory #(
      .WIDTH(WIDTH),
      .MEM_SIZE(MEM_SIZE)
  ) DRAM (
      .clk(clk),
      .ren(ren),
      .wen(wen),
      .addr_i(addr_i),
      .data_i(data_i),
      .data_o(data_o)
  );

endmodule
