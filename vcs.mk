DUT  := tb/tb_top_vcs.sv
SRCS := src/defs.sv
SRCS += src/cpu.sv
SRCS += $(wildcard src/header/*.svh)
SRCS += $(wildcard src/axi/*.sv)
SRCS += $(wildcard src/stages/*.sv)
SRCS += $(wildcard src/buffers/*.sv)
SRCS += $(wildcard src/sub_modules/*.sv)
SRCS += $(wildcard src/peripheral/*.sv)
SRCS += $(DUT)

SIMULATOR := vcs
COMPILE_OPTS := -q -R -sverilog -debug_access+all -full64
COMPILE_OPTS += +incdir+src +notimingcheck +error+1000

all:
	$(SIMULATOR) $(COMPILE_OPTS) $(SRCS)
