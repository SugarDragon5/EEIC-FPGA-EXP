module seg7 (
    in,
    out
);
    input wire [3:0] in;
    output wire [6:0] out;
    
    function [6:0] num_to_seg7(input [3:0] in);
    begin
        case(in)
        0: num_to_seg7=7'b1000000;
        1: num_to_seg7=7'b1111001;
        2: num_to_seg7=7'b0100100;
        3: num_to_seg7=7'b0110000;
        4: num_to_seg7=7'b0011001;
        5: num_to_seg7=7'b0010010;
        6: num_to_seg7=7'b0000010;
        7: num_to_seg7=7'b1011000;
        8: num_to_seg7=7'b0000000;
        9: num_to_seg7=7'b0010000;
        default: num_to_seg7=7'b1111111;
        endcase
    end
    endfunction
    assign out=num_to_seg7(in);
endmodule