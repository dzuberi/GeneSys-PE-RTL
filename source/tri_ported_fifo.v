

//`timescale 1ns / 1ps
`default_nettype none

module tri_ported_fifo #(
    parameter WIDTH = 64,
    parameter DEPTH = 24
)(
    input wire [WIDTH-1:0] data_in1,
    input wire [WIDTH-1:0] data_in2,
    input wire [WIDTH-1:0] data_in3,
    input wire clk,
    input wire rst,
    input wire write1,
    input wire write2,
    input wire write3,
    input wire read,
    output reg [WIDTH-1:0] data_out,
    output wire fifo_full,
    output wire fifo_empty
  //  output wire fifo_not_empty,
//    output wire fifo_not_full
);

    // memory will contain the FIFO data.
    // $clog2(DEPTH+1) == bits-to-address-DEPTH
    //reg [WIDTH-1:0] memory [0:$clog2(DEPTH+1)];
    reg [DEPTH*WIDTH-1:0] memory;
    // $clog2(DEPTH+1)-2 to count from 0 to DEPTH
    reg [$clog2(DEPTH)-1:0] write_ptr;
    reg [$clog2(DEPTH)-1:0] read_ptr;

    // Initialization
    initial begin

        // Init both write_cnt and read_cnt to 0
        write_ptr = 0;
        read_ptr = 0;

        // Display error if WIDTH is 0 or less.
        if ( WIDTH <= 0 ) begin
            $error("%m ** Illegal condition **, you used %d WIDTH", WIDTH);
        end
        // Display error if DEPTH is 0 or less.
        if ( DEPTH <= 0) begin
            $error("%m ** Illegal condition **, you used %d DEPTH", DEPTH);
        end

    end // end initial

    assign fifo_empty   = ( write_ptr == 0 ) ? 1'b1 : 1'b0;
    assign fifo_full    = ( write_ptr == (DEPTH-1) ) ? 1'b1 : 1'b0;
  //  assign fifo_not_empty = ~fifo_empty;
  //  assign fifo_not_full = ~fifo_full;

    always @ (posedge clk) begin
        if ( write1 ) begin
            memory[write_ptr*WIDTH+:WIDTH] <= data_in1;
            //memory[write_ptr] <= data_in;
        end else if (write2) begin
            memory[write_ptr*WIDTH+:WIDTH] <= data_in1;
            memory[(write_ptr+1)*WIDTH+:WIDTH] <= data_in2;
        end else if (write3) begin
            memory[write_ptr*WIDTH+:WIDTH] <= data_in1;
            memory[(write_ptr+1)*WIDTH+:WIDTH] <= data_in2;
            memory[(write_ptr+2)*WIDTH+:WIDTH] <= data_in3;
        end

        if ( read ) begin
            data_out <= memory[read_ptr*WIDTH+:WIDTH];
            //data_out <= memory[read_ptr];
        end

    end

    always @ ( posedge clk) begin
        if ( rst ) begin
          read_ptr <= 0;
          write_ptr <= 0;
        end
        else begin
        if ( write1 ) begin
            write_ptr <= write_ptr + 1;
        end else if (write2) begin
            write_ptr <= write_ptr + 2;
        end else if (write3) begin
            write_ptr <= write_ptr + 3;
        end

        if ( read && !fifo_empty) begin
            read_ptr <= read_ptr + 1;
        end
        end
    end


endmodule
