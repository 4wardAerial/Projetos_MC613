module pressure_button_tb;
	
	reg clk = 1'b0;
	reg button_in = 1'b1;
	wire button_out;
	
	pressure_button uut (
		.clk(clk),
		.button_in(button_in),
		.button_out(button_out)
	);
	
	always #5 clk = ~clk;
	initial begin
		$monitor("button_out = %b", button_out);
		repeat(10) @(posedge clk);
		button_in = 0;
		repeat(30) @(posedge clk);
		button_in = 1;
		repeat(7) @(posedge clk);
		button_in = 0;
		@(posedge clk);
		button_in = 1;
		repeat(6) @(posedge clk);
		$finish;
	end
endmodule