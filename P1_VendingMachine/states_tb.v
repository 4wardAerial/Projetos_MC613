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
	
	task paga_com_troco;
		begin
			val_pag = 11'd400; #10;

			$display("Apertei avança");
			advance = 1'b1;
			@(posedge clk)
			advance = 1'b0;
		end
	endtask
	
	task paga_sem_troco;
		begin
			val_pag = 11'd350; #10;
			
			$display("Apertei avança");
			advance = 1'b1;
			@(posedge clk)
			advance = 1'b0;
		end
	endtask
	
	task cancela_com_troco;
		begin
			val_pag = 11'd150; #10;
		
			$display("Apertei cancela");
			cancel = 1'b1;
			@(posedge clk)
			cancel = 1'b0;
		end
	endtask
	
	task cancela_sem_troco;
		begin
			val_pag = 11'd0; #10;
		
			$display("Apertei cancela");
			cancel = 1'b1;
			@(posedge clk)
			cancel = 1'b0;
		end
	endtask
	
	initial begin
		$monitor("val_pag = %d, val_prod = %d, result_state = %d", val_pag, val_prod, result_state);
		val_prod = 11'd350; #10;
		
		$display("Apertei avança");
		advance = 1'b1;
		@(posedge clk)
		advance = 1'b0;
		
		//paga_com_troco;
		//paga_sem_troco;
		//cancela_com_troco;
		cancela_sem_troco;
		#200;
		$finish;
		
	end
endmodule