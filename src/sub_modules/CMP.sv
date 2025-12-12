import defs::*;

module CMP (
    input  cmp_op_t cmp_op_c_i,
    input  data_t   data1_i,
    input  data_t   data2_i,
    output enable_t branch_taken_o
);

    always_comb begin
        unique case (cmp_op_c_i)
            BEQ:     branch_taken_o = (data1_i == data2_i) ? ENABLE : DISABLE;
            BNE:     branch_taken_o = (data1_i != data2_i) ? ENABLE : DISABLE;
            BLT:     branch_taken_o = ($signed(data1_i) < $signed(data2_i)) ? ENABLE : DISABLE;
            BGE:     branch_taken_o = ($signed(data1_i) >= $signed(data2_i)) ? ENABLE : DISABLE;
            BLTU:    branch_taken_o = (data1_i < data2_i) ? ENABLE : DISABLE;
            BGEU:    branch_taken_o = (data1_i >= data2_i) ? ENABLE : DISABLE;
            default: branch_taken_o = DISABLE;
        endcase
    end

endmodule
