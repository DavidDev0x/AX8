/* vim: set filetype=verilog : */
`timescale 1ns / 1ps

module demux_3to8 (
    input  [2:0] s,
    input        e,
    output [7:0] y
);
    wire ns2;
    not n0 (ns2, s[2]);

    wire dmx0_e, dmx1_e;
    and a0 (dmx0_e, ns2, e);  // DMX0 <- ~s & e
    and a1 (dmx1_e, s[2], e);  // DMX1 <- s & e

    demux_2to4 dmx0 (
        .s(s[1:0]),
        .e(dmx0_e),
        .y(y[3:0])
    );
    demux_2to4 dmx1 (
        .s(s[1:0]),
        .e(dmx1_e),
        .y(y[7:4])
    );
endmodule
