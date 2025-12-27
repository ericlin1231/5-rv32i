.section .text
.globl ori_u32
.type ori_u32, @function

/* a0: ptr_ref: **volatile u32
 * a1: mask: u32
 */

ori_u32:
    lw t0, 0(a0)
    mv t1, a1
    ori t1, t1, 0
    sw t1, 0(t0)
    addi t0, t0, 4
    sw t0, 0(a0)
    ret