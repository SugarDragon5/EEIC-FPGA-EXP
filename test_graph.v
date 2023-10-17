`include "graph.v"
`default_nettype none

module tb_graph;
reg clk;
reg rst_n;
wire [31:0] xs[63:0];
wire [31:0] ys[63:0];
wire complete;

graph grp
(
    .rst (rst_n),
    .clk (clk),
    .xs(xs),
    .ys(ys),
    .complete(complete)
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("tb_graph.vcd");
    $dumpvars(0, tb_graph);
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