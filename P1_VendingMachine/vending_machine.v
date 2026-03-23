module vending_machine (
    input wire CLK_50,
    input wire [9:0] SW,
    input wire [1:0] KEY,
    output wire [6:0] HEX0,
    output wire [6:0] HEX1,
    output wire [6:0] HEX2,
    output wire [6:0] HEX3,
    output wire [6:0] HEX5,
    output wire [1:0] LEDR
);

wire is_key_0;
wire is_key_1;
wire [2:0] state;
wire [10:0] val_prod;
wire [3:0] code_num;
wire [10:0] val_pago;
wire [10:0] displayed_value;
wire [15:0] bcd_displayed_value;

pressure_button key_0 (
    .clk(CLK_50),
    .button_in(KEY[0]),
    .button_out(is_key_0)
);

pressure_button key_1 (
    .clk(CLK_50),
    .button_in(KEY[1]),
    .button_out(is_key_1)
);

product2price add_prod (
	 .clk(CLK_50),
	 .state(state),
    .BIN(SW[3:0]),
    .PROD_PRICE(val_prod),
	 .PROD_NUM(code_num)
);

payer find_val (
    .clk(CLK_50),
    .advance(is_key_0),
    .coin(SW[9:4]),
    .state(state),
    .val_pago(val_pago)
);

states find_state (
    .clk(CLK_50),
    .advance(is_key_0),
    .cancel(is_key_1),
    .val_prod(val_prod),
    .val_pag(val_pago),
    .state(state)
);

displayer displayer (
	.clk(CLK_50),
	.state(state),
	.val_pago(val_pago),
	.prod_price(val_prod),
	.prod_value_bin(displayed_value),
	.ledr(LEDR)
);

bin11_to_bcd4 bin11_to_bcd4_converter (
	.bin(displayed_value),
	.bcd(bcd_displayed_value)
);

bin2hex bin2hex_converter3 (
	.BIN(bcd_displayed_value[15:12]),
	.HEX(HEX3)
);

bin2hex bin2hex_converter2 (
	.BIN(bcd_displayed_value[11:8]),
	.HEX(HEX2)
);

bin2hex bin2hex_converter1 (
	.BIN(bcd_displayed_value[7:4]),
	.HEX(HEX1)
);

bin2hex bin2hex_converter0 (
	.BIN(bcd_displayed_value[3:0]),
	.HEX(HEX0)
);

bin2hex bin2hex_product_code_converter (
	.BIN(code_num),
	.HEX(HEX5)
);



endmodule