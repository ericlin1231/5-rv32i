TOP ?= top
SRCS += test/$(TOP).sv 
SRCS += $(wildcard peripheral/*.sv)
SRCS += $(wildcard stages/*.sv)
SRCS += $(wildcard buffers/*.sv)
PROGRAM_SRCS += $(wildcard program/asm/*.s)
PROGRAM_SRCS += $(wildcard program/c/*.c)
PROGRAM_SRCS_HEX := program/hex
TARGET_PROGRAM ?= add.s
TARGET_PROGRAM_HEX := $(PROGRAM_SRCS_HEX)/$(TARGET_PROGRAM)

SIMULATION := sim/sim_$(TOP).cpp
SIMULATOR := verilator
SIMULATOR_OPTS := --sv --top-module $(TOP) --trace --build -j 0
SIMULATION_BIN := $(notdir $(basename $(SIMULATION)))
WAVE := *.vcd
VIEWER := surfer
VIEWER_SCRIPT := script.sucl

sim: $(SRCS) $(SIMULATION) program
	$(SIMULATOR) $(SIMULATOR_OPTS) \
		-cc $(SRCS) -exe $(SIMULATION) -o $(SIMULATION_BIN)
	./obj_dir/$(BIN) +IMEM=$(TARGET_PROGRAM_HEX)
	$(VIEWER) -c $(VIEWER_SCRIPT)

prog: $(PROGRAM_SRCS)
	@make -C program/asm

clean:
	@rm -rf obj_dir $(WAVE)
	@make -C program clean

.PHONY: sim program clean
