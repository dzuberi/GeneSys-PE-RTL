module EvE_Delete_Gene_Engine#(parameter max_deletions  = 8)(InGene, Rand, Config, Reset, clk, OutGene);

input [35:0] Rand;
input [31:0] Config;
input clk;
input Reset;
input [63:0] InGene;
output reg [63:0] OutGene;
reg [8 * max_deletions -1:0] deletedNodeIDs;
reg numNodesDeleted_reg;
//reg cntrEn;
wire Select;
wire lw, eq, gr;
wire deleted_already;
wire full;
wire uhhh;
//counter #(.DATA_WIDTH(8), .COUNT_FROM(0)) numNodesDeleted (.clk(clk), .en(cntrEn), .rst(Reset), .out(numNodesDeleted_reg));
comparator #(32) delete_comp(.a(Rand[35:4]),.b(Config[31:0]),.equal(eq),.lower(lw),.greater(gr));
Deleted_Nodes #(.max_deletions(max_deletions),.DATA_WIDTH(8)) delete_file(
  .clk(clk),
  .rst(Reset),
  .conn(InGene[55]),
  .node_id1(InGene[47:40]), //include second gene
  .node_id2(InGene[39:32]),
  .add(gr & ~uhhh),
  .match(deleted_already),//this is 1 if already deleted
  .full(full)
);
comparator #(8) valid_comp(.a(InGene[63:56]),.b(8'hFF),.equal(uhhh),.lower(),.greater());
always @(posedge clk)
begin
if(Reset) begin
  numNodesDeleted_reg<= 0;
end

if  (gr == 1'b1 && InGene[63:56] != 8'b11111111) begin
  if (InGene[55] == 1'b1) begin  // Connections
    //cntrEn <= 1'b0;
    OutGene[63:56] <= 8'hFF;// invalid / node is deleted
  end else if (InGene[55] == 1'b0 && (numNodesDeleted_reg < max_deletions)) begin  // NODES
    //cntrEn <= 1'b1;

    OutGene[63:56] <= 8'hFF;// invalid / node is deleted
    // Add the ID of this node to the table holding all the IDS of deleted nodes
    //deletedNodeIDs[8*numNodesDeleted_reg+:8] <= InGene[47:40];
    numNodesDeleted_reg <= numNodesDeleted_reg+1;
  end else begin
    //cntrEn <= 1'b0;
    OutGene <= InGene;
  end
end else begin
  if (InGene[55] == 1'b1) begin
    if (deleted_already) begin
      OutGene[63:56] <= 8'hFF;//invalid
    end else begin
      OutGene <= InGene;
    end
  end
  else begin
    OutGene <= InGene;
  end
  // Check to see if Dangling connection
  //cntrEn <= 1'b0;
end
end

//always @(Reset) begin

//end

endmodule
