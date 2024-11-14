class in_agent;

    in_gen       input_gen;
    in_driver    input_driver;
    in_monitor   input_monitor;

    function new();
        input_gen      = new();
        input_driver   = new();
        input_monitor  = new();
    endfunction

    virtual task run();
        fork
            input_gen.run();
            input_driver.run();
            input_monitor.run();
        join
    endtask

endclass