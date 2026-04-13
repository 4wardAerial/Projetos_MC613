`timescale 1ns/1ps
module ppu_top_tb;

    reg clk;
    reg [1:0] estado_olhos;
    reg [9:0] pixel_x;
    reg [9:0] pixel_y;
    reg video_active;
    reg rst_n;

    wire [23:0] final_color;

 
    ppu_top uut (
        .clk(clk),
        .estado_olhos(estado_olhos),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .video_active(video_active),
        .rst_n(rst_n),
        .final_color(final_color)
    );

  
    // inverte o clk a cada 20ns
    always #20 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0; 
        estado_olhos = 2'b00;
        pixel_x = 10'd0;
        pixel_y = 10'd0;
        video_active = 1'b1;

        #50;
        rst_n = 1;

        // Teste do Background
        #40;
        pixel_x = 10'd100;
        pixel_y = 10'd100;

        // Teste do Sprite 0
        #40;
        pixel_x = 10'd35; 
        pixel_y = 10'd42;

        // Teste de alteração de estado (estado_olhos[0])
        #40;
        estado_olhos = 2'b01; // estado_olhos = 1

        // Teste do Sprite 1 
        #40;
        pixel_x = 10'd75; 
        pixel_y = 10'd42;

        #100;
        $finish;
    end

    initial begin
        $monitor("Tempo: %0t | rst_n: %b | X: %0d | Y: %0d | SW: %b | Final Color: %h", 
                 $time, rst_n, pixel_x, pixel_y, SW, final_color);
    end

endmodule