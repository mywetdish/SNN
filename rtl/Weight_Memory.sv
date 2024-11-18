
module Weight_Memory 

#(
  parameter dataWidth = 16,
  parameter AddrWidth = 10,
  parameter numWeight = 961,
  parameter MEM_FILE = "weight.mem"
)
(
  input logic clk_i,
  input logic [numWeight-1:0] ren,
  input logic [AddrWidth:0] r_addr [0:30],

  output logic [dataWidth-1:0] weight [0:30]
);

logic [dataWidth-1:0] mem [numWeight-1:0];

initial begin
  $readmemb(MEM_FILE, mem);
end

always_comb begin
    for ( int j = 0; j < 31; j++) begin
        weight[j] = ren[r_addr[j]] ? mem[r_addr[j]] : 'd0;
    end
end

endmodule