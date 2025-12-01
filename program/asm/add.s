.section .text
.global _start

_start:
    li t0, 0
    li t1, 0
    li t2, 10
    sw t1, 0(t0)
loop:
    lw t1, 0(t0)
    addi t1, t1, 1
    sw t1, 0(t0)
    addi t2, t2, -1
    bnez t2, loop
exit:
    j exit
