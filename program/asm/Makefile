.DEFAULT_GOAL := sim

COMPILER := clang
LINKER   := lld
OBJDUMP  := llvm-objdump
OBJCOPY  := llvm-objcopy
HEXDUMP  := hexdump

TARGET        := riscv32-unknown-elf
ARCH          := rv32i
ABI           := ilp32
LINKER_SCRIPT := link.ld

CFLAGS := --target=$(TARGET) -march=$(ARCH) -mabi=$(ABI)
CFLAGS += -fuse-ld=$(LINKER) -nostdlib
CFLAGS += -Wl,-T,$(LINKER_SCRIPT)
OFLAGS := -O binary --only-section=.text*
HFLAGS := -ve '1/1 "%02x\n"'

ASM_SRCS := $(wildcard *.s)
ASM_DIR  := ../asm

BASE := $(basename $(ASM_SRCS))

ELFS    := $(addsuffix .elf, $(BASE))
ELF_DIR := ../elf

BINS := $(addsuffix .bin, $(BASE))

HEXS      := $(addsuffix .hex, $(BASE))
HEX_DIR   := ../hex
BUILD_DIR := $(HEX_DIR)

.PHONY: sim
sim: $(HEXS) | dir
	@mv $(HEXS) $(HEX_DIR)

.PHONY: debug
debug: BUILD_DIR = $(ELF_DIR)
debug: $(ELFS) | dir
	@mv $(ELFS) $(ELF_DIR)

%.hex: %.bin
	$(HEXDUMP) $(HFLAGS) $< > $@

%.bin: %.elf
	$(OBJCOPY) $(OFLAGS) $< $@

%.elf: %.s
	$(COMPILER) $(CFLAGS) -o $@ $<

.PHONY: dir
dir:
	@mkdir -p $(BUILD_DIR)
