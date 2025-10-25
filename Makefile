TOP ?= top
SRCS := test/$(TOP).sv $(wildcard peripheral/*.sv)
SIMULATION := sim/sim_$(TOP).cpp
SIMULATOR := verilator
SIMULATOR_OPTS := --sv --top-module $(TOP) --trace --build -j 0
BIN := $(notdir $(basename $(SIMULATION)))
WAVE ?= wave.vcd
VIEWER := surfer

sim: FORCE
	$(SIMULATOR) $(SIMULATOR_OPTS) \
		-cc $(SRCS) -exe $(SIMULATION) -o $(BIN)
	./obj_dir/$(BIN)
	$(VIEWER) $(WAVE)

clean:
	@rm -rf obj_dir $(WAVE)

.PHONY: clean FORCE
