# Top simulation module select
TOP = tb_top

# Output directory
OUT = build

# Compilation options
COMP_OPTS = -sv -work work $(ALL)

# Simulation options
SIM_OPTS = -sv_lib arnix_lib_api/libArnixFifo \
           -do do.tcl \
           -voptargs="+acc" \
           -l $(OUT)/sim.log

# All Verilog / SystemVerilog files from example directory
TESTBENCH = tb/package/test_pkg.sv tb/tb_top.sv tb/interfaces/*.sv
DUT = rtl/*.sv 

ALL = $(TESTBENCH) $(DUT)

# Verbosity
v =

.PHONY: run compile clean connect create_fifo delete_fifo

# Run target
run: compile
	$(v)vsim work.$(TOP) $(SIM_OPTS)

# Clean target
clean:
	rm -rf $(OUT)

# Compile target
ifneq ($(ALL),) # Guard on compilation only from existing example
compile: $(ALL) $(OUT)
	$(v)vlib $(OUT)/work > $(OUT)/compile.log
	$(v)vmap work $(OUT)/work >> $(OUT)/compile.log
	$(v)vlog $(COMP_OPTS) >> $(OUT)/compile.log
endif

# Output directory target
$(OUT):
	@mkdir -p $@

create_fifo: 
	mkfifo arnix_lib_api/ArNI_FIFO/fifo_arni
	mkfifo arnix_lib_api/ArNI_FIFO/fifo_dpi

delete_fifo:
	rm -rf arnix_lib_api/ArNI_FIFO/fifo_arni
	rm -rf arnix_lib_api/ArNI_FIFO/fifo_dpi