`timescale 1ns / 1ps

module decode_system_tb;

    reg        g_sys;
    reg  [3:0] fr;
    reg  [7:0] ir;

    wire       hlt;
    wire [3:0] fr_we;
    wire [3:0] fr_data;
    wire       fr_z;
    wire       fr_n;
    wire       fr_c;
    wire       fr_v;

    decode_system uut (
        .g_sys(g_sys),
        .fr(fr),
        .ir(ir),
        .hlt(hlt),
        .fr_we(fr_we),
        .fr_data(fr_data),
        .fr_z(fr_z),
        .fr_n(fr_n),
        .fr_c(fr_c),
        .fr_v(fr_v)
    );

    initial begin
        $dumpfile("decode_system.vcd");
        $dumpvars(0, decode_system_tb);

        $display("===============================================");
        $display(" g_sys |    fr    |     ir     | hlt | fr_we | fr_data ");
        $display("===============================================");

        // Mesmo caso da imagem: G_SYS=0, FR=1000, IR=00000100
        g_sys = 0;
        fr    = 4'b1000;
        ir    = 8'b00000100;
        #10;
        $display("   %b   |   %b   |  %b  |  %b  |  %b  |   %b",
                 g_sys, fr, ir, hlt, fr_we, fr_data);

        // G_SYS=1, IR2=1, IR1=0 -> deve ativar FR_WE_C
        g_sys = 1;
        fr    = 4'b1000;
        ir    = 8'b00000100;
        #10;
        $display("   %b   |   %b   |  %b  |  %b  |  %b  |   %b",
                 g_sys, fr, ir, hlt, fr_we, fr_data);

        // G_SYS=1, IR2=1, IR1=1 -> deve ativar FR_WE_V
        g_sys = 1;
        fr    = 4'b1000;
        ir    = 8'b00000110;
        #10;
        $display("   %b   |   %b   |  %b  |  %b  |  %b  |   %b",
                 g_sys, fr, ir, hlt, fr_we, fr_data);

        // G_SYS=1, IR3=1 -> deve ativar HLT
        g_sys = 1;
        fr    = 4'b1000;
        ir    = 8'b00001000;
        #10;
        $display("   %b   |   %b   |  %b  |  %b  |  %b  |   %b",
                 g_sys, fr, ir, hlt, fr_we, fr_data);

        // G_SYS=1, IR4=1 -> deve ativar HLT
        g_sys = 1;
        fr    = 4'b1000;
        ir    = 8'b00010000;
        #10;
        $display("   %b   |   %b   |  %b  |  %b  |  %b  |   %b",
                 g_sys, fr, ir, hlt, fr_we, fr_data);

        $display("===============================================");
        $finish;
    end

endmodule
