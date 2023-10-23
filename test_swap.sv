`default_nettype none

module tb_swap;
reg clk;
reg rst_n;
reg [31:0] xs[5:0];
reg [31:0] ys[5:0];
wire res;
wire complete;
checkswap checkswap
(
    .rst (rst_n),.clk (clk),
    .x1(xs[0]), .y1(ys[0]),
    .x2(xs[1]), .y2(ys[1]),
    .x3(xs[2]), .y3(ys[2]),
    .x4(xs[3]), .y4(ys[3]),
    .x5(xs[4]), .y5(ys[4]),
    .x6(xs[5]), .y6(ys[5]),
    .res(res), .complete(complete)
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("tb_swap.vcd");
    $dumpvars(0, tb_swap);
end

initial begin
    #1 rst_n=1'bx;clk=1'b0;
    #(CLK_PERIOD*3)
        rst_n=1;
        xs[0]=32'd00000000;ys[0]=32'd00000000;
        xs[1]=32'd00000010;ys[1]=32'd00000000;
        xs[2]=32'd00000030;ys[2]=32'd00000000;
        xs[3]=32'd00000060;ys[3]=32'd00000000;
        xs[4]=32'd00000100;ys[4]=32'd00000000;
        xs[5]=32'd00000150;ys[5]=32'd00000000;

    #(CLK_PERIOD*3) rst_n=0;
    repeat(15) @(posedge clk);
    #(CLK_PERIOD*3)
        rst_n=1;
        xs[0]=32'd00000000;ys[0]=32'd00000000;
        xs[1]=32'd00000100;ys[1]=32'd00000000;
        xs[2]=32'd00000030;ys[2]=32'd00000000;
        xs[3]=32'd00000060;ys[3]=32'd00000000;
        xs[4]=32'd00000010;ys[4]=32'd00000000;
        xs[5]=32'd00000150;ys[5]=32'd00000000;
    #(CLK_PERIOD*3) rst_n=0;
    repeat(15) @(posedge clk);
    $finish(2);
end

endmodule
`default_nettype wire