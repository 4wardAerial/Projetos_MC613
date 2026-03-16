module payer (
    input wire clk,
    input wire AVAN,
    input wire [9:4] COIN,
    input wire [2:0] state,
    output reg [10:0] val_pago
)

always @(posedge clk) begin
    if state == 3'b010 begin
        if AVAN begin
            case(COIN)
                6'b100000: val_pago = val_pago + 11'd200;
                6'b010000: val_pago = val_pago + 11'd100;
                6'b001000: val_pago = val_pago + 11'd50;
                6'b000100: val_pago = val_pago + 11'd25;
                6'b000010: val_pago = val_pago + 11'd10;
                6'b000001: val_pago = val_pago + 11'd5;
            endcase
        end
    end
    
    if state == 3'b001 begin
        val_pago = 11'd0;
    end
end    
