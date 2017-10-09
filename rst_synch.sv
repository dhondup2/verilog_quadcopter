module rst_synch(clk, RST_n, rst_n);

input clk, RST_n;
output rst_n;

logic FF;
logic rst_n;

always_ff@(negedge clk, negedge RST_n)
    if(!RST_n)begin
        FF <= 1'b0;
        rst_n <= 1'b0;
    end
    else    begin
        FF <= 1'b1;
        rst_n <= FF;
    end
endmodule
