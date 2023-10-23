`include "graph.sv"
`include "swap.sv"
module tsp (
    clk,rst,xs,ys,path,performance
);
    input clk,rst;
    output wire [31:0] xs[63:0],ys[63:0];
    output reg [31:0] path[63:0];
    output wire [31:0] performance;
    wire complete_graph_gen;
    reg [31:0] stage;
    reg [31:0] cnt;
    reg [31:0] v1,v2;
    graph graph(
        .clk(clk),.rst(rst),
        .xs(xs),.ys(ys),
        .complete(complete_graph_gen)
    );
    reg [31:0] rnd_val;
    xorshift xorshift1(.rst(rst),.clk(clk),.res(rnd_val));
    reg [31:0] x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,x6,y6;
    reg rst_swap;
    reg should_swap, complete_check_swap;
    reg [31:0] swap_difference;
    reg [31:0] total_difference;
    assign performance=total_difference;
    checkswap checkswap1(
        .clk(clk),.rst(rst_swap),
        .x1(x1),.y1(y1),
        .x2(x2),.y2(y2),
        .x3(x3),.y3(y3),
        .x4(x4),.y4(y4),
        .x5(x5),.y5(y5),
        .x6(x6),.y6(y6),
        .res(should_swap),
        .complete(complete_check_swap),
        .difference(swap_difference)
    );
    always @(posedge clk ) begin
        if(rst)begin
            stage<=0;
            cnt<=0;
            total_difference<=0;
        end else if(stage==0)begin
            //グラフの生成とパスの初期化
            path[cnt]<=cnt;
            cnt<=cnt+1;
            if(complete_graph_gen && cnt>=64)begin
                stage<=1;
                cnt<=0;
            end
        end else if(stage==1)begin
            if(cnt==0)begin
                v1<=rnd_val%62+1;   //todo
                cnt<=cnt+1;
            end else if(cnt==1) begin
                v2<=rnd_val%62+1;   //todo
                cnt<=cnt+1;
            end else begin
                if(v1==v2 || v1+1==v2 || v2+1==v1)begin
                    v2<=rnd_val%62+1;   //todo
                    cnt<=cnt+1;
                end else begin
                    x1<=xs[path[v1-1]]; y1<=ys[path[v1-1]];
                    x2<=xs[path[v1]]; y2<=ys[path[v1]];
                    x3<=xs[path[v1+1]]; y3<=ys[path[v1+1]];
                    x4<=xs[path[v2-1]]; y4<=ys[path[v2-1]];
                    x5<=xs[path[v2]]; y5<=ys[path[v2]];
                    x6<=xs[path[v2+1]]; y6<=ys[path[v2+1]];
                    stage<=2;
                    cnt<=0;
                    rst_swap<=1;
                end
            end
        end else if(stage==2)begin
            if(rst_swap)begin
                rst_swap<=0;
            end else if(complete_check_swap)begin
                if(should_swap)begin
                    path[v1]<=path[v2];
                    path[v2]<=path[v1];
                    total_difference+=swap_difference;
                end
                stage<=1;
                cnt<=0;
            end
        end
    end
    
endmodule