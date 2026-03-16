module vending_machine (
    input wire clk,
    input wire [9:0] SW,
    input wire [1:0] KEY,
    output wire [6:0] HEX0,
    output wire [6:0] HEX1,
    output wire [6:0] HEX2,
    output wire [6:0] HEX3,
    output wire [6:0] HEX5,
    output wire [1:0] LEDR,
    reg [10:0] val_prod,
    reg [10:0] val_pago
);

    products add_prod (
        .ID(SW[3:0]),
    )
    
    payer find_val (
        .AVAN(KEY[0]),
        .COIN(SW[9:4])
    )
    
    states find_state (
		  .clk(clk)
        .AVAN(KEY[0]),
        .CANC(KEY[1]),
		  .val_prod(val_prod),
		  .val_pag(val_pag)
    )
