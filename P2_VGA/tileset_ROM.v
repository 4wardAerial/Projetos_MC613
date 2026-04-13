module tileset_ROM (
	input wire [3:0] id,
	output wire [23:0] data_out
);

reg [23:0] mem [0:2];

initial begin
	mem[0] = 24'hfbc336;
	mem[1] = 24'h000000;
	mem[2] = 24'hffffff;
end
assign data_out = mem[id-1];
endmodule