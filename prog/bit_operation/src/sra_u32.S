.section .text
.globl sra_u32
.type sra_u32, @function

/* a0: ptr_ref: **volatile u32
 * a1: val: u32
 * a2: shift_width: usize
 * a3: amount: u32
 */

sra_u32:
    lw t0, 0(a0)
    mv t1, a1
    mv t2, a2
    mv t3, a3
sra_u32_loop_start:
    sra t1, t1, t2
    sw t1, 0(t0)
    addi t0, t0, 4
    addi t3, t3, -1
    bnez t3, sra_u32_loop_start
sra_u32_loop_end:
    sw t0, 0(a0)
    ret