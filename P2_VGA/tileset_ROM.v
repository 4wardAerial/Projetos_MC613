module bg_ROM (
	input wire [3:0] id,
	output wire [7:0] data_out
);

reg [23:0] mem [0:2] = [6'hfbc336, 6'h000000, 6'hffffff];

assign data_out = mem[id-1];
endmodule