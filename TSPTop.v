module TSPTop(	input CLOCK_50,
	input [1:0]  SW,
	output [3:0] LEDR,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	input 	     nrst    
);
    wire rst;
    function inv(input in);
        inv=~nrst;
    endfunction
    assign rst=inv(nrst);
    TSPTop_wrap top(
        .CLOCK_50(CLOCK_50),
        .SW(SW),
        .LEDR(LEDR),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .rst(rst)
    );
endmodule
