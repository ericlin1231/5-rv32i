OUTPUT_ARCH("riscv")
ENTRY(_start)

_STACK_SIZE = 0x1000;

MEMORY {
  imem : ORIGIN = 0x00000000, LENGTH = 0x00010000
  dmem : ORIGIN = ORIGIN(imem) + LENGTH(imem), LENGTH = 0x00010000
}

SECTIONS
{
    .text : ALIGN(16) {
        *(.text.start)
        *(.text)
        *(.text.*)
    } > imem

    .rodata : ALIGN(16) {
        *(.rodata)
        *(.rodata.*)
    } > imem

    .data : ALIGN(16) {
        *(.data)
        *(.data.*)
    } > dmem

    .bss : ALIGN(16) {
        __bss_start = .;
        *(.bss)
        *(.bss.*)
        *(COMMON)
        __bss_end = .;
    } > dmem
    
    .signature (NOLOAD): ALIGN(16) {
        PROVIDE(begin_signature = .);
        . = . + 1024;
        PROVIDE(end_signature = .);
    } > dmem

    .stack (NOLOAD) : ALIGN(16) {
        _stack_bottom = .;
        . = . + _STACK_SIZE;
        _stack_top = .;
    } > dmem

    __image_end = .;
}
