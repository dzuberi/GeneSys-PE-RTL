module mux_2to1_8bit (a, b, select, out);
input [7:0] a, b;
input select;
output reg [7:0] out;

always @(select or a or b) begin
	if(select == 1'b0) begin
		out <= a;
	end else begin
		out <= b;
	end
end

endmodule
