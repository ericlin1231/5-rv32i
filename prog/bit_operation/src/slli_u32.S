.section .text
.globl slli_u32
.type slli_u32, @function

/* a0: ptr_ref: **volatile u32
 * a1: val: u32
 * a2: times: u32
 */

slli_u32:
    lw t0, 0(a0)
    mv t1, a1
    mv t2, a2
slli_u32_loop_start:
    slli t1, t1, 1
    sw t1, 0(t0)
    addi t0, t0, 4
    addi t2, t2, -1
    bnez t2, slli_u32_loop_start
slli_u32_loop_end:
    sw t0, 0(a0)
    ret