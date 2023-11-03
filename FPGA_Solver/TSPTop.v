module TSPTop(	input CLOCK_50,
	input [1:0]  SW,
	output [3:0] LEDR,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	output [6:0] HEX5,
	input 	     nrst    
);
    wire rst;
    function inv(input in);
        inv=~nrst;
    endfunction
	 
	 wire sclk;
	 wire locked;
	 pll pll1(
		.refclk(CLOCK_50),   //  refclk.clk
		.rst(0),      //   reset.reset
		.outclk_0(sclk), // outclk0.clk
		.locked(locked)    //  locked.export
	);
	 
    assign rst=inv(nrst);
    TSPTop_wrap top(
        .clk(sclk),
        .SW(SW),
        .LEDR(LEDR),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5),
        .rst(rst)
    );

endmodule
