module graph
(
    rst,clk,xs,ys,complete
);
    input rst;
    input clk;
    output reg [7:0] xs[63:0];
    output reg [7:0] ys[63:0];
    output reg complete;
    wire [31:0] rand_val;
    reg [10:0] cnt;
    reg [31:0] rand_seed;

    xorshift rnd(
        .rst(rst),
        .clk(clk),
        .res(rand_val),
        .seed(rand_seed)
    );
    initial begin
        rand_seed<=27182818;
    end
    always @(posedge clk ) begin
        if(rst)begin
            cnt<=0;
            complete<=0;
        end
        else if(complete==0)begin
            // x座標の初期化
            if(cnt<64) begin
                xs[cnt]<=rand_val[7:0];
            end
            // y座標の初期化
            else if(cnt<2*64) begin
                ys[cnt-64]<=rand_val[7:0];
            end else begin
                complete<=1;
            end
            cnt<=cnt+1;
        end
    end
endmodule
