`include "xorshift.v"
`default_nettype none

module tb_xorshift;
reg clk;
reg rst_n;

xorshift rand(.rst (rst_n), .clk (clk));

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("tb_xorshift.vcd");
    $dumpvars(0, tb_xorshift);
end

initial begin
    #1 rst_n<=1'bx;clk<=1'bx;
    #(CLK_PERIOD*3) rst_n<=1;
    #(CLK_PERIOD*3) rst_n<=0;clk<=0;
    repeat(100) @(posedge clk);
    rst_n<=1;
    @(posedge clk);
    repeat(2) @(posedge clk);
    $finish(2);
end

endmodule
`default_nettype wire