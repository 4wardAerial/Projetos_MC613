module states(
	input wire clk,
	input wire val_prod,
	input wire val_pag,
	input wire advance,
	input wire cancel,
	output reg [2:0] state
);

	reg [2:0] prev_state;
	reg [2:0] next_state;

	
	always@(posedge clk) begin
		case(state)
			3'b000: begin // A - seleçao do produto
				if(advance)
					next_state = 3'b001;
			end
			3'b001: begin // B - inserçao de dinheiro
				if(val_prod == val_pag)
					next_state = 3'b010;
				else if(val_prod < val_pag)
					next_state = 3'b011;
			end
			3'b010: begin // C - Recebe sem troco
				
			end
			3'b011: begin // D - Recebe com troco
			
			end
			3'b100: begin // E - Devolver dinheiro
			
			end	
		endcase
		prev_state = state;
		state = next_state;
	end
endmodule
