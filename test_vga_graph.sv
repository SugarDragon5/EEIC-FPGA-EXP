`include "vga_graph.sv"
`default_nettype none

module tb_vga_graph;
reg clk;
reg rst_n;
reg [63:0][7:0] xs;
reg [63:0][7:0] ys;
reg [63:0][5:0] path;
wire [15:0] R,G,B;

VGAGraph vga_graph_0
(
    .rst (rst_n),
    .clk (clk),
    .xs(xs),
    .ys(ys),
    .path(path),
    .R(R),
    .G(G),
    .B(B)
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("tb_vga_graph.vcd");
    $dumpvars(0, tb_vga_graph);
end
integer i;
initial begin
    #1 rst_n<=1'bx;clk<=1'b0;
    #(CLK_PERIOD*3) rst_n<=1;
    #(CLK_PERIOD*3) rst_n<=0;clk<=0;
    for(i=0;i<64;i=i+1) begin
        xs[i]=(i*32)%256;
        ys[i]=(i*27)%256;
        path[i]=i;
    end
    repeat(70000) @(posedge clk);
    $finish(2);
end

endmodule
`default_nettype wire