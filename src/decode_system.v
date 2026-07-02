module decode_system (
    input  wire       g_sys,
    input  wire [3:0] fr,
    input  wire [7:0] ir,

    output wire       hlt,
    output wire [3:0] fr_we,
    output wire [3:0] fr_data,

    output wire       fr_z,
    output wire       fr_n,
    output wire       fr_c,
    output wire       fr_v
);

    wire ir0;
    wire ir1;
    wire ir2;
    wire ir3;
    wire ir4;

    wire hlt_internal;
    wire fr_we_enable;
    wire fr_we_c;
    wire fr_we_v;

    assign fr_z = fr[0];
    assign fr_n = fr[1];
    assign fr_c = fr[2];
    assign fr_v = fr[3];

    assign ir0 = ir[0];
    assign ir1 = ir[1];
    assign ir2 = ir[2];
    assign ir3 = ir[3];
    assign ir4 = ir[4];

    assign hlt_internal = ((ir0 | ir1) & ~ir2) | (ir3 | ir4);

    assign fr_we_enable = ~hlt_internal & ir2;

    assign fr_we_c = fr_we_enable & ~ir1;
    assign fr_we_v = fr_we_enable &  ir1;

    assign hlt = g_sys & hlt_internal;

    assign fr_we = g_sys ? {fr_we_v, fr_we_c, 1'b0, 1'b0} : 4'b0000;

    assign fr_data = g_sys ? {ir0, ir0, fr_n, fr_z} : 4'b0000;

endmodule