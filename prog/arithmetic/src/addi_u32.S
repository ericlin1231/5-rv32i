.section .text
.globl addi_u32
.type addi_u32, @function

/* a0: ptr_ref: **volatile u32
 * a1: val: u32
 */

addi_u32:
    lw t0, 0(a0)
    mv t1, a1
    addi t1, t1, 1
    sw t1, 0(t0)
    addi t0, t0, 4
    sw t0, 0(a0)
    ret