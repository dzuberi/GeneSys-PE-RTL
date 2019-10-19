module EvE_Add_Gene_Engine(InGene, Rand, Config, Reset, clk, OutGene1, OutGene2, OutGene3 );

input [35:0] Rand;
input [31:0] Config;
input clk;
input Reset;
input [63:0] InGene;
output reg [63:0] OutGene1, OutGene2, OutGene3;
//reg [8 * max_deletions -1:0] deletedNodeIDs;
reg [7:0]prevID;
wire [7:0]maxNodeID;  // Actually pass in the correct value
reg cntEn;
wire lwr, equ, grt;

counter #(.DATA_WIDTH(8), .COUNT_FROM(0)) maxNodeIDReg (.clk(clk), .en(cntEn), .rst(Reset), .out(maxNodeID));
comparator #(32) add_comp(.a(Rand[34:3]),.b(Config[31:0]),.equal(equ),.lower(lwr),.greater(grt));

always @(posedge clk)
begin

if(Reset) begin
  prevID<= 8'h05;
end

if (!Reset && InGene[55] == 1'b1 && InGene[63:56] != 8'b11111111) begin  // Connections Streaming
  prevID <= InGene[47:40];




  if (grt == 1'b1) begin
    // Add a Node -> split this conneciton in two
    OutGene2[63:56] <= InGene[63:56];
    OutGene2[55] <= 1'b0; //
    OutGene2[54:53] <= InGene[54:53];
    OutGene2[47:40] <= maxNodeID; //
    OutGene2[31:0] <= 32'hC0C0C0C0;  // Default Value (fix later)
    cntEn <= 1'b1;
    // Add Connection from Src to New Node
    OutGene1[63:56] <= InGene[63:56];
    OutGene1[55] <= 1'b1; //
    OutGene1[54:53] <= InGene[54:53];
    OutGene1[47:40] <= InGene[47:40]; //src
    OutGene1[39:32] <= maxNodeID; //dest
    OutGene1[31:0] <= InGene[31:0];  // Default Value (fix later)
    // Add Connection from New Node ot Dest
    OutGene3[63:56] <= InGene[63:56];
    OutGene3[55] <= 1'b1; //
    OutGene3[54:53] <= InGene[54:53];
    OutGene3[47:40] <= maxNodeID; //src
    OutGene3[39:32] <= InGene[39:32];
    OutGene3[31:0] <= 32'hC0C0C0C0;  // Default Value (fix later)
  end
  else begin
    OutGene1 <= InGene;
    OutGene2 <= 64'hFFFFFFFFFFFFFFFF;
    OutGene3 <= 64'hFFFFFFFFFFFFFFFF;
    cntEn <= 1'b0;
  end

end else if (InGene[55] == 1'b0 && InGene[63:56] != 8'b11111111) begin  // NODES Streaming
  prevID <= InGene[47:40];
  OutGene1 <= InGene;
  if (InGene[47:40] >= maxNodeID) begin
    cntEn <= 1'b1;
  end else  begin
    cntEn <= 1'b0;
  end
  if (grt == 1'b1) begin
    // Add a Connection
    OutGene2[63:56] <= InGene[63:56];
    OutGene2[55:53] <= 3'b100;
    OutGene2[47:40] <= InGene[47:40];
    OutGene2[39:32] <= prevID;//fix later
    OutGene2[31:0] <= 32'hC0C0C0C0;  // Default Value (fix later)
  end
  else begin
    OutGene2 <= 64'hFFFFFFFFFFFFFFFF;
  end
  OutGene3 <= 64'hFFFFFFFFFFFFFFFF;
end else if (InGene[55] == 1'b0) begin
  if (InGene[47:40] >= maxNodeID) begin
    cntEn <= 1'b1;
  end else  begin
    cntEn <= 1'b0;
  end
end else begin
cntEn <= 1'b0;
OutGene1 <= 64'hFFFFFFFFFFFFFFFF;
OutGene2 <= 64'hFFFFFFFFFFFFFFFF;
OutGene3 <= 64'hFFFFFFFFFFFFFFFF;
end
end

//always @(Reset) begin
//    prevID <= 8'h05;
//end


endmodule
