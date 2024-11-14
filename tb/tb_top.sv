`timescale 1ns/1ps

module tb_top;

    import test_pkg::*;

    logic clk;
    logic rst;

    in_intf input_intf(clk,rst);
    out_intf output_intf(clk,rst);

    snn DUT(
        .clk_i          ( clk                      ),
        .rst_i          ( rst                      ),
        .spike_i        ( input_intf.spike_i       ),
        .spike_o        ( output_intf.spike_o      ),
        .next_stage     ( output_intf.valid_spike  )
    );

    parameter CLK_PERIOD = 10;

    task reset();
        rst <= 1;
        #(5*CLK_PERIOD);
        rst <= 0;
    endtask

    initial begin
        clk <= 0;
        forever begin
            #(CLK_PERIOD/2) clk <= ~clk;
        end
    end

    initial begin
        test test;
        test = new(input_intf, output_intf);
        fork
            reset();
            test.run();
        join/*
        repeat(1000) @(posedge clk);
        reset();*/
    end

endmodule