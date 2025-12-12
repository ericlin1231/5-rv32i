import defs::*;

module IF2ID (
    input  logic    clk,
    /* Input */
    input  enable_t stall_c_i,
    input  enable_t flush_c_i,
    input  data_t   pc_i,
    input  data_t   pc_next_i,
    input  data_t   instruction_i,
    /* Output */
    output data_t   pc_o,
    output data_t   pc_next_o,
    output data_t   instruction_o
);

    always_ff @(posedge clk) begin
        if (flush_c_i) begin
            pc_o          <= DATA_UNKNOWN;
            pc_next_o     <= DATA_UNKNOWN;
            instruction_o <= DATA_UNKNOWN;
        end else if (stall_c_i) begin
            pc_o          <= pc_o;
            pc_next_o     <= pc_next_o;
            instruction_o <= instruction_o;
        end else begin
            pc_o          <= pc_i;
            pc_next_o     <= pc_next_i;
            instruction_o <= instruction_i;
        end
    end

endmodule
