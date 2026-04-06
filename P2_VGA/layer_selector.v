module layer_selector(
	input wire [24:0] bckg_color,
	input wire [24:0] sprite_color,
	input wire transparent,
	output wire [24:0] layer_color
);

assign layer_color = transparent ? bckg_color : sprite_color;

endmodule