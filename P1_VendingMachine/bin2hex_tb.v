module bin11_to_bcd4_tb;
	
	reg  [10:0] test_input;
	wire [15:0] test_output;
	
	bin11_to_bcd4 uut (
		.bin(test_input),
		.bcd(test_output)
	);
	
	integer i;
	initial begin
		$display("Inicio");
		for(i = 0; i <= 2047; i = i + 1) begin
			test_input = i; #10;
			$display("%4d = %1d %1d %1d %1d", test_input, test_output[15:12], test_output[11:8], test_output[7:4], test_output[3:0]); 
		end
		$finish;
	end 

endmodule