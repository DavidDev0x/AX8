SRC_DIR   := src
TB_DIR    := tb
BUILD_DIR := build

IVERILOG := iverilog # Path to the icarus-verilog binary
VVP      := vvp      # Path to the vvp binary
GTKWAVE  := gtkwave  # Path to the gtkwave binary

FILELIST := files.f

IFLAGS := -g2012 -Wall

# Each entry: name of module = name of .v file (without extension)
MODULES := full_adder

.PHONY: all
all: $(BUILD_DIR)/%_sim $(BUILD_DIR)/%.vcd

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/%_sim: $(TB_DIR)/%_tb.v $(FILELIST) $(wildcard $(SRC_DIR)/*.v) | $(BUILD_DIR)
	$(IVERILOG) $(IFLAGS) -f $(FILELIST) -o $@ $(TB_DIR)/$*_tb.v

$(BUILD_DIR)/%.vcd: $(BUILD_DIR)/%_sim
	cd $(BUILD_DIR) && $(VVP) $(notdir $<)
	@echo "== $* simulation complete =="

.PHONY: wave_%
wave_%: $(BUILD_DIR)/%.vcd
	$(GTKWAVE) $^ &

.PRECIOUS: $(BUILD_DIR)/%_sim $(BUILD_DIR)/%.vcd

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
