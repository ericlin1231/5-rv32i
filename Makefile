ISA := rv32i

TB  := tb/tb_top_vcs.sv
TOP := src/top_axi.sv
SRCS := $(wildcard src/pkgs/*.sv)
SRCS += $(wildcard src/axi/*.sv)
SRCS += $(wildcard src/stages/*.sv)
SRCS += $(wildcard src/buffers/*.sv)
SRCS += $(wildcard src/sub_modules/*.sv)
SRCS += $(wildcard src/peripheral/*.sv)
SRCS += src/cpu.sv
SRCS += $(TB) $(TOP)

SIMULATOR := vcs
COMPILE_OPTS := -q -R -sverilog $(SRCS) -debug_access+all -full64
COMPILE_OPTS += +IMEM=prog/sims/copy_arr_sim.hex
COMPILE_OPTS += +notimingcheck +error+1000

VIEWER := verdi
WAVE := wave.fsdb
VIEWER_OPTS := -sswr signal.rc

QEMU   := qemu-system-riscv32
QFLAGS := -nographic -smp 1 -machine virt -bios none

GDB     := gdb
GDBINIT := gdbinit

all: prog sim
	$(VIEWER) $(VIEWER_OPTS) $(WAVE)

.PHONY: sim
sim: prog
	$(SIMULATOR) $(COMPILE_OPTS)

SPIKE_ELF_BASE := 0x80000000
SPIKE_ELF_SIZE := 0x20000
.PHONY: golden
golden: prog
	spike -l -m$(SPIKE_ELF_BASE):$(SPIKE_ELF_SIZE) --isa=$(ISA) +signature=golden.sig --signature=golden.sig prog/spikes/copy_arr_spike
	xxd -r -p golden.sig sig.raw
	xxd -p -c 4 sig.raw > golden.sig
	mkdir -p golden
	mv golden.sig golden

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
	make -C prog

.PHONY: clean
clean:
	@rm -rf golden