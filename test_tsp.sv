`include "tsp.sv"
`default_nettype none

module tb_tsp;
reg clk;
reg rst_n;
wire [31:0] xs[63:0],ys[63:0];
wire [31:0] path[63:0];

tsp tsp1
(
    .rst (rst_n),
    .clk (clk),
    .xs (xs),
    .ys (ys),
    .path (path)
);

localparam CLK_PERIOD = 5;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("tb_tsp.vcd");
    $dumpvars(0, tb_tsp);
end

integer i;

initial begin
    #1 rst_n<=1'bx;clk<=1'b0;
    #(CLK_PERIOD*3) rst_n<=1;
    #(CLK_PERIOD*3) rst_n<=0;
    repeat(10000) @(posedge clk);
    $display("xs, ys");
    for(i=0;i<64;i++)begin
        $display("%d, %d",xs[i],ys[i]);
    end
    $display("path");
    for(i=0;i<64;i++)begin
        $display("%d",path[i]);
    end
    $finish(2);
end

endmodule
`default_nettype wire