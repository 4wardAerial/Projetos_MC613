module states(
	input wire clk;
	output reg current_product;
	output reg current_shown_value;
	
);

	reg [2:0] state
	always(@posedge clk) begin
		case(state)
			3'b000: begin // A - seleçao do produto
			
			end
			3'b'001: begin // B - inserçao de dinheiro
			
			end
			3b'010: begin // C - Recebe sem troco
			
			end
			3b'011: begin // D - Recebe com troco
			
			end
			3b'100: begin // E - Devolver dinheiro
			
			end	
		endcase
	end
endmodule