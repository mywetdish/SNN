`timescale 1ns / 1ps

module snn
#(
      parameter numWeight = 961,
      parameter INT_WIDTH = 7,
      parameter FRAC_WIDTH = 9,
      parameter H = 16'b0001000100010000, //potential_threshold_value
      parameter tv = 2, //membrane_leakage_time
      parameter TQ = 9, //the time tϴ necessary for the threshold potential to reach its basic value after a single stand-alone firing (msec) 
      parameter Tk = 16'b0000000011101001,
      parameter a = 16'b0000000000011010,
      parameter MEM_FILE_0 = "weight0.mem",
      parameter MEM_FILE_1 = "weight1.mem",
      parameter MEM_FILE_2 = "weight2.mem"

)

(
    input logic  clk_i,
    input logic  rst_i,
    input logic [numWeight-1:0] spike_i,

    output logic [2:0]  spike_o,
    output logic next_stage

);

logic [numWeight-1:0] spike;


delay delay0 ( 
        .spike_i   (spike_i),
        .clk_i     ( clk_i ),
        .rst_i     ( rst_i ),
        .next_stage( next_stage),
        .spike_o   (spike)

);

neuron #(.numWeight(numWeight), .a(a), .MEM_FILE ( MEM_FILE_0 ), .INT_WIDTH(INT_WIDTH),.FRAC_WIDTH(FRAC_WIDTH), .H(H), .tv(tv), .TQ(TQ), .Tk(Tk)) neuron0(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .spike_i(spike),
        .spike_o(spike_o[0]),
        .next_stage(next_stage)


);

neuron #(.numWeight(numWeight), .a(a), .MEM_FILE ( MEM_FILE_1 ), .INT_WIDTH(INT_WIDTH),.FRAC_WIDTH(FRAC_WIDTH), .H(H), .tv(tv),  .TQ(TQ), .Tk(Tk)) neuron1(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .spike_i(spike),
        .spike_o(spike_o[1])
);

neuron #(.numWeight(numWeight), .a(a), .MEM_FILE ( MEM_FILE_2 ), .INT_WIDTH(INT_WIDTH),.FRAC_WIDTH(FRAC_WIDTH), .H(H), .tv(tv),  .TQ(TQ), .Tk(Tk)) neuron2(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .spike_i(spike),
        .spike_o(spike_o[2])
);


endmodule