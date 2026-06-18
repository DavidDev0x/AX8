/* vim: set filetype=verilog : */
`timescale 1ns / 1ps

module demux_2to4 (
    input  [1:0] s,
    input        e,
    output [3:0] y
);
    wire ns0, ns1;
    not n0 (ns0, s[0]);
    not n1 (ns1, s[1]);

    and a0 (y[0], e, ns1, ns0);  // 00
    and a1 (y[1], e, ns1, s[0]);  // 01
    and a2 (y[2], e, s[1], ns0);  // 10
    and a3 (y[3], e, s[1], s[0]);  // 11
endmodule
