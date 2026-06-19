/* vim: set filetype=verilog : */
`timescale 1ns / 1ps

module mux_2to1_tb;
    reg sel, in0, in1;
    wire y;

    mux_2to1 uut (
        .sel(sel),
        .in0(in0),
        .in1(in1),
        .y  (y)
    );

    initial begin
        $dumpfile("mux_2to1.vcd");
        $dumpvars(0, mux_2to1_tb);

        // verilog_format: off
        sel = 1'b0; in0 = 1'b0; in1 = 1'b0; #10 // in0=0, in1=0, y=in0 -> 0
        sel = 1'b0; in0 = 1'b0; in1 = 1'b1; #10 // in0=0, in1=1, y=in0 -> 0
        sel = 1'b0; in0 = 1'b1; in1 = 1'b0; #10 // in0=1, in1=0, y=in0 -> 1
        sel = 1'b0; in0 = 1'b1; in1 = 1'b1; #10 // in0=1, in1=1, y=in0 -> 1

        sel = 1'b1; in0 = 1'b0; in1 = 1'b0; #10 // in0=0, in1=0, y=in1 -> 0
        sel = 1'b1; in0 = 1'b0; in1 = 1'b1; #10 // in0=0, in1=1, y=in1 -> 1
        sel = 1'b1; in0 = 1'b1; in1 = 1'b0; #10 // in0=1, in1=0, y=in1 -> 0
        sel = 1'b1; in0 = 1'b1; in1 = 1'b1; #10 // in0=1, in1=1, y=in1 -> 1
        // verilog_format: on

        $finish;
    end
endmodule
