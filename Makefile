.DEFAULT_GOAL := sim

DUT  ?= src/top.sv
TB   ?= tb/tb_top.sv
SRCS := src/defs.sv
SRCS += src/cpu.sv
SRCS += $(wildcard src/stages/*.sv)
SRCS += $(wildcard src/buffers/*.sv)
SRCS += $(wildcard src/sub_modules/*.sv)
SRCS += $(wildcard src/peripheral/*.sv)
SRCS += $(DUT)

IMEM      ?= program/uart/uart.hex
VCD       ?= wave.vcd
BUILD_DIR ?= build
OBJ_DIR   := $(BUILD_DIR)/obj_dir
SIM_BIN   := $(BUILD_DIR)/Vtb_top

SIMULATOR       := verilator
INC_DIRS        := -Isrc
VERILATOR_FLAGS := -sv --timing --trace --binary -Wall
VERILATOR_FLAGS += $(INC_DIRS)
VERILATOR_FLAGS += --Mdir $(OBJ_DIR)
VERILATOR_FLAGS += --top-module tb_top

QEMU   := qemu-system-riscv32
QFLAGS := -nographic -smp 1 -machine virt -bios none

GDB     := gdb
GDBINIT := gdbinit

FORMATTER      := verible-verilog-format
FORMATTER_OPTS := --inplace
FORMATTER_OPTS += --indentation_spaces=4
FORMATTER_OPTS += --assignment_statement_alignment=align
FORMATTER_OPTS += --port_declarations_alignment=align
FORMATTER_OPTS += --named_port_alignment=align

WAVE          := *.vcd
VIEWER        := surfer
VIEWER_SCRIPT := script.sucl

.PHONY: format
format:
	$(FORMATTER) $(FORMATTER_OPTS) $(SRCS)

sim: $(SIM_BIN)
	@$(SIM_BIN) +IMEM=$(IMEM) +VCD=$(VCD)

$(SIM_BIN): $(SRCS) $(TB)
	@mkdir -p $(BUILD_DIR)
	$(SIMULATOR) $(VERILATOR_FLAGS) $(TB) $(SRCS)

.PHONY: debug
debug: prog_debug
	@echo "------------------------------------"
	@echo "Press Crtl-A and then X to exit QEMU"
	@echo "------------------------------------"
	@$(QEMU) $(QFLAGS) -kernel $(PROG_DEBUG_PATH) -s -S

.PHONY: gdb
gdb:
	@$(GDB) $(PROG_DEBUG_PATH) -q -x $(GDBINIT)
	
.PHONY: clean
clean:
	@rm -rf $(BUILD_DIR) $(WAVE)
