module top_level;
reg pixel_clk;
my_pll pll (
	.clk_in(CLOCK_50),
	.rstn(1),
	.pll_clk_out_25mhz(pixel_clk)
);

controlado_vga vga (
	.pixel_clk(pixel_clk),
	.reset_n(1'b1),
	.r_in(8'd0),
	.g_in(8'd0),
	.b_in(8'd0),
);

endmodule