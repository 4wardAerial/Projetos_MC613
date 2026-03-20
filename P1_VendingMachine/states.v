module states(
	input wire clk,
	input wire [10:0] val_prod,
	input wire [10:0] val_pag,
	input wire advance,
	input wire cancel,
	output reg [2:0] state = 3'b000
);
	
	reg reset_timer;
	wire sec_pulse;
	count_1s timer (
		.clk(clk),
		.reset(reset_timer),
		.sec_pulse(sec_pulse)
	);
	reg [2:0] prev_state;
	reg [2:0] next_state;

	always@(posedge clk) begin
		next_state = state;
		case(state)
			3'b000: begin // A - seleçao do produto
				if(advance)
					next_state = 3'b001;
			end
			3'b001: begin // B - inserçao de dinheiro
				if(cancel && val_pag == 0)
					next_state = 3'b000;
				else if(cancel)
					next_state = 3'b100;
				else if(val_prod == val_pag)
					next_state = 3'b010;
				else if(val_prod < val_pag)
					next_state = 3'b011;
			end
			3'b010: begin // C - Recebe sem troco
				if(prev_state != 3'b010)
					reset_timer = 1;
				else if(sec_pulse == 1) begin
					reset_timer = 0;
					next_state = 3'b000;
				end else
					reset_timer = 0;
			end
			3'b011: begin // D - Recebe com troco
				if(prev_state != 3'b011)
					reset_timer = 1;
				else if(sec_pulse == 1) begin
					reset_timer = 0;
					next_state = 3'b000;
				end else
					reset_timer = 0;
			end
			3'b100: begin // E - Devolver dinheiro
				if(prev_state != 3'b100)
					reset_timer = 1;
				else if(sec_pulse == 1) begin
					reset_timer = 0;
					next_state = 3'b000;
				end else
					reset_timer = 0;
			end	
		endcase
		prev_state = state;
		state = next_state;
	end
endmodule
