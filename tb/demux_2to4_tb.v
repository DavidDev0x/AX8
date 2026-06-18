/* vim: set filetype=verilog : */
`timescale 1ns / 1ps

module demux_2to4_tb;
    reg [1:0] s;
    reg e;
    wire [3:0] y;

    demux_2to4 uut (
        .s(s),
        .e(e),
        .y(y)
    );

    initial begin
        $dumpfile("demux_2to4.vcd");
        $dumpvars(0, demux_2to4_tb);

        // verilog_format: off
        e = 1'b1; #10 // Enabled, so output is driven out
        s[1] = 1'b0; s[0] = 1'b0; #10 // S=00 -> Y=0001
        s[1] = 1'b0; s[0] = 1'b1; #10 // S=01 -> Y=0010
        s[1] = 1'b1; s[0] = 1'b0; #10 // S=10 -> Y=0100
        s[1] = 1'b1; s[0] = 1'b1; #10 // S=11 -> Y=1000

        e = 1'b0; #10 // Disabled, no output is driven out
        s[1] = 1'b0; s[0] = 1'b0; #10 // S=00 -> Y=0001
        s[1] = 1'b0; s[0] = 1'b1; #10 // S=01 -> Y=0010
        s[1] = 1'b1; s[0] = 1'b0; #10 // S=10 -> Y=0100
        s[1] = 1'b1; s[0] = 1'b1; #10 // S=11 -> Y=1000
        // verilog_format: on
        $finish;
    end

endmodule
