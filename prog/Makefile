ISA = rv32i

SRCS   := bit_operation copy_arr
SIM_DIR   := sims
SPIKE_DIR := spikes
GOLDEN    := golden

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
	@$(MAKE) -j $(addsuffix .golden, $(SRCS))

%.golden:
	@spike -l -m$(SPIKE_ELF_BASE):$(PROG_MAX_SIZE) --isa=$(ISA) \
		+signature=$*_golden.txt                                \
		--signature=$*_golden.txt                               \
		--signature-granularity=4                               \
		spikes/$*_spike
	@mv $*_golden.txt $(GOLDEN)/

.PHONY: clean
clean:
	@$(MAKE) -j $(addsuffix .clean, $(SRCS))
	@rm -rf $(SIM_DIR) $(SPIKE_DIR) $(GOLDEN)

.PHONY: build_dirs
build_dirs:
	@mkdir -p $(SIM_DIR) $(SPIKE_DIR) $(GOLDEN)