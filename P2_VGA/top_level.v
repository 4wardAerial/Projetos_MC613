module top_level(
    input wire CLOCK_50,
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
wire [7:0]final_color;

my_pll pll (
	.clk_in(CLOCK_50),
	.rstn(1),
	.pll_clk_out_25mhz(pixel_clk)
);

ppu_top ppu (
	.clk(pixel_clk),
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
    .r_in(8'h89),
    .g_in(8'hd8),
    .b_in(8'h08),
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