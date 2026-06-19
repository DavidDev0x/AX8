/* vim: set filetype=verilog : */
`timescale 1ns / 1ps

module mux_4to1 (
    // verilog_format: off
    input  [1:0] sel,
    input  in0, in1, in2, in3,
    output y
    // verilog_format: on
);
    wire w0, w1;

    mux_2to1 mux0_2to1 (
        .sel(sel[0]),
        .in0(in0),
        .in1(in1),
        .y  (w0)
    );
    mux_2to1 mux1_2to1 (
        .sel(sel[0]),
        .in0(in2),
        .in1(in3),
        .y  (w1)
    );
    mux_2to1 mux2_2to1 (
        .sel(sel[1]),
        .in0(w0),
        .in1(w1),
        .y  (y)
    );
endmodule
