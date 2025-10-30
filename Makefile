.DEFAULT_GOAL := sim

TOP ?= top
SRCS += test/$(TOP).sv 
SRCS += $(wildcard peripheral/*.sv)
SRCS += $(wildcard stages/*.sv)
SRCS += $(wildcard buffers/*.sv)

PROG_DIR        := program
PROG_ELF_DIR    := $(PROG_DIR)/elf
PROG_HEX_DIR    := $(PROG_DIR)/hex
PROG_SIM        ?= add.hex
PROG_DEBUG      ?= add.elf
PROG_SIM_PATH   := $(PROG_HEX_DIR)/$(PROG_SIM)
PROG_DEBUG_PATH := $(PROG_ELF_DIR)/$(PROG_DEBUG)

QEMU   := qemu-system-riscv32
QFLAGS := -nographic -smp 1 -machine virt -bios none

GDB     := gdb
GDBINIT := gdbinit

SIMULATION := sim/sim_$(TOP).cpp
SIMULATOR := verilator
SIMULATOR_OPTS := --sv --top-module $(TOP) --trace --build -j 0
SIMULATION_BIN := $(notdir $(basename $(SIMULATION)))
WAVE := *.vcd
VIEWER := surfer
VIEWER_SCRIPT := script.sucl

.PHONY: sim
sim: $(SRCS) $(SIMULATION) prog_sim
	$(SIMULATOR) $(SIMULATOR_OPTS) \
		-cc $(SRCS) -exe $(SIMULATION) -o $(SIMULATION_BIN)
	./obj_dir/$(SIMULATION_BIN) +IMEM=$(PROG_PATH)
	$(VIEWER) -c $(VIEWER_SCRIPT)

.PHONY: debug
debug:
	@make -C program debug
	@echo "------------------------------------"
	@echo "Press Crtl-A and then X to exit QEMU"
	@echo "------------------------------------"
	@$(QEMU) $(QFLAGS) -kernel $(PROG_DEBUG_PATH) -s -S

.PHONY: gdb
gdb:
	@$(GDB) $(PROG_DEBUG_PATH) -q -x $(GDBINIT)
	
.PHONY: prog_sim
prog_sim:
	@make -C program

.PHONY: clean
clean:
	@rm -rf obj_dir $(WAVE)
	@make -C program clean
