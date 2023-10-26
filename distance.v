module distance (x1,y1,x2,y2,res);
    input [7:0] x1;
    input [7:0] y1;
    input [7:0] x2;
    input [7:0] y2;
    output [31:0] res;
    
    wire [31:0] xd,yd;
    wire [31:0] distance_sq;
    wire [31:0] distance_mh;
    wire [31:0] a;
    wire [31:0] b;
    wire [31:0] c;

    function [31:0] subtract_abs(input [7:0] a,input [7:0] b);
    begin
        if(a>b)subtract_abs=a-b;
        else subtract_abs=b-a;
    end
    endfunction

    function [31:0] square_distance (input [31:0] x_diff, input [31:0] y_diff);
        square_distance=x_diff*x_diff+y_diff*y_diff;
    endfunction

    function [31:0] manhattan_distance (input [31:0] x_diff, input [31:0] y_diff);
    begin
        manhattan_distance = x_diff+y_diff;
    end
    endfunction

    function [31:0] newton_sqrt(input[31:0] x,input[31:0] current);
        newton_sqrt=(current+x/current)/2;
    endfunction

    assign xd=subtract_abs(x1,x2);
    assign yd=subtract_abs(y1,y2);
    assign distance_sq=square_distance(xd,yd);
    assign distance_mh=manhattan_distance(xd,yd);
    assign a=newton_sqrt(distance_sq,distance_mh); 
    assign b=newton_sqrt(distance_sq,a); 
    assign c=newton_sqrt(distance_sq,b);
    assign res=c; 
endmodule