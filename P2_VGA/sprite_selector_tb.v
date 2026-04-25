`timescale 1ns/1ps

module sprite_selector_tb();

    
    reg clk;
    reg rst_n;
    reg [1:0] estado_olhos;
    reg estado_lingua;
    reg is_there_sprite;
    reg [1:0] ID;
    reg [1:0] tile_x;
    reg [1:0] tile_y;


    wire [23:0] color;
    wire transparent;

  
    sprite_selector uut (
        .clk(clk),
        .rst_n(rst_n),
        .estado_olhos(estado_olhos),
        .estado_lingua(estado_lingua),
        .is_there_sprite(is_there_sprite),
        .ID(ID),
        .tile_x(tile_x),
        .tile_y(tile_y),
        .color(color),
        .transparent(transparent)
    );

  
    always #10 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        estado_olhos = 2'b00;
        estado_lingua = 1'b0;
        is_there_sprite = 0;
        ID = 2'd0;
        tile_x = 2'b00;
        tile_y = 2'b00;

        #25; 
        rst_n = 1;

        // Teste fora do sprite - transparente
        is_there_sprite = 0;
        #20;

        // Teste olho esquerdo aberto
    
        is_there_sprite = 1;
        ID = 2'd0;
        estado_olhos = 2'b00; 
        tile_x = 2'b00; tile_y = 2'b00; 
        #20; 
        
        tile_x = 2'b01; tile_y = 2'b01; 
        #20; 

        //  Teste olho esquerdo fechado
        estado_olhos = 2'b10; 
        tile_x = 2'b00; tile_y = 2'b00; 
        #20; 
        
        tile_x = 2'b00; tile_y = 2'b01; 
        #20; 

        // Teste  olho direito aberto
        ID = 2'd1;
        estado_olhos = 2'b00; 
        tile_x = 2'b00; tile_y = 2'b00; 
        #20; 
        
        estado_olhos = 2'b01; 
        tile_x = 2'b00; tile_y = 2'b00; 
        #20; 

        // Teste língua fora
        ID = 2'd2;
        estado_lingua = 1'b0; 
        #20; 
        
        estado_lingua = 1'b1; 
        #20; 


        $finish;
    end

    initial begin
        $monitor("Tempo: %0t | Sprite?: %b | ID: %0d | Olhos: %b | Lingua: %b | TX: %0d | TY: %0d || Transp: %b | Cor: %h", 
                 $time, is_there_sprite, ID, estado_olhos, estado_lingua, tile_x, tile_y, transparent, color);
    end

endmodule