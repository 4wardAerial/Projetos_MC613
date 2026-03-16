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
    input reg [2:0] state,
    input reg [10:0] val_prod,
    input reg [10:0] val_pago
);

wire [0] is_key_0;
wire [0] is_key_1;

    keychecker key_0 (
         .clk(clk),
         .KEY(KEY[0])
    )

    keychecker key_1 (
          .clk(clk),
          .KEY(KEY[1])
    )

    products2price add_prod (
        .ID(SW[3:0]),
          .STT(state)
    )
    
    payer find_val (
        .AVAN(is_key_0),
        .COIN(SW[9:4]),
          .STT(state)
    )
    
    states find_state (
          .clk(clk)
        .AVAN(is_key_0),
        .CANC(is_key_1),
          .val_prod(val_prod),
          .val_pag(val_pag),
          .STT(state)
    )

