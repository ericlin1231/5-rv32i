.option norvc
.section .text.start
.globl _start

_start:
    la sp, _stack_top
    j  main

