`include "seg7.sv"
`default_nettype none

module tb_seg7;
reg [3:0] in;
wire [6:0] out;

seg7 seg7
(
    .in(in),
    .out(out)
);


initial begin
    $dumpfile("tb_seg7.vcd");
    $dumpvars(0, tb_seg7);
end
integer i;
initial begin
    for(i=0;i<10;i++)begin
        #10 in=i;
    end
    $finish(2);
end

endmodule
`default_nettype wire