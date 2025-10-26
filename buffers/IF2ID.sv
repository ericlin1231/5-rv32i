module IF2ID #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
    input clk,
    input stall_c,
    input flush_c,
    input logic [ADDR_WIDTH-1:0] pc_i,
    input logic [DATA_WIDTH-1:0] instruction_i,
    output logic [ADDR_WIDTH-1:0] pc_o,
    output logic [DATA_WIDTH-1:0] instruction_o
);

  always_comb begin
    pc_o = pc;
    instruction_o = instruction;
  end

  logic [ADDR_WIDTH-1:0] pc;
  logic [DATA_WIDTH-1:0] instruction;
  always_ff @(posedge clk) begin
    if (flush_c) begin
      pc <= 0;
      instruction <= 0;
    end else begin
      if (stall_c) begin
        pc <= pc;
        instruction <= instruction;
      end else begin
        pc <= pc_i;
        instruction <= instruction_i;
      end
    end
  end

endmodule
