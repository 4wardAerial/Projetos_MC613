module top_level (
	input wire CLOCK_50,
	
	input wire [9:0] SW,
	input wire [3:0] KEY,
	
	inout wire [15:0] DRAM_DQ,
	output wire [12:0] DRAM_ADDR,
	output wire [1:0] DRAM_BA,
	output wire DRAM_CLK,
	output wire DRAM_CKE,
	output wire DRAM_LDQM,
	output wire DRAM_UDQM,
	output wire DRAM_WE_N,
	output wire DRAM_CAS_N,
	output wire DRAM_RAS_N,
	output wire DRAM_CS_N,
	
	output wire [6:0] HEX0,
	output wire [6:0] HEX1,
	output wire [6:0] HEX4,
	output wire [6:0] HEX5,
	output wire [9:0] LEDR
);

wire ready;
wire [7:0] data;
wire [25:0] address;
wire req;
wire wEn;
wire clk_controller;

wire 	rst_raw = ~KEY[0];
reg rst;
always @(posedge clk_controller) begin
	rst <= rst_raw;
end

dram_iface interface(
	.clk(clk_controller),
	.rst(rst),
	.SW(SW),
	.KEY(KEY),
	
	.ready(ready),
	.data(data),
	
	.HEX0(HEX0),
	.HEX1(HEX1),
	.HEX4(HEX4),
	.HEX5(HEX5),
	
	.address(address),
	.req(req),
	.wEn(wEn),
	.teste(LEDR[9:7])
);

dram_controller controller(
	.clk(clk_controller),
	.rst(rst),
	.address(address),
	.data(data),
	
	.req(req),
	.wEn(wEn),
	
	.ready(ready),
	
	.dram_addr(DRAM_ADDR),
	.dram_ba(DRAM_BA),
	.dram_dq(DRAM_DQ),
	.dram_cke(DRAM_CKE),
	.dram_ldqm(DRAM_LDQM),
	.dram_udqm(DRAM_UDQM),
	.dram_we_n(DRAM_WE_N),
	.dram_cas_n(DRAM_CAS_N),
	.dram_ras_n(DRAM_RAS_N),
	.dram_cs_n(DRAM_CS_N),
	.teste(LEDR[5:0])
);

my_pll pll(
	.refclk(CLOCK_50),
	.rst(1'b0),
	.outclk_0(clk_controller),
	.outclk_1(DRAM_CLK) // clock shiftado em 3ns
);

endmodule