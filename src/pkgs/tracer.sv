package tracer;
  import CPU_profile::*;

  typedef struct packed {
    inst_t inst;
    logic [XLEN-1] pc;
  } tracer_bus_t;

  /***** helper ****************************************/
  function automatic string reg_idx2abi(input logic [4:0] idx);
    case (idx)
      5'd0: return "zero";
      5'd1: return "ra";
      5'd2: return "sp";
      5'd3: return "gp";
      5'd4: return "tp";

      // temporaries
      5'd5: return "t0";
      5'd6: return "t1";
      5'd7: return "t2";

      // saved
      5'd8: return "s0";
      5'd9: return "s1";

      // arguments
      5'd10: return "a0";
      5'd11: return "a1";
      5'd12: return "a2";
      5'd13: return "a3";
      5'd14: return "a4";
      5'd15: return "a5";
      5'd16: return "a6";
      5'd17: return "a7";

      // saved
      5'd18: return "s2";
      5'd19: return "s3";
      5'd20: return "s4";
      5'd21: return "s5";
      5'd22: return "s6";
      5'd23: return "s7";
      5'd24: return "s8";
      5'd25: return "s9";
      5'd26: return "s10";
      5'd27: return "s11";

      // temporaries
      5'd28: return "t3";
      5'd29: return "t4";
      5'd30: return "t5";
      5'd31: return "t6";

      default: return $sformatf("x%0d", idx);
    endcase
  endfunction
endpackage
