 class test_cfg;
         int master_pkt_amount    = 50;
         int test_timeout_cycles  = 10000000;
         
    function void post_randomize();
        string str;
        str = {str, $sformatf("master_pkt_amount  : %0d\n", master_pkt_amount  )};
        str = {str, $sformatf("test_timeout_cycles: %0d\n", test_timeout_cycles)};
        $display(str);
    endfunction
endclass