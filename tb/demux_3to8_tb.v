/* vim: set filetype=verilog : */
`timescale 1ns / 1ps

module demux_3to8_tb;
    reg [2:0] s;
    reg e;
    wire [7:0] y;

    demux_3to8 uut (
        .s(s),
        .e(e),
        .y(y)
    );

    initial begin
        $dumpfile("demux_3to8.vcd");
        $dumpvars(0, demux_3to8_tb);

        // verilog_format: off
        e = 1'b1; #10 // Enabled, so output is driven out
        s[2] = 1'b0; s[1] = 1'b0; s[0] = 1'b0; #10 // S=000 -> Y=0000'0001
        s[2] = 1'b0; s[1] = 1'b0; s[0] = 1'b1; #10 // S=001 -> Y=0000'0010
        s[2] = 1'b0; s[1] = 1'b1; s[0] = 1'b0; #10 // S=010 -> Y=0000'0100
        s[2] = 1'b0; s[1] = 1'b1; s[0] = 1'b1; #10 // S=011 -> Y=0000'1000
        s[2] = 1'b1; s[1] = 1'b0; s[0] = 1'b0; #10 // S=100 -> Y=0001'0000
        s[2] = 1'b1; s[1] = 1'b0; s[0] = 1'b1; #10 // S=101 -> Y=0010'0000
        s[2] = 1'b1; s[1] = 1'b1; s[0] = 1'b0; #10 // S=110 -> Y=0100'0000
        s[2] = 1'b1; s[1] = 1'b1; s[0] = 1'b1; #10 // S=111 -> Y=1000'0000

        e = 1'b0; #10 // Disabled, no output is driven out
        s[2] = 1'b0; s[1] = 1'b0; s[0] = 1'b0; #10 // S=000 -> Y=0000'0001
        s[2] = 1'b0; s[1] = 1'b0; s[0] = 1'b1; #10 // S=001 -> Y=0000'0010
        s[2] = 1'b0; s[1] = 1'b1; s[0] = 1'b0; #10 // S=010 -> Y=0000'0100
        s[2] = 1'b0; s[1] = 1'b1; s[0] = 1'b1; #10 // S=011 -> Y=0000'1000
        s[2] = 1'b1; s[1] = 1'b0; s[0] = 1'b0; #10 // S=100 -> Y=0001'0000
        s[2] = 1'b1; s[1] = 1'b0; s[0] = 1'b1; #10 // S=101 -> Y=0010'0000
        s[2] = 1'b1; s[1] = 1'b1; s[0] = 1'b0; #10 // S=110 -> Y=0100'0000
        s[2] = 1'b1; s[1] = 1'b1; s[0] = 1'b1; #10 // S=111 -> Y=1000'0000

        // verilog_format: on
        $finish;
    end

endmodule
