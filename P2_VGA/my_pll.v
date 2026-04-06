module my_pll(
	clk_in, 
	rstn, 
	pll_clk_out_25mhz
);
					
input clk_in;
input rstn;
output pll_clk_out_25mhz;

pll_ip pll_ip_inst (
		.refclk   (clk_in),   				// refclk.clk
		.rst      (!rstn),      			// reset.reset
		.outclk_0 (pll_clk_out_25mhz),	// outclk0.clk
		.locked   ()							// locked.export
	);
	
endmodule