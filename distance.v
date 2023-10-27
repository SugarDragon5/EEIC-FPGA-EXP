module distance (clk,x1,y1,x2,y2,complete,res);
//入力を与えると、5クロック目に距離が出力される
    input clk;
    input [7:0] x1;
    input [7:0] y1;
    input [7:0] x2;
    input [7:0] y2;
    output reg complete;
    output reg [31:0] res;
    
    reg [31:0] xd,yd;
    reg [31:0] distance_sq1;
    reg [31:0] distance_sq2;
    reg [31:0] distance_sq3;
    reg [31:0] distance_mh;
    reg [31:0] a;
    reg [31:0] b;

    always @(posedge clk)begin
        //クロック1: 差分計算
        if(x1>x2)xd<=x1-x2;
        else xd<=x2-x1;
        if(y1>y2)yd<=y1-y2;
        else yd<=y2-y1;
        //クロック2: マンハッタン・二乗距離計算
        distance_mh<=xd+yd;
        distance_sq1<=xd*xd+yd*yd;
        //クロック3: ニュートン法1
        a<=(distance_mh+distance_sq1/distance_mh)>>1;
        distance_sq2<=distance_sq1;
        //クロック4: ニュートン法2
        b<=(a+distance_sq2/a)>>1;
        distance_sq3<=distance_sq2;
        //クロック5: ニュートン法3
        res<=(b+distance_sq3/b)>>1;
    end
endmodule