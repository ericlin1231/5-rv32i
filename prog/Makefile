ISA = rv32i

SRCS := write_single_u32 \
		bitwise          \
		arithmetic       \
		load_store       \
		fibonacci        \
		sort
SIM_DIR    := sims
SPIKE_DIR  := spikes
GOLDEN_DIR := golden

SPIKE_ELF_BASE := 0x80000000
PROG_MAX_SIZE  := 0x50000

all: build_dirs
	@$(MAKE) -j $(addsuffix .all, $(SRCS))

%.all:
	@$(MAKE) -C $(patsubst %.all, %, $@) all SIM_DIR=../$(SIM_DIR) SPIKE_DIR=../$(SPIKE_DIR)

%.clean:
	@$(MAKE) -C $(patsubst %.clean, %, $@) clean

.PHONY: golden
golden: all
	@$(MAKE) $(addsuffix .golden, $(SRCS))

%.golden:
	@echo "$* spike running"
	@spike -l -m$(SPIKE_ELF_BASE):$(PROG_MAX_SIZE) --isa=$(ISA) \
		+signature=$*_golden.txt                                \
		--signature=$*_golden.txt                               \
		--signature-granularity=4                               \
		spikes/$*_spike
	@mv $*_golden.txt $(GOLDEN_DIR)/

.PHONY: clean
clean:
	@$(MAKE) -j $(addsuffix .clean, $(SRCS))
	@rm -rf $(SIM_DIR) $(SPIKE_DIR) $(GOLDEN_DIR)

.PHONY: build_dirs
build_dirs:
	@mkdir -p $(SIM_DIR) $(SPIKE_DIR) $(GOLDEN_DIR)