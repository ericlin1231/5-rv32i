import defs::*;

module IF2ID (
    input  logic    clk,
    input  enable_t stall_c,
    input  enable_t flush_c,
    input  data_t   pc_i,
    input  data_t   instruction_i,
    output data_t   pc_o,
    output data_t   instruction_o
);

    always_comb
    begin
        pc_o = pc;
        instruction_o = instruction;
    end

    data_t pc;
    data_t instruction;
    always_ff @(posedge clk)
    begin
        if (flush_c) begin
            pc <= 0;
            instruction <= 0;
        end
        else if (stall_c) begin
            pc <= pc;
            instruction <= instruction;
        end
        else begin
            pc <= pc_i;
            instruction <= instruction_i;
        end
    end

endmodule
