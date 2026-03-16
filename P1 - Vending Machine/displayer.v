module displayer(
	input wire [2:0] STATE,
	input wire [10:0] PROD_VALUE,
	input wire [10:0] PROD_PRICE,
	output reg [10:0] PROD_VALUE_BIN,
	output reg [1:0] LEDR	// Saida: 2 LEDs vermelhos da placa
);

always @(*) begin
	if (STATE == 3'b000 || STATE == 3'b001) begin	// Estado A ou B, nao finalizou compra
		LEDR[0] = 1'b0;
		LEDR[1] = 1'b0;
		PROD_VALUE_BIN = PROD_VALUE;
	end else if (STATE == 3'b010) begin	// Estado C, recebe sem troco
		LEDR[0] = 1'b1;
		LEDR[1] = 1'b0;
		PROD_VALUE_BIN = PROD_VALUE;
	end else if (STATE == 3'b011) begin	// Estado D, recebe com troco
		LEDR[0] = 1'b1;
		LEDR[1] = 1'b1;
		PROD_VALUE_BIN = -PROD_VALUE;
	end else if (STATE == 3'b100) begin // Estado E, devolve dinheiro
		LEDR[0] = 1'b0;
		LEDR[1] = 1'b1;
		PROD_VALUE_BIN = PROD_PRICE - PROD_VALUE;
	end else begin	// Estado impossivel
		LEDR[0] = 1'b0;
		LEDR[0] = 1'b0;
		PROD_VALUE_BIN = PROD_VALUE;
	end
end

endmodule