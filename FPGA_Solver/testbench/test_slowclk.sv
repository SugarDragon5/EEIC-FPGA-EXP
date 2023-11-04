`include "slowclk.sv"
`default_nettype none

module tb_slowclk;
  reg clk;
  reg [1:0] sw;
  wire out;

  slowclk slowclk1 (
      .clk(clk),
      .sw (sw),
      .out(out)
  );

  localparam CLK_PERIOD = 10;
  always #(CLK_PERIOD / 2) clk = ~clk;

  initial begin
    $dumpfile("tb_slowclk.vcd");
    $dumpvars(0, tb_slowclk);
  end

  initial begin
    #1 clk <= 1'b0;
    sw = 2'b00;
    repeat (1 << 10) @(posedge clk);
    sw = 2'b01;
    repeat (1 << 20) @(posedge clk);
    sw = 2'b10;
    repeat (1 << 20) @(posedge clk);
    sw = 2'b11;
    repeat (1 << 20) @(posedge clk);
    $finish(2);
  end

endmodule
`default_nettype wire
