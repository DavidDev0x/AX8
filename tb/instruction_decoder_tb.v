`timescale 1ns / 1ps

module instruction_decoder_tb;

    reg  [3:0] fr;
    reg  [7:0] ir;

    wire       hlt;
    wire       alu_wb;
    wire [1:0] pc_op;
    wire [1:0] op_size;
    wire [2:0] dst_sel;
    wire [2:0] src_sel;
    wire [3:0] fr_we;
    wire [3:0] fr_data;
    wire [3:0] alu_op;

    instruction_decoder uut (
        .fr(fr),
        .ir(ir),
        .hlt(hlt),
        .alu_wb(alu_wb),
        .pc_op(pc_op),
        .op_size(op_size),
        .dst_sel(dst_sel),
        .src_sel(src_sel),
        .fr_we(fr_we),
        .fr_data(fr_data),
        .alu_op(alu_op)
    );

    initial begin
        $dumpfile("instruction_decoder.vcd");
        $dumpvars(0, instruction_decoder_tb);

        $display("======================================================================================================");
        $display("   fr   |     ir     | group | hlt | alu_wb | pc_op | op_size | dst | src | fr_we | fr_data | alu_op");
        $display("======================================================================================================");

        // Grupo 000: system
        fr = 4'b1000;
        ir = 8'b00000100;
        #10;
        $display("  %b  |  %b  |  %b  |  %b  |   %b    |  %b   |    %b   | %b | %b |  %b  |   %b    |  %b",
                 fr, ir, ir[7:5], hlt, alu_wb, pc_op, op_size, dst_sel, src_sel, fr_we, fr_data, alu_op);

        // Grupo 001: memory
        fr = 4'b0000;
        ir = 8'b00100100;
        #10;
        $display("  %b  |  %b  |  %b  |  %b  |   %b    |  %b   |    %b   | %b | %b |  %b  |   %b    |  %b",
                 fr, ir, ir[7:5], hlt, alu_wb, pc_op, op_size, dst_sel, src_sel, fr_we, fr_data, alu_op);

        // Grupo 010: arithmetic
        fr = 4'b0000;
        ir = 8'b01000001;
        #10;
        $display("  %b  |  %b  |  %b  |  %b  |   %b    |  %b   |    %b   | %b | %b |  %b  |   %b    |  %b",
                 fr, ir, ir[7:5], hlt, alu_wb, pc_op, op_size, dst_sel, src_sel, fr_we, fr_data, alu_op);

        // Grupo 011: unary
        fr = 4'b0100;
        ir = 8'b01100000;
        #10;
        $display("  %b  |  %b  |  %b  |  %b  |   %b    |  %b   |    %b   | %b | %b |  %b  |   %b    |  %b",
                 fr, ir, ir[7:5], hlt, alu_wb, pc_op, op_size, dst_sel, src_sel, fr_we, fr_data, alu_op);

        // Grupo 100: jump condicional
        fr = 4'b0001;
        ir = 8'b10000100;
        #10;
        $display("  %b  |  %b  |  %b  |  %b  |   %b    |  %b   |    %b   | %b | %b |  %b  |   %b    |  %b",
                 fr, ir, ir[7:5], hlt, alu_wb, pc_op, op_size, dst_sel, src_sel, fr_we, fr_data, alu_op);

        // Grupo inválido 101: deve gerar HLT e zerar controles
        fr = 4'b0000;
        ir = 8'b10100000;
        #10;
        $display("  %b  |  %b  |  %b  |  %b  |   %b    |  %b   |    %b   | %b | %b |  %b  |   %b    |  %b",
                 fr, ir, ir[7:5], hlt, alu_wb, pc_op, op_size, dst_sel, src_sel, fr_we, fr_data, alu_op);

        // Grupo inválido 110: deve gerar HLT e zerar controles
        fr = 4'b0000;
        ir = 8'b11000000;
        #10;
        $display("  %b  |  %b  |  %b  |  %b  |   %b    |  %b   |    %b   | %b | %b |  %b  |   %b    |  %b",
                 fr, ir, ir[7:5], hlt, alu_wb, pc_op, op_size, dst_sel, src_sel, fr_we, fr_data, alu_op);

        // Grupo inválido 111: deve gerar HLT e zerar controles
        fr = 4'b0000;
        ir = 8'b11100000;
        #10;
        $display("  %b  |  %b  |  %b  |  %b  |   %b    |  %b   |    %b   | %b | %b |  %b  |   %b    |  %b",
                 fr, ir, ir[7:5], hlt, alu_wb, pc_op, op_size, dst_sel, src_sel, fr_we, fr_data, alu_op);

        $display("======================================================================================================");
        $finish;
    end

endmodule
