/* vim: set filetype=verilog : */
`timescale 1ns / 1ps

module shifter_8 (
    input  [7:0] a,
    input        cin,
    input        m,
    output [7:0] y,
    output       cout
);
    // ROL (m=0) > Shifts everything to the left, Cin fills Y[0]:
    // A: [6][5][4][3][2][1][0][Cin]
    // v
    // Y: [7][6][5][4][3][2][1][0]    Cout <- A[7]
    //
    // ROR (m=1) > Shifts everything to the right, Cin fills Y[7]:
    // A: [Cin][7][6][5][4][3][2][1]
    // v
    // Y: [7]  [6][5][4][3][2][1][0]  Cout <- A[0]

    // verilog_format: off
    mux_2to1 mx0 (.sel(m), .in0(cin),  .in1(a[1]), .y(y[0]));
    mux_2to1 mx1 (.sel(m), .in0(a[0]), .in1(a[2]), .y(y[1]));
    mux_2to1 mx2 (.sel(m), .in0(a[1]), .in1(a[3]), .y(y[2]));
    mux_2to1 mx3 (.sel(m), .in0(a[2]), .in1(a[4]), .y(y[3]));
    mux_2to1 mx4 (.sel(m), .in0(a[3]), .in1(a[5]), .y(y[4]));
    mux_2to1 mx5 (.sel(m), .in0(a[4]), .in1(a[6]), .y(y[5]));
    mux_2to1 mx6 (.sel(m), .in0(a[5]), .in1(a[7]), .y(y[6]));
    mux_2to1 mx7 (.sel(m), .in0(a[6]), .in1(cin),  .y(y[7]));

    mux_2to1 mxc (.sel(m), .in0(a[7]), .in1(a[0]), .y(cout));
    // verilog_format: on

endmodule
