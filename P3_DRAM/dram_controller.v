module dram_controller (
    input  wire clk,       // Clock(143 MHz da PLL)
    input  wire rst,       
    input  wire [25:0] address,   
    inout  wire [7:0]  data,      // Barramento de dados de 8 bits com a interface
    
    input  wire req,       // Pedido de operação
    input  wire wEn,       // 1 = Write, 0 = Read
    
    output wire ready,     // 1 = Controlador livre
    inout  wire [15:0] dram_dq,   // Pinos - dados da SDRAM
    output reg  [12:0] dram_addr, // Pinos - endereço da SDRAM
    output reg  [1:0]  dram_ba,   // Pinos - Bank Address
    output wire dram_cke,  // Clock Enable
    output wire dram_ldqm, // Lower Byte Mask
    output wire dram_udqm, // Upper Byte Mask
    output wire dram_we_n, // Write Enable
    output wire dram_cas_n,// Column Address Strobe
    output wire dram_ras_n,// Row Address Strobe
    output wire dram_cs_n // Chip Select
);

    
    // Comandos SDRAM CS, RAS, CAS, WE
    parameter CMD_MRS = 4'b0000;
    parameter CMD_REF = 4'b0001;
    parameter CMD_PRE = 4'b0010;
    parameter CMD_ACT = 4'b0011;
    parameter CMD_WRITE = 4'b0100;
    parameter CMD_READ = 4'b0101;
    parameter CMD_NOP = 4'b0111;

    // Tempos em ciclos de clock (143 MHz)
    parameter TRCD = 15'd3;
    parameter TCAS = 15'd3;
    parameter TRP = 15'd3;
    parameter TRC = 15'd9;
    parameter TDPL = 15'd2;
    parameter TMRD = 15'd3;
    parameter TRAS = 15'd6;
    parameter INIT_DELAY = 15'd30000; // ~200us
    parameter REF_PERIOD = 15'd1000;  // Refresh a cada ~7us

    // código dos estados
    parameter S_INIT_WAIT = 6'd0, S_INIT_PRE = 6'd1,  S_INIT_REFS = 6'd2;
    parameter S_INIT_MRS  = 6'd3, S_READY    = 6'd4,  S_ACT       = 6'd5;
    parameter S_READ      = 6'd7, S_WRITE    = 6'd9,  S_PRE       = 6'd11;
    parameter S_REF       = 6'd13, S_CAPT    = 6'd16;



    reg [5:0]  state;
    reg [15:0] delay_ctr;
    reg [10:0] ref_ctr;
    reg [3:0]  init_ref_ctr;
    reg need_refresh;
    reg is_write_op; // guarda se a operação é R ou W

    reg [3:0] dram_cmd;
    reg [7:0] captured_data;
    reg output_en;


    // fala pra interface que estamos prontos
    assign ready = (state == S_READY) && (delay_ctr == 0) && (!need_refresh);
<<<<<<< HEAD
    
    // liga o estado aos LEDs
    assign teste = state;
