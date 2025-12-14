`ifndef CPU_PROFILE_SVH
`define CPU_PROFILE_SVH

parameter XLEN = 32;
parameter ADDR_WIDTH = 32;
parameter ADDR_SHIFT = 2;
parameter REG_ADDR_WIDTH = 5;

parameter int unsigned IMEM_BYTES = 64 * 1024;  /* 64 KiB */
parameter int unsigned DMEM_BYTES = 64 * 1024;  /* 64 KiB */

parameter int unsigned IMEM_SIZE = IMEM_BYTES >> ADDR_SHIFT;
parameter int unsigned DMEM_SIZE = DMEM_BYTES >> ADDR_SHIFT;
parameter int unsigned MEM_SIZE = IMEM_SIZE + DMEM_SIZE;

typedef enum logic [REG_ADDR_WIDTH-1:0] {
    zero = 5'd0,
    ra   = 5'd1,
    sp   = 5'd2,
    gp   = 5'd3,
    tp   = 5'd4,
    t0   = 5'd5,
    t1   = 5'd6,
    t2   = 5'd7,
    s0   = 5'd8,   /* fp */
    s1   = 5'd9,
    a0   = 5'd10,  /* return value */
    a1   = 5'd11,  /* return value */
    a2   = 5'd12,
    a3   = 5'd13,
    a4   = 5'd14,
    a5   = 5'd15,
    a6   = 5'd16,
    a7   = 5'd17,
    s2   = 5'd18,
    s3   = 5'd19,
    s4   = 5'd20,
    s5   = 5'd21,
    s6   = 5'd22,
    s7   = 5'd23,
    s8   = 5'd24,
    s9   = 5'd25,
    s10  = 5'd26,
    s11  = 5'd27,
    t3   = 5'd28,
    t4   = 5'd29,
    t5   = 5'd30,
    t6   = 5'd31
} reg_addr_t;

`endif
