`default_nettype none

module tb_distance;
  reg clk;

  reg  [7:0] x1;
  reg  [7:0] y1;
  reg  [7:0] x2;
  reg  [7:0] y2;
  wire [31:0] res;

  distance distance (
      .clk(clk),
      .x1 (x1),
      .y1 (y1),
      .x2 (x2),
      .y2 (y2),
      .res(res)
  );

  integer i;
  initial begin
    $dumpfile("tb_distance.vcd");
    $dumpvars(0, tb_distance);
    for(i=0;i<10;i=i+1)$dumpvars(1, distance.distance_sq[i]);
    for(i=0;i<8;i=i+1)$dumpvars(1, distance.distance[i]);
  end

  always begin
    #1 clk = ~clk;
  end

  initial begin
    clk<=0;
    #2 x1 <= 0;
    y1 <= 0;
    x2 <= 3;
    y2 <= 4;
    #2 x1 <= 0;
    y1 <= 0;
    x2 <= 30;
    y2 <= 40;
    #2 x1 <= 0;
    y1 <= 0;
    x2 <= 300;
    y2 <= 400;
    #2 x1 <= 0;
    y1 <= 0;
    x2 <= 640;
    y2 <= 480;
    #2 x1 <= 0;
    y1 <= 0;
    x2 <= 100;
    y2 <= 100;
    #100;
$finish(2);
  end

endmodule
`default_nettype wire
