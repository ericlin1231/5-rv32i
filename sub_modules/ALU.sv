import defs::*;

module ALU #(
    parameter XLEN = 32    
) (
    input alu_op_t alu_op_i,
    input data_t   data1,
    input data_t   data2,
    output data_t  data_out
);

    always_comb
    begin
        unique case (alu_op_i)
            ADD:     data_out =         data1  +   data2;
            SUB:     data_out =         data1  -   data2;
            SLL:     data_out =         data1  <<  data2[4:0];
            SRL:     data_out =         data1  >>  data2[4:0];
            SRA:     data_out =         data1  >>> data2[4:0];
            AND:     data_out =         data1  &   data2;
            OR :     data_out =         data1  |   data2;
            XOR:     data_out =         data1  ^   data2;
            SLT:     data_out = $signed(data1) <   $signed(data2);
            SLTU:    data_out =         data1  <   data2;
            PASS:    data_out =                    data2; /* only imm: LUI */
            default: data_out =         DATA_UNKNOWN;
        endcase
    end

endmodule
