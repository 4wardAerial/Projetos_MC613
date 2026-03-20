module vending_machine_tb;
	
	reg clk = 1'b0;
	reg [9:0] sw = 9'b0;
	reg [1:0] key = 2'b11;
	wire [6:0] hex0;
	wire [6:0] hex1; 
	wire [6:0] hex2;
	wire [6:0] hex3;
	wire [6:0] hex5;
	wire [1:0] ledr;
	
	
	
	vending_machine uut (
		.CLK_50(clk),
		.SW(sw),
		.KEY(key),
		.HEX0(hex0),
		.HEX1(hex1),
		.HEX2(hex2),
		.HEX3(hex3),
		.HEX5(hex5),
		.LEDR(ledr)
	);
	
	always #5 clk = ~clk;
	
	initial begin
		$monitor("tempo = %0t | estado = %b", $time, uut.find_state.state);
		#100;
		$finish;
	end
endmodule