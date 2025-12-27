.section .text
.globl and_u32
.type and_u32, @function

/* a0: ptr_ref: **volatile u32
 * a1: operand_a: u32
 * a2: operand_b: u32
 */

and_u32:
    lw t0, 0(a0)
    mv t1, a1
    mv t2, a2
    and t1, t1, t2
    sw t1, 0(t0)
    addi t0, t0, 4
    sw t0, 0(a0)
    ret