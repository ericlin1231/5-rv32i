.section .text
.globl andi_u32
.type andi_u32, @function

/* a0: ptr_ref: **volatile u32
 * a1: mask: u32
 */

andi_u32:
    lw t0, 0(a0)
    mv t1, a1
    andi t1, t1, -1 // -1 is 0xFFF
    sw t1, 0(t0)
    addi t0, t0, 4
    sw t0, 0(a0)
    ret