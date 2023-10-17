`include "xorshift.v"
module graph
(
    rst,clk,xs,ys,complete
);
    input rst;
    input clk;
    output reg [31:0] xs[63:0];
    output reg [31:0] ys[63:0];
    output reg complete;
    wire [31:0] rnd_val;
    reg [10:0] cnt;

    xorshift rnd(
        .rst(rst),
        .clk(clk),
        .res(rnd_val)
    );

    always @(posedge clk ) begin
        if(rst)begin
            cnt<=0;
            complete<=0;
        end
        else if(complete==0)begin
            // x座標の初期化
            if(cnt<64) begin
                xs[cnt]<=rnd_val;
            end
            // y座標の初期化
            else if(cnt<2*64) begin
                ys[cnt-64]<=rnd_val[7:0];
            end else begin
                complete<=1;
            end
            cnt<=cnt+1;
        end
    end
endmodule
