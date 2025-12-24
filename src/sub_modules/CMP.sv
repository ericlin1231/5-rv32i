module CMP
  import CPU_profile::*;
  import decode::*;
(
    input  cmp_op_e            cmp_op_i,
    input  logic    [XLEN-1:0] data1_i,
    input  logic    [XLEN-1:0] data2_i,
    output logic               branch_taken_o
);

  always_comb begin
    unique case (cmp_op_i)
      BEQ:     branch_taken_o = (data1_i == data2_i);
      BNE:     branch_taken_o = (data1_i != data2_i);
      BLT:     branch_taken_o = ($signed(data1_i) < $signed(data2_i));
      BGE:     branch_taken_o = ($signed(data1_i) >= $signed(data2_i));
      BLTU:    branch_taken_o = (data1_i < data2_i);
      BGEU:    branch_taken_o = (data1_i >= data2_i);
      default: branch_taken_o = '0;
    endcase
  end

endmodule
