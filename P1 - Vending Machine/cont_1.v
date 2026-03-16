module cont_1s(
	input clk,
	input reset,
	output reg sec_pulse
);



	reg[25:0] cont;
	
	// Para criar a l´ogica do temporizador, quando termina o ciclo de 1 segundo, o clock retorna 1
	always @(posedge clk or posedge reset) begin
	
	if(reset) begin
		cont <= 26'd0;
		clk <= 1'b0;
		
	end else begin
		if(cont == 26'd49999999) begin
			cont <=26'd0;
			clk <= 1'b1;
		end else begin
			cont <= cont + 26'd1;
			clk <= 1'b0;
		end
	end
	
	end
	
endmodule
	