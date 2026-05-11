`timescale 1ns / 1ps

module tb_dram_iface();

    reg clk;
    reg rst;
    
    reg [9:0] SW;
    reg [3:0] KEY;
    
    wire ready;
    wire req; //req é o pedido da operação
    wire wEn;
    wire [25:0] address;
    wire [7:0] data;
    
    wire [6:0] HEX0, HEX1, HEX4, HEX5;

    wire [2:0] teste;

   
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
        .HEX5(HEX5),
        .teste(teste)
    );

   
    // Vamos criar um clock de 50 MZ
    initial begin
        clk = 0;
        forever #10 clk = ~clk; 
    end

    
    reg mock_ready;
    reg [7:0] mock_data_out;
    reg mock_data_en;
    reg [2:0] m_state;

    assign ready = mock_ready;
    // só injeta dados na leitura.
    assign data = mock_data_en ? mock_data_out : 8'bz;

    always @(posedge clk) begin
        if (rst) begin
            mock_ready   <= 1'b1;
            mock_data_en <= 1'b0;
            m_state      <= 0;
        end else begin
            case (m_state)
                0: begin // caso do IDLE
                    mock_ready   <= 1'b1;
                    mock_data_en <= 1'b0;
                    if (req) m_state <= 1; // se temos um pedido, vamos para o próximo estado
                end
                
                1: begin // caso que vamos processar o req
                    mock_ready <= 1'b0; 
                    if (!req) m_state <= 2; 
                end
                
                2: begin // vamos para a memória
                    repeat(5) @(posedge clk); // um atraso pequeno(pra pudermos simular)
                    
                    if (!wEn) begin // Se é leitura, vamos pegar e colocar um dado que depende do endereço 
                        mock_data_en  <= 1'b1;
                        mock_data_out <= address[7:0] + 8'hA0; // Ex: Endereço 2 + A0 = A2
                    end
                    
                    mock_ready <= 1'b1; // Fazer que o ready seja 1 para simbolizar o fim
                    m_state    <= 3;
                end
                
                3: begin // reinicia o ciclo para o ready
                    mock_data_en <= 1'b0;
                    m_state      <= 0;
                end
            endcase
        end
    end

    // Alguns testes reais.
    initial begin
        // Inicialização
        rst = 1;
        SW = 10'b0;
        KEY = 4'b1111; // Botão não pressionado
        #50 rst = 0;
        
        
        #100;


        // TESTE 1: Mudar o endereço no SW para a leitura
        $display("[%0t] Teste 1: Alterando SW[9:4] para endereco 0x05.", $time);
        SW[9:4] = 6'h05; 
        
        // Espera todo o ciclo de handshake
        wait (req == 1'b1);
        $display("[%0t] Interface pediu LEITURA", $time);
        
        wait (ready == 1'b1 && req == 1'b0); // Espera a leitura terminar
        
        @(posedge clk); // +1 ciclo para esperar o dado aparecer no display
        $display("[%0t] Teste 1 terminado e o Mock retornou para A5\n", $time);
        
        #100;

        -
        // Teste 2: Escrever dados e observar a leitura automática 
        $display("[%0t] Teste 2: Escrevendo o dado 0x0C.", $time);
        SW[3:0] = 4'hC; // Colocar o C em hexadecimal
        #20;
        
        // Aperta e solta o botão de escrita
        KEY[3] = 1'b0; 
        #60; 
        KEY[3] = 1'b1;
        
        // Ciclo de escrita
        wait (req == 1'b1 && wEn == 1'b1);
        $display("[%0t] Interface pediu escrita. Dado : %h", $time, data);
        wait (ready == 1'b1 && req == 1'b0);
        $display("[%0t] Escrita terminada.", $time);
        
        // Ciclo de leitura automática
        wait (req == 1'b1 && wEn == 1'b0);
        $display("[%0t] Interface fez a leitura automática", $time);
        wait (ready == 1'b1 && req == 1'b0);
        
        @(posedge clk);


        #100 $stop;
    end

endmodule