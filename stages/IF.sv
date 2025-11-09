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
    output logic [DATA_WIDTH-1:0] instruction_o,
    output logic [ADDR_WIDTH-1:0] pc_o
);
    logic [ADDR_WIDTH-1:0] pc;
    always_ff @(posedge clk)
    begin
        if (!rst_n) pc <= 0;
        else begin
            if (jump_c) pc <= jump_addr_i;
            else begin
                if (stall_c) pc <= pc;
                else pc <= pc + 4;
            end
        end
    end

    always_comb
    begin
        pc_o = pc;
    end

    logic [DATA_WIDTH-1:0] instruction_i;
    always_comb instruction_o = instruction_i;

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
