module controlador_vga(
	// Entradas de Controle
	input wire pixel_clk,
	input wire reset_n,
	
	// Entradas de Cor (vindas da PPU)
	input wire [7:0] r_in,
	input wire [7:0] g_in,
	input wire [7:0] b_in,
	
	// Saidas de Controle interno
	output wire [9:0] pixel_x,
	output wire [9:0] pixel_y,
	output wire video_active,
	
	// Saidas fisicas
	output wire [7:0] VGA_R,	// Intensidade vermelho
	output wire [7:0] VGA_G,	// Intensidade verde
	output wire [7:0] VGA_B,	// Intensidade azul
	output wire VGA_HS,			// Sinal hsync (ativo baixo)
	output wire VGA_VS,			// Sinal vsync (ativo baixo)
	output wire VGA_BLANK_N,	// Sinal que indica pos. fora do visivel (ativo baixo)
	output wire VGA_SYNC_N,		// Sinal para sincronismo (ativo baixo)
	output wire VGA_CLK			// Clock de pixel
);

reg [9:0] contador_h = 0;
reg [9:0] contador_v = 0;
// A ordem e:
// active video -> front porch -> sync pulse -> back porch
// entao o contador pode ser usado como pos dos pixels
assign pixel_x = contador_h;
assign pixel_y = contador_v;
assign video_active = contador_h < 640 && contador_v < 480;

assign VGA_CLK = pixel_clk;
assign VGA_SYNC_N = 1;
assign VGA_BLANK_N = video_active;
assign VGA_VS = ~(contador_v >= 491 && contador_v < 493);
assign VGA_HS = ~(contador_h >= 656 && contador_h < 752);
assign VGA_R = video_active ? r_in : 8'h00;
assign VGA_G = video_active ? g_in : 8'h00;
assign VGA_B = video_active ? b_in : 8'h00;

always @(posedge pixel_clk or negedge reset_n) begin
	if (!reset_n) begin
		contador_h <= 0;
		contador_v <= 0;
	end else begin
		if (contador_h == 799) begin
			contador_h <= 0;
			contador_v <= (contador_v == 523) ? 0 : contador_v + 1;
		end else begin
			contador_h <= contador_h + 1;
		end
	end
end

endmodule