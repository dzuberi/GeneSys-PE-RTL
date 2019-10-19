module EvE#(parameter num_PE = 8)(parent1, parent2, input_clk, wr_en, reset, cfg1, cfg2, cfg3, out1, out2, out3);
input [63:0] parent1;
input [63:0] parent2;
input input_clk, reset, wr_en;
output [64*num_PE-1:0] out1, out2, out3;
input wr_en;
input [31:0] cfg1;
input [31:0] cfg2;
input [31:0] cfg3;
wire [8*num_PE-1:0] genome_ID;
assign genome_ID[7:0] = 8'b0;
genvar r;
generate
  for (r = 0; r < num_PE; r = r + 1)
    begin: genOuter

      EvE_PE  dut(
            .genomeID(genome_ID[8*r+:8]),
            .parent1(parent1),
            .parent2(parent2),
            .input_clk(input_clk),
            .reset(reset),
            .wr_en(wr_en),
            .cfg1(cfg1),
            .cfg2(cfg2),
            .cfg3(cfg3),
            .out1(out1[64*r+:64]),
            .out2(out2[64*r+:64]),
            .out3(out3[64*r+:64])
        );

    end
endgenerate

genvar q;
generate
  for(q = 1; q<num_PE; q=q+1)
    begin: gen2
      assign genome_ID[8*q+:8] = genome_ID[8*(q-1)+:8]+1;
    end
endgenerate

endmodule
