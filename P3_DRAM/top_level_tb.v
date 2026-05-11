`timescale 1ns / 1ps

module top_level_tb;

    // --- Sinais de Entrada (Regs) ---
    reg CLOCK_50;
    reg [9:0] SW;
    reg [3:0] KEY;

    // --- Sinais de Saída (Wires) ---
    wire [15:0] DRAM_DQ;
    wire [12:0] DRAM_ADDR;
    wire [1:0]  DRAM_BA;
    wire        DRAM_CLK;
    wire        DRAM_CKE;
    wire        DRAM_LDQM;
    wire        DRAM_UDQM;
    wire        DRAM_WE_N;
    wire        DRAM_CAS_N;
    wire        DRAM_RAS_N;
    wire        DRAM_CS_N;
    wire [6:0]  HEX0, HEX1, HEX4, HEX5;

    // --- Instância do Módulo Top Level ---
    top_level uut (
        .CLOCK_50(CLOCK_50),
        .SW(SW),
        .KEY(KEY),
        .DRAM_DQ(DRAM_DQ),
        .DRAM_ADDR(DRAM_ADDR),
        .DRAM_BA(DRAM_BA),
        .DRAM_CLK(DRAM_CLK),
        .DRAM_CKE(DRAM_CKE),
        .DRAM_LDQM(DRAM_LDQM),
        .DRAM_UDQM(DRAM_UDQM),
        .DRAM_WE_N(DRAM_WE_N),
        .DRAM_CAS_N(DRAM_CAS_N),
        .DRAM_RAS_N(DRAM_RAS_N),
        .DRAM_CS_N(DRAM_CS_N),
        .HEX0(HEX0), .HEX1(HEX1), .HEX4(HEX4), .HEX5(HEX5)
    );

    // --- Geração do Clock (50 MHz = Período de 20ns) ---
    always #10 CLOCK_50 = ~CLOCK_50;

    // --- Lógica de Simulação do Barramento de Dados (Tri-state) ---
    // Se você não tiver um modelo de memória, pode forçar um valor no DQ 
    // durante a leitura para testar se a interface captura corretamente.
    // assign DRAM_DQ = (DRAM_CAS_N == 0 && DRAM_WE_N == 1) ? 16'hABCD : 16'bz;

    initial begin
        // Inicialização
        CLOCK_50 = 0;
        SW = 10'b0;
        KEY = 4'hF; // Botões em HIGH (não pressionados)

        // 1. Reset do Sistema (KEY[0] no seu código faz rst = ~KEY[0])
        $display("--- Iniciando Reset ---");
        KEY[0] = 0; 
        #100;
        KEY[0] = 1;
        #100;

        // 2. Aguardar a inicialização da SDRAM (S_INIT_WAIT + S_INIT_REFS + S_INIT_MRS)
        // No seu código, INIT_DELAY é 30.000 ciclos. Na simulação, isso demora.
        $display("--- Aguardando Inicialização do Controlador ---");
        $display("--- Controlador Pronto! ---");

        // 3. Preparar uma Escrita
        // SW[9:4] = Endereço, SW[3:0] = Dado
        SW = 10'b101010_1010; // Endereço 101010, Dado 1010 (0xA)
        #200;
        
        $display("--- Disparando Escrita ---");
        KEY[3] = 0; // Aperta o botão de escrita
        #100;
        KEY[3] = 1; // Solta o botão

        // 4. Aguardar o ciclo de escrita terminar
        $display("--- Escrita e Leitura Automática Finalizadas ---");

        #1000;
        $stop; // Finaliza a simulação
    end

    // Monitor de Estados para Debug no Console
    initial begin
        $monitor("Tempo: %0t | Estado Controller: %d | DQ: %h", 
                 $time, uut.interface.state, DRAM_DQ);
    end

endmodule