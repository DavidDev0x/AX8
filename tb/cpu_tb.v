`timescale 1ns / 1ps

module cpu_tb;

    reg         CLK;
    reg         RST_N;
    reg         RDY;
    reg         IN_HLT;
    reg  [7:0]  IN_DATA_BUS;

    wire        OUT_HLT;
    wire        RW;
    wire [15:0] ADDR_BUS;
    wire [7:0]  OUT_DATA_BUS;

    integer errors;
    integer cycles;

    cpu uut (
        .CLK          (CLK),
        .RST_N        (RST_N),
        .RDY          (RDY),
        .IN_HLT       (IN_HLT),
        .IN_DATA_BUS  (IN_DATA_BUS),
        .OUT_HLT      (OUT_HLT),
        .RW           (RW),
        .ADDR_BUS     (ADDR_BUS),
        .OUT_DATA_BUS (OUT_DATA_BUS)
    );

    always #5 CLK = ~CLK;

    always @(*) begin
        case (ADDR_BUS)
            16'hfff0: IN_DATA_BUS = 8'h00;
            16'hfff1: IN_DATA_BUS = 8'h20;
            16'h2000: IN_DATA_BUS = 8'h00;
            16'h2001: IN_DATA_BUS = 8'h1f;
            default:  IN_DATA_BUS = 8'h00;
        endcase
    end

    task show_state;
        input [8*28-1:0] name;

        begin
            $display(
                "%0s | IN_DATA=%02h | HLT=%b RW=%b ADDR=%04h OUT_DATA=%02h | PC=%04h IR=%02h OP=%02h%02h FR=%01h",
                name,
                IN_DATA_BUS,
                OUT_HLT,
                RW,
                ADDR_BUS,
                OUT_DATA_BUS,
                uut.pc_q,
                uut.ir_q,
                uut.op_hi_q,
                uut.op_lo_q,
                uut.fr_q
            );
        end
    endtask

    task expect_addr;
        input [15:0] value;
        input [8*28-1:0] name;

        begin
            if (ADDR_BUS !== value) begin
                errors = errors + 1;
                $display(
                    "ERRO %0s: ADDR esperado=%04h obtido=%04h",
                    name,
                    value,
                    ADDR_BUS
                );
            end
        end
    endtask

    initial begin
        $dumpfile("cpu.vcd");
        $dumpvars(0, cpu_tb);

        CLK    = 1'b0;
        RST_N  = 1'b1;
        RDY    = 1'b1;
        IN_HLT = 1'b0;

        errors = 0;

        #2;
        RST_N = 1'b0;

        #12;
        RST_N = 1'b1;

        #1;

        show_state("RESET VECTOR LOW");
        expect_addr(16'hfff0, "RESET VECTOR LOW");

        @(negedge CLK);
        RDY = 1'b0;

        repeat (3)
            @(posedge CLK);

        #1;

        show_state("RDY STALL");
        expect_addr(16'hfff0, "RDY STALL");

        @(negedge CLK);
        RDY = 1'b1;

        @(posedge CLK);
        #1;

        show_state("RESET VECTOR HIGH");
        expect_addr(16'hfff1, "RESET VECTOR HIGH");

        @(posedge CLK);
        #1;

        show_state("LOAD RESET PC");

        @(posedge CLK);
        #1;

        show_state("BOOT COMPLETE");

        if (uut.pc_q !== 16'h2000) begin
            errors = errors + 1;
            $display(
                "ERRO PC inicial: esperado=2000 obtido=%04h",
                uut.pc_q
            );
        end

        cycles = 0;

        while ((ADDR_BUS !== 16'h2000) && (cycles < 20)) begin
            @(negedge CLK);
            cycles = cycles + 1;
        end

        show_state("FETCH NOP");
        expect_addr(16'h2000, "FETCH NOP");

        cycles = 0;

        while ((ADDR_BUS !== 16'h2001) && (cycles < 30)) begin
            @(negedge CLK);
            cycles = cycles + 1;
        end

        show_state("FETCH HLT");
        expect_addr(16'h2001, "FETCH HLT");

        cycles = 0;

        while ((uut.ir_q !== 8'h1f) && (cycles < 30)) begin
            @(negedge CLK);
            cycles = cycles + 1;
        end

        show_state("HLT DECODED");

        cycles = 0;

        while ((OUT_HLT !== 1'b1) && (cycles < 30)) begin
            @(negedge CLK);
            cycles = cycles + 1;
        end

        show_state("CPU HALTED");

        if (OUT_HLT !== 1'b1) begin
            errors = errors + 1;
            $display("ERRO: CPU nao entrou em HALT");
        end

        @(negedge CLK);
        RST_N = 1'b0;

        repeat (2)
            @(posedge CLK);

        @(negedge CLK);
        RST_N = 1'b1;
        IN_HLT = 1'b1;

        @(posedge CLK);
        #1;

        show_state("EXTERNAL HLT");

        if (OUT_HLT !== 1'b1) begin
            errors = errors + 1;
            $display("ERRO: IN_HLT nao parou a CPU");
        end

        if (errors == 0)
            $display("PASS: todos os testes passaram.");
        else
            $display("FAIL: %0d teste(s) falharam.", errors);

        #10;
        $finish;
    end

endmodule