=======
>>>>>>> bb41f9e940a0d48be1004d6326bf8772168b1c05

    // Pinos fixos da SDRAM
    assign dram_cke = 1'b1;
    assign {dram_cs_n, dram_ras_n, dram_cas_n, dram_we_n} = dram_cmd;

    // 0 = Ativo, 1 = Mascarado
    assign {dram_udqm, dram_ldqm} = (address[0] == 1) ? 2'b01 : 2'b10;

   
    // escrita vamos pegar do 'data' e colocar no 'dram_dq'
    assign dram_dq = output_en ? ((address[0] == 1) ? {data, 8'h00} : {8'h00, data}) : 16'bz;
    
    // o valor que foi lido
    assign data = (!output_en && !wEn) ? captured_data : 8'bz;

    //máquina de estados
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state         <= S_INIT_WAIT;
            delay_ctr     <= 0;
            ref_ctr       <= 0;
            init_ref_ctr  <= 0;
            need_refresh  <= 0;
            is_write_op   <= 0;
            captured_data <= 8'b0;
            dram_cmd      <= CMD_NOP;
            dram_addr     <= 13'b0;
            dram_ba       <= 2'b0;
            output_en     <= 1'b0;
        end else begin
            
            // 1. Contador de Auto-Refresh , sempre está atualizando
            if (ref_ctr >= REF_PERIOD) begin
                need_refresh <= 1'b1;
                ref_ctr      <= 0;
            end else begin
                ref_ctr <= ref_ctr + 1;
            end

            
            // A menos que o case(state) diga o contrário, o comando é sempre NOP
            dram_cmd  <= CMD_NOP; 
            output_en <= 1'b0;

    
            if (delay_ctr > 0) begin
                delay_ctr <= delay_ctr - 1;
                
            
                if (state == S_WRITE) output_en <= 1'b1;
                // Quando falta apenas 1 ciclo para o S_CAPT acabar, capturamos o dado
                if (delay_ctr == 1 && state == S_CAPT) begin
                    captured_data <= (address[0] == 1) ? dram_dq[15:8] : dram_dq[7:0];
                end

            end else begin
                case (state)
                    S_INIT_WAIT: begin
                        delay_ctr <= INIT_DELAY;
                        state     <= S_INIT_PRE;
                    end
                    
                    S_INIT_PRE: begin
                        dram_cmd      <= CMD_PRE;
                        dram_addr[10] <= 1'b1; //precharge todos os banks
                        delay_ctr     <= TRP;
                        init_ref_ctr  <= 8;    // Precisamos fazer 8 refreshes
                        state         <= S_INIT_REFS;
                    end
                    
                    S_INIT_REFS: begin
                        dram_cmd  <= CMD_REF;
                        delay_ctr <= TRC;
                        if (init_ref_ctr == 0) begin
                            state <= S_INIT_MRS;
                        end else begin
                            init_ref_ctr <= init_ref_ctr - 1;
                            state        <= S_INIT_REFS;
                        end
                    end
                    
                    S_INIT_MRS: begin
                        dram_cmd  <= CMD_MRS;
                        dram_addr <= 13'b000_1_00_011_0_000; // CL=3, Burst=1
                        delay_ctr <= TMRD;
                        state     <= S_READY;
                    end
                    
                    //IDLE
                    S_READY: begin
                        if (need_refresh) begin
                            state <= S_REF;
                        end else if (req) begin
                            state       <= S_ACT;
                            is_write_op <= wEn; // qual a operação
                        end
                    end
                    
                    // REFRESH 
                    S_REF: begin
                        dram_cmd     <= CMD_REF;
                        delay_ctr    <= TRC;
                        need_refresh <= 1'b0; 
                        state        <= S_READY;
                    end
                    
                    S_ACT: begin
                        dram_cmd  <= CMD_ACT;
                        dram_ba   <= address[25:24];
                        dram_addr <= address[23:11]; // Row Address
                        delay_ctr <= TRCD;
                        state     <= is_write_op ? S_WRITE : S_READ;
                    end
                    
                    S_WRITE: begin
                        dram_cmd      <= CMD_WRITE;
                        dram_ba       <= address[25:24];
                        dram_addr[9:0]<= address[10:1]; // Column Address
                        dram_addr[10] <= 1'b0;          // Sem Auto-Precharge
                        
                        output_en <= 1'b1; // Libera a FPGA para mandar o dado
                        
                        delay_ctr <= TDPL + TRAS; // Delay pro dado gravar 
                        state     <= S_PRE;
                    end
                    
                    S_READ: begin
                        dram_cmd      <= CMD_READ;
                        dram_ba       <= address[25:24];
                        dram_addr[9:0]<= address[10:1]; // Column Address
                        dram_addr[10] <= 1'b0;          // Sem Auto-Precharge
                        
                        delay_ctr <= TCAS + 1; // CL = 3 + 1 
                        state     <= S_CAPT;
                    end
                    
                    S_CAPT: begin
                        state <= S_PRE; // Fecha a linha atual
                    end
                    
                    S_PRE: begin
                        dram_cmd      <= CMD_PRE;
                        dram_addr[10] <= 1'b1; // Fecha todos os banks
                        delay_ctr     <= TRP;
                        state         <= S_READY;
                    end
                    
                    default: begin
                        state <= S_INIT_WAIT;
                    end
                endcase
            end
        end
    end

endmodule