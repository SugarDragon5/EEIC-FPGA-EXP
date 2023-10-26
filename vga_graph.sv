module VGAGraph (
    clk,rst,xs,ys,path,R,G,B
);
    input clk,rst;
    input [7:0] xs[63:0],ys[63:0];
    input [5:0] path[63:0];
    output [15:0] R[255:0][255:0],G[255:0][255:0],B[255:0][255:0];
    reg cnt[15:0];
    wire [7:0] X,Y;
    assign {X,Y}=cnt;
    integer [5:0] i;
    always @(posedge clk) begin
        if(rst)begin
            cnt<=0;
        end else begin
            cnt<=cnt+1;
            R[X][Y]<=255;
            G[X][Y]<=255;
            B[X][Y]<=255;
            for(i=0;i<64;i++)begin
                if(X==xs[i]&&Y==ys[i])begin
                    R[X][Y]<=0;
                    G[X][Y]<=0;
                    B[X][Y]<=0;
                end
                if(xs[path[i]]<=X&&X<=xs[path[i+1]]||xs[path[i+1]]<=X&&X<=xs[path[i]])begin
                    if(ys[path[i]]<=Y&&Y<=ys[path[i+1]]||ys[path[i+1]]<=Y&&Y<=ys[path[i]])begin
                        if(
                            ((ys[path[i+1]]-ys[path[i]])*(X-xs[path[i]])-(xs[path[i+1]]-xs[path[i]])*(Y-ys[path[i]]))*((ys[path[i+1]]-ys[path[i]])*(i+1-xs[path[i]])-(xs[path[i+1]]-xs[path[i]])*(Y+1-ys[path[i]]))<=0 
                            || ((ys[path[i+1]]-ys[path[i]])*(i+1-xs[path[i]])-(xs[path[i+1]]-xs[path[i]])*(Y-ys[path[i]]))*((ys[path[i+1]]-ys[path[i]])*(i-xs[path[i]])-(xs[path[i+1]]-xs[path[i]])*(Y+1-ys[path[i]]))<=0
                        )begin
                            R[X][Y]<=0;
                            G[X][Y]<=0;
                            B[X][Y]<={i,2'b00};
                        end
                    end
                end
            end
        end
    end
    
endmodule