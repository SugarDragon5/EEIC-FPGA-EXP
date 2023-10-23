module distance (x1,y1,x2,y2,res);
    input [31:0] x1;
    input [31:0] y1;
    input [31:0] x2;
    input [31:0] y2;
    output [31:0] res;
    
    wire [31:0] distance_sq;
    wire [31:0] distance_mh;
    wire [31:0] a;
    wire [31:0] b;
    wire [31:0] c;

    function [31:0] square_distance (input [31:0] x1, input[31:0] y1, input [31:0] x2, input [31:0] y2);
        square_distance = (x1-x2)*(x1-x2)+(y1-y2)*(y1-y2);
    endfunction

    function [31:0] manhattan_distance (input [31:0] x1, input[31:0] y1, input [31:0] x2, input [31:0] y2);
    begin
        manhattan_distance = 0;
        if(x1>x2) manhattan_distance=manhattan_distance+x1-x2;
        else manhattan_distance=manhattan_distance+x2-x1;
        if(y1>y2) manhattan_distance=manhattan_distance+y1-y2;
        else manhattan_distance=manhattan_distance+y2-y1;
    end
    endfunction

    function [31:0] newton_sqrt(input[31:0] x,input[31:0] current);
        newton_sqrt=(current+x/current)/2;
    endfunction

    assign distance_sq=square_distance(x1,y1,x2,y2);
    assign distance_mh=manhattan_distance(x1,y1,x2,y2);
    assign a=newton_sqrt(distance_sq,distance_mh); 
    assign b=newton_sqrt(distance_sq,a); 
    assign c=newton_sqrt(distance_sq,b);
    assign res=c; 
endmodule