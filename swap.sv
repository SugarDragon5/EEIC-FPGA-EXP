module checkswap (
    clk,rst,
    x1,y1,
    x2,y2,
    x3,y3,
    x4,y4,
    x5,y5,
    x6,y6,
    res,
    complete,
    difference
);
    input clk;
    input rst;
    input [7:0] x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,x6,y6;
    output reg res;
    output reg complete;
    output reg [18:0] difference;
    reg [10:0] cnt;
    reg [7:0] inx1,iny1,inx2,iny2,inx3,iny3,inx4,iny4;
    wire [18:0] out1,out2;
    reg [18:0] sum1,sum2;
    distance calc1(.clk(clk),.x1(inx1),.y1(iny1),.x2(inx2),.y2(iny2),.res(out1));
    distance calc2(.clk(clk),.x1(inx3),.y1(iny3),.x2(inx4),.y2(iny4),.res(out2));
    always @(posedge clk) begin
        if(rst)begin
            res<=0;
            complete<=0;
            cnt<=0;
            sum1<=0;
            sum2<=0;
            difference<=0;
        end
        else if(complete==0)begin
            if(cnt==0)begin
                //v1->v2 (path1)
                inx1<=x1;
                iny1<=y1;
                inx2<=x2;
                iny2<=y2;
                //v1->v5 (path2)
                inx3<=x1;
                iny3<=y1;
                inx4<=x5;
                iny4<=y5;
            end else if(cnt==1)begin
                //v2->v3 (path1)
                inx1<=x2;
                iny1<=y2;
                inx2<=x3;
                iny2<=y3;
                //v5->v3 (path2)
                inx3<=x5;
                iny3<=y5;
                inx4<=x3;
                iny4<=y3;
            end else if(cnt==2)begin
                //v4->v5 (path1)
                inx1<=x4;
                iny1<=y4;
                inx2<=x5;
                iny2<=y5;
                //v4->v2 (path2)
                inx3<=x4;
                iny3<=y4;
                inx4<=x2;
                iny4<=y2;
            end else if(cnt==3)begin
                //v5->v6 (path1)
                inx1<=x5;
                iny1<=y5;
                inx2<=x6;
                iny2<=y6;
                //v2->v6 (path2)
                inx3<=x2;
                iny3<=y2;
                inx4<=x6;
                iny4<=y6;
            end else if(cnt==6)begin
                sum1<=out1;
                sum2<=out2;
            end else if(7<=cnt&&cnt<=9)begin
                sum1<=sum1+out1;
                sum2<=sum2+out2;
            end else if(cnt==10)begin
                if(sum1>sum2)res<=1;
                else res<=0;
                complete<=1;
                difference<=sum1-sum2;
            end
            cnt<=cnt+1;
        end
    end

endmodule