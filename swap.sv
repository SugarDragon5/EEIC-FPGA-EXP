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
    output reg [31:0] difference;
    reg [10:0] cnt;
    reg [7:0] inx1,iny1,inx2,iny2;
    wire [31:0] out;
    reg [31:0] sum1,sum2;
    distance calc(.x1(inx1),.y1(iny1),.x2(inx2),.y2(iny2),.res(out));
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
                inx1<=x1;
                iny1<=y1;
                inx2<=x2;
                iny2<=y2;
            end else if(cnt==1)begin
                inx1<=x2;
                iny1<=y2;
                inx2<=x3;
                iny2<=y3;
                sum1<=out; //(v1,v2)
            end else if(cnt==2)begin
                inx1<=x4;
                iny1<=y4;
                inx2<=x5;
                iny2<=y5;
                sum1<=sum1+out; //(v2,v3)
            end else if(cnt==3)begin
                inx1<=x5;
                iny1<=y5;
                inx2<=x6;
                iny2<=y6;
                sum1<=sum1+out; //(v4,v5)
            end else if(cnt==4)begin
                inx1<=x1;
                iny1<=y1;
                inx2<=x5;
                iny2<=y5;
                sum1<=sum1+out; //(v5,v6)
            end else if(cnt==5)begin
                inx1<=x5;
                iny1<=y5;
                inx2<=x3;
                iny2<=y3;
                sum2<=out; //(v1,v5)
            end else if(cnt==6)begin
                inx1<=x4;
                iny1<=y4;
                inx2<=x2;
                iny2<=y2;
                sum2<=sum2+out; //(v5,v3)
            end else if(cnt==7)begin
                inx1<=x2;
                iny1<=y2;
                inx2<=x6;
                iny2<=y6;
                sum2<=sum2+out; //(v4,v2)
            end else if(cnt==8)begin
                sum2<=sum2+out; //(v2,v6)
            end else if(cnt==9)begin
                if(sum1>sum2)res<=1;
                else res<=0;
                complete<=1;
                difference<=sum1-sum2;
            end
            cnt<=cnt+1;
        end
    end

endmodule