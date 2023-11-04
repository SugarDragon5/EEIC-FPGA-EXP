`default_nettype none

module tb_distance;
  reg  [31:0] x1;
  reg  [31:0] y1;
  reg  [31:0] x2;
  reg  [31:0] y2;
  wire [31:0] res;

  distance distance (
      .x1 (x1),
      .y1 (y1),
      .x2 (x2),
      .y2 (y2),
      .res(res)
  );


  initial begin
    $dumpfile("tb_distance.vcd");
    $dumpvars(0, tb_distance);
  end

  initial begin
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
    #10;
    $finish(2);
  end

endmodule
`default_nettype wire
