.section .text
.globl sll_u32
.type sll_u32, @function

/* a0: ptr_ref: **volatile u32
 * a1: val: u32
 * a2: shift_width: usize
 * a3: times: u32
 */

sll_u32:
    lw t0, 0(a0)
    mv t1, a1
    mv t2, a2
    mv t3, a3
sll_u32_loop_start:
    sll t1, t1, t2
    sw t1, 0(t0)
    addi t0, t0, 4
    addi t3, t3, -1
    bnez t3, sll_u32_loop_start
sll_u32_loop_end:
    sw t0, 0(a0)
    ret