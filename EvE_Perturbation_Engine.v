module EvE_Perturbation_Engine(Crossover, ChildGene, Rand, Config);
input [63:0] Crossover;
output [63:0] ChildGene;
input [35:0] Rand;
input [31:0] Config;

wire[3:0] Select;
wire[31:0] Mutated;
wire[31:0] Perturbation;

assign Perturbation[31:27] = 5'd0;
assign Perturbation[26:24] = Rand[2:0];
assign Perturbation[23:19] = 5'd0;
assign Perturbation[18:16] = Rand[5:3];
assign Perturbation[15:11] = 5'd0;
assign Perturbation[11:8] = Rand[8:6];
assign Perturbation[7:3] = 5'd0;
assign Perturbation[2:0] = Rand[11:9];

assign Mutated[31:24] = Crossover[31:24] + Perturbation[31:24];
assign Mutated[23:16] = Crossover[23:16] + Perturbation[23:16];
assign Mutated[15:8] = Crossover[15:8] + Perturbation[15:8];
assign Mutated[7:0] = Crossover[7:0] + Perturbation[7:0];

assign ChildGene[63:32] = Crossover[63:32];
//assign ChildGene[31:0] = Mutated[31:0];

comparator #(32) compID1(.a(Rand[35:4]),.b(Config[31:0]),.equal(),.lower(lw),.greater(Select[3]));
comparator #(32) compID2(.a(Rand[34:3]),.b(Config[31:0]),.equal(),.lower(lw),.greater(Select[2]));
comparator #(32) compID3(.a(Rand[33:2]),.b(Config[31:0]),.equal(),.lower(lw),.greater(Select[1]));
comparator #(32) compID4(.a(Rand[32:1]),.b(Config[31:0]),.equal(),.lower(lw),.greater(Select[0]));

mux_2to1_8bit bits31to24(.a(Mutated[31:24]), .b(Crossover[31:24]), .select(Select[3]), .out(ChildGene[31:24]));
mux_2to1_8bit bits23to16(.a(Mutated[23:16]), .b(Crossover[23:16]), .select(Select[2]), .out(ChildGene[23:16]));
mux_2to1_8bit bits15to8(.a(Mutated[15:8]), .b(Crossover[15:8]), .select(Select[1]), .out(ChildGene[15:8]));
mux_2to1_8bit bits7to0(.a(Mutated[7:0]), .b(Crossover[7:0]), .select(Select[0]), .out(ChildGene[7:0]));

endmodule
