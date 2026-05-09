module dram_iface (
	input wire clk,	// clock
	input wire rst,	// Reset
	input wire [9:0] SW,		// Switches de entrada (endereço parcial e dado)
	input wire [3:0] KEY,	// Botões da placa (KEY[3] = write, KEY[0] = reset)
	
	input wire ready,	// Indica que o controlador está pronto para receber uma nova operação
	
	output wire [6:0] HEX0,	// Exibe o dado de entrada (escrita)
	output wire [6:0] HEX1,	// Exibe o valor lido da memória
	output wire [6:0] HEX4,	// Exibe parte do endereço
	output wire [6:0] HEX5,	// Exibe parte do endereço
	
	output wire [25:0] address,	// Endereço completo da DRAM
	output wire req,	// Indica a recepção de um comando no controlador.
	output wire wEn	// Indica sinal permissão de escrita (o comando é uma escrita)
	
	/*
	data 	Entrada/Saída 	8 bits 	Dado lido/a ser escrito
	*/
);

endmodule