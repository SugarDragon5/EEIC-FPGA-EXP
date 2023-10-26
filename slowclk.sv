module slowclk (
    clk,sw,out
);
    input clk;
    input [1:0] sw;
    output reg out;
    reg [31:0] cnt;

    initial begin
        cnt<=0;
        out<=0;
    end
    
    always @(posedge clk or negedge clk) begin
        cnt<=cnt+1;
        if(sw==0)begin
            out<=~out;
        end else if(sw==1)begin
            if(cnt[9:0]==0)begin
                out<=~out;
            end
        end else if(sw==2)begin
            if(cnt[14:0]==0)begin
                out<=~out;
            end
        end else if(sw==3)begin
            if(cnt[19:0]==0)begin
                out<=~out;
            end
        end
    end
endmodule