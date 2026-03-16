module displayer(
	input wire [2:0] STATE,
	input wire [10:0] PROD_VALUE,
	input wire [10:0] PROD_PRICE,
	output wire[10:0] PROD_VALUE_BIN,
	output wire [1:0] LEDR,	// Saida: 2 LEDs vermelhos da placa
);

if (STATE == 3'b000 || STATE == 3'b001)	// Estado A ou B, nao finalizou compra
	assign LEDR[0] = 1'b0
	assign LEDR[1] = 1'b0
	assign PROD_VALUE_BIN = PROD_VALUE
end else if (STATE == 3'b010)	// Estado C, recebe sem troco
	assign LEDR[0] = 1'b1
	assign LEDR[1] = 1'b0
	assign PROD_VALUE_BIN = PROD_VALUE
end else if (STATE == 3'b011) // Estado D, recebe com troco
	assign LEDR[0] = 1'b1
	assign LEDR[1] = 1'b1
	assign PROD_VALUE_BIN = -PROD_VALUE
end else if (STATE == 3'b100) // Estado E, devolve dinheiro
	assign LEDR[0] = 1'b0
	assign LEDR[1] = 1'b1
	assign PROD_VALUE_BIN = PROD_PRICE - PROD_VALUE
end