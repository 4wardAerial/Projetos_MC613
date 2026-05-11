module dram_iface (
    input  wire        clk,
    input  wire        rst,       // Reset limpo vindo do top_level
    input  wire [9:0]  SW,        // Chaves da placa
    input  wire [3:0]  KEY,       // Botões
    
    input  wire        ready,     // Status do controlador
    inout  wire [7:0]  data,      // Barramento bidirecional de dados
    output wire        req,       // Pedido de operação
    output wire        wEn,       // 1 = Write, 0 = Read
    output wire [25:0] address,   // Endereço para a memória
    
    output wire [6:0]  HEX0,      // Displays de 7 Segmentos
    output wire [6:0]  HEX1,
    output wire [6:0]  HEX4,
    output wire [6:0]  HEX5,
	 output wire [2:0] teste
);
assign teste = state;

    // =========================================================================
    // PARÂMETROS DOS ESTADOS
    // =========================================================================
    parameter S_IDLE         = 3'd0;
    parameter S_REQ_RD       = 3'd1;
    parameter S_WAIT_RD      = 3'd2;
    parameter S_REQ_WR       = 3'd3;
    parameter S_WAIT_WR      = 3'd4;
    parameter S_AUTO_REQ_RD  = 3'd5;
    parameter S_AUTO_WAIT_RD = 3'd6;

    // =========================================================================
    // REGISTRADORES INTERNOS
    // =========================================================================
    reg [2:0] state;
    reg       req_reg;
    reg       wEn_reg;
    reg       data_dir;       // 1 = Interface conduz o dado, 0 = High-Z (Controlador conduz)
    reg [7:0] data_out_reg;   // O que vamos escrever
    reg [7:0] display_data;   // O que lemos da memória
    reg [25:0] last_sw_addr;   // Memória do último endereço

    // Sincronizadores para o botão KEY[3] (Antitrepidacao / Debounce)
    reg k3_sync1, k3_sync2, k3_last;

    // =========================================================================
    // DETETORES DE EVENTOS (COMBINACIONAIS)
    // =========================================================================
    // KEY[3] é ativo em LOW. A escrita dispara na borda de descida (quando aperta)
    wire write_trigger = (k3_last == 1'b1 && k3_sync2 == 1'b0);
    
    // O endereço mudou se as chaves SW[9:4] estiverem diferentes do último valor gravado
    wire addr_changed = (address != last_sw_addr);

    // =========================================================================
    // ATRIBUIÇÕES CONTÍNUAS (ASSIGNS)
    // =========================================================================
    assign req = req_reg;
    assign wEn = wEn_reg;
    
    // Concatena o endereço selecionado com zeros para formar os 26 bits
    assign address = {SW[9], 1'b0, SW[8:6], 19'b0, SW[5:4]};

    // Controle inteligente do barramento tristate
    assign data = data_dir ? data_out_reg : 8'bz;

    // =========================================================================
    // MÁQUINA DE ESTADOS PRINCIPAL (SÍNCRONA)
    // =========================================================================
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= S_IDLE;
            req_reg      <= 1'b0;
            wEn_reg      <= 1'b0;
            data_dir     <= 1'b0;
            data_out_reg <= 8'b0;
            display_data <= 8'b0;
            last_sw_addr <= address; // Inicia sincronizado com as chaves
            
            k3_sync1     <= 1'b1;
            k3_sync2     <= 1'b1;
            k3_last      <= 1'b1;
        end else begin
            
            // 1. Atualiza o filtro do botão
            k3_sync1 <= KEY[3];
            k3_sync2 <= k3_sync1;
            k3_last  <= k3_sync2;

            // 2. Transições de Estado
            case (state)
                
                // --- OCIOSO E VIGILANTE ---
                S_IDLE: begin
                    req_reg  <= 1'b0;
                    data_dir <= 1'b0; // Libera o barramento
                    
                    if (write_trigger && ready) begin
                        state        <= S_REQ_WR;
                        req_reg      <= 1'b1;
                        wEn_reg      <= 1'b1;
                        data_dir     <= 1'b1; // Toma posse do barramento
                        data_out_reg <= {4'h0, SW[3:0]}; // Carrega o dado
                        last_sw_addr <= address; // Memoriza onde vai escrever
                    
                    end else if (addr_changed && ready) begin
                        state        <= S_REQ_RD;
                        req_reg      <= 1'b1;
                        wEn_reg      <= 1'b0;
                        data_dir     <= 1'b0;
                        last_sw_addr <= address; // Memoriza o novo endereço
                    end
                end

                // --- FLUXO DE LEITURA ---
                S_REQ_RD: begin
                    if (!ready) begin 
                        // Controlador reconheceu e baixou o ready
                        state   <= S_WAIT_RD;
                        req_reg <= 1'b0; // Tira o dedo do botão
                    end
                end

                S_WAIT_RD: begin
                    if (ready) begin 
                        // Controlador terminou e devolveu o ready alto
                        display_data <= data; // Bate a foto do dado lido
                        state        <= S_IDLE;
                    end
                end

                // --- FLUXO DE ESCRITA ---
                S_REQ_WR: begin
                    // Mantém a direção do dado firme!
                    wEn_reg  <= 1'b1;
                    data_dir <= 1'b1;
                    
                    if (!ready) begin 
                        state   <= S_WAIT_WR;
                        req_reg <= 1'b0;
                    end
                end

                S_WAIT_WR: begin
                    if (ready) begin 
                        // Escrita finalizada! Dispara uma leitura automática
                        state    <= S_AUTO_REQ_RD;
                        req_reg  <= 1'b1;
                        wEn_reg  <= 1'b0;
                        data_dir <= 1'b0; // Solta o barramento para poder ler
                    end
                end

                // --- FLUXO DE LEITURA AUTOMÁTICA (Após Escrita) ---
                S_AUTO_REQ_RD: begin
                    if (!ready) begin
                        state   <= S_AUTO_WAIT_RD;
                        req_reg <= 1'b0;
                    end
                end

                S_AUTO_WAIT_RD: begin
                    if (ready) begin
                        display_data <= data; // Atualiza o display com o dado recém-escrito
                        state        <= S_IDLE;
                    end
                end

                // Rota de Fuga
                default: state <= S_IDLE;
            endcase
        end
    end

    // =========================================================================
    // INSTANCIAÇÃO DOS DECODIFICADORES 7-SEGMENTOS
    // =========================================================================
    // Exibe o dado lido em Hexadecimal nos displays 0 e 1
    bin2hex dec0 (.BIN(SW[3:0]), .HEX(HEX0));
    bin2hex dec1 (.BIN(display_data[3:0]), .HEX(HEX1));
    
    // Exibe os 6 bits de endereço (SW[9:4]) nos displays 4 e 5
    bin2hex dec4 (.BIN({last_sw_addr[22:21], last_sw_addr[1:0]}),     .HEX(HEX4));
    bin2hex dec5 (.BIN({2'b00, last_sw_addr[25], last_sw_addr[23]}), .HEX(HEX5));

endmodule