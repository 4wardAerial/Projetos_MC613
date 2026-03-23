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
	
	integer i;
	
	
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
	
	task avancar;
		begin
			key[0] = 0;
			#15;
			key[0] = 1;
			#15;
		end
	endtask
	
	task cancelar;
		begin
			key[1] = 0;
			#15;
			key[1] = 1;
			#15;
		end
	endtask
	
	task testar_selecao;
		begin
			for (i = 0; i < 4'b1111; i = i + 1) begin
				sw[3:0] = i;
				#10;
			end
		end
	endtask
	
	task testar_troco;
		begin
			sw[3:0] = 4'b0001;
			#10;
			avancar;
			sw[9:4] = 6'b000001;
			avancar;
			sw[9:4] = 6'b000010;
			avancar;
			sw[9:4] = 6'b000100;
			avancar;
			sw[9:4] = 6'b001000;
			avancar;
			sw[9:4] = 6'b010000;
			avancar;
			sw[9:4] = 6'b100000;
			avancar;
		end
	endtask
	
	task testar_sem_troco;
		begin
			sw[3:0] = 4'b0001;
			#10;
			avancar;
			sw[9:4] = 6'b100000;
			avancar;
			sw[9:4] = 6'b010000;
			avancar;
		end
	endtask
	
	task testar_cancelar_sem_troco;
		begin
			sw[3:0] = 4'b0010;
			#10;
			avancar;
			cancelar;
		end
	endtask
	
	task testar_cancelar_com_troco;
		begin
			sw[3:0] = 4'b0001;
			#10;
			avancar;
			sw[9:4] = 6'b100000;
			avancar;
			
			cancelar;
		end
	endtask
	
	task testar_mais_de_uma_moeda;
		begin
			sw[3:0] = 4'b0001;
			#10;
			avancar;
			sw[9:4] = 6'b011000;
			avancar;
		end
	endtask
		
	task testar_mudar_selecao;
		begin
			sw[3:0] = 4'b0001;
			#10;
			avancar;
			sw[3:0] = 4'b0010;
			avancar;
		end
	endtask

	initial begin
		$monitor("tempo = %0t | estado = %b", $time, uut.find_state.state);
		#10
		
		testar_selecao;
		//testar_troco;
		//testar_sem_troco;
		//testar_cancelar_sem_troco;
		//testar_cancelar_com_troco;
		//testar_mais_de_uma_moeda;
		//testar_mudar_selecao;

		#100;
		$finish;
	end
endmodule