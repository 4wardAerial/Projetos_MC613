`timescale 1ns / 1ps

module dram_controller_tb();

    // Sinais de controle (Clock e Reset)
    reg clk;
    reg rst;

    // Interface com o Controlador (Simulando o dram_iface)
    reg  [25:0] tb_address;
    reg         tb_req;
    reg         tb_wEn;
    wire        tb_ready;
    
    // Barramento interno de dados (inout)
    wire [7:0]  tb_data;
    reg  [7:0]  tb_data_drive;
    reg         tb_drive_data_bus;
    
    // Interface Física com a SDRAM simulada
    wire        sdram_cke;
    wire        sdram_cs_n;
    wire        sdram_ras_n;
    wire        sdram_cas_n;
    wire        sdram_we_n;
    wire [1:0]  sdram_ba;
    wire [12:0] sdram_a;
    wire [1:0]  sdram_dqm; // Assumindo 2 bits para x16
    wire [15:0] sdram_dq;

    // =========================================================================
    // Controle dos barramentos Inout (Tri-state)
    // =========================================================================
    // O TB dirige o barramento 'data' quando estamos enviando uma ESCRITA
    assign tb_data = tb_drive_data_bus ? tb_data_drive : 8'bz;
    
    // Simulação simplificada de resposta da memória SDRAM
    // Quando CAS e WE estão baixos (Write), a memória não dirige o barramento.
    // Para simplificar a simulação de leitura, injetamos um valor fixo (16'hA5A5) 
    // no barramento físico para ver se o controlador repassa corretamente para 'tb_data'.
    reg mock_sdram_drive;
    assign sdram_dq = mock_sdram_drive ? 16'hA5A5 : 16'bz;

    // =========================================================================
    // Instanciação do Device Under Test (DUT)
    // =========================================================================
    dram_controller #(
        // REDUZIMOS OS TEMPOS APENAS PARA A SIMULAÇÃO FICAR RÁPIDA
        .INIT_DELAY(10),  // De 14500 para 10 ciclos
        .REF_PERIOD(400) // De 1000 para 100 ciclos (para vermos um refresh logo)
    ) uut (
        .clk(clk),
        .rst(rst),
        .address(tb_address),
        .data(tb_data),
        .req(tb_req),
        .wEn(tb_wEn),
        .ready(tb_ready),
        .dram_cke(sdram_cke),
        .dram_cs_n(sdram_cs_n),
        .dram_ras_n(sdram_ras_n),
        .dram_cas_n(sdram_cas_n),
        .dram_we_n(sdram_we_n),
        .dram_ba(sdram_ba),
        .dram_addr(sdram_a),
        .dram_udqm(sdram_dqm[1]),
		  .dram_ldqm(sdram_dqm[0]),
        .dram_dq(sdram_dq)
    );

    // =========================================================================
    // Geração de Clock (143 MHz = ~7ns de período -> 3.5ns por semiciclo)
    // =========================================================================
    initial begin
        clk = 0;
        forever #3.5 clk = ~clk;
    end

    // =========================================================================
    // Estímulos de Teste
    // =========================================================================
    initial begin
        // 1. Inicialização segura
        rst = 1;
        tb_req = 0;
        tb_wEn = 0;
        tb_address = 0;
        tb_drive_data_bus = 0;
        mock_sdram_drive = 0;

        // Aguarda alguns ciclos e libera o reset
        #20 rst = 0;
        
        $display("[%0t] Reset liberado. Aguardando inicializacao da SDRAM...", $time);

        // Aguarda a flag ready subir (fim do INIT)
        wait(tb_ready == 1'b1);
        @(posedge clk); // Sincroniza
        $display("[%0t] SDRAM Pronta!", $time);

        // ---------------------------------------------------------------------
        // TESTE 1: Operação de Escrita (WRITE)
        // ---------------------------------------------------------------------
        $display("[%0t] Iniciando ESCRITA...", $time);
        tb_req = 1;
        tb_wEn = 1;
        tb_address = 26'h0001024; // Endereço de teste (bit 0 = 0 -> Lower Byte)
        tb_data_drive = 8'hBB;    // Dado a ser escrito
        tb_drive_data_bus = 1;    // TB assume o controle do barramento

        // Deixa o request alto por apenas 1 ciclo (como o iface faria)
        @(posedge clk);
        tb_req = 0;

        // Aguarda a FSM processar (ACT -> WRITE -> PRE) e voltar ao S_READY
		  @(posedge clk);
        wait(tb_ready == 1'b1);
        tb_drive_data_bus = 0; // Libera o barramento
        $display("[%0t] ESCRITA Concluida.", $time);

        // Aguarda 5 ciclos de "folga"
        repeat(5) @(posedge clk);

        // ---------------------------------------------------------------------
        // TESTE 2: Operação de Leitura (READ)
        // ---------------------------------------------------------------------
        $display("[%0t] Iniciando LEITURA...", $time);
        tb_req = 1;
        tb_wEn = 0;
        tb_address = 26'h0001025; // Bit 0 = 1 -> Upper Byte (para ver o DQM mudar)
        
        @(posedge clk);
        tb_req = 0;

        // Simula a memória enviando o dado após a CAS Latency.
        // O controlador envia READ, espera CL=3 e então lê o barramento.
        // Para simplificar, ativamos o drive falso da memória após alguns ciclos.
        repeat(5) @(posedge clk);
        mock_sdram_drive = 1; 
        
        wait(tb_ready == 1'b1);
        mock_sdram_drive = 0;
        $display("[%0t] LEITURA Concluida.", $time);

        // ---------------------------------------------------------------------
        // TESTE 3: Observação do Auto-Refresh
        // ---------------------------------------------------------------------
        $display("[%0t] Aguardando contador de Auto-Refresh...", $time);
        
        // O ready deve cair sozinho quando o contador estourar
        wait(tb_ready == 1'b0);
        $display("[%0t] Refresh Iniciado!", $time);
        
        // Espera voltar a ficar pronto
        wait(tb_ready == 1'b1);
        $display("[%0t] Refresh Concluido!", $time);

        // Fim da simulação
        #50 $stop;
    end

endmodule