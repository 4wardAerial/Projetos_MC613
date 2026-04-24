module top_level(
	input wire CLOCK_50,
	input wire [1:0] SW,
	input wire [3:0]KEY,
	output wire [7:0] VGA_R,
	output wire [7:0] VGA_G,
	output wire [7:0] VGA_B,
	output wire VGA_HS,
	output wire VGA_VS,
	output wire VGA_BLANK_N,
	output wire VGA_SYNC_N,
	output wire VGA_CLK
);

wire pixel_clk;
wire [9:0] pixel_x;
wire [9:0] pixel_y;
wire video_active;
wire [23:0]final_color;

my_pll pll (
	.refclk(CLOCK_50),
	.rst(0),
	.outclk_0(pixel_clk)
);

ppu_top ppu (
	.clk(pixel_clk),
	.estado_olhos(SW[1:0]),
	.estado_lingua(KEY[0]),
	.rst_n(1'd1),
	.pixel_x(pixel_x),
	.pixel_y(pixel_y),
	.final_color(final_color)
);

controlador_vga vga (
    .pixel_clk(pixel_clk),
    .reset_n(1'b1),
	 .pixel_x(pixel_x),
	 .pixel_y(pixel_y),
	 .video_active(video_active),
    .r_in(final_color[23:16]),
    .g_in(final_color[15:8]),
    .b_in(final_color[7:0]),
    .VGA_R(VGA_R),
    .VGA_G(VGA_G),
    .VGA_B(VGA_B),
    .VGA_HS(VGA_HS),
    .VGA_VS(VGA_VS),
    .VGA_BLANK_N(VGA_BLANK_N),
	 .VGA_SYNC_N(VGA_SYNC_N),
    .VGA_CLK(VGA_CLK)
);

endmodule