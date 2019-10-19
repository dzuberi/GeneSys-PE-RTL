module EvE_PE(genomeID, parent1, parent2, input_clk, wr_en, reset, cfg1, cfg2, cfg3, out1, out2, out3);
wire [35:0] s_out;
input [7:0] genomeID;
wire [63:0] crossover_out, perturbaiton_out, deleteGene_out;
input [63:0] parent1;
input [63:0] parent2;
wire [63:0] parent1_fifo_out, parent2_fifo_out;
input input_clk, reset, wr_en;
output [63:0] out1, out2, out3;
wire rdA, rdB;
input [31:0] cfg1;
input [31:0] cfg2;
input [31:0] cfg3;

syn_fifo p1_Fifo (
	.clk(input_clk) ,
	.rst(reset)      ,
	.data_in(parent1)  ,
	.read(rdA)    ,
//	.en(1),
	.write(wr_en)    ,
	.data_out(parent1_fifo_out) ,
	.fifo_empty()    ,
	.fifo_full()
	);
syn_fifo p2_Fifo (
	.clk(input_clk) ,
	.rst(reset)      ,
	.data_in(parent2)  ,
	.read(rdB)    ,
	.write(wr_en)    ,
	.data_out(parent2_fifo_out) ,
	.fifo_empty()    ,
	.fifo_full()
	);
EvE_PRNG PRNG  (
		.clk(input_clk),
		.reset(reset),
		//.s_in(s_in),
		.r_next(s_out),
		.pe_id(genomeID)
	);
	//check to see if both nodes
	//split config in here
EvE_Crossover_Engine Crossover_Engine(
	.ID(genomeID),
 	.ParentA(parent1_fifo_out),
 	.ParentB(parent2_fifo_out),
 	.out(crossover_out),
	.clk(input_clk),
	.rst(reset),
 	.Rand(s_out[35:0]),
	.readA(rdA),
	.readB(rdB),
	.Config(cfg1)
 );
EvE_Perturbation_Engine Perturbation_Engine(
	.Crossover(crossover_out),
	.ChildGene(perturbaiton_out),
	.Rand(s_out[35:0]),
	.Config(cfg1)
	);
EvE_Delete_Gene_Engine Delete_Gene_Engine(
	.InGene(perturbaiton_out),
	.Rand(s_out[35:0]),
	.Config(cfg2),
	.Reset(reset),
	.clk(input_clk),
	.OutGene(deleteGene_out)
	);
EvE_Add_Gene_Engine Add_Gene_Engine(
	.InGene(deleteGene_out),
	.Rand(s_out[35:0]),
	.Config(cfg3),
	.Reset(reset),
	.clk(input_clk),
	.OutGene1(out1),
	.OutGene2(out2),
	.OutGene3(out3)
	);

endmodule
