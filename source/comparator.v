module comparator #(
   parameter DATA_WIDTH   = 8
   )
   (
    input wire [DATA_WIDTH-1:0] a,
    input wire [DATA_WIDTH-1:0] b,
    output reg equal,
    output reg lower,
    output reg greater
    );

    always @* begin
      if (a<b) begin
        equal = 0;
        lower = 1;
        greater = 0;
      end
      else if (a==b) begin
        equal = 1;
        lower = 0;
        greater = 0;
      end
      else begin
        equal = 0;
        lower = 0;
        greater = 1;
      end
    end
endmodule
