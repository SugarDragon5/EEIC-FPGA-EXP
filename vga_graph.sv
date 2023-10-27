module VGAGraph (
    clk,rst,xs,ys,path,R,G,B
);
    input clk,rst;
    input [63:0][7:0] xs,ys;
    input [63:0][5:0] path;
    output reg [7:0] R,G,B;
    reg [15:0] cnt;
    wire [7:0] X,Y;
    assign X=cnt[7:0];
    assign Y=cnt[15:8];
    integer i;
    always @(posedge clk) begin
        if(rst)begin
            cnt<=0;
        end else begin
            cnt<=cnt+1;
            R<=255;
            G<=255;
            B<=255;
            for(i=0;i<64;i++)begin
                if(X==xs[i]&&Y==ys[i])begin
                    R<=0;
                    G<=0;
                    B<=0;
                end
                if(Y==ys[path[i]]&&(xs[path[i]]<=X&&X<=xs[path[i+1]]||xs[path[i+1]]<=X&&X<=xs[path[i]]))begin
                    R<=0;
                    G<=0;
                    B<={i,2'b00};
                end else if(X==xs[path[i+1]]&&(ys[path[i]]<=Y&&Y<=ys[path[i+1]]||ys[path[i+1]]<=Y&&Y<=ys[path[i]]))begin
                    R<=0;
                    G<=0;
                    B<={i,2'b00};
                end
            end
        end
    end
    
endmodule