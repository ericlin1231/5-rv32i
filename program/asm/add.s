.section .text
.global _start

_start:
    li t0, 10
    li t1, 20
    add t2, t0, t1
loop:
    j loop
