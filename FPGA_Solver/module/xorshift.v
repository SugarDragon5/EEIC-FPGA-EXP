module xorshift (
    rst,
    clk,
    seed,
    res
);
  input rst;
  input clk;
  input [31:0] seed;
  output [31:0] res;

  reg [31:0] x;
  reg [31:0] y;
  reg [31:0] z;
  reg [31:0] w;
  assign res = w;
  always @(posedge clk) begin
    if (rst) begin
      x <= 123456789;
      y <= 362436069;
      z <= 521288629;
      w <= seed;
    end else begin
      x <= y;
      y <= z;
      z <= w;
      w <= (w ^ (w >> 19)) ^ ((x ^ (x << 11)) ^ ((x ^ (x << 11)) >> 8));
    end
  end
endmodule
