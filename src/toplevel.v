/* vim: set filetype=verilog : */
`timescale 1ns / 1ps

module toplevel #(
    parameter ROM_FILE = ""
) (
    input         CLK,
    input         RESET,
    input         RDY,
    input         IN_HLT,
    output        OUT_HLT,
    output        RW,
    output [15:0] ADDR_BUS,
    output [7:0]  OUT_DATA_BUS
);
    wire        cpu_rw;
    wire [15:0] cpu_addr_bus;
    wire [7:0]  cpu_out_data_bus;

    wire [14:0] decoded_addr;
    wire        sel_rom;

    wire        we;
    wire        oe;

    wire [7:0] ram_data;
    wire [7:0] rom_data;
    wire [7:0] in_data_bus;

    reg [7:0] ram [0:32767];
    reg [7:0] rom [0:32767];

    integer i;

    // Address decode
    assign decoded_addr = cpu_addr_bus[14:0];
    assign sel_rom = cpu_addr_bus[15];

    not n0 (we, cpu_rw);
    buf b0 (oe, cpu_rw);

    // Memory data mux
    assign ram_data =
        (!sel_rom && oe) ? ram[decoded_addr] : 8'bz;

    assign rom_data = rom[decoded_addr];

    assign in_data_bus =
        sel_rom ? rom_data : ram_data;

    // RAM write
    always @(posedge CLK) begin
        if (we && !sel_rom)
            ram[decoded_addr] <= cpu_out_data_bus;
    end

    initial begin
        for (i = 0; i < 32768; i = i + 1) begin
            ram[i] = 8'h00;
            rom[i] = 8'h00;
        end

        if (ROM_FILE != "")
            $readmemh(ROM_FILE, rom);
    end

    cpu u_cpu (
        .CLK          (CLK),
        .RST_N        (~RESET),
        .RDY          (RDY),
        .IN_HLT       (IN_HLT),
        .IN_DATA_BUS  (in_data_bus),
        .OUT_HLT      (OUT_HLT),
        .RW           (cpu_rw),
        .ADDR_BUS     (cpu_addr_bus),
        .OUT_DATA_BUS (cpu_out_data_bus)
    );

    assign RW = cpu_rw;
    assign ADDR_BUS = cpu_addr_bus;
    assign OUT_DATA_BUS = cpu_out_data_bus;

endmodule
