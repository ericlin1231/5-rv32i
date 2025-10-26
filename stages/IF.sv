module IF #(
    parameter XLEN = 32,
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter IMEM_SIZE = 4096
) (
    input logic clk,
    input logic rst_n,
    input logic stall_c,
    input logic jump_c,
    input logic [ADDR_WIDTH-1:0] jump_addr_i,
    input logic instruction_valid_c,
    output logic [DATA_WIDTH-1:0] instruction_o,
    output logic [ADDR_WIDTH-1:0] pc_o
);
  logic [ADDR_WIDTH-1:0] pc;
  always_ff @(posedge clk) begin
    if (!rst_n) begin
      pc <= 0;
    end else begin
      if (jump_c) begin
        pc <= jump_addr_i;
      end else begin
        if (stall_c) begin
          pc <= pc;
        end else begin
          pc <= pc + 4;
        end
      end
    end
  end
  always_comb begin
    pc_o = pc;
  end

  logic [DATA_WIDTH-1:0] instruction_i;
  always_comb begin
    if (instruction_valid_c) begin
      instruction_o = instruction_i;
    end else begin
      instruction_o = 32'hDEADBEAF;
    end
  end

  memory #(
      .WIDTH(DATA_WIDTH),
      .MEM_SIZE(IMEM_SIZE)
  ) DMEM (
      .clk(clk),
      .ren(1),
      .wen(),
      .addr_i(pc),
      .data_i(),
      .data_o(instruction_i)
  );

endmodule
