import defs::*;

module CMP #(
    parameter XLEN = 32    
) (
    input cmp_op_t cmp_op_c_i,
    input data_t data1_i,
    input data_t data2_i,
    output logic branch_taken_o
);

    always_comb
    begin
        unique case (cmp_op_c_i)
            BEQ : branch_taken_o = (data1_i == data2_i);
            BNE : branch_taken_o = (data1_i != data2_i);
            BLT : branch_taken_o = ($signed(data1_i) <  $signed(data2_i));
            BGE : branch_taken_o = ($signed(data1_i) >= $signed(data2_i));
            BLTU: branch_taken_o = (data1_i <  data2_i);
            BGEU: branch_taken_o = (data1_i >= data2_i);
            default branch_taken_o = 1'b0;
        endcase
    end

endmodule
