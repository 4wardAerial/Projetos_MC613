`timescale 1ns / 1ps

module tb_dram_iface();

    // Sinais base
    reg clk;
    reg rst;
    
    // Entradas do Utilizador
    reg [9:0] SW;
    reg [3:0] KEY;
    
    // Ligações entre a Interface e o "Controlador Falso"
    wire        ready;
    wire        req;
    wire        wEn;
    wire [25:0] address;
    wire [7:0]  data;
    
    // Saídas visuais
    wire [6:0] HEX0, HEX1, HEX4, HEX5;

    // =========================================================================
    // INSTANCIAÇÃO DO MÓDULO A TESTAR (DUT)
    // =========================================================================
    dram_iface uut (
        .clk(clk),
        .rst(rst),
        .SW(SW),
        .KEY(KEY),
        .ready(ready),
        .data(data),
        .req(req),
        .wEn(wEn),
        .address(address),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX4(HEX4),
        .HEX5(HEX5)
    );

    // =========================================================================
    // GERAÇÃO DE CLOCK (50 MHz -> Período de 20 ns)
    // =========================================================================
    initial begin
        clk = 0;
        forever #10 clk = ~clk; 
    end

    // =========================================================================
    // EMULADOR DO CONTROLADOR DRAM (Mock Controller c/ Handshake 4 Fases)
    // =========================================================================
    reg       mock_ready;
    reg [7:0] mock_data_out;
    reg       mock_data_en;
    reg [2:0] m_state;

    assign ready = mock_ready;
    // O Testbench só injeta dados na leitura. No resto do tempo fica em High-Z
    assign data = mock_data_en ? mock_data_out : 8'bz;

    always @(posedge clk) begin
        if (rst) begin
            mock_ready   <= 1'b1;
            mock_data_en <= 1'b0;
            m_state      <= 0;
        end else begin
            case (m_state)
                0: begin // IDLE: Controlador livre
                    mock_ready   <= 1'b1;
                    mock_data_en <= 1'b0;
                    if (req) m_state <= 1; // Recebeu um pedido da interface!
                end
                
                1: begin // ACK: Baixa o ready para "Estou a trabalhar"
                    mock_ready <= 1'b0; 
                    if (!req) m_state <= 2; // Espera a interface baixar o req
                end
                
                2: begin // PROCESSA: Finge que vai à memória
                    repeat(5) @(posedge clk); // Simula atraso da SDRAM
                    
                    if (!wEn) begin
                        // Se for LEITURA, injeta um dado falso dependente do endereço
                        mock_data_en  <= 1'b1;
                        mock_data_out <= address[7:0] + 8'hA0; // Ex: Endereço 2 -> Dado A2
                    end
                    
                    mock_ready <= 1'b1; // Sobe o ready: "Terminei!"
                    m_state    <= 3;
                end
                
                3: begin // CLEANUP: Desliga o barramento no ciclo seguinte
                    mock_data_en <= 1'b0;
                    m_state      <= 0;
                end
            endcase
        end
    end

    // =========================================================================
    // ESTÍMULOS DO UTILIZADOR (Testes Reais)
    // =========================================================================
    initial begin
        // 1. Inicialização segura
        rst = 1;
        SW = 10'b0;
        KEY = 4'b1111; // Botão não pressionado
        #50 rst = 0;
        
        $display("\n[%0t] Sistema Inicializado.", $time);
        #100;

        // ---------------------------------------------------------------------
        // TESTE 1: Mudar o endereço no SW para forçar Leitura Automática
        // ---------------------------------------------------------------------
        $display("[%0t] TESTE 1: Alterando SW[9:4] para endereco 0x05.", $time);
        SW[9:4] = 6'h05; // Vai causar a mudança
        
        // Espera todo o ciclo do Handshake
        wait (req == 1'b1);
        $display("[%0t]   -> Interface pediu LEITURA", $time);
        
        wait (ready == 1'b1 && req == 1'b0); // Espera a leitura terminar
        
        @(posedge clk); // +1 ciclo para o dado aparecer no display
        $display("[%0t] TESTE 1 Concluido! (Mock deve ter retornado A5)\n", $time);
        
        #100;

        // ---------------------------------------------------------------------
        // TESTE 2: Escrever dados e observar o Auto-Read de confirmação
        // ---------------------------------------------------------------------
        $display("[%0t] TESTE 2: Escrevendo o dado 0x0C.", $time);
        SW[3:0] = 4'hC; // Configura o dado
        #20;
        
        // Aperta e solta o botão (Mantém por alguns ciclos para o Debouncer ver)
        KEY[3] = 1'b0; 
        #60; // 3 ciclos de relógio
        KEY[3] = 1'b1;
        
        // A) Espera o ciclo de ESCRITA
        wait (req == 1'b1 && wEn == 1'b1);
        $display("[%0t]   -> Interface pediu ESCRITA. Dado no barramento: %h", $time, data);
        wait (ready == 1'b1 && req == 1'b0);
        $display("[%0t]   -> ESCRITA Terminada.", $time);
        
        // B) Espera o ciclo de LEITURA AUTOMÁTICA
        wait (req == 1'b1 && wEn == 1'b0);
        $display("[%0t]   -> Interface disparou o AUTO-READ.", $time);
        wait (ready == 1'b1 && req == 1'b0);
        
        @(posedge clk);
        $display("[%0t] TESTE 2 Concluido com sucesso!\n", $time);

        #100 $stop;
    end

endmodule