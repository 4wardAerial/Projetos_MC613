module ppu_top(
	input wire clk,
	input wire [1:0] SW,
	input wire pixel_x,
	input wire pixel_y,
	input wire video_active,
	input wire rst_n,
	output wire [23:0] final_color
);

wire [23:0] bckg_color;
wire [23:0] sprite_color;
wire ID;
wire [1:0] tile_x;
wire [1:0] tile_y;

layer_selector layer (
	.bckg_color(bckg_color),
	.sprite_color(sprite_color),
	.transparent(0),
	.layer_color(final_color)
);


find_background_pixel find_bckg (
	.pixel_x(pixel_x),
	.pixel_y(pixel_y),
	.bg_color(bckg_color)
);
/*
find_sprites_ppu find_spr (
	.clk(clk),
	.rst_n(rst_n),
	.pixel_x(pixel_x),
	.pixel_y(pixel_y),
	.ID(ID),
	.tile_x(tile_x),
	.tile_y(tile_y)
);
*/
endmodule