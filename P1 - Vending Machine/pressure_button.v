module pressure_button#(
	parameter CLK = 50_000_000,
	parameter PRESSURE_TIME = 20
)
(
	input wire clk,
	input wire button_in,
	output reg button_out = 1'b0
	
	
);
	
	localparam COUNTER_MAX = (CLK / 1000) * PRESSURE_TIME; // Para esperar 20 s
	localparam COUNTER_WIDTH = $clog2(COUNTER_MAX + 1); // Equação para sabermos quantos bits o registrador tera. Log 2
	
	reg [COUNTER_WIDTH - 1 : 0] cont;
	reg button_sync_0 = 1'b0; // variavel responsável por ser o valor inicial do botão
	reg button_sync_1 = 1'b0; // botão final do botao
	
	

	always @(posedge clk) begin
		button_sync_0 <= button_in;
		button_sync_1 <= button_sync_0; 
	end
	
	always @(posedge clk) begin
		if(button_sync_1 != button_out) begin
			if(cont < COUNTER_MAX) begin
				cont <= cont + 1'b1;
			end else begin
				button_out <= button_sync_1;
				cont <= 0;
			end
		end else begin
			cont <= 0;
			
			end
		end
	endmodule
