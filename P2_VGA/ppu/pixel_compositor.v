module pixel_compositor (
    input wire clk,
    input wire rst_n,
    input wire [8:0] pixel_x,
    input wire [8:0] pixel_y,
    input wire [7:0] bg_color,
    input wire bg_transparent,
    input wire [7:0] sprite_color,
    input wire sprite_transparent,
    output wire [7:0] final_color
);

    reg [7:0] final_color;

    always @(*) begin
        if (!sprite_transparent) begin
            final_color = sprite_color;
        end else if (!bg_transparent) begin
            final_color = bg_color;
        end else begin
            final_color = 8'h00; 
        end
    end

endmodule