module pressure_button
(
	input wire clk,
	input wire button_in,
	output reg button_out = 1'b0
	
	
);
	
	reg button_sync_0 = 1'b1; // variavel responsável por ser o valor inicial do botão
	reg button_sync_1 = 1'b1; // botão final do botao
	
	

	always @(posedge clk) begin
		button_sync_0 <= button_in;
		button_sync_1 <= button_sync_0; 
	end
	
	always @(posedge clk) begin
		if(button_sync_1 == 1 && button_sync_0 == 0) begin
			button_out <= 1;
		end else begin
			button_out <= 0;
		end
	end
endmodule
