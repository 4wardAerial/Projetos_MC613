module dram_iface (
	input wire clk,	// clock
	input wire rst,	// Reset
	input wire [9:0] SW,		// Switches de entrada (endereço parcial e dado)
	input wire [3:0] KEY,	// Botões da placa (KEY[3] = write, KEY[0] = reset)
	
	input wire ready,	// Indica que o controlador está pronto para receber uma nova operação
	inout wire [7:0] data, // Dado lido/a ser escrito
	
	output wire [6:0] HEX0,	// Exibe o dado de entrada (escrita)
	output wire [6:0] HEX1,	// Exibe o valor lido da memória
	output wire [6:0] HEX4,	// Exibe parte do endereço
	output wire [6:0] HEX5,	// Exibe parte do endereço
	
	output wire [25:0] address,	// Endereço completo da DRAM
	output reg req,	// Indica a recepção de um comando no controlador.
	output reg wEn	// Indica sinal permissão de escrita (o comando é uma escrita)
);

	//estados
	localparam READY = 3'd0, REQ_READ = 3'd1, WAIT_READ = 3'd2;
	localparam REQ_WRITE = 3'd3, WAIT_WRITE = 3'd4;

	reg [2:0] state, next_state;

	assign address = {SW[9], 1'b0, SW[8:6], 19'b0, SW[5:4]};

	reg [25:0] last_address;
	wire address_changed = (last_address != address);
	
	reg key3_prev, key3_now; // estados atuais e anterior do botão de escrita
	wire write_trigger = (!key3_now && key3_prev); // 1 ao pressionar o botão de escrita
	
	reg [7:0] data_out;
	reg [7:0] data_display;
	reg data_dir; // 1 = escrita, 0 = leitura
	assign data = data_dir ? data_out : 8'bz;

	always @(posedge clk) begin
		if(rst) begin
			state <= READY;
			last_address <= 26'b0;
			key3_prev <= 1'b1;
			key3_now <= 1'b1;
			data_display <= 8'b0;
		end else begin
			key3_prev <= key3_now;
			key3_now <= KEY[3];
			state <= next_state;
			
			if(state == WAIT_READ && ready) begin
				data_display <= data;
				last_address <= address;
			end
		end
	end
	
	always @(*) begin
		next_state = state;
		req = 1'b0;
		wEn = 1'b0;
		data_dir = 1'b0;
		data_out = 8'b0;
		
		case (state)
			READY: begin
				if (ready) begin
					if (write_trigger) begin
						next_state = REQ_WRITE;
					end else if (address_changed) begin
						next_state = REQ_READ;
					end
				end
			end
			
			REQ_READ: begin
				req = 1'b1;
				wEn = 1'b0;
				next_state = WAIT_READ;
			end
			
			WAIT_READ: begin
				if(ready)
					next_state = READY;
			end
			
			REQ_WRITE: begin
				data_dir = 1'b1;
				req = 1'b1;
				wEn = 1'b1;
				data_out = {4'b0000, SW[3:0]};
				next_state = WAIT_WRITE;
			end
			
			WAIT_WRITE: begin
				data_dir = 1'b1;
				wEn = 1'b1;
				data_out = {4'b0000, SW[3:0]};	
				if(ready)
					next_state = REQ_READ;
			end
		endcase
	end
	
	bin2hex converter1 (
		.BIN(SW[3:0]),
		.HEX(HEX0)
	);
	bin2hex converter2 (
		.BIN(data_display[3:0]),
		.HEX(HEX1)
	);
	bin2hex converter3 (
		.BIN({2'b00, address[25], address[23]}),
		.HEX(HEX5)
	);
	bin2hex converter4 (
		.BIN({address[22:21], address[1:0]}),
		.HEX(HEX4)
	);
	
endmodule