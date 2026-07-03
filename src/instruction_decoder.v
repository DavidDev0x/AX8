`timescale 1ns / 1ps

module instruction_decoder (
    input  wire [3:0] fr,
    input  wire [7:0] ir,

    output wire       hlt,
    output wire       alu_wb,
    output wire [1:0] pc_op,
    output wire [1:0] op_size,
    output wire [2:0] dst_sel,
    output wire [2:0] src_sel,
    output wire [3:0] fr_we,
    output wire [3:0] fr_data,
    output wire [3:0] alu_op
);

    wire [2:0] op_group;

    wire g_sys;
    wire g_mem;
    wire g_ari;
    wire g_uny;
    wire g_jmp;

    wire invalid_group;

    wire sys_hlt;
    wire mem_hlt;
    wire ari_hlt;
    wire uny_hlt;
    wire jmp_hlt;

    wire mem_alu_wb;
    wire ari_alu_wb;
    wire uny_alu_wb;

    wire [1:0] mem_op_size;
    wire [1:0] ari_op_size;
    wire [1:0] jmp_op_type;

    wire [2:0] mem_dst_sel;
    wire [2:0] ari_dst_sel;
    wire [2:0] uny_dst_sel;

    wire [2:0] mem_src_sel;
    wire [2:0] ari_src_sel;
    wire [2:0] uny_src_sel;

    wire [3:0] sys_fr_we;
    wire [3:0] uny_fr_we;

    wire [3:0] sys_fr_data;
    wire [3:0] uny_fr_data;

    wire [3:0] mem_alu_op;
    wire [3:0] ari_alu_op;
    wire [3:0] uny_alu_op;

    wire [1:0] jmp_pc_op;

    wire hlt_internal;
    wire enable_outputs;

    /*
        OP_GROUP vem dos bits mais altos da instrução:
        IR[7:5]

        000 -> system
        001 -> memory
        010 -> arithmetic
        011 -> unary
        100 -> jump
        101, 110, 111 -> grupo inválido, gera HLT
    */
    assign op_group = ir[7:5];

    assign g_sys = (op_group == 3'b000);
    assign g_mem = (op_group == 3'b001);
    assign g_ari = (op_group == 3'b010);
    assign g_uny = (op_group == 3'b011);

    /*
        Pela lógica do circuito, G_JMP é ativado quando OP_GROUP[2] = 1.
        Mas se OP_GROUP for 101, 110 ou 111, o circuito também gera HLT.
    */
    assign g_jmp = op_group[2];

    assign invalid_group = op_group[2] & (op_group[1] | op_group[0]);

    decode_system u_decode_system (
        .g_sys(g_sys),
        .fr(fr),
        .ir(ir),
        .hlt(sys_hlt),
        .fr_we(sys_fr_we),
        .fr_data(sys_fr_data),
        .fr_z(),
        .fr_n(),
        .fr_c(),
        .fr_v()
    );

    decode_memory u_decode_memory (
        .g_mem(g_mem),
        .fr(fr),
        .ir(ir),
        .hlt(mem_hlt),
        .alu_wb(mem_alu_wb),
        .op_size(mem_op_size),
        .dst_sel(mem_dst_sel),
        .src_sel(mem_src_sel),
        .alu_op(mem_alu_op)
    );

    decode_arithmetic u_decode_arithmetic (
        .g_ari(g_ari),
        .fr(fr),
        .ir(ir),
        .hlt(ari_hlt),
        .alu_wb(ari_alu_wb),
        .op_size(ari_op_size),
        .dst_sel(ari_dst_sel),
        .src_sel(ari_src_sel),
        .alu_op(ari_alu_op)
    );

    decode_unary u_decode_unary (
        .g_uny(g_uny),
        .fr(fr),
        .ir(ir),
        .hlt(uny_hlt),
        .alu_wb(uny_alu_wb),
        .dst_sel(uny_dst_sel),
        .src_sel(uny_src_sel),
        .fr_we(uny_fr_we),
        .fr_data(uny_fr_data),
        .alu_op(uny_alu_op)
    );

    decode_jump u_decode_jump (
        .g_jmp(g_jmp),
        .fr(fr),
        .ir(ir),
        .hlt(jmp_hlt),
        .pc_op(jmp_pc_op),
        .op_type(jmp_op_type)
    );

    assign hlt_internal = invalid_group |
                          sys_hlt |
                          mem_hlt |
                          ari_hlt |
                          uny_hlt |
                          jmp_hlt;

    assign enable_outputs = ~hlt_internal;

    assign hlt = hlt_internal;

    assign alu_wb = enable_outputs & (mem_alu_wb | ari_alu_wb | uny_alu_wb);

    assign pc_op = enable_outputs ? jmp_pc_op : 2'b00;

    assign op_size = enable_outputs ? (mem_op_size | ari_op_size | jmp_op_type) : 2'b00;

    assign dst_sel = enable_outputs ? (mem_dst_sel | ari_dst_sel | uny_dst_sel) : 3'b000;

    assign src_sel = enable_outputs ? (mem_src_sel | ari_src_sel | uny_src_sel) : 3'b000;

    assign fr_we = enable_outputs ? (sys_fr_we | uny_fr_we) : 4'b0000;

    assign fr_data = enable_outputs ? (sys_fr_data | uny_fr_data) : 4'b0000;

    assign alu_op = enable_outputs ? (mem_alu_op | ari_alu_op | uny_alu_op) : 4'b0000;

endmodule
