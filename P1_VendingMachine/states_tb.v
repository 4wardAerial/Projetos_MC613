module states_tb;

	reg clk = 1'b0;
	reg [10:0] val_prod = 11'b0;
	reg [10:0] val_pag = 11'b0;
	reg advance = 1'b0;
	reg cancel = 1'b0;
	wire [2:0] result_state;
	
	states uut(
		.clk(clk),
		.val_prod(val_prod),
		.val_pag(val_pag),
		.advance(advance),
		.cancel(cancel),
		.state(result_state)
	);
	
	always #5 clk = ~clk;
	
	initial begin
		$monitor("val_pag = %d, val_prod = %d, result_state = %d", val_pag, val_prod, result_state);
		val_prod = 11'd345; #10;
		
		$display("Apertei avança");
		advance = 1'b1;
		@(posedge clk)
		advance = 1'b0;
		
		val_pag = 11'd300; #10;
		val_pag = 11'd345; #10;
		#200;
		
		$finish;
		
	end
endmodule