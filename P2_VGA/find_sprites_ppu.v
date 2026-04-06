module find_sprites (
        input wire clk,
        input wire rst_n,
        input wire [8:0] pixel_x,
        input wire [8:0] pixel_y,
        output reg [0] ID,
        output reg [0] tile_x,
        output reg [0] tile_y
    );


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 2; i = i + 1) begin
                if (pixel_x <= sprite[i][0:1] + 8*sprite[i][4] && 
                    pixel_y <= sprite[i][2:3] + 8*sprite[i][5]) begin

                    ID <= i;
                    tile_x <= (pixel_x - sprite[i][0:1]) / 8;
                    tile_y <= (pixel_y - sprite[i][2:3]) / 8;
                    break;
                end
            end
        end
    end

            
    sprite_map begin
        sprite[0] <= 6'h040533;
        sprite[1] <= 6'h090533; # tile 09, tile 05, size 3x3 tiles
    end

endmodule