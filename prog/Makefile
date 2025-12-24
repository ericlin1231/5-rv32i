SRCS      := copy_arr
SIM_DIR   := sims
SPIKE_DIR := spikes

all: $(SRCS) build_dirs

$(SRCS): build_dirs
	@make -C $@

.PHONY: build_dirs
build_dirs:
	@mkdir -p $(SIM_DIR) $(SPIKE_DIR)

.PHONY: clean
clean: 
	@rm -rf $(SIM_DIR) $(SPIKE_DIR)