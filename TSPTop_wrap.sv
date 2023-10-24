module TSPTop_wrap(
    input clk,
	input [1:0]  SW,
	output [3:0] LEDR,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	output [6:0] HEX5,
	input 	     rst    
);
    reg [31:0] cnt;
    wire [7:0] xs[63:0],ys[63:0];
    wire [31:0] performance;
    wire [5:0] path[63:0];
    tsp tsp1(
        .clk(clk),
        .rst(rst),
        .xs(xs),
        .ys(ys),
        .path(path),
        .performance(performance)
    );
    reg [3:0] digits[5:0];
    seg7 seg0(.in(digits[0]),.out(HEX0));
    seg7 seg1(.in(digits[1]),.out(HEX1));
    seg7 seg2(.in(digits[2]),.out(HEX2));
    seg7 seg3(.in(digits[3]),.out(HEX3));
    seg7 seg4(.in(digits[4]),.out(HEX4));
    seg7 seg5(.in(digits[5]),.out(HEX5));
    always @(posedge clk) begin
        cnt<=cnt+1;
        if(!cnt[24:0])begin
            digits[0]<=performance[3:0];
            digits[1]<=performance[7:4];
            digits[2]<=performance[11:8];
            digits[3]<=performance[15:12];
            digits[4]<=performance[19:16];
            digits[5]<=performance[23:20];
        end
    end
endmodule
