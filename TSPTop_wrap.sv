module TSPTop_wrap(	input CLOCK_50,
	input [1:0]  SW,
	output [3:0] LEDR,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	input 	     rst    
);
    wire [31:0] xs[63:0],ys[63:0];
    wire [31:0] performance;
    wire [31:0] path[63:0];
    tsp tsp1(
        .clk(CLOCK_50),
        .rst(rst),
        .xs(xs),
        .ys(ys),
        .path(path),
        .performance(performance)
    );
    //1の位
    wire [3:0] digit1;
    function [3:0] calc_digit1(input [31:0] performance);
        calc_digit1=performance%10;
    endfunction
    assign digit1=calc_digit1(performance);
    seg7 seg70(
        .in(digit1),
        .out(HEX0)
    );
    //10の位
    wire [3:0] digit10;
    function [3:0] calc_digit10(input [31:0] performance);
        calc_digit10=performance/10%10;
    endfunction
    assign digit10=calc_digit10(performance);
    seg7 seg71(
        .in(digit10),
        .out(HEX1)
    );
    //100の位
    wire [3:0] digit100;
    function [3:0] calc_digit100(input [31:0] performance);
        calc_digit100=performance/100%10;
    endfunction
    assign digit100=calc_digit100(performance);
    seg7 seg72(
        .in(digit100),
        .out(HEX2)
    );
    //1000の位
    wire [3:0] digit1000;
    function [3:0] calc_digit1000(input [31:0] performance);
        calc_digit1000=performance/1000%10;
    endfunction
    assign digit1000=calc_digit1000(performance);
    seg7 seg73(
        .in(digit1000),
        .out(HEX3)
    );
    //10000の位
    wire [3:0] digit10000;
    function [3:0] calc_digit10000(input [31:0] performance);
        calc_digit10000=performance/10000%10;
    endfunction
    assign digit10000=calc_digit10000(performance);
    seg7 seg74(
        .in(digit10000),
        .out(HEX4)
    );   
endmodule
