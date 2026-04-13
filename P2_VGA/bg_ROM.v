module bg_ROM (
	input wire [3:0] linha,
	input wire [3:0] coluna,
	output wire [3:0] data_out
);

reg [3:0] mem [0:255];

initial begin
	$readmemh("bckg.txt", mem);
end

assign data_out = (linha <= 16 && coluna <= 16) ? mem[linha*16+coluna] : 3'b0;
endmodule