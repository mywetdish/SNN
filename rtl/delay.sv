
module delay #(
    parameter numWeight = 961
)

(
    input logic  clk_i,
    input logic  rst_i,
    input logic [numWeight-1:0] spike_i,
    input logic  next_stage,

    output logic [numWeight-1:0] spike_o

);

logic [numWeight-1:0] spike;

always_ff @(posedge clk_i) begin
  spike <= spike_i;
end

always_comb begin
  if ( next_stage ) begin
    spike_o = spike;
  end
  else begin
    spike_o = spike_o;
  end

end


endmodule