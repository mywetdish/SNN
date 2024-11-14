class scoreboard;

    test_cfg cfg;

    bit [2:0] arnix_out;
    bit in_reset;
    bit done;

    int cnt;

    mailbox#(in_transaction) in_mbx;
    mailbox#(out_transaction) out_mbx;

    virtual task run();
        done = 0;
        cnt = 0;
        forever begin  
            wait(~in_reset);
            fork
                forever begin
                    do_check();
                end
            join_none
            wait(in_reset);
            disable fork;
        end
    endtask

    virtual task do_check();
        in_transaction in_t;
        out_transaction out_t;
        forever begin
            
            in_mbx.get(in_t);
            out_mbx.get(out_t);
            //$display("SCOREBOARD IN: %h\nSCOREBOARD OUT: %b\n",in_t.spike_i,out_t.spike_o);
            arnix_fifo(in_t.spike_i, 961, 3, arnix_out);
            if ( out_t.spike_o !== arnix_out ) begin
                $error("%d: %0t Invalid OUT: Real: %b, Expected: %b\nIn: %h\n", cnt, $time(), out_t.spike_o, arnix_out, in_t.spike_i);
            end
            else begin
                $display("%d: Transaction was Successful\nOut: %b\nIn: %h\n", cnt, out_t.spike_o, in_t.spike_i);
            end
            cnt = cnt + 1;
            if ( cnt == cfg.master_pkt_amount ) begin
                done = 1;
                break;
            end
        end
    endtask

endclass