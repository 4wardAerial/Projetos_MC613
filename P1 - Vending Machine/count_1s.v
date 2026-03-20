module count_1s(
	input clk,
	input reset,
	output reg sec_pulse
);



	reg[25:0] cont;
	
	// Para criar a l´ogica do temporizador, quando termina o ciclo de 1 segundo, o clock retorna 1
	always @(posedge clk) begin
	
	if(reset) begin
		cont <= 26'd0;
		sec_pulse <= 1'b0;
		
	end else begin
		if(cont == 26'd9) begin
			cont <=26'd0;
			sec_pulse <= 1'b1;
		end else begin
			cont <= cont + 26'd1;
			sec_pulse <= 1'b0;
		end
	end
	
	end
	
endmodule
