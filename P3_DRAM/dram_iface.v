module dram_iface (
	input wire clk,	// clock
	input wire rst,	// Reset
	input wire SW [9:0],		// Switches de entrada (endereço parcial e dado)
	input wire KEY [3:0],	// Botões da placa (KEY[3] = write, KEY[0] = reset)
	
	input wire ready	// Indica que o controlador está pronto para receber uma nova operação
	
	output wire HEX0 [6:0],	// Exibe o dado de entrada (escrita)
	output wire HEX1 [6:0],	// Exibe o valor lido da memória
	output wire HEX4 [6:0],	// Exibe parte do endereço
	output wire HEX5 [6:0],	// Exibe parte do endereço
	
	output wire address [25:0],	// Endereço completo da DRAM
	output wire req,	// Indica a recepção de um comando no controlador.
	output wire wEn,	// Indica sinal permissão de escrita (o comando é uma escrita)
	
	/*
	data 	Entrada/Saída 	8 bits 	Dado lido/a ser escrito
	*/
);

endmodule