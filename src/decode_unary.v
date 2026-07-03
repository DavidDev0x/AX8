`timescale 1ns / 1ps

module decode_unary (
    input  wire       g_uny,
    input  wire [3:0] fr,
    input  wire [7:0] ir,

    output wire       hlt,
    output wire       alu_wb,
    output wire [2:0] dst_sel,
    output wire [2:0] src_sel,
    output wire [3:0] fr_we,
    output wire [3:0] fr_data,
    output wire [3:0] alu_op
);

    wire ir0;
    wire ir1;
    wire ir2;
    wire ir3;
    wire ir4;

    wire fr_z;
    wire fr_n;
    wire fr_c;
    wire fr_v;

    wire n_ir3;

    wire [7:0] dec_unary;

    wire alu_shift;
    wire is_hlt;
    wire i_not;
    wire alu_rotate;

    wire i_inc;
    wire i_dec;

    wire hlt_internal;
    wire alu_wb_internal;
    wire out_c;

    wire [2:0] dst_sel_internal;
    wire [2:0] src_sel_internal;
    wire [3:0] fr_we_internal;
    wire [3:0] fr_data_internal;
    wire [3:0] alu_op_internal;

    assign ir0 = ir[0];
    assign ir1 = ir[1];
    assign ir2 = ir[2];
    assign ir3 = ir[3];
    assign ir4 = ir[4];

    assign fr_z = fr[0];
    assign fr_n = fr[1];
    assign fr_c = fr[2];
    assign fr_v = fr[3];

    assign n_ir3 = ~ir3;

    assign dec_unary = n_ir3 ? (8'b00000001 << ir[2:0]) : 8'b00000000;

    assign alu_shift  = dec_unary[0] | dec_unary[1];
    assign is_hlt     = dec_unary[2] | dec_unary[3] | dec_unary[4];
    assign i_not      = dec_unary[5];
    assign alu_rotate = dec_unary[6] | dec_unary[7];

    assign i_inc = ir3 & ~ir2;
    assign i_dec = ir3 &  ir2;

    assign hlt_internal = ir4 | is_hlt | (ir3 & ir0 & ir1);

    assign alu_wb_internal = ~hlt_internal;

    assign out_c = (fr_c | i_inc) & ~alu_shift;

    assign dst_sel_internal = {
        1'b0,
        ir3 & ir1,
        ir3 & ir0
    };

    assign src_sel_internal = {
        1'b1,
        1'b1,
        i_dec | i_not
    };

    assign alu_op_internal = {
        1'b0,
        n_ir3 & (ir2 ^ alu_shift),
        n_ir3 & (ir1 ^ alu_shift),
        n_ir3 & ir0
    };

    assign fr_we_internal = 4'b0000;

    assign fr_data_internal = {
        fr_v,
        out_c,
        fr_n,
        fr_z
    };

    assign hlt     = g_uny & hlt_internal;
    assign alu_wb  = g_uny & alu_wb_internal;
    assign dst_sel = g_uny ? dst_sel_internal : 3'b000;
    assign src_sel = g_uny ? src_sel_internal : 3'b000;
    assign fr_we   = g_uny ? fr_we_internal : 4'b0000;
    assign fr_data = g_uny ? fr_data_internal : 4'b0000;
    assign alu_op  = g_uny ? alu_op_internal : 4'b0000;

    wire unused_alu_rotate;
    assign unused_alu_rotate = alu_rotate;

endmodule
