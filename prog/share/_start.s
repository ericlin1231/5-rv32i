.section .text.start
.globl _start

_start:
    la sp, _stack_top
    call clean_signature
    j main

clean_signature:
    la t0, begin_signature
    la t1, end_signature
    li t2, 0
clean_step:
    sw t2, 0(t0)
    addi t0, t0, 4
    bltu t0, t1, clean_step
clean_signature_end:
    ret