class in_driver;

    virtual in_intf in_vif;
    virtual out_intf out_vif;
    
    mailbox#(in_transaction) gen2drv;

    virtual task run();
        in_transaction t;
        //in_vif.spike_i <= '0;
        forever begin
            fork
                forever begin
                    drive_input(t); 
                end
            join_none
            wait(in_vif.rst);
            disable fork;
            reset_input(t);
            wait(~in_vif.rst);
        end
    endtask

    virtual task reset_input(in_transaction t);
        in_vif.spike_i <= '0;
    endtask

    virtual task drive_input(in_transaction t);
        wait(out_vif.valid_spike);
            gen2drv.get(t);
            in_vif.spike_i <= t.spike_i;
        @(posedge in_vif.clk);
        @(posedge in_vif.clk);
        @(posedge in_vif.clk);
    endtask

endclass