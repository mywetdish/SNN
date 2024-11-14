class out_monitor;

    virtual out_intf out_vif;

    mailbox#(out_transaction) out_mbx;

    virtual task run();
        wait(out_vif.valid_spike);
        @(posedge out_vif.clk);
        forever begin
            wait(~out_vif.rst);
            fork
                forever begin
                    monitor_output();
                end
            join_none
            wait(out_vif.rst);
            disable fork;
        end        
    endtask

    virtual task monitor_output();
        out_transaction t;
        @(posedge out_vif.clk);
        if( out_vif.valid_spike ) begin
            //@(posedge out_vif.clk);
            t = new();
            t.spike_o = out_vif.spike_o;
            $display("%b",t.spike_o);
            out_mbx.put(t);
        end
    endtask

endclass