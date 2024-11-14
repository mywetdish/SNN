class in_gen;

    test_cfg cfg;

    mailbox#(in_transaction) gen2drv;

    virtual task run();
        int cnt = 0;
        in_transaction t;
        repeat(cfg.master_pkt_amount) begin
            t = new();
            t.spike_i = cnt;
            cnt++;
            $display("Spike: %h",t.spike_i);
            gen2drv.put(t);
        end/*
        repeat(cfg.master_pkt_amount) begin
            t = new();
            assert(t.randomize());
            $display("Randomize spike: %h",t.spike_i);
            gen2drv.put(t);
        end*/

    endtask
    
endclass