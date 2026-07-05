`timescale 1ns / 1ps

module toplevel_tb;

    reg CLK;
    reg RESET;
    reg RDY;
    reg IN_HLT;

    wire        OUT_HLT;
    wire        RW;
    wire [15:0] ADDR_BUS;
    wire [7:0]  OUT_DATA_BUS;

    integer errors;
    integer cycles;

    reg saw_fff0;
    reg saw_fff1;
    reg saw_8000;
    reg saw_8001;

    toplevel #(
        .ROM_FILE("../tb/toplevel_test.hex")
    ) uut (
        .CLK          (CLK),
        .RESET        (RESET),
        .RDY          (RDY),
        .IN_HLT       (IN_HLT),
        .OUT_HLT      (OUT_HLT),
        .RW           (RW),
        .ADDR_BUS     (ADDR_BUS),
        .OUT_DATA_BUS (OUT_DATA_BUS)
    );

    always #5 CLK = ~CLK;

    task check_byte;
        input [8*32-1:0] name;
        input [7:0] got;
        input [7:0] expected;

        begin
            $display(
                "%0s | GOT=%02h EXPECTED=%02h",
                name,
                got,
                expected
            );

            if (got !== expected) begin
                errors = errors + 1;
                $display("ERRO em %0s", name);
            end
        end
    endtask

    initial begin
        $dumpfile("toplevel.vcd");
        $dumpvars(0, toplevel_tb);

        CLK = 1'b0;
        RESET = 1'b0;
        RDY = 1'b1;
        IN_HLT = 1'b0;

        errors = 0;
        cycles = 0;

        saw_fff0 = 1'b0;
        saw_fff1 = 1'b0;
        saw_8000 = 1'b0;
        saw_8001 = 1'b0;

        #2;

        // RAM select
        uut.ram[15'h0010] = 8'ha5;

        force uut.cpu_addr_bus = 16'h0010;
        force uut.cpu_rw = 1'b1;

        #1;

        check_byte(
            "RAM READ",
            uut.in_data_bus,
            8'ha5
        );

        release uut.cpu_addr_bus;
        release uut.cpu_rw;

        // ROM select
        force uut.cpu_addr_bus = 16'h8010;
        force uut.cpu_rw = 1'b1;

        #1;

        check_byte(
            "ROM READ",
            uut.in_data_bus,
            8'h5a
        );

        release uut.cpu_addr_bus;
        release uut.cpu_rw;

        // RAM write
        force uut.cpu_addr_bus = 16'h0020;
        force uut.cpu_rw = 1'b0;
        force uut.cpu_out_data_bus = 8'h3c;

        @(posedge CLK);
        #1;

        check_byte(
            "RAM WRITE",
            uut.ram[15'h0020],
            8'h3c
        );

        release uut.cpu_addr_bus;
        release uut.cpu_rw;
        release uut.cpu_out_data_bus;

        // RAM disabled when ROM is selected
        uut.ram[15'h0020] = 8'ha5;

        force uut.cpu_addr_bus = 16'h8020;
        force uut.cpu_rw = 1'b0;
        force uut.cpu_out_data_bus = 8'h77;

        @(posedge CLK);
        #1;

        check_byte(
            "ROM AREA BLOCKS RAM WRITE",
            uut.ram[15'h0020],
            8'ha5
        );

        release uut.cpu_addr_bus;
        release uut.cpu_rw;
        release uut.cpu_out_data_bus;

        // Reset CPU
        RESET = 1'b0;

        repeat (2)
            @(posedge CLK);

        @(negedge CLK);
        RESET = 1'b1;

        #2;
        RESET = 1'b0;

        cycles = 0;

        while (!OUT_HLT && cycles < 150) begin
            @(negedge CLK);
            #1;

            cycles = cycles + 1;

            if ((ADDR_BUS == 16'hfff0) && !saw_fff0) begin
                saw_fff0 = 1'b1;
                $display(
                    "RESET VECTOR LOW  | ADDR=%04h DATA=%02h",
                    ADDR_BUS,
                    uut.in_data_bus
                );
            end

            if ((ADDR_BUS == 16'hfff1) && !saw_fff1) begin
                saw_fff1 = 1'b1;
                $display(
                    "RESET VECTOR HIGH | ADDR=%04h DATA=%02h",
                    ADDR_BUS,
                    uut.in_data_bus
                );
            end

            if ((ADDR_BUS == 16'h8000) && !saw_8000) begin
                saw_8000 = 1'b1;
                $display(
                    "FETCH 8000        | ADDR=%04h DATA=%02h",
                    ADDR_BUS,
                    uut.in_data_bus
                );
            end

            if ((ADDR_BUS == 16'h8001) && !saw_8001) begin
                saw_8001 = 1'b1;
                $display(
                    "FETCH 8001        | ADDR=%04h DATA=%02h",
                    ADDR_BUS,
                    uut.in_data_bus
                );
            end
        end

        $display("--------------------------------------------");
        $display("FFF0=%b FFF1=%b 8000=%b 8001=%b HLT=%b",
            saw_fff0,
            saw_fff1,
            saw_8000,
            saw_8001,
            OUT_HLT
        );
        $display("--------------------------------------------");

        if (!saw_fff0)
            errors = errors + 1;

        if (!saw_fff1)
            errors = errors + 1;

        if (!saw_8000)
            errors = errors + 1;

        if (!saw_8001)
            errors = errors + 1;

        if (!OUT_HLT)
            errors = errors + 1;

        if (errors == 0)
            $display("PASS: todos os testes passaram.");
        else
            $display("FAIL: %0d teste(s) falharam.", errors);

        #10;
        $finish;
    end

endmodule
