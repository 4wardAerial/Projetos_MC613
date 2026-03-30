module sprite_evaluator (
    input wire clk,
    input wire rst_n,
    input wire [8:0] pixel_x,
    input wire [8:0] pixel_y,
    output reg [7:0] sprite_color,
    output reg sprite_transparent
);
