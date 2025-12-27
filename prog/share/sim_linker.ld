OUTPUT_ARCH("riscv")
ENTRY(_start)

_STACK_SIZE = 0x1000;
_SIGNATURE_SIZE = 0x1000;

MEMORY {
  imem (rx) : ORIGIN = 0x00000000, LENGTH = 0x00010000
  dmem (rw) : ORIGIN = ORIGIN(imem) + LENGTH(imem), LENGTH = 0x00010000
  debug (rw) : ORIGIN = ORIGIN(dmem) + LENGTH(dmem), LENGTH = 0x00010000
}

SECTIONS
{
    .text : ALIGN(16) {
        *(.text.start)
        *(.text.main)
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

    .tohost : ALIGN(8) {
        PROVIDE(tohost = .);
    } > dmem

    .stack (NOLOAD) : ALIGN(16) {
        _stack_bottom = .;
        . = . + _STACK_SIZE;
        _stack_top = .;
    } > dmem

    .signature (NOLOAD): ALIGN(16) {
        PROVIDE(begin_signature = .);
        . = . + _SIGNATURE_SIZE;
        PROVIDE(end_signature = .);
    } > debug
}
