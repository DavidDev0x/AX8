`timescale 1ns / 1ps

module decode_memory_tb;

    reg        g_mem;
    reg  [3:0] fr;
    reg  [7:0] ir;

    wire       hlt;
    wire       alu_wb;
    wire [1:0] op_size;
    wire [2:0] dst_sel;
    wire [2:0] src_sel;
    wire [3:0] alu_op;

    decode_memory uut (
        .g_mem(g_mem),
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
        $dumpfile("decode_memory.vcd");
        $dumpvars(0, decode_memory_tb);

        $display("=====================================================================");
        $display(" g_mem |    fr    |     ir     | hlt | alu_wb | op_size | dst | src | alu_op");
        $display("=====================================================================");

        // Caso 1: G_MEM desligado
        g_mem = 0;
        fr    = 4'b0000;
        ir    = 8'b00000100;
        #10;
        $display("   %b   |   %b   |  %b  |  %b  |   %b    |    %b   | %b | %b |  %b",
                 g_mem, fr, ir, hlt, alu_wb, op_size, dst_sel, src_sel, alu_op);

        // Caso 2: MEM_WE ativo: IR2=1, IR4=0
        g_mem = 1;
        fr    = 4'b0000;
        ir    = 8'b00000100;
        #10;
        $display("   %b   |   %b   |  %b  |  %b  |   %b    |    %b   | %b | %b |  %b",
                 g_mem, fr, ir, hlt, alu_wb, op_size, dst_sel, src_sel, alu_op);

        // Caso 3: IS_IND ativo: IR3=1, IR4=0
        g_mem = 1;
        fr    = 4'b0000;
        ir    = 8'b00001000;
        #10;
        $display("   %b   |   %b   |  %b  |  %b  |   %b    |    %b   | %b | %b |  %b",
                 g_mem, fr, ir, hlt, alu_wb, op_size, dst_sel, src_sel, alu_op);

        // Caso 4: IS_REG ativo: IR4=1
        g_mem = 1;
        fr    = 4'b0000;
        ir    = 8'b00010000;
        #10;
        $display("   %b   |   %b   |  %b  |  %b  |   %b    |    %b   | %b | %b |  %b",
                 g_mem, fr, ir, hlt, alu_wb, op_size, dst_sel, src_sel, alu_op);

        // Caso 5: HLT ativo por IR0 & IR1
        g_mem = 1;
        fr    = 4'b0000;
        ir    = 8'b00000011;
        #10;
        $display("   %b   |   %b   |  %b  |  %b  |   %b    |    %b   | %b | %b |  %b",
                 g_mem, fr, ir, hlt, alu_wb, op_size, dst_sel, src_sel, alu_op);

        // Caso 6: HLT ativo por IR2 & IR3 & IR4
        g_mem = 1;
        fr    = 4'b0000;
        ir    = 8'b00011100;
        #10;
        $display("   %b   |   %b   |  %b  |  %b  |   %b    |    %b   | %b | %b |  %b",
                 g_mem, fr, ir, hlt, alu_wb, op_size, dst_sel, src_sel, alu_op);

        $display("=====================================================================");
        $finish;
    end

endmodule
