module tileset_ROM_tb;
	reg [3:0] id = 0;
	wire [23:0] cor;
	tileset_ROM uut(
		.id(id),
		.data_out(cor)
	);
	
	initial begin
		id = 1;
		# 10;
		id = 2;
		# 10;
		id = 3;
		# 10;
		$finish;
	end
	initial begin
        $monitor("Tempo: %0t | ID requisitado: %0d | Cor devolvida (Hex): %h", 
                 $time, id, cor);
    end
endmodule
