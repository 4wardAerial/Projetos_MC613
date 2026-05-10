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
	output wire [6:0] HEX5
);

wire rst = ~KEY[0];
wire ready;
wire [7:0] data;
wire [25:0] address;
wire req;
wire wEn;

dram_iface interface(
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
	.wEn(wEn)
);

dram_controller controller(
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
	.dram_cs_n(DRAM_CS_N)
);

endmodule