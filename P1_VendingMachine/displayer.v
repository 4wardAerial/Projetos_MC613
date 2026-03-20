module displayer(
	input wire [2:0] state,
	input wire [10:0] val_pago,
	input wire [10:0] prod_price,
	output reg [10:0] prod_value_bin,
	output reg [1:0] ledr	// Saida: 2 LEDs vermelhos da placa
);

always @(*) begin
	if (state == 3'b000 || state == 3'b001) begin	// Estado A ou B, nao finalizou compra
		ledr[0] = 1'b0;
		ledr[1] = 1'b0;
		prod_value_bin = prod_price - val_pago;
	end else if (state == 3'b010) begin	// Estado C, recebe sem troco
		ledr[0] = 1'b1;
		ledr[1] = 1'b0;
		prod_value_bin = 11'b0;
	end else if (state == 3'b011) begin	// Estado D, recebe com troco
		ledr[0] = 1'b1;
		ledr[1] = 1'b1;
		prod_value_bin = val_pago - prod_price;
	end else if (state == 3'b100) begin // Estado E, devolve dinheiro
		ledr[0] = 1'b0;
		ledr[1] = 1'b1;
		prod_value_bin = val_pago;
	end else begin	// Estado impossivel
		ledr[0] = 1'b0;
		ledr[0] = 1'b0;
		prod_value_bin = prod_price;
	end
end

endmodule