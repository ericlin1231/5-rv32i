.section .text
.globl _start

_start:
    li t0, 0
    li t1, 10
    li t2, 20
    add t3, t1, t2
    sw t2, 0(t0)
loop:
    j loop
