module bg_ROM (
	input wire [3:0] linha,
	input wire [3:0] coluna,
	output wire [23:0] data_out
);

reg [3:0] mem [0:255];

initial begin
	$readmemh("bckg.txt", mem);
end

assign data_out = linha*16+coluna <= 255 ? mem[linha*16+coluna] : 24'h000000;
endmodule