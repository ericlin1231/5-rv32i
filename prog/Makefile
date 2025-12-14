SRCS      := copy_arr
SIM_DIR   := sims
SPIKE_DIR := spikes

all: $(SRCS) build_dirs

$(SRCS):
	@make -C $@

build_dirs:
	@mkdir -p $(SIM_DIR) $(SPIKE_DIR)
