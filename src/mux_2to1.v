/* vim: set filetype=verilog : */
`timescale 1ns / 1ps

module mux_2to1 (
    input  sel,
    input  in0,
    input  in1,
    output y
);
    // y = (~s & a) | (s & b)
    wire nsel;
    wire w0, w1;

    not n0 (nsel, sel);

    nand na0 (w0, nsel, in0);
    nand na1 (w1, sel, in1);

    nand na2 (y, w0, w1);

endmodule
