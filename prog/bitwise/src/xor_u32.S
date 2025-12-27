.section .text
.globl xor_u32
.type xor_u32, @function

/* a0: ptr_ref: **volatile u32
 * a1: val: u32
 * a2: times: u32
 */

xor_u32:
    lw t0, 0(a0)
    mv t1, a1
    mv t2, a1
    mv t3, a2
xor_u32_loop_start:
    xor t1, t1, t2
    addi t3, t3, -1
    bnez t3, xor_u32_loop_start
xor_u32_loop_end:
    sw t1, 0(t0)
    addi t0, t0, 4
    sw t0, 0(a0)
    ret