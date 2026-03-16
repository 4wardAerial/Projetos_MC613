// Módulo conversor de binario 11 bits para 4 bcd
// Entrada: 11 bits (0-10)
// Saída: 16 bits representando 4 digitos bcd
module bin11_to_bcd4(
	input wire [10:0] bin,	// Entrada: numero de 11 bits
	output reg [15:0] bcd	// Saida: numero de 16 bits (cada 4 representa um digito)
);
	integer i;
	reg [10:0] x;
	reg [15:0] acc;
	
	always @(*) begin

		x = bin;
		acc = 16'b0;
		
		for(i = 10; i >= 0; i = i - 1) begin
			if(acc[3:0] > 4)
				acc[3:0] = acc[3:0] + 3;
			if(acc[7:4] > 4)
				acc[7:4] = acc[7:4] + 3;
			if(acc[11:8] > 4)
				acc[11:8] = acc[11:8] + 3;
			if(acc[15:12] > 4)
				acc[15:12] = acc[15:12] + 3;
			
			acc = {acc[14:0], x[i]};
		end
		
		bcd = acc;
		
	end
endmodule