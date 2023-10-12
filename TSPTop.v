
module TSPTop(	input CLOCK_50,
	input [1:0]  SW,
	output [3:0] LEDR,
	output [6:0] HEX0,
	input 	     nrst    
);

   wire [31:0] 	     cnt;
   wire [3:0] 	     selcnt;
   assign  LEDR = selcnt;
   
   counter32  cc( .clk(CLOCK_50), .nrst(nrst), .cntout(cnt));
   mux4x4     mm( .cntout(cnt), .selout(selcnt), .sel(SW) );
   roulette   rr( .clk(CLOCK_50), .nrst(nrst), .cntout1(selcnt[0]), .ledout(HEX0) );
   
endmodule

module roulette ( clk, nrst, cntout1, ledout );
   input clk, nrst;
   input cntout1;
   output [6:0] ledout;

   reg [5:0] rr;
   reg 	     cntout0;
   
   assign ledout = ~{1'b 0, rr};
   
   always @(posedge clk) begin
      if( !nrst ) begin
	 rr <= 6'b 1;
	 cntout0 <= 0;
      end else if( cntout1 == 0 && cntout0 == 1 )	rr <= {rr[4:0],rr[5]};
      cntout0 <= cntout1;
   end
endmodule

module mux4x4 ( cntout, selout, sel );
   input [31:0] cntout;
   input [1:0] 	sel;
   output [3:0] selout;

   assign selout = ((sel == 2'b 00) ? cntout[31:28] :
	    ((sel == 2'b 01) ? cntout[29:26] :
	    ((sel == 2'b 10) ? cntout[27:24] :cntout[25:22] )));

endmodule

module counter32 ( clk, nrst, cntout );
   input clk;   // CLOCK0 (50MHz)
   input nrst;   // HPS_NRST
   output [31:0] cntout;
   reg [31:0] 	 cntout;
   
  
   always @(posedge clk) begin
      if( !nrst ) cntout <= 0;
      else cntout <= cntout + 1;
   end
endmodule // counter32
