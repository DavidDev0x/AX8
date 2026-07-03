`timescale 1ns / 1ps

module decode_arithmetic_tb;

    reg        g_ari;
    reg  [3:0] fr;
    reg  [7:0] ir;

    wire       hlt;
    wire       alu_wb;
    wire [1:0] op_size;
    wire [2:0] dst_sel;
    wire [2:0] src_sel;
    wire [3:0] alu_op;

    decode_arithmetic uut (
        .g_ari(g_ari),
        .fr(fr),
        .ir(ir),
        .hlt(hlt),
        .alu_wb(alu_wb),
        .op_size(op_size),
        .dst_sel(dst_sel),
        .src_sel(src_sel),
        .alu_op(alu_op)
    );

    initial begin
        $dumpfile("decode_arithmetic.vcd");
        $dumpvars(0, decode_arithmetic_tb);

        $display("==========================================================================");
        $display(" g_ari |    fr    |     ir     | hlt | alu_wb | op_size | dst | src | alu_op");
        $display("==========================================================================");

        // G_ARI desligado
        g_ari = 0;
        fr    = 4'b0000;
        ir    = 8'b00000000;
        #10;
        $display("   %b   |   %b   |  %b  |  %b  |   %b    |    %b   | %b | %b |  %b",
                 g_ari, fr, ir, hlt, alu_wb, op_size, dst_sel, src_sel, alu_op);

        // Operação normal, ALU_OP = 0000
        g_ari = 1;
        fr    = 4'b0000;
        ir    = 8'b00000000;
        #10;
        $display("   %b   |   %b   |  %b  |  %b  |   %b    |    %b   | %b | %b |  %b",
                 g_ari, fr, ir, hlt, alu_wb, op_size, dst_sel, src_sel, alu_op);

        // Operação normal, ALU_OP = 0001
        g_ari = 1;
        fr    = 4'b0000;
        ir    = 8'b00000001;
        #10;
        $display("   %b   |   %b   |  %b  |  %b  |   %b    |    %b   | %b | %b |  %b",
                 g_ari, fr, ir, hlt, alu_wb, op_size, dst_sel, src_sel, alu_op);

        // I_CMP ativo: IR1=1 e IR2=1
        g_ari = 1;
        fr    = 4'b0000;
        ir    = 8'b00000110;
        #10;
        $display("   %b   |   %b   |  %b  |  %b  |   %b    |    %b   | %b | %b |  %b",
                 g_ari, fr, ir, hlt, alu_wb, op_size, dst_sel, src_sel, alu_op);

        // HLT ativo por IR0 & IR1 & IR2
        g_ari = 1;
        fr    = 4'b0000;
        ir    = 8'b00000111;
        #10;
        $display("   %b   |   %b   |  %b  |  %b  |   %b    |    %b   | %b | %b |  %b",
                 g_ari, fr, ir, hlt, alu_wb, op_size, dst_sel, src_sel, alu_op);

        // HLT ativo por IR3 & ~IR4
        g_ari = 1;
        fr    = 4'b0000;
        ir    = 8'b00001000;
        #10;
        $display("   %b   |   %b   |  %b  |  %b  |   %b    |    %b   | %b | %b |  %b",
                 g_ari, fr, ir, hlt, alu_wb, op_size, dst_sel, src_sel, alu_op);

        // IR4=1, IR3=0 -> OP_SIZE = 10, SRC_SEL = 011
        g_ari = 1;
        fr    = 4'b0000;
        ir    = 8'b00010000;
        #10;
        $display("   %b   |   %b   |  %b  |  %b  |   %b    |    %b   | %b | %b |  %b",
                 g_ari, fr, ir, hlt, alu_wb, op_size, dst_sel, src_sel, alu_op);

        // IR4=1, IR3=1 -> OP_SIZE = 01, SRC_SEL = 101
        g_ari = 1;
        fr    = 4'b0000;
        ir    = 8'b00011000;
        #10;
        $display("   %b   |   %b   |  %b  |  %b  |   %b    |    %b   | %b | %b |  %b",
                 g_ari, fr, ir, hlt, alu_wb, op_size, dst_sel, src_sel, alu_op);

        $display("==========================================================================");
        $finish;
    end

endmodule
