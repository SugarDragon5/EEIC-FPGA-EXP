module seg7 (
    in,
    out
);
    input wire [3:0] in;
    output wire [6:0] out;
    
    function [6:0] num_to_seg7(input [3:0] in);
    begin
        case(in)
        0: num_to_seg7=7'b0000001;
        1: num_to_seg7=7'b1001111;
        2: num_to_seg7=7'b1010010;
        3: num_to_seg7=7'b0000110;
        4: num_to_seg7=7'b1001101;
        5: num_to_seg7=7'b0100100;
        6: num_to_seg7=7'b0100000;
        7: num_to_seg7=7'b0001101;
        8: num_to_seg7=7'b0000000;
        9: num_to_seg7=7'b0000100;
        default: num_to_seg7=7'b1111111;
        endcase
    end
    endfunction
    assign out=num_to_seg7(in);
endmodule