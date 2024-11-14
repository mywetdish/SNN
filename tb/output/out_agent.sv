class out_agent;

    out_monitor output_monitor;

    function new();
        output_monitor = new();
    endfunction

    virtual task run();
        fork
            output_monitor.run();
        join
    endtask

endclass