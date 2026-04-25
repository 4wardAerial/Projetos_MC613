`timescale 1ns/1ps
module find_sprites_tb();
    reg clk;
    reg rst_n;
    reg [9:0] pixel_x;
    reg [9:0] pixel_y;

    wire is_there_sprite;
    wire [1:0] ID;
    wire [1:0] tile_x;
    wire [1:0] tile_y;


    find_sprites uut (
        .clk(clk),
        .rst_n(rst_n),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .is_there_sprite(is_there_sprite),
        .ID(ID),
        .tile_x(tile_x),
        .tile_y(tile_y)
    );

    always #10 clk = ~clk;
    initial begin
        clk = 0;
        rst_n = 0; 
        pixel_x = 10'd0;
        pixel_y = 10'd0;

        #25; 
        rst_n = 1; 
        

        // Colocar na coord (10,10) fora dos sprites
        #20;
        pixel_x = 10'd10;
        pixel_y = 10'd10;

    
        // Teste Coord (300,228) no olho esq
        #20;
        pixel_x = 10'd300;
        pixel_y = 10'd228;

        // Teste Coord (340,228) no olho dir
        #20;
        pixel_x = 10'd340;
        pixel_y = 10'd228;

        // Teste Coord (328,284) na boca
        #20;
        pixel_x = 10'd328;
        pixel_y = 10'd284;

        // Teste Coord (500,400) fora de tudo
        #20;
        pixel_x = 10'd500;
        pixel_y = 10'd400;

        #40;
        $finish;
    end

    initial begin
        $monitor("Tempo: %0t | X: %0d | Y: %0d | Tem Sprite?: %b | ID: %0d | tileX: %0d | tileY: %0d", 
                 $time, pixel_x, pixel_y, is_there_sprite, ID, tile_x, tile_y);
    end

endmodule

