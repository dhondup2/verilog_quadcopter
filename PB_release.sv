module PB_release (clk, rst_n, PB, released);

input clk, rst_n, PB;
output released;


logic PB1;
logic PB2;
logic PB3;

always_ff @ (posedge clk, negedge rst_n) begin
  if (~rst_n) begin
   PB1 <= 1'b1;
   PB2 <= 1'b1;
   PB3 <= 1'b1;
end
  else begin
   PB1 <= PB;
   PB2 <= PB1;
   PB3 <= PB2;
end

end

assign released = PB2 & (~PB3);

endmodule

