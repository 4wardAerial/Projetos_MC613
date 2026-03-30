module ppu_fsm (
    input wire clk,
    input wire rst_n,
    input wire [8:0] pixel_x,
    input wire [8:0] pixel_y,
    output reg [1:0] state
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 2'b00; 
        end else begin
            case (state)
                2'b00: state <= 2'b01; 
                2'b01: state <= 2'b10; 
                2'b10: state <= 2'b00; 
                default: state <= 2'b00;
            endcase
        end
    end