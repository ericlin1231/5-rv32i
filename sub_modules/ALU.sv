import defs::*;

module ALU (
    input alu_op_t alu_op_i,
    input data_t   data1_i,
    input data_t   data2_i,
    output data_t  alu_result_o
);

    always_comb
    begin
        unique case (alu_op_i)
            ADD:     alu_result_o =         data1_i  +   data2_i;
            SUB:     alu_result_o =         data1_i  -   data2_i;
            SLL:     alu_result_o =         data1_i  <<  data2_i[4:0];
            SRL:     alu_result_o =         data1_i  >>  data2_i[4:0];
            SRA:     alu_result_o =         data1_i  >>> data2_i[4:0];
            AND:     alu_result_o =         data1_i  &   data2_i;
            OR :     alu_result_o =         data1_i  |   data2_i;
            XOR:     alu_result_o =         data1_i  ^   data2_i;
            SLT:     alu_result_o = $signed(data1_i) <   $signed(data2_i) ? 32'd1 : 32'd0;
            SLTU:    alu_result_o =         data1_i  <   data2_i ? 32'd1 : 32'd0;
            PASS:    alu_result_o =         data2_i; /* LUI */
            default: alu_result_o =         DATA_UNKNOWN;
        endcase
    end

endmodule
