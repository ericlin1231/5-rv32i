ENTRY(_start)

__stack_size = 4K;

SECTIONS
{
    . = 0x1000;

    /* Ensure the entry stub is first */
    .text : ALIGN(16) {
        *(.text.start)
        *(.text)
        *(.text.*)
    }

    .rodata : ALIGN(16) {
        *(.rodata)
        *(.rodata.*)
    }

    .data : ALIGN(16) {
        *(.data)
        *(.data.*)
    }

    .bss : ALIGN(16) {
        __bss_start = .;
        *(.bss)
        *(.bss.*)
        *(COMMON)
        __bss_end = .;
    }

    .stack (NOLOAD) : ALIGN(16) {
        _stack_bottom = .;
        . = . + __stack_size;
        _stack_top = .;
    }

    __image_end = .;
}
