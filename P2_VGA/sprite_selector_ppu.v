begin module sprite_selector (
        input wire clk,
        input wire rst_n,
        input wire [0] estado_olhos,
        input wire [0] ID,
        input wire [0] tile_x,
        input wire [0] tile_y,
        output reg [5:0] color
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            if (estado_olhos == 1'b0) begin
                sprite <= eye_open;
            end else begin
                case (ID)
                    1'b0: sprite <= left_eye_closed;
                    1'b1: sprite <= right_eye_closed;
                    default: sprite <= left_eye_closed;
                endcase
            end

            color = sprite[tile[tile_x][tile_y]];
        end
    end

    left_eye_closed begin
        tile[0][0] <= 3'b010;
        tile[0][1] <= 3'b000;
        tile[0][2] <= 3'b000;
        tile[1][0] <= 3'b000;
        tile[1][1] <= 3'b010;
        tile[1][2] <= 3'b000;
        tile[2][0] <= 3'b010;
        tile[2][1] <= 3'b000;
        tile[2][2] <= 3'b000;
    end

    eye_open begin
        tile[0][0] <= 3'b100;
        tile[0][1] <= 3'b100;
        tile[0][2] <= 3'b100;
        tile[1][0] <= 3'b100;
        tile[1][1] <= 3'b100;
        tile[1][2] <= 3'b010;
        tile[2][0] <= 3'b100;
        tile[2][1] <= 3'b100;
        tile[2][2] <= 3'b100;
    end

    right_eye_closed begin
        tile[0][0] <= 3'b000;
        tile[0][1] <= 3'b000;
        tile[0][2] <= 3'b010;
        tile[1][0] <= 3'b000;
        tile[1][1] <= 3'b010;
        tile[1][2] <= 3'b000;
        tile[2][0] <= 3'b000;
        tile[2][1] <= 3'b000;
        tile[2][2] <= 3'b000;
    end

    tile_map begin
        color[1] <= 6'hffff00;
        color[2] <= 6'h000000;
        color[3] <= 6'hffffff;
    end
