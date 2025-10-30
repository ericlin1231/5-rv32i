.DEFAULT_GOAL := sim

COMPILER := clang
LINKER   := lld
OBJDUMP  := llvm-objdump
OBJCOPY  := llvm-objcopy
HEXDUMP  := hexdump

TARGET        := riscv32-unknown-elf
ARCH          := rv32i
ABI           := ilp32

CFLAGS := --target=$(TARGET) -march=$(ARCH) -mabi=$(ABI)
CFLAGS += -g -fuse-ld=$(LINKER) -nostdlib
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
sim: CFLAGS += -Wl,-T,link.ld
sim: $(HEXS) | dir
	@mv $(HEXS) $(HEX_DIR)

.PHONY: debug
debug: BUILD_DIR = $(ELF_DIR)
debug: CFLAGS += -Wl,-T,link_debug.ld
debug: $(ELFS) | dir
	@mv $(ELFS) $(ELF_DIR)

%.hex: %.bin
	@$(HEXDUMP) $(HFLAGS) $< > $@

%.bin: %.elf
	@$(OBJCOPY) $(OFLAGS) $< $@

%.elf: %.s
	@$(COMPILER) $(CFLAGS) -o $@ $<

.PHONY: dir
dir:
	@mkdir -p $(BUILD_DIR)
