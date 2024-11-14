package test_pkg;

    parameter numWeight = 961;

    import "DPI-C" function void arnix_fifo(input bit [961-1:0] in, input int unsigned in_size, input int unsigned out_size, output bit [2:0] out);

    `include "../input/in_transaction.sv"
    `include "../output/out_transaction.sv"

    `include "../test/test_cfg.sv"

    `include "../output/out_monitor.sv"
    `include "../output/out_agent.sv"

    `include "../input/in_gen.sv"
    `include "../input/in_driver.sv"
    `include "../input/in_monitor.sv"
    `include "../input/in_agent.sv"

    `include "../scoreboard.sv"
    `include "../env.sv"
    `include "../test/test.sv"

endpackage