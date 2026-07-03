`timescale 1ns / 1ps

module decode_unary_tb;

    reg        g_uny;
    reg  [3:0] fr;
    reg  [7:0] ir;

    wire       hlt;
    wire       alu_wb;
    wire [2:0] dst_sel;
    wire [2:0] src_sel;
    wire [3:0] fr_we;
    wire [3:0] fr_data;
    wire [3:0] alu_op;

    decode_unary uut (
        .g_uny(g_uny),
        .fr(fr),
        .ir(ir),
        .hlt(hlt),
        .alu_wb(alu_wb),
        .dst_sel(dst_sel),
        .src_sel(src_sel),
        .fr_we(fr_we),
        .fr_data(fr_data),
        .alu_op(alu_op)
    );

    initial begin
        $dumpfile("decode_unary.vcd");
        $dumpvars(0, decode_unary_tb);

        $display("========================================================================");
        $display(" g_uny |   fr   |     ir     | hlt | alu_wb | dst | src | fr_we | fr_data | alu_op");
        $display("========================================================================");

        g_uny = 0;
        fr    = 4'b0000;
        ir    = 8'b00000000;
        #10;
        $display("   %b   |  %b  |  %b  |  %b  |   %b    | %b | %b |  %b  |   %b    |  %b",
                 g_uny, fr, ir, hlt, alu_wb, dst_sel, src_sel, fr_we, fr_data, alu_op);

        g_uny = 1;
        fr    = 4'b0100;
        ir    = 8'b00000000;
        #10;
        $display("   %b   |  %b  |  %b  |  %b  |   %b    | %b | %b |  %b  |   %b    |  %b",
                 g_uny, fr, ir, hlt, alu_wb, dst_sel, src_sel, fr_we, fr_data, alu_op);

        g_uny = 1;
        fr    = 4'b0100;
        ir    = 8'b00000001;
        #10;
        $display("   %b   |  %b  |  %b  |  %b  |   %b    | %b | %b |  %b  |   %b    |  %b",
                 g_uny, fr, ir, hlt, alu_wb, dst_sel, src_sel, fr_we, fr_data, alu_op);

        g_uny = 1;
        fr    = 4'b0000;
        ir    = 8'b00000010;
        #10;
        $display("   %b   |  %b  |  %b  |  %b  |   %b    | %b | %b |  %b  |   %b    |  %b",
                 g_uny, fr, ir, hlt, alu_wb, dst_sel, src_sel, fr_we, fr_data, alu_op);

        g_uny = 1;
        fr    = 4'b0001;
        ir    = 8'b00000101;
        #10;
        $display("   %b   |  %b  |  %b  |  %b  |   %b    | %b | %b |  %b  |   %b    |  %b",
                 g_uny, fr, ir, hlt, alu_wb, dst_sel, src_sel, fr_we, fr_data, alu_op);

        g_uny = 1;
        fr    = 4'b0000;
        ir    = 8'b00001000;
        #10;
        $display("   %b   |  %b  |  %b  |  %b  |   %b    | %b | %b |  %b  |   %b    |  %b",
                 g_uny, fr, ir, hlt, alu_wb, dst_sel, src_sel, fr_we, fr_data, alu_op);

        g_uny = 1;
        fr    = 4'b0000;
        ir    = 8'b00001100;
        #10;
        $display("   %b   |  %b  |  %b  |  %b  |   %b    | %b | %b |  %b  |   %b    |  %b",
                 g_uny, fr, ir, hlt, alu_wb, dst_sel, src_sel, fr_we, fr_data, alu_op);

        g_uny = 1;
        fr    = 4'b0000;
        ir    = 8'b00001011;
        #10;
        $display("   %b   |  %b  |  %b  |  %b  |   %b    | %b | %b |  %b  |   %b    |  %b",
                 g_uny, fr, ir, hlt, alu_wb, dst_sel, src_sel, fr_we, fr_data, alu_op);

        g_uny = 1;
        fr    = 4'b0000;
        ir    = 8'b00010000;
        #10;
        $display("   %b   |  %b  |  %b  |  %b  |   %b    | %b | %b |  %b  |   %b    |  %b",
                 g_uny, fr, ir, hlt, alu_wb, dst_sel, src_sel, fr_we, fr_data, alu_op);

        $display("========================================================================");
        $finish;
    end

endmodule
