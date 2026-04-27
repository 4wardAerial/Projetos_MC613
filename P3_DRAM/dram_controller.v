module dram_controller ()
	input wire clk,	// clock
	input wire rst,	// Reset
	input wire [25:0] address,	// Endereço completo da DRAM
	
	input wire req,	// Indica a recepção de um comando no controlador.
	input wire wEn,	// Indica sinal permissão de escrita (o comando é uma escrita)
	
	output wire ready	// Indica que o controlador está pronto para receber uma nova operação
	
	/*
	data 	Entrada/Saída 	8 bits 	Dado lido/a ser escrito
	*/
);

endmodule