`timescale 1ns / 1ps

module decode_jump_tb;

    reg        g_jmp;
    reg  [3:0] fr;
    reg  [7:0] ir;

    wire       hlt;
    wire [1:0] pc_op;
    wire [1:0] op_type;

    decode_jump uut (
        .g_jmp(g_jmp),
        .fr(fr),
        .ir(ir),
        .hlt(hlt),
        .pc_op(pc_op),
        .op_type(op_type)
    );

    initial begin
        $dumpfile("decode_jump.vcd");
        $dumpvars(0, decode_jump_tb);

        $display("==============================================================");
        $display(" g_jmp |   fr   |     ir     | hlt | pc_op | op_type");
        $display("==============================================================");

        // G_JMP desligado
        g_jmp = 0;
        fr    = 4'b0000;
        ir    = 8'b00000000;
        #10;
        $display("   %b   |  %b  |  %b  |  %b  |   %b  |    %b",
                 g_jmp, fr, ir, hlt, pc_op, op_type);

        // Branch condicional: FR_Z=1, IR2=1, seleciona FR_Z
        // Deve tomar branch: PC_OP = 01
        g_jmp = 1;
        fr    = 4'b0001;
        ir    = 8'b00000100;
        #10;
        $display("   %b   |  %b  |  %b  |  %b  |   %b  |    %b",
                 g_jmp, fr, ir, hlt, pc_op, op_type);

        // Branch condicional: FR_Z=0, IR2=1
        // Não toma branch: PC_OP = 00
        g_jmp = 1;
        fr    = 4'b0000;
        ir    = 8'b00000100;
        #10;
        $display("   %b   |  %b  |  %b  |  %b  |   %b  |    %b",
                 g_jmp, fr, ir, hlt, pc_op, op_type);

        // Branch condicional invertido: FR_Z=0, IR2=0
        // Toma branch: PC_OP = 01
        g_jmp = 1;
        fr    = 4'b0000;
        ir    = 8'b00000000;
        #10;
        $display("   %b   |  %b  |  %b  |  %b  |   %b  |    %b",
                 g_jmp, fr, ir, hlt, pc_op, op_type);

        // BRA incondicional: IS_UCF=1, IR1=0, IR0=0
        // PC_OP = 01
        g_jmp = 1;
        fr    = 4'b0000;
        ir    = 8'b00010000;
        #10;
        $display("   %b   |  %b  |  %b  |  %b  |   %b  |    %b",
                 g_jmp, fr, ir, hlt, pc_op, op_type);

        // JMP incondicional: IS_UCF=1, IR1=0, IR0=1
        // PC_OP = 10
        g_jmp = 1;
        fr    = 4'b0000;
        ir    = 8'b00010001;
        #10;
        $display("   %b   |  %b  |  %b  |  %b  |   %b  |    %b",
                 g_jmp, fr, ir, hlt, pc_op, op_type);

        // HLT por IS_UCF com IR2=1
        g_jmp = 1;
        fr    = 4'b0000;
        ir    = 8'b00010100;
        #10;
        $display("   %b   |  %b  |  %b  |  %b  |   %b  |    %b",
                 g_jmp, fr, ir, hlt, pc_op, op_type);

        // HLT por IR3=1
        g_jmp = 1;
        fr    = 4'b0000;
        ir    = 8'b00001000;
        #10;
        $display("   %b   |  %b  |  %b  |  %b  |   %b  |    %b",
                 g_jmp, fr, ir, hlt, pc_op, op_type);

        $display("==============================================================");
        $finish;
    end

endmodule
