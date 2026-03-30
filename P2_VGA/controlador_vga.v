module controlador_vga(
	input wire pixel_clk,
	input wire reset_n,
	input wire [7:0] r_in,
	input wire [7:0] g_in,
	input wire [7:0] b_in,
	output wire VGA_R,
	output wire VGA_G,
	output wire VGA_B,
	output reg VGA_HS,
	output reg VGA_VS,
	output wire VGA_BLANK_N,
	output wire VGA_SYNC_N,
	output wire VGA_CLK
);

reg [9:0] contador_h = 1;
reg [9:0] contador_v = 1;
assign VGA_CLK = pixel_clk;
assign VGA_G = 8'hff;
assign VGA_R = 8'h00;
assign VGA_B = 8'h00;
assign VGA_BLANK_N = 0;
assign VGA_SYNC_N = 1;

always @(posedge pixel_clk) begin
	if(VGA_HS == 0) begin
		if(contador_h== 96) begin
			VGA_HS = 1;
			contador_h = 1;
			contador_v = contador_v + 1;
		end else
			contador_h = contador_h + 1;
	end else begin
		if(contador_h== 704) begin
			VGA_HS = 0;
			contador_h = 1;
		end else
			contador_h = contador_h + 1;
	end
	
	if(VGA_VS == 0) begin
		if(contador_v== 2) begin
			VGA_VS = 1;
			contador_v = 1;
		end
	end else begin
		if(contador_v== 522) begin
			VGA_VS = 0;
			contador_v = 1;
		end else
			contador_v = contador_v + 1;
	end
end

endmodule