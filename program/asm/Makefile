SRCS := *.s
COMPILER := clang
LINKER := lld
OBJCOPY := llvm-objcopy

ARCH ?= rv32i
TARGET ?= riscv64-unknown-elf
LINKSCRIPT ?= link.ld

all: $(SRCS)
	@$(COMPILER) --target=$(TARGET) -march=$(ARCH)        \
    	-fuse-ld=$(LINKER) -nostdlib -Wl,-T,$(LINKSCRIPT) \
		-o $(basename $<).elf $<
	@llvm-objcopy -O binary --only-section=.text $(basename $<).elf $(basename $<).bin
	@hexdump -ve '1/1 "%02x\n"' $(basename $<).bin > $(basename $<).hex
	@mv $(basename $<).elf ../elf
	@mv $(basename $<).bin ../bin
	@mv $(basename $<).hex ../hex

clean:
	@rm *.elf

.PHONY: clean
