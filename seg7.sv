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
        2: num_to_seg7=7'b0010010;
        3: num_to_seg7=7'b0000110;
        4: num_to_seg7=7'b1001100;
        5: num_to_seg7=7'b0100100;
        6: num_to_seg7=7'b0100000;
        7: num_to_seg7=7'b0001111;
        8: num_to_seg7=7'b0000000;
        9: num_to_seg7=7'b0000100;
        10: num_to_seg7=7'b0001000;
        11: num_to_seg7=7'b1100000;
        12: num_to_seg7=7'b0110001;
        13: num_to_seg7=7'b1000010;
        14: num_to_seg7=7'b0110000;
        15: num_to_seg7=7'b0111000;
        default: num_to_seg7=7'b1111111;
        endcase
    end
    endfunction
    assign out=num_to_seg7(in);
endmodule