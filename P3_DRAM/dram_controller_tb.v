`timescale 1ns / 1ps

module dram_controller_tb();

    reg clk;
    reg rst;

    // Interface do Controlador
    reg  [25:0] address;
    reg         req;
    reg         wEn;
    wire        ready;
    wire [7:0]  data;

    // Controle bidirecional do TB
    reg  [7:0]  data_drive;
    reg         drive_data_bus;

    // Interface Física da SDRAM
    wire        dram_cke;
    wire        dram_cs_n;
    wire        dram_ras_n;
    wire        dram_cas_n;
    wire        dram_we_n;
    wire [1:0]  dram_ba;
    wire [12:0] dram_addr;
    wire        dram_udqm;
    wire        dram_ldqm;
    wire [15:0] dram_dq;

    assign data = drive_data_bus ? data_drive : 8'bz;

    // Mock simples da resposta da SDRAM para leitura
    reg mock_sdram_drive;
    assign dram_dq = mock_sdram_drive ? 16'hA5A5 : 16'bz;

    dram_controller #(
        .INIT_DELAY(10),  
        .REF_PERIOD(100) 
    ) uut (
        .clk(clk),
        .rst(rst),
        .address(address),
        .data(data),
        .req(req),
        .wEn(wEn),
        .ready(ready),
        .dram_cke(dram_cke),
        .dram_cs_n(dram_cs_n),
        .dram_ras_n(dram_ras_n),
        .dram_cas_n(dram_cas_n),
        .dram_we_n(dram_we_n),
        .dram_ba(dram_ba),
        .dram_addr(dram_addr),
        .dram_udqm(dram_udqm),
        .dram_ldqm(dram_ldqm),
        .dram_dq(dram_dq)
    );

    // Clock (143 MHz)
    initial begin
        clk = 0;
        forever #3.5 clk = ~clk;
    end

    initial begin
        rst = 1;
        req = 0;
        wEn = 0;
        address = 0;
        drive_data_bus = 0;
        mock_sdram_drive = 0;

        #20 rst = 0;
        $display("[%0t] Reset liberado.", $time);

        wait(ready == 1'b1);
        @(posedge clk);
        $display("[%0t] SDRAM Pronta!", $time);

        // --- TESTE 1: Escrita ---
        $display("[%0t] Iniciando ESCRITA...", $time);
        req = 1;
        wEn = 1;
        address = 26'h0001024; 
        data_drive = 8'hBB;
        drive_data_bus = 1;

        @(posedge clk);
        req = 0;

        @(posedge clk);
        wait(ready == 1'b1);
        drive_data_bus = 0;
        $display("[%0t] ESCRITA Concluida.", $time);

        repeat(5) @(posedge clk);

        // --- TESTE 2: Leitura ---
        $display("[%0t] Iniciando LEITURA...", $time);
        req = 1;
        wEn = 0;
        address = 26'h0001025;
        
        @(posedge clk);
        req = 0;

        repeat(5) @(posedge clk);
        mock_sdram_drive = 1;
        wait(ready == 1'b1);
        mock_sdram_drive = 0;
        $display("[%0t] LEITURA Concluida.", $time);

        // --- TESTE 3: Auto-Refresh ---
        $display("[%0t] Aguardando Auto-Refresh...", $time);
        wait(ready == 1'b0);
        $display("[%0t] Refresh Iniciado!", $time);
        
        wait(ready == 1'b1);
        $display("[%0t] Refresh Concluido!", $time);

        #50 $stop;
    end

endmodule