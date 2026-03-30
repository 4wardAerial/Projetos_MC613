module vending_machine (
    input wire clk,
    input wire rst_n,
    input wire [8:0] pixel_x,
    input wire [8:0] pixel_y,
    input wire oam_ready,
    output wire [7:0] final_color
);

    wire [1:0] state;
    wire [7:0] bg_color;
    wire bg_transparent;
    wire [7:0] sprite_color;
    wire sprite_transparent;

    ppu_fsm fsm (
        .clk(clk),
        .rst_n(rst_n),
        .oam_ready(oam_ready),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .state(state)
    );

    bg_pipeline bg (
        .clk(clk),
        .rst_n(rst_n),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .color(bg_color),
        .bg_transparent(bg_transparent)
    );

    sprite_evaluator sprite_eval (
        .clk(clk),
        .rst_n(rst_n),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .sprite_color(sprite_color),
        .sprite_transparent(sprite_transparent)
    );

    pixel_compositor compositor (
        .clk(clk),
        .rst_n(rst_n),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .bg_color(bg_color),
        .bg_transparent(bg_transparent),
        .sprite_color(sprite_color),
        .sprite_transparent(sprite_transparent),
        .final_color(final_color)
    );

    mem_interface mem (
        .clk(clk),
        .rst_n(rst_n),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .color(bg_color)
    );

endmodule