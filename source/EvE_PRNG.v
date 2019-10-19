module EvE_PRNG
   (
    clk, reset,
     r_next, pe_id
   );
   input clk, reset;
   input [7:0] pe_id;
   reg [35:0] r_reg;
   output [35:0] r_next;


   always @(posedge clk)
   begin
      if (reset)
         r_reg <= {pe_id[3:0],pe_id,pe_id,pe_id,pe_id};
      else
         r_reg <= r_next;
	end

	//assign r_next = {s_in, r_reg[N-1:1]};
  assign r_next = {r_reg[0], r_reg[35:1]} ^ r_reg;


endmodule
