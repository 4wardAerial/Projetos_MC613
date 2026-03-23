module bin2hex_tb;
	
	reg  [3:0] test_input;
	wire [6:0] test_output;
	
	bin2hex uut (
		.BIN(test_input),
		.HEX(test_output)
	);
	
	integer i;
	initial begin
		$display("Inicio");
		for(i = 0; i <= 15; i = i + 1) begin
			test_input = i; #10;
			$display("%2d = %7b", test_input, test_output); 
		end
		$finish;
	end 

endmodule