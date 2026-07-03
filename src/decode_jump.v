`timescale 1ns / 1ps

module decode_jump (
    input  wire       g_jmp,
    input  wire [3:0] fr,
    input  wire [7:0] ir,

    output wire       hlt,
    output wire [1:0] pc_op,
    output wire [1:0] op_type
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

    wire is_cb;
    wire is_ucf;

    wire selected_flag;
    wire cb_bra;

    wire i_bra;
    wire i_jmp;
    wire take_branch;

    wire hlt_internal;
    wire [1:0] pc_op_internal;
    wire [1:0] op_type_internal;

    assign ir0 = ir[0];
    assign ir1 = ir[1];
    assign ir2 = ir[2];
    assign ir3 = ir[3];
    assign ir4 = ir[4];

    assign fr_z = fr[0];
    assign fr_n = fr[1];
    assign fr_c = fr[2];
    assign fr_v = fr[3];

    /*
        IS_CB = instrução de branch condicional
        IS_UCF = instrução de fluxo incondicional
    */
    assign is_cb  = ~(ir4 | ir3);
    assign is_ucf = ir4 & ~ir3;

    /*
        MUX de flags:
        IR1 IR0 = 00 -> FR_Z
        IR1 IR0 = 01 -> FR_N
        IR1 IR0 = 10 -> FR_C
        IR1 IR0 = 11 -> FR_V
    */
    assign selected_flag = ir1 ? (ir0 ? fr_v : fr_c)
                               : (ir0 ? fr_n : fr_z);

    /*
        CB_BRA = IS_CB & ~(selected_flag ^ IR2)
        Ou seja: branch condicional é tomado quando a flag selecionada bate com IR2.
    */
    assign cb_bra = is_cb & ~(selected_flag ^ ir2);

    /*
        DMX de IS_UCF controlado por IR1:IR0.
        Saída 0 -> I_BRA
        Saída 1 -> I_JMP
    */
    assign i_bra = is_ucf & ~ir1 & ~ir0;
    assign i_jmp = is_ucf & ~ir1 &  ir0;

    assign take_branch = cb_bra | i_bra;

    /*
        HLT:
        HLT = instrução inválida nesse decoder
              ou IS_UCF com IR2 ativo
    */
    assign hlt_internal = ~(is_cb | is_ucf) | (is_ucf & ir2);

    /*
        PC_OP e OP_TYPE usam a mesma lógica no circuito.
        bit0 = branch
        bit1 = jump
    */
    assign pc_op_internal[0] = take_branch & ~i_jmp;
    assign pc_op_internal[1] = i_jmp & ~take_branch;

    assign op_type_internal = pc_op_internal;

    assign hlt     = g_jmp & hlt_internal;
    assign pc_op   = g_jmp ? pc_op_internal   : 2'b00;
    assign op_type = g_jmp ? op_type_internal : 2'b00;

endmodule
