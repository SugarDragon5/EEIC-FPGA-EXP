`include "tsp.sv"
`default_nettype none

module tb_tsp;
reg clk;
reg rst_n;

tsp tsp1
(
    .rst (rst_n),
    .clk (clk)
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("tb_tsp.vcd");
    $dumpvars(0, tb_tsp);
end

initial begin
    #1 rst_n<=1'bx;clk<=1'b0;
    #(CLK_PERIOD*3) rst_n<=1;
    #(CLK_PERIOD*3) rst_n<=0;
    repeat(1000) @(posedge clk);
    $finish(2);
end

endmodule
`default_nettype wire