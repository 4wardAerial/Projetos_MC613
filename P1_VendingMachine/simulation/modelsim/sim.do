module dram_controller (
	input wire clk,	// clock
	input wire rst,	// Reset
	input wire [25:0] address,	// Endereço completo da DRAM
	inout wire [7:0] data, // Dado lido/a ser escrito
	
	
	input wire req,	// Indica a recepção de um comando no controlador.
	input wire wEn,	// Indica sinal permissão de escrita (o comando é uma escrita)
	
	output wire ready,	// Indica que o controlador está pronto para receber uma nova operação
	inout wire [15:0] dram_dq,
	output reg [12:0] dram_addr,
	output reg [1:0] dram_ba,
	output wire dram_cke,
	output wire dram_ldqm,
	output wire dram_udqm,
	output wire dram_we_n,
	output wire dram_cas_n,
	output wire dram_ras_n,
	output wire dram_cs_n,
	output wire [5:0] teste
);

	//comandos da DRAM
	localparam CMD_MRS  = 4'b0000;
	localparam CMD_REF  = 4'b0001;
	localparam CMD_PRE  = 4'b0010;
	localparam CMD_ACT  = 4'b0011;
	localparam CMD_WRITE = 4'b0100;
	localparam CMD_READ = 4'b0101;
	localparam CMD_NOP  = 4'b0111;
	
	//tempos em ciclos de clock
	parameter TRCD = 15'd3;
	parameter TCAS = 15'd3;
	parameter TRP = 15'd3;
	parameter TRC = 15'd9;
	parameter TDPL = 15'd2;
	parameter TMRD = 15'd3;
	parameter TRAS = 15'd6;
	parameter INIT_DELAY = 30000;
	parameter REF_PERIOD = 1000; // ciclos entre 2 refresh
	
	// Estados da máquina de estados
	localparam S_INIT_WAIT = 6'd0, S_INIT_PRE = 6'd1, S_INIT_REFS = 6'd2;
	localparam S_INIT_MRS = 6'd3, S_READY     = 6'd4, S_ACT       = 6'd5;
	localparam S_RCD      = 6'd6, S_READ      = 6'd7, S_CAS       = 6'd8;
	localparam S_WRITE    = 6'd9, S_DPL      = 6'd10, S_PRE       = 6'd11;
	localparam S_RP      = 6'd12, S_REF      = 6'd13, S_RC        = 6'd15;
	localparam S_CAPT = 6'd16;
	
	reg [5:0] state, next_state; // estado atual e próximo
	reg [15:0] delay_ctr, next_delay_ctr; // conatdor do delay necessário na transição de estados
	reg [10:0] ref_ctr, next_ref_ctr; // contador para marcar quando é necessário fazer um refresh
	reg [3:0] init_ref_ctr, next_init_ref_ctr; // contador para ser feito o número correto de refresh na inicialização
	reg need_refresh, next_need_refresh; // 1 quando precisa de refresh
	reg [3:0] dram_cmd; // comando a ser passado para a DRAM listados em "comandos da DRAM"
	
	reg [7:0] captured_data;
	reg output_en;
	
	assign dram_dq = output_en ? ((address[0] == 1) ? {data, 8'b0} : {8'b0, data}) : 16'bz; // modo 
	assign data = (!output_en && !wEn) ? captured_data : 8'bz;
	assign ready = (state == S_READY) && (delay_ctr == 0) && (!need_refresh);
	//sinais fixos
	assign dram_cke = 1'b1;
	assign {dram_cs_n, dram_ras_n, dram_cas_n, dram_we_n} = dram_cmd;
	assign {dram_udqm, dram_ldqm} = (state == S_INIT_WAIT || state == S_INIT_PRE || state == S_INIT_REFS || state == S_INIT_MRS) ? 2'b11 : ((address[0] == 1) ? 2'b01 : 2'b10);
	assign teste = (state);
	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			state <= S_INIT_WAIT;
			delay_ctr <= 0;
			ref_ctr <= 0;
			init_ref_ctr <= 4'd9;
			need_refresh <= 0;
			captured_data<= 8'b0;
		end else begin
			state <= next_state;
			delay_ctr <= next_delay_ctr;
			ref_ctr <= next_ref_ctr;
			init_ref_ctr <= next_init_ref_ctr;
			need_refresh <=next_need_refresh;
			if (state == S_CAPT && delay_ctr == 0) begin
				captured_data <= (address[0] == 1) ? dram_dq[15:8] : dram_dq[7:0];
			end
		end
	end
	
	always @(*) begin
		//default
		next_state = state;
		next_delay_ctr = delay_ctr;
		next_init_ref_ctr = init_ref_ctr;
		next_need_refresh = need_refresh;
		
		output_en = 1'b0;
		
		dram_cmd = CMD_NOP;
		dram_addr = 13'b0;
		dram_ba = 2'b0;
		
		if(ref_ctr >= REF_PERIOD) begin
			next_need_refresh = 1;
			next_ref_ctr = 0;
		end else begin
			next_ref_ctr = ref_ctr + 1;
		end
		
		if(delay_ctr > 0) begin
			next_delay_ctr = delay_ctr - 1;
		end else begin
			case(state)
				S_INIT_WAIT: begin
					next_need_refresh = 0;
					next_delay_ctr = INIT_DELAY;
					next_state = S_INIT_PRE;
				end
				
				S_INIT_PRE: begin
					dram_addr[10] = 1'b1;
					dram_cmd = CMD_PRE;
					next_state = S_INIT_REFS;
					next_delay_ctr = TRP;
				end
				
				S_INIT_REFS: begin
					dram_cmd = CMD_REF;
					next_delay_ctr = TRC;
					if (init_ref_ctr == 0) begin
						next_state = S_INIT_MRS;
					end else begin
						next_init_ref_ctr = init_ref_ctr - 1;
						next_state = S_INIT_REFS;
					end
					
				end
				
				S_INIT_MRS: begin
					dram_cmd = CMD_MRS;
					dram_addr = 13'b000_1_00_011_0_000;
					next_delay_ctr = TMRD;
					next_state = S_READY;
				end
				
				S_READY: begin
					if(need_refresh) begin
						next_delay_ctr = TRP;
						next_state = S_REF;
					end else if (req) begin
						next_state = S_ACT;
					end
				end
				
				S_ACT: begin
					dram_cmd = CMD_ACT;
					dram_ba = address[25:24];
					dram_addr = address[23:11];
					next_delay_ctr = TRCD;
					next_state = wEn ? S_WRITE : S_READ;
				end
				
				S_READ: begin
					dram_cmd = CMD_READ;
					
					dram_ba = address[25:24];
					dram_addr[9:0] = address[10:1];
					dram_addr[10] = 1'b0; // desabilita auto precharge	
					
					next_delay_ctr = TCAS;
					next_state = S_CAPT;
				end
				
				S_CAPT: begin
					next_delay_ctr = TCAS;
					next_state = S_PRE;
				end
				
				S_WRITE: begin
					dram_cmd = CMD_WRITE;
					
					dram_ba = address[25:24];
					dram_addr[9:0] = address[10:1];
					dram_addr[10] = 1'b0; // desabilita auto precharge	
					
					output_en = 1'b1;
					
					next_delay_ctr = TDPL + TRAS;
					next_state = S_PRE;
				end
			
				
				S_PRE: begin
					dram_cmd = CMD_PRE;
					
					dram_addr[10] = 1'b1; //all banks
					next_delay_ctr = TRP + TRAS;
					next_state = S_READY;
				end
				
				S_REF: begin
					dram_cmd = CMD_REF;
					next_need_refresh = 1'b0;
					
					next_delay_ctr = TRC;
					next_state = S_READY;
				end
			endcase
		end
		
		
	end
	
	
	
endmodule
