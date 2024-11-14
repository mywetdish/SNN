class test;

    virtual in_intf vif_in;
    virtual out_intf vif_out;

    test_cfg    cfg;

    env env;

    mailbox#(in_transaction) gen2drv;
    mailbox#(in_transaction) in_mbx;
    mailbox#(out_transaction) out_mbx;

    function new( virtual in_intf vif_in, virtual out_intf vif_out );

        this.vif_in = vif_in;
        this.vif_out = vif_out;

        cfg = new();
        env = new();
        
        gen2drv = new();
        in_mbx  = new();
        out_mbx = new();

        if( !cfg.randomize() ) begin
            $error("Can't randomize test configuration!");
            $finish();
        end

        env.input_ag.input_gen.cfg          = cfg;
        env.scrb.cfg                        = cfg;

        env.input_ag.input_gen.gen2drv          = gen2drv;
        env.input_ag.input_driver.gen2drv       = gen2drv;
        env.input_ag.input_monitor.in_mbx       = in_mbx;
        env.output_ag.output_monitor.out_mbx    = out_mbx;
        env.scrb.in_mbx                         = in_mbx;
        env.scrb.out_mbx                        = out_mbx;

        env.input_ag.input_driver.in_vif        = this.vif_in;
        env.input_ag.input_driver.out_vif       = this.vif_out;
        env.input_ag.input_monitor.in_vif       = this.vif_in;
        env.input_ag.input_monitor.out_vif      = this.vif_out;
        env.output_ag.output_monitor.out_vif    = this.vif_out;
        
    endfunction

    virtual task run();
        bit done;
        fork
            env.run();
            reset_scrb();
            timeout();
        join_none
        wait(env.scrb.done);
        $display("Test was finished!");
        $finish();
    endtask 

    virtual task reset_scrb();
        forever begin
            wait(vif_in.rst);
            env.scrb.in_reset = 1;
            wait(~vif_in.rst);
            env.scrb.in_reset = 0;
        end
    endtask

    task timeout();
        repeat(cfg.test_timeout_cycles) @(posedge vif_in.clk);
        $error("Test timeout!");
        $finish();
    endtask

endclass