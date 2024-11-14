class env;

    in_agent     input_ag;
    out_agent    output_ag;
    scoreboard   scrb;

    function new();
        input_ag    = new();
        output_ag   = new();
        scrb        = new();
    endfunction

    virtual task run();
        fork
            input_ag.run();
            output_ag.run();
            scrb.run();
        join
    endtask

endclass