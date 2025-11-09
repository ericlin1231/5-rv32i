import defs::*;

module ImmGen #(
    parameter XLEN = 32
) (
    input  imm_sel_t imm_sel_c,
    input  logic [XLEN-1:7] imm_i,
    output imm_t imm_o
);
    always_comb
    begin
        unique case(imm_sel_c)
            IMM_I_TYPE: imm_o = data_t'($signed(imm_i[31:20]));
            IMM_S_TYPE: imm_o = data_t'($signed({imm_i[31:25], imm_i[11:7]}));
            IMM_B_TYPE: imm_o = data_t'($signed({imm_i[31], imm_i[7], imm_i[30:25], imm_i[11:8], 1'b0}));
            IMM_U_TYPE: imm_o = data_t'({imm_i[31:12], 12'b0});
            IMM_J_TYPE: imm_o = data_t'($signed({imm_i[31], imm_i[19:12], imm_i[20], imm_i[30:21], 1'b0}));
            default: imm_o = 0;
        endcase
    end
endmodule
