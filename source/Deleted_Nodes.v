module Deleted_Nodes #( //include second gene
   parameter max_deletions  = 8,
   parameter DATA_WIDTH = 8
   )
   (
    input wire clk,
    input wire rst,
    input wire conn,
    input wire [DATA_WIDTH-1:0] node_id1,
    input wire [DATA_WIDTH-1:0] node_id2,
    input wire add,
    output wire match,
    output reg full
    );
reg [7:0] num_deleted = 8'b0;
wire [max_deletions-1:0] match_found1;
wire [max_deletions-1:0] match_found2;
reg [DATA_WIDTH*max_deletions - 1:0] stored_nodes;
wire [max_deletions -2 :0] intermediate1;
wire [max_deletions -2 :0] intermediate2;
assign intermediate1[0] = match_found1[0] | match_found1[1];
assign intermediate2[0] = match_found2[0] | match_found2[1];
assign match = intermediate1[max_deletions-2] | intermediate2[max_deletions-2];


genvar i;
generate
  for (i=0; i<max_deletions; i=i+1)
    begin:gen1
    comparator #(DATA_WIDTH) add_comp1(.a(node_id1),.b(stored_nodes[DATA_WIDTH*(i+1)-1:DATA_WIDTH*i]),.equal(match_found1[i]),.lower(),.greater());
    comparator #(DATA_WIDTH) add_comp2(.a(node_id2),.b(stored_nodes[DATA_WIDTH*(i+1)-1:DATA_WIDTH*i]),.equal(match_found2[i]),.lower(),.greater());
  end
endgenerate


genvar j;
generate
  for (j=1; j< max_deletions-1; j=j+1)
    begin:gen2
    assign intermediate1[j] = intermediate1[j-1] | match_found1[j+1];
    assign intermediate2[j] = intermediate2[j-1] | match_found2[j+1];
  end
endgenerate


always @(posedge clk) begin
  if((add == 1'b1) && (!conn)) begin
    if (num_deleted < max_deletions) begin
      stored_nodes[DATA_WIDTH*num_deleted+:DATA_WIDTH] <= node_id1;
      num_deleted <= num_deleted+1;
    end
    if (num_deleted == (max_deletions - 1)) begin
      full <= 1;
    end
  end
  if(rst == 1'b1) begin
    num_deleted <= 8'b0;
    stored_nodes <= {DATA_WIDTH*max_deletions{1'b1}};
    full <= 0;
  end
end
endmodule
