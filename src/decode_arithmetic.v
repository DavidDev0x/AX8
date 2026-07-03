`timescale 1ns / 1ps

module decode_arithmetic (
    input  wire       g_ari,
    input  wire [3:0] fr,
    input  wire [7:0] ir,

    output wire       hlt,
    output wire       alu_wb,
    output wire [1:0] op_size,
    output wire [2:0] dst_sel,
    output wire [2:0] src_sel,
    output wire [3:0] alu_op
);

    wire ir0;
    wire ir1;
    wire ir2;
    wire ir3;
    wire ir4;

    wire hlt_internal;
    wire i_cmp;
    wire alu_wb_internal;

    wire [1:0] op_size_internal;
    wire [2:0] dst_sel_internal;
    wire [2:0] src_sel_internal;
    wire [3:0] alu_op_internal;

    wire unused_fr;

    assign unused_fr = |fr;

    assign ir0 = ir[0];
    assign ir1 = ir[1];
    assign ir2 = ir[2];
    assign ir3 = ir[3];
    assign ir4 = ir[4];

    assign hlt_internal = (ir0 & ir1 & ir2) | (ir3 & ~ir4);

    assign i_cmp = ir1 & ir2;

    assign alu_wb_internal = ~(i_cmp | hlt_internal);

    assign alu_op_internal = {
        1'b0,
        ir2 ^ i_cmp,
        ir1 ^ i_cmp,
        ir0 ^ i_cmp
    };

    assign src_sel_internal = {
        ir3 & ir4,
        ~ir3 & ir4,
        1'b1
    };

    assign op_size_internal = {
        ~ir3 & ir4,
        ir3 & ir4
    };

    assign dst_sel_internal = 3'b000;

    assign hlt     = g_ari & hlt_internal;
    assign alu_wb  = g_ari & alu_wb_internal;
    assign op_size = g_ari ? op_size_internal : 2'b00;
    assign dst_sel = g_ari ? dst_sel_internal : 3'b000;
    assign src_sel = g_ari ? src_sel_internal : 3'b000;
    assign alu_op  = g_ari ? alu_op_internal : 4'b0000;

endmodule
