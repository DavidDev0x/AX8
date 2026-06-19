/* vim: set filetype=verilog : */
`timescale 1ns / 1ps

module mux_4to1_tb;
    reg [1:0] sel;
    reg in0, in1, in2, in3;
    wire y;

    mux_4to1 uut (
        .sel(sel),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .y  (y)
    );

    integer errors = 0;
    task automatic check;
        input [1:0] tsel;
        input tin3, tin2, tin1, tin0;
        input expected_y;

        begin
            sel = tsel;
            in3 = tin3;
            in2 = tin2;
            in1 = tin1;
            in0 = tin0;
            #10;

            if (y !== expected_y) begin
                $display("FAIL: sel=%h in3=%b in2=%b in1=%b in0=%b -> got y=%b, expected y=%b",
                         tsel, tin3, tin2, tin1, tin0, y, expected_y);
                errors = errors + 1;
            end else
                // verilog_format: off
                $display("PASS: sel=%h in3=%b in2=%b in1=%b in0=%b -> y=%b",
                         tsel, tin3, tin2, tin1, tin0, y);
                // verilog_format: on
        end
    endtask

    initial begin
        $dumpfile("mux_4to1.vcd");
        $dumpvars(0, mux_4to1_tb);

        check(2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        check(2'b00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1);
        check(2'b00, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0);
        check(2'b00, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        check(2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0);

        check(2'b01, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        check(2'b01, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
        check(2'b01, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1);
        check(2'b01, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        check(2'b01, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0);

        check(2'b10, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        check(2'b10, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
        check(2'b10, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0);
        check(2'b10, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1);
        check(2'b10, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0);

        check(2'b11, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        check(2'b11, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
        check(2'b11, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0);
        check(2'b11, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        check(2'b11, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1);
        $finish;
    end
endmodule
