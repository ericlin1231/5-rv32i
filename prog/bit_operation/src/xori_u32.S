.section .text
.globl xori_u32
.type xori_u32, @function

/* a0: ptr_ref: **volatile u32
 * a1: val: u32
 * a2: times: u32
 */

xori_u32:
    lw t0, 0(a0)
    mv t1, a1
    mv t2, a2
xori_u32_loop_start:
    xori t1, t1, -273 // -273 = 0xEEF is last 3 byte of magic number 0xDEADBEEF
    addi t2, t2, -1
    bnez t2, xori_u32_loop_start
xori_u32_loop_end:
    sw t1, 0(t0)
    addi t0, t0, 4
    sw t0, 0(a0)
    ret