`default_nettype none

module tb_TSPTop_wrap;
reg clk;
reg rst_n;

reg [1:0]  SW;
wire [3:0] LEDR;
wire [6:0] HEX0;
wire [6:0] HEX1;
wire [6:0] HEX2;
wire [6:0] HEX3;
wire [6:0] HEX4;
wire [6:0] HEX5;

TSPTop_wrap tp
(
    .clk(clk),
	.SW(SW),
	.LEDR(LEDR),
	.HEX0(HEX0),
	.HEX1(HEX1),
	.HEX2(HEX2),
	.HEX3(HEX3),
	.HEX4(HEX4),
	.HEX5(HEX5),
	.rst(rst_n)
);

localparam CLK_PERIOD = 3;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("tb_TSPTop_wrap.vcd");
    $dumpvars(0, tb_TSPTop_wrap);
end
integer i;
initial begin
    #1 rst_n<=1'bx;clk<=1'b0;
    for(i=0;i<10;i++)begin
        #(CLK_PERIOD*3) rst_n<=1;
        #(CLK_PERIOD*3) rst_n<=0;
        repeat(100000) @(posedge clk);
    end
    $finish(2);
end

endmodule
`default_nettype wire