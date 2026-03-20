module payer (
    input wire clk,
    input wire advance,
    input wire [9:4] coin,
    input wire [2:0] state,
    output reg [10:0] val_pago = 11'b0
);

always @(posedge clk) begin
    if (state == 3'b001) begin
        if (advance) begin
            case(coin)
                6'b100000: val_pago <= val_pago + 11'd200;
                6'b010000: val_pago <= val_pago + 11'd100;
                6'b001000: val_pago <= val_pago + 11'd50;
                6'b000100: val_pago <= val_pago + 11'd25;
                6'b000010: val_pago <= val_pago + 11'd10;
                6'b000001: val_pago <= val_pago + 11'd5;
					 default: val_pago <= val_pago;
            endcase
        end
    end
    
    else if (state == 3'b000) begin
        val_pago <= 11'd0;
    end
end    

endmodule