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
wire [10:0] val_pago;

pressure_button key_0 (
    .clk(clk),
    .button_in(KEY[0]),
    .button_out(is_key_0)
);

pressure_button key_1 (
    .clk(clk),
    .button_in(KEY[1]),
    .button_out(is_key_1)
);

product2price add_prod (
    .BIN(SW[3:0]),
    .PROD_PRICE(val_prod)
);

payer find_val (
    .clk(clk),
    .advance(is_key_0),
    .coin(SW[9:4]),
    .state(state),
    .val_pago(val_pago)
);

states find_state (
    .clk(clk),
    .advance(is_key_0),
    .cancel(is_key_1),
    .val_prod(val_prod),
    .val_pag(val_pago),
    .state(state)
);

endmodule