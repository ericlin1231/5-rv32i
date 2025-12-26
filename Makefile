ISA := rv32i

TB  := tb/tb_top.sv
TOP := src/top_axi.sv
SRCS := src/pkgs/CPU_profile.sv
SRCS += src/pkgs/decode.sv
SRCS += src/pkgs/CPU_buffer_bus.sv
SRCS += src/pkgs/AXI_define.sv
SRCS += src/pkgs/tracer.sv
SRCS += $(wildcard src/axi/*.sv)
SRCS += $(wildcard src/stages/*.sv)
SRCS += $(wildcard src/buffers/*.sv)
SRCS += $(wildcard src/sub_modules/*.sv)
SRCS += $(wildcard src/peripheral/*.sv)
SRCS += src/cpu.sv
SRCS += $(TB) $(TOP)

SIMULATOR := vcs
COMPILE_OPTS := -q -R -sverilog $(SRCS) -debug_access+all -full64
COMPILE_OPTS += +IMEM=prog/sims/copy_arr_sim.hex +DEBUG_BASE=00020000 +define+TRACE
COMPILE_OPTS += +notimingcheck

VIEWER := verdi
WAVE := wave.fsdb
VIEWER_OPTS := -sswr trace_dmem_write.rc

QEMU   := qemu-system-riscv32
QFLAGS := -nographic -smp 1 -machine virt -bios none

GDB     := gdb
GDBINIT := gdbinit

all: sim
	@$(VIEWER) $(VIEWER_OPTS) $(WAVE)

.PHONY: sim
sim: golden
	$(SIMULATOR) $(COMPILE_OPTS)

SPIKE_ELF_BASE := 0x80000000
SPIKE_ELF_SIZE := 0x50000
.PHONY: golden
golden: prog
	@spike -l -m$(SPIKE_ELF_BASE):$(SPIKE_ELF_SIZE) --isa=$(ISA) +signature=golden.sig --signature=golden.sig prog/spikes/copy_arr_spike
	@xxd -r -p golden.sig sig.raw
	@xxd -p -c 4 sig.raw > golden.txt
	@rm golden.sig sig.raw
	@mkdir -p golden
	@mv golden.txt golden

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
	@make -C prog

.PHONY: clean
clean:
	@rm -rf golden