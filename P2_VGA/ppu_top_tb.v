`timescale 1ns/1ps
module ppu_top_tb;

    reg clk = 0;
    reg [1:0] estado_olhos;
	 reg estado_lingua;
    reg [9:0] pixel_x;
    reg [9:0] pixel_y;

    wire [23:0] final_color;

 
    ppu_top uut (
        .clk(clk),
        .estado_olhos(estado_olhos),
		  .estado_lingua(estado_lingua),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .video_active(1'b1),
        .rst_n(1'b1),
        .final_color(final_color)
    );

  
    // inverte o clk a cada 20ns
    always #10 clk = ~clk;

    initial begin 
        estado_olhos = 2'b00;
		  estado_lingua = 1'b1;

        #50;

        // Teste do Background
        #40;
        pixel_x = 10'd10;
        pixel_y = 10'd10;

        // Teste do Sprite do olho esquerdo aberto
        #40;
        pixel_x = 10'd290;
        pixel_y = 10'd220;
		  
		  
		  //fechando o olho esquerdo
		  #40;
		  estado_olhos[1] = 1'b1;
			
		  
		  // Teste do Sprite do olho direito aberto
		  #40;
		  pixel_x = 10'd330;
        pixel_y = 10'd228;
			
			//fechando o olho direito
		  #40;
		  estado_olhos[0] = 1'b1;
		  

        // Teste do Sprite da língua desativado
        #40;
        pixel_x = 10'd325; 
        pixel_y = 10'd280;
		  
		  #40;
		  estado_lingua = 1'b0;
		  
		  // Teste do Sprite da língua ativado
        #40;
        pixel_x = 10'd325; 
        pixel_y = 10'd280;
		  

        #100;
        $finish;
    end

    initial begin
        $monitor("Tempo: %0t | X: %0d | Y: %0d | estado_olhos: %b | estado_lingua: %b| Final Color: %h", 
                 $time, pixel_x, pixel_y, estado_olhos, estado_lingua, final_color);
    end

endmodule