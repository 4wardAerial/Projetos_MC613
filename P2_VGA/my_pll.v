module my_pll(
	clk_in, 
	rstn, 
	pll_clk_out_25mhz,
	pll_clk_out_150mhz
);
					
input clk_in;
input rstn;
output pll_clk_out_25mhz;
output pll_clk_out_150mhz; // Desnecessario

pll_ip pll_ip_inst (
		.refclk   (clk_in),   				// refclk.clk
		.rst      (!rstn),      			// reset.reset
		.outclk_0 (pll_clk_out_25mhz),	// outclk0.clk
		.outclk_1 (pll_clk_out_150mhz),	// outclk1.clk
		.locked   ()							// locked.export
	);
	
endmodule