PROG      := bit_operation
BIN       := zig-out/bin
SIM_ELF   := $(BIN)/$(PROG)_sim
SIM_HEX   := $(PROG)_sim.hex
SPIKE_ELF := $(BIN)/$(PROG)_spike

SIM_DIR   ?= ../sims
SPIKE_DIR ?= ../spikes

CROSS   := riscv32-unknown-elf-
OBJCOPY := $(CROSS)objcopy -O verilog --verilog-data-width 4

all:
	@zig build
	@$(OBJCOPY) $(SIM_ELF) $(SIM_HEX)
	@mv $(SIM_HEX) $(SIM_DIR)
	@mv $(SPIKE_ELF) $(SPIKE_DIR)

clean:
	@rm -rf zig-out
