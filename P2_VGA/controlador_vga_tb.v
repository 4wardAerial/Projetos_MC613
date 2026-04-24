module controlador_vga_tb();
	reg pixel_clk = 1'b0;
	reg reset_n;

	reg [7:0] r_in;
	reg [7:0] g_in;
	reg [7:0] b_in;

	reg [9:0] pixel_x;
	reg [9:0] pixel_y;
	reg video_active;

	wire [7:0] VGA_R;
	wire [7:0] VGA_G;
	wire [7:0] VGA_B;
	wire VGA_HS;
	wire VGA_VS;
	wire VGA_BLANK_N;
	wire VGA_SYNC_N;
	wire VGA_CLK;
	
	controlador_vga cont_vga(
		.pixel_clk(pixel_clk),
		.reset_n(reset_n),
		.r_in(r_in),
		.g_in(g_in),
		.b_in(b_in),
		
		.pixel_x(pixel_x),
		.pixel_y(pixel_y),
		.video_active(video_active),
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B),
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS),
		.VGA_BLANK_N(VGA_BLANK_N),
		.VGA_SYNC_N(VGA_SYNC_N),
		.VGA_CLK(VGA_CLK)			
	);
	
	always #10 pixel_clk = ~pixel_clk;  // Inverte a cada 10ns

	initial begin 
		reset_n = 1'b0;
		r_in = 8'b0;
		g_in = 8'b0;
		b_in = 8'b0;
		pixel_x = 10'b0;
		pixel_y = 10'b0;
		video_active = 0;

	
		
	end

endmodule