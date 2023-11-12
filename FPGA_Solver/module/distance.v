module distance (
    clk,
    x1,
    y1,
    x2,
    y2,
    res
);
  //入力を与えると、11クロック目に距離が出力される
  input clk;
  input [7:0] x1;
  input [7:0] y1;
  input [7:0] x2;
  input [7:0] y2;
  output reg [31:0] res;

  reg [31:0] xd, yd;
  reg [17:0] distance_sq[9:0];
  reg [17:0] distance[7:0];

  reg [8:0] mask = 9'b100000000;

  always @(posedge clk) begin
    //クロック1: 差分計算
    if (x1 > x2) xd <= x1 - x2;
    else xd <= x2 - x1;
    if (y1 > y2) yd <= y1 - y2;
    else yd <= y2 - y1;
    //クロック2: マンハッタン・二乗距離計算
    distance_sq[0] <= xd * xd + yd * yd;
    //クロック3: 二分法 9bit目
    distance_sq[1] <= distance_sq[0];
    if(mask*mask > distance_sq[0])begin
      distance[0]<=18'b0;
    end else begin
      distance[0]<=mask;
    end
    //クロック4: 二分法 8bit目
    distance_sq[2] <= distance_sq[1];
    if({distance[0][17:8],mask[8:1]}*{distance[0][17:8],mask[8:1]} > distance_sq[1])begin
      distance[1]<=distance[0];
    end else begin
      distance[1]<={distance[0][17:8],mask[8:1]};
    end
    //クロック5: 二分法 7bit目
    distance_sq[3] <= distance_sq[2];
    if({distance[1][17:7],mask[8:2]}*{distance[1][17:7],mask[8:2]} > distance_sq[2])begin
      distance[2]<=distance[1];
    end else begin
      distance[2]<={distance[1][17:7],mask[8:2]};
    end
    //クロック6: 二分法 6bit目
    distance_sq[4] <= distance_sq[3];
    if({distance[2][17:6],mask[8:3]}*{distance[2][17:6],mask[8:3]} > distance_sq[3])begin
      distance[3]<=distance[2];
    end else begin
      distance[3]<={distance[2][17:6],mask[8:3]};
    end
    //クロック7: 二分法 5bit目
    distance_sq[5] <= distance_sq[4];
    if({distance[3][17:5],mask[8:4]}*{distance[3][17:5],mask[8:4]} > distance_sq[4])begin
      distance[4]<=distance[3];
    end else begin
      distance[4]<={distance[3][17:5],mask[8:4]};
    end
    //クロック8: 二分法 4bit目
    distance_sq[6] <= distance_sq[5];
    if({distance[4][17:4],mask[8:5]}*{distance[4][17:4],mask[8:5]} > distance_sq[5])begin
      distance[5]<=distance[4];
    end else begin
      distance[5]<={distance[4][17:4],mask[8:5]};
    end
    //クロック9: 二分法 3bit目
    distance_sq[7] <= distance_sq[6];
    if({distance[5][17:3],mask[8:6]}*{distance[5][17:3],mask[8:6]} > distance_sq[6])begin
      distance[6]<=distance[5];
    end else begin
      distance[6]<={distance[5][17:3],mask[8:6]};
    end
    //クロック10: 二分法 2bit目
    distance_sq[8] <= distance_sq[7];
    if({distance[6][17:2],mask[8:7]}*{distance[6][17:2],mask[8:7]} > distance_sq[7])begin
      distance[7]<=distance[6];
    end else begin
      distance[7]<={distance[6][17:2],mask[8:7]};
    end
    //クロック11: 二分法 1bit目
    distance_sq[9] <= distance_sq[8];
    if({distance[7][17:1],mask[8]}*{distance[7][17:1],mask[8]} > distance_sq[8])begin
      res<=distance[7];
    end else begin
      res<={distance[7][17:1],mask[8]};
    end

  end
endmodule
