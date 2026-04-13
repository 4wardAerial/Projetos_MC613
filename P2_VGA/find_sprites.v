module find_sprites (
    input wire clk,
    input wire rst_n,
    input wire [9:0] pixel_x,
    input wire [9:0] pixel_y,
    output reg [1:0] ID,
    output reg [1:0] tile_x,
    output reg [1:0] tile_y
);

    reg [23:0] sprite [0:1]; 
	 
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ID <= 2;
            tile_x <= 2;
            tile_y <= 2;
        end else begin
            if (pixel_x >= (sprite[0][23:16] * 8) && 
                pixel_x <  ((sprite[0][23:16] + sprite[0][7:4]) * 8) &&
                pixel_y >= (sprite[0][15:8] * 8) && 
                pixel_y <  ((sprite[0][15:8] + sprite[0][3:0]) * 8)) begin
                
                ID <= 0;
                tile_x <= (pixel_x - (sprite[0][23:16] * 8)) / 8    
                    4'b00_00: pixel_idx = 3'b011;
                    4'b00_01: pixel_idx = 3'b011;
                    4'b00_10: pixel_idx = 3'b011;
                    4'b01_00: pixel_idx = 3'b011;
                    4'b01_01: pixel_idx = 3'b011;
                    4'b01_10: pixel_idx = 3'b010;
                    4'b10_00: pixel_ 8;
                tile_y <= (pixel_y - (sprite[0][15:8] * 8)) / 8;

            end else if (pixel_x >= (sprite[1][23:16] * 8) && 
                         pixel_x <  ((sprite[1][23:16] + sprite[1][7:4]) * 8) &&
                         pixel_y >= (sprite[1][15:8] * 8) && 
                         pixel_y <  ((sprite[1][15:8] + sprite[1][3:0]) * 8)) begin
                
                ID <= 1;
                tile_x <= (pixel_x - (sprite[1][23:16] * 8)) / 8;
                tile_y <= (pixel_y - (sprite[1][15:8] * 8)) / 8;
                
            end else begin
                ID <= 2;
                tile_x <= 2;
                tile_y <= 2;
            end
        end
    end

    initial begin
        sprite[0] = 24'h040533; 
        sprite[1] = 24'h090533; 
    end
endmodule
