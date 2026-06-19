/* vim: set filetype=verilog : */
`timescale 1ns / 1ps

module mux_8to1_tb;
    reg [2:0] sel;
    reg in0, in1, in2, in3;
    reg in4, in5, in6, in7;
    wire y;

    mux_8to1 uut (
        .sel(sel),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .in6(in6),
        .in7(in7),
        .y  (y)
    );

    integer errors = 0;
    task automatic check;
        input [2:0] tsel;
        input tin7, tin6, tin5, tin4;
        input tin3, tin2, tin1, tin0;
        input expected_y;

        begin
            sel = tsel;
            in7 = tin7;
            in6 = tin6;
            in5 = tin5;
            in4 = tin4;
            in3 = tin3;
            in2 = tin2;
            in1 = tin1;
            in0 = tin0;
            #10;

            if (y !== expected_y) begin
                $display(
                    "FAIL: sel=%h in7=%b in6=%b in5=%b in4=%b in3=%b in2=%b in1=%b in0=%b -> got y=%b, expected y=%b",
                    tsel, tin7, tin6, tin5, tin4, tin3, tin2, tin1, tin0, y, expected_y);
                errors = errors + 1;
            end else
                // verilog_format: off
                $display(
                    "PASS: sel=%h in7=%b in6=%b in5=%b in4=%b in3=%b in2=%b in1=%b in0=%b -> y=%b",
                    tsel, tin7, tin6, tin5, tin4, tin3, tin2, tin1, tin0, y);
                // verilog_format: on
        end
    endtask

    initial begin
        $dumpfile("mux_8to1.vcd");
        $dumpvars(0, mux_8to1_tb);

        //       sel     7     6     5     4     3     2     1     0     y
        check(3'b000, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0);
        check(3'b001, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1);
        check(3'b010, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0);
        check(3'b011, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1);
        check(3'b100, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);
        check(3'b101, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0);
        check(3'b110, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0);
        check(3'b111, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0);

        $finish;
    end
endmodule
