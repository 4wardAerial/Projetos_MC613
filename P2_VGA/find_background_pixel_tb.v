'`timescale 1ps/1ps
module find_background_pixel_tb
    wire [9:0] pixel_x;
    wire [9:0] pixel_y;


    wire [23:0] bg_color;

    find_background_pixel utt(
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .bg_color(bg_color)
    );

    initial begin
        // X e Y nas posições iniciais
        pixel_x = 10'd0;
        pixel_y = 10'd0;

        #10;
        // X e  Y com val diferentes e válidos
        pixel_x = 10'd 50;
        pixel_y = 10'd0;

        #10;
        // X e Y com os mesmos val e válidos
        pixel_x = 10'd50;
        pixel_y = 10'd50;


        #10;
        // Casp do X está em posição inválida, 
        //fora da nossa delimitação inicial
        pixel_x = 10'd129;
        pixel_y = 10'd50;

        #10;

        // Caso do Y em posição inválida
        pixel_x = 10'd50;
        pixel_y = 10'd129;

        // Caso X e Y em posições inválidas
        pixel_x = 10'd150;
        pixel_y = 10'd150;

        #10;
        $finish;
    end
    initial begin
        $monitor("Tempo: %0t | X: %0d | Y: %0d | Bg color: %h", 
                 $time, pixel_x, pixel_y, bg_color);
    end

endmodule