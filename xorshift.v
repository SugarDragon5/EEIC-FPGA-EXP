module xorshift (rst, clk, res);
    input rst;
    input clk;
    output [31:0] res;
    
    reg [31:0] x;
    reg [31:0] y;
    reg [31:0] z;
    reg [31:0] w;
    assign res=w;
    always @(posedge rst) begin
        x<=123456789;
        y<=362436069;
        z<=521288629;
        w<=88675123;
    end
    always @(posedge clk) begin
        x<=y;
        y<=z;
        z<=w;
        w<=(w^(w>>19))^((x^(x<<11))^((x^(x<<11))>>8));
    end
endmodule