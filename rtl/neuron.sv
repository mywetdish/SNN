module neuron 
#(
      parameter numWeight = 961,
      parameter INT_WIDTH = 5,
      parameter FRAC_WIDTH = 11,
      parameter H = 16'b0001000010110100, //potential_threshold_value
      parameter tv = 2, //membrane_leakage_time
      parameter TQ = 9, //the time tϴ necessary for the threshold potential to reach its basic value after a single stand-alone firing (msec) 
      parameter Tk = 16'b0000000011101001,
      parameter a = 16'b0000000000011010,//  the threshold potential increment
      parameter A = 10'd512,
      parameter MEM_FILE= "weight.mem"
  
)

(
    input logic  clk_i,
    input logic  rst_i,
    input logic [numWeight-1:0] spike_i,

    output logic spike_o,
    output logic next_stage

);

parameter AddrWidth = $clog2(numWeight);
parameter dataWidth = INT_WIDTH + FRAC_WIDTH;

logic [numWeight-1:0] ren;

logic stop;
logic spike_rst;

logic [10:0] cnt;
logic stage_1;

logic [numWeight-1:0] spike_i_latch;

logic [AddrWidth:0] r_addr [0:30];
logic [dataWidth-1:0] weight [0:30];

logic [64:0] result_temp [0:30];

logic signed  [22:0] potential_threshold;


logic [22:0] basic_potential_threshold;

always_ff @ ( posedge clk_i ) begin
  if ( rst_i | next_stage )
    cnt <= 'd0;
  else begin
    cnt <= cnt + 1;
  end
end

always_ff @ ( posedge clk_i ) begin
  if ( rst_i )
    stage_1 <= 0;
  else
    stage_1 <= ( cnt == 30 ) ;
    //stage_1 <= ( (cnt >= 31) && ( cnt <= 63));
end

always_ff @ ( posedge clk_i ) begin
  if ( rst_i )
    next_stage <= 0;
  else
    next_stage <= ( cnt == 31 ) ;
end


always_ff @( posedge clk_i ) begin
  if ( rst_i )
    ren <= 'd0;
  else if ( next_stage )
    ren <= spike_i;
  else
    ren <= ren;
end

always_ff @ ( posedge clk_i ) begin
  if ( rst_i | next_stage)
    spike_i_latch <= 'd0;
  else
  spike_i_latch <= spike_i;
end

always_ff @ ( posedge clk_i ) begin
  if ( rst_i )
    basic_potential_threshold <= {8'd0 , H };// : {{48{1'd1}} , H };
  else if ( basic_potential_threshold < H )
    basic_potential_threshold <= {8'd0 , H };
  else if ( spike_o )
    basic_potential_threshold <= basic_potential_threshold + Tk;
  else if ( next_stage )
    basic_potential_threshold <= basic_potential_threshold - a;
  else
    basic_potential_threshold <= basic_potential_threshold;
end


always_ff @ ( posedge clk_i ) begin
  for ( int i = 0; i < 31; i++ ) begin
    for ( int j = (i)*31; j < (i)*31+30; j ++) begin
      if ( rst_i | next_stage)
        r_addr[i] <= j - 29 ;
      else if ( stop )
        r_addr[i] <= r_addr[i];
      else if ( next_stage )
        r_addr[i]  <= 'd0;
      else
        r_addr[i] <= r_addr[i] + 1;
    end
  end
end

assign stop = ( r_addr[0] == 'd30 ) && ( spike_i_latch == spike_i );


always_ff @ ( posedge clk_i ) begin
  for ( int i = 0; i < 31; i++ ) begin
      if ( rst_i | next_stage )
        result_temp[i] <= 'd0;
      else if ( stage_1 )
        result_temp[i] <= result_temp[i];
      else
        result_temp[i] <= $signed(result_temp[i]) + $signed(weight[i]);
    end
end

always_comb begin
  if ( (potential_threshold) < 0)
    potential_threshold = 'd0;
  else if ( ( rst_i | ( next_stage && spike_o) ) )
    potential_threshold = 'd0;
  else if ( stage_1 )
    for ( int i = 0; i < 31; i ++ ) begin
      potential_threshold = (potential_threshold) + $signed(result_temp[i]);
    end
  else if ( next_stage && ~spike_o )
    potential_threshold =  ( potential_threshold * A ) >>> 10;
  else
    potential_threshold = potential_threshold;
end

always_ff @ ( posedge clk_i ) begin
  if ( ((potential_threshold) >= $signed(basic_potential_threshold)) && stage_1 ) begin 
    spike_o = 1;
    spike_rst = 1;
  end
  else begin
    spike_o = 0;
    spike_rst = 0;
  end
    
end


Weight_Memory #(.numWeight(numWeight),.AddrWidth(AddrWidth),.dataWidth(dataWidth), .MEM_FILE(MEM_FILE)) WM(
        .clk_i(clk_i),
        .ren(ren),
        .r_addr(r_addr),
        .weight(weight)
    );

endmodule