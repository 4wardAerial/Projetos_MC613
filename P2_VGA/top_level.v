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

my_pll pll (
	.clk_in(CLOCK_50),
	.rstn(1),
	.pll_clk_out_25mhz(pixel_clk)
);

controlador_vga vga (
    .pixel_clk(pixel_clk),
    .reset_n(1'b1),
    .r_in(8'h00),
    .g_in(8'hff),
    .b_in(8'h00),
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