module EvE_Crossover_Engine(ID, ParentA, ParentB, out, clk,rst, Rand, Config, readA, readB);
input [7:0] ID;
input [63:0] ParentA, ParentB;
input [35:0] Rand;
output reg [63:0] out;
output reg readA, readB;
input [31:0] Config;
input clk, rst;
//wire eq_1b, lw_1b, gr_1b;
wire eq_n, lw_n, gr_n;
wire eq_c, lw_c, gr_c;
wire [3:0] Select;
reg signalX;
reg stage;

wire [31:0] Crossover;
comparator #(8) compID1(.a(ParentA[47:40]), .b(ParentB[47:40]), .equal(eq_n), .lower(lw_n), .greater(gr_n));
comparator #(8) compID2(.a(ParentA[39:32]), .b(ParentB[39:32]), .equal(eq_c), .lower(lw_c), .greater(gr_c));

comparator #(32) compRand1(.a(Rand[35:4]),.b(Config[31:0]),.equal(),.lower(lw),.greater(Select[3]));
comparator #(32) compRand2(.a(Rand[34:3]),.b(Config[31:0]),.equal(),.lower(lw),.greater(Select[2]));
comparator #(32) compRand3(.a(Rand[33:2]),.b(Config[31:0]),.equal(),.lower(lw),.greater(Select[1]));
comparator #(32) compRand4(.a(Rand[32:1]),.b(Config[31:0]),.equal(),.lower(lw),.greater(Select[0]));


mux_2to1_8bit bits31to24(.a(ParentA[31:24]), .b(ParentB[31:24]), .select(Select[3]), .out(Crossover[31:24]));
mux_2to1_8bit bits23to16(.a(ParentA[23:16]), .b(ParentB[23:16]), .select(Select[2]), .out(Crossover[23:16]));
mux_2to1_8bit bits15to8(.a(ParentA[15:8]), .b(ParentB[15:8]), .select(Select[1]), .out(Crossover[15:8]));
mux_2to1_8bit bits7to0(.a(ParentA[7:0]), .b(ParentB[7:0]), .select(Select[0]), .out(Crossover[7:0]));

always @(posedge clk)
begin

if(rst) begin
  signalX <= 1;
  stage <= 0;
end
else begin
stage <= ~stage;
if (signalX == 1) begin
  readA <= 1;
  readB <= 1;
  signalX <= 0;
end
if (!stage && !signalX) begin
  readA <= 0;
  readB <= 0;
  if (ParentA[55] == 1'b1 && ParentB[55] == 1'b1) begin  // Connections
    if (eq_n == 1'b1 && eq_c == 1'b1) begin
      out[63:56] <= ID;
      out[55:32] <= ParentA[55:32];
      out[31:0]  <= Crossover;
      //readA <= 1;
      //readB <= 1;
    end else if (gr_n == 1'b1) begin

      out[63:56] <= 8'hFF;//invalid
      out[55:0] <= ParentB[55:0];
      //readA <= 0;
      //readB <= 1;
    end else if (lw_n == 1'b1) begin
      out[63:56] <= ID;
      out[55:0] <= ParentA[55:0];
      //readA <= 1;
      //readB <= 0;
    end else if (eq_n == 1'b1 && gr_c == 1'b1) begin
      out[63:56] <= 8'hFF;//invalid
      out[55:0] <= ParentB[55:0];
      //readA <= 0;
      //readB <= 1;
    end else if (eq_n == 1'b1 && lw_n == 1'b1) begin

      out[63:56] <= ID;
      out[55:0] <= ParentA[55:0];
      //readA <= 1;
      //readB <= 0;
    end

  end else if  (ParentA[55] == 1'b0 && ParentB[55] == 1'b0) begin // NODES



    if (eq_n == 1'b1) begin
      out[63:56] <= ID;
      out[55:32] <= ParentA[55:32];
      out[31:0]  <= Crossover;
      //readA <= 1;
      //readB <= 1;
    end else if (gr_n == 1'b1) begin

      out[63:56] <= 8'hFF;//invalid
      out[55:0] <= ParentB[55:0];
      //readA <= 0;
      //readB <= 1;
    end else if (lw_n == 1'b1) begin
      out[63:56] <= ID;
      out[55:0] <= ParentA[55:0];
      //readA <= 1;
      //readB <= 0;
    end
  end else if (ParentA[55] == 1'b0 && ParentB[55] == 1'b1) begin
    out[63:56] <= ID;
    out[55:0] <= ParentA[55:0];
    //readA <= 1;
    //readB <= 0;
  end else if (ParentA[55] == 1'b1 && ParentB[55] == 1'b0) begin
    out[63:56] <= 8'hFF;//invalid
    out[55:0] <= ParentB[55:0];
    //readA <= 0;
    //readB <= 1;
  end
end

if (stage && !signalX) begin
  if (ParentA[55] == 1'b1 && ParentB[55] == 1'b1) begin  // Connections
    if (eq_n == 1'b1 && eq_c == 1'b1) begin
      out[63:56] <= 8'hFF;//invalid
      readA <= 1;
      readB <= 1;
    end else if (gr_n == 1'b1) begin
    out[63:56] <= 8'hFF;//invalid
      readA <= 0;
      readB <= 1;
    end else if (lw_n == 1'b1) begin
    out[63:56] <= 8'hFF;//invalid
      readA <= 1;
      readB <= 0;
    end else if (eq_n == 1'b1 && gr_c == 1'b1) begin
    out[63:56] <= 8'hFF;//invalid
      readA <= 0;
      readB <= 1;
    end else if (eq_n == 1'b1 && lw_n == 1'b1) begin
    out[63:56] <= 8'hFF;//invalid
      readA <= 1;
      readB <= 0;
    end

  end else if  (ParentA[55] == 1'b0 && ParentB[55] == 1'b0) begin // NODES



    if (eq_n == 1'b1) begin
    out[63:56] <= 8'hFF;//invalid
      readA <= 1;
      readB <= 1;
    end else if (gr_n == 1'b1) begin
    out[63:56] <= 8'hFF;//invalid
      readA <= 0;
      readB <= 1;
    end else if (lw_n == 1'b1) begin
    out[63:56] <= 8'hFF;//invalid
      readA <= 1;
      readB <= 0;
    end
  end else if (ParentA[55] == 1'b0 && ParentB[55] == 1'b1) begin
  out[63:56] <= 8'hFF;//invalid
    readA <= 1;
    readB <= 0;
  end else if (ParentA[55] == 1'b1 && ParentB[55] == 1'b0) begin
  out[63:56] <= 8'hFF;//invalid
    readA <= 0;
    readB <= 1;
  end
end
end
end
//always @(negedge rst) begin
  //signalX <= 1;
  //stage <= 0;
//end

endmodule
