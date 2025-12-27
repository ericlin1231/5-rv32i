ISA := rv32i
SIM_DEBUG_BASE := 00020000 # memory dump address to compare with golden

PROG_SRCS := bitwise    \
			 arithmetic \
			 fibonacci

TB  := tb/tb_top.sv
TOP := src/top_axi.sv
SRCS := src/pkgs/CPU_profile.sv          \
		src/pkgs/decode.sv               \
		src/pkgs/CPU_buffer_bus.sv       \
		src/pkgs/AXI_define.sv           \
		src/pkgs/tracer.sv               \
		$(wildcard src/axi/*.sv)         \
		$(wildcard src/stages/*.sv)      \
		$(wildcard src/buffers/*.sv)     \
		$(wildcard src/sub_modules/*.sv) \
		$(wildcard src/peripheral/*.sv)  \
		src/cpu.sv                       \
		$(TB) $(TOP)

SIMULATOR := vcs
COMPILE_OPTS := -q -R -sverilog $(SRCS) -debug_access+all -full64 \
				+DEBUG_BASE=$(SIM_DEBUG_BASE) +define+TRACE       \
				+notimingcheck +fsdb+no_logo

VIEWER := verdi
WAVE := wave.fsdb
VIEWER_OPTS := -sswr trace_dmem_write.rc

QEMU   := qemu-system-riscv32
QFLAGS := -nographic -smp 1 -machine virt -bios none

GDB     := gdb
GDBINIT := gdbinit

all: sim
	@echo ""
	@echo "---------------------------------------------------"
	@echo "verdi log"
	@echo "---------------------------------------------------"
	@echo ""
	@$(VIEWER) $(VIEWER_OPTS) $(WAVE)

.PHONY: sim
sim: golden
	@$(MAKE) $(addsuffix .sim, $(PROG_SRCS))

%.sim:
	@echo ""
	@echo "---------------------------------------------------"
	@echo "simulation with program $*"
	@echo "---------------------------------------------------"
	@echo ""
	@$(SIMULATOR) $(COMPILE_OPTS) +TESTCASE=$*

.PHONY: golden
golden: prog
	$(MAKE) -C prog golden

.PHONY: debug
debug: prog
	@echo "------------------------------------"
	@echo "Press Crtl-A and then X to exit QEMU"
	@echo "------------------------------------"
	@$(QEMU) $(QFLAGS) -kernel $(PROG_DEBUG_PATH) -s -S

.PHONY: gdb
gdb:
	@$(GDB) $(PROG_DEBUG_PATH) -q -x $(GDBINIT)

.PHONY: prog
prog:
	@$(MAKE) -C prog

.PHONY: clean
clean:
	@$(MAKE) -C prog clean