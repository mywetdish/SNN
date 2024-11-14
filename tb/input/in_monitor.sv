class in_monitor;

    virtual in_intf in_vif;
    virtual out_intf out_vif;

    mailbox#(in_transaction) in_mbx;

    virtual task run();
        forever begin
            wait(~in_vif.rst);
            fork
                forever begin
                    monitor_input();
                end
            join_none
            wait(in_vif.rst);
            disable fork;
        end        
    endtask

    virtual task monitor_input();
        in_transaction t;
        t = new();
        wait(out_vif.valid_spike);
        @(posedge in_vif.clk);
        t.spike_i = in_vif.spike_i;
        in_mbx.put(t);
        @(posedge in_vif.clk);
        @(posedge in_vif.clk);
    endtask

endclass