`timescale 1ns / 1ps

module decode_memory (
    input  wire       g_mem,
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

    wire is_reg;
    wire mem_we;
    wire is_ind;

    wire [1:0] dst_reg;
    wire [1:0] src_reg;
    wire [2:0] mem_addr_sel;

    wire hlt_internal;
    wire alu_wb_internal;
    wire op_size_internal;

    wire [2:0] dst_sel_internal;
    wire [2:0] src_sel_internal;

    wire src_sel_control;

    // FR aparece no circuito, mas nesta parte não é usado diretamente.
    wire unused_fr;
    assign unused_fr = |fr;

    assign ir0 = ir[0];
    assign ir1 = ir[1];
    assign ir2 = ir[2];
    assign ir3 = ir[3];
    assign ir4 = ir[4];

    assign is_reg = ir4;

    assign mem_we = ir2 & ~is_reg;
    assign is_ind = ir3 & ~is_reg;

    assign dst_reg = {ir1, ir0};

    assign src_reg = is_reg ? {ir3, ir2} : {ir1, ir0};

    assign mem_addr_sel = {is_ind, ~is_ind, ~is_ind};

    assign hlt_internal = (ir0 & ir1) | (ir2 & ir3 & ir4);

    assign alu_wb_internal = ~hlt_internal;

    assign op_size_internal = ~(is_ind | is_reg);

    assign dst_sel_internal = mem_we ? mem_addr_sel : {1'b0, dst_reg};

    assign src_sel_control = is_reg | mem_we;

    assign src_sel_internal = src_sel_control ? {1'b0, src_reg} : mem_addr_sel;

    assign hlt = g_mem & hlt_internal;

    assign alu_wb = g_mem & alu_wb_internal;

    assign op_size = g_mem ? {op_size_internal, 1'b0} : 2'b00;

    assign dst_sel = g_mem ? dst_sel_internal : 3'b000;

    assign src_sel = g_mem ? src_sel_internal : 3'b000;

    assign alu_op = g_mem ? 4'b1000 : 4'b0000;

endmodule
