module EvE_tb(
);

reg clk;
reg rst;
reg wr_en;
parameter num_PE = 8;
// Changed the following


//reg [7:0] genomeNum;
reg [31:0] cnfg1;
reg [31:0] cnfg2;
reg [31:0] cnfg3;
reg [63:0] parentA;
reg [63:0] parentB;
wire [num_PE *64 - 1:0] gene1;
wire [num_PE *64 - 1:0] gene2;
wire [num_PE *64 - 1:0] gene3;

//wire compute_done_out;
//wire [OUT_WORD_SIZE-1:0] cycles_count_out;
//wire [0:OUT_WORD_SIZE * ARR_ROWS*ARR_COLS-1] pe_register_vals_wire;
//wire [OUT_WORD_SIZE-1:0] pe_register_vals_mem [0:ARR_ROWS*ARR_COLS-1];


integer i,j;
integer row, col;

//Block to hint generation of waveforms
initial begin
    $vcdplusfile("EvE_PE.vcd");
    $vcdplusmemon();
    $vcdpluson();
end

//Initialize the design
initial begin
    clk = 0;
    rst = 1;
    wr_en = 0;
    //genomeNum = 8'h03;
    //wr_en = 1;
    cnfg1 = 32'h80000000;
    cnfg2 = 32'hd0000000;
    cnfg3 = 32'hc0000000;

    #15 rst =0;

    // Nodes
    #10 wr_en = 1;
     parentA = 64'hC82000F722222222;    // 0, 1, 2 are input
     parentB = 64'hC92000F611331133;
    #10 wr_en = 0;
    #10 parentA = 64'hC82001F733333333;
     parentB = 64'hC92002F622442244;
     wr_en = 1;
    #10 wr_en = 0;
    #10 parentA = 64'hC80003F730303030;    // 3, 4 are hidden
     parentB = 64'hC90003F622332233;
     wr_en = 1;
    #10 wr_en = 0;
    #10 parentA = 64'hC80004F730322030;
     parentB = 64'hC90004F622132231;
     wr_en = 1;
    #10 wr_en = 0;
    #10 parentA = 64'hC84005F722220000;    //  5, 6, 7 are output
     parentB = 64'hC94005F600001133;
     wr_en = 1;
    #10 wr_en = 0;
    #10 wr_en = 1;
    parentA = 64'hC84007F722000022;
     parentB = 64'hC94006F611000033;
    // Connections
    #10 wr_en = 0;
    #10 parentA = 64'hC880000344444444;  // 0 -> 3
     parentB = 64'hC980000323232323;  // 0 -> 3
     wr_en = 1;
    #10 wr_en = 0;
    #10 parentA = 64'hC880010344400044;  // 1 -> 3
     parentB = 64'hC980020300032323;  // 2 -> 3
     wr_en = 1;
    #10 wr_en = 0;
    #10 parentA = 64'hC88003054444CCC4; // 3 -> 5
     parentB = 64'hC980030523CC2323; // 3 -> 5
     wr_en = 1;
    #10 wr_en = 0;
    #10 parentA = 64'hC88004054444BCB4; // 4 -> 5
     parentB = 64'hC980040523BC2626; // 4 -> 5
     wr_en = 1;
    #10 wr_en = 0;
    #10 parentA = 64'hC88004074C4444C4; // 4 -> 7
     parentB = 64'hC98004062B2323B3; // 4 -> 6
     wr_en = 1;
    #10 wr_en = 0;

end

// Read the input matrices from file and populate the memory
//initial $readmemh(`INPUTL, left_inputs);
//initial $readmemh(`INPUTT, top_inputs);

//Free running clk
always #5 clk = ~clk;


EvE#(.num_PE (num_PE))  dut(
        .parent1(parentA),
        .parent2(parentB),
        .input_clk(clk),
        .reset(rst),
        .wr_en(wr_en),
        .cfg1(cnfg1),
        .cfg2(cnfg2),
        .cfg3(cnfg3),
        .out1(gene1),
        .out2(gene2),
        .out3(gene3)
    );

always #10000 $finish;

endmodule
