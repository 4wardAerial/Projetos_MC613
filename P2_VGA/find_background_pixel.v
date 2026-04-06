module find_background_pixel(
	input wire [9:0] pixel_x,
	input wire [9:0] pixel_y,
	output wire [23:0] bg_color
)

wire [3:0] linha_bg;
wire [3:0] coluna_bg;
wire [3:0] id;

assign linha_bg  = pixel_x / 8;
assign coluna_bg = pixel_y / 8;

bg_ROM rom_bg(
	.linha(linha_bg),
	.coluna(coluna_bg),
	.data_out(id)
);

tileset_ROM rom_tileset(
	.id(id),
	.data_out(bg_color)
)

tileset_ROM rom_tileset(