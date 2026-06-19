/* vim: set filetype=verilog : */
`timescale 1ns / 1ps

module mux_8to1 (
    // verilog_format: off
    input  [2:0] sel,
    input  in0, in1, in2, in3,
    input  in4, in5, in6, in7,
    output y
    // verilog_format: on
);
    wire w0, w1;

    mux_4to1 mux0_4to1 (
        .sel(sel[1:0]),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .y  (w0)
    );
    mux_4to1 mux1_4to1 (
        .sel(sel[1:0]),
        .in0(in4),
        .in1(in5),
        .in2(in6),
        .in3(in7),
        .y  (w1)
    );

    mux_2to1 mux0_2to1 (
        .sel(sel[2]),
        .in0(w0),
        .in1(w1),
        .y  (y)
    );
endmodule
