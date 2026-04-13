module sprite_selector (
    input wire clk,
    input wire rst_n,
    input wire estado_olhos,
    input wire is_there_sprite,
    input wire  ID,
    input wire [1:0] tile_x, 
    input wire [1:0] tile_y, 
    output reg [23:0] color,  
    output reg transparent
);

    reg [2:0] pixel_idx;

    always @(*) begin
        if (is_there_sprite) begin
            if (estado_olhos == 1'b0) begin
                case ({tile_x, tile_y})
                    4'b00_00: pixel_idx = 3'b011;
                    4'b00_01: pixel_idx = 3'b011;
                    4'b00_10: pixel_idx = 3'b011;
                    4'b01_00: pixel_idx = 3'b011;
                    4'b01_01: pixel_idx = 3'b011;
                    4'b01_10: pixel_idx = 3'b010;
                    4'b10_00: pixel_idx = 3'b011;
                    4'b10_01: pixel_idx = 3'b011;
                    4'b10_10: pixel_idx = 3'b011;
                    default:  pixel_idx = 3'b000;
                endcase
            end else begin
                if (ID == 1'b0) begin
                    case ({tile_x, tile_y})
                        4'b00_00: pixel_idx = 3'b010;
                        4'b00_01: pixel_idx = 3'b000;
                        4'b00_10: pixel_idx = 3'b000;
                        4'b01_00: pixel_idx = 3'b000;
                        4'b01_01: pixel_idx = 3'b010;
                        4'b01_10: pixel_idx = 3'b000;
                        4'b10_00: pixel_idx = 3'b010;
                        4'b10_01: pixel_idx = 3'b000;
                        4'b10_10: pixel_idx = 3'b000;
                        default:  pixel_idx = 3'b000;
                    endcase
                end else begin
                    case ({tile_x, tile_y})
                        4'b00_00: pixel_idx = 3'b000;
                        4'b00_01: pixel_idx = 3'b000;
                        4'b00_10: pixel_idx = 3'b010;
                        4'b01_00: pixel_idx = 3'b000;
                        4'b01_01: pixel_idx = 3'b010;
                        4'b01_10: pixel_idx = 3'b000;
                        4'b10_00: pixel_idx = 3'b000;
                        4'b10_01: pixel_idx = 3'b000;
                        4'b10_10: pixel_idx = 3'b010;
                        default:  pixel_idx = 3'b000;
                    endcase
                end
            end
        end else begin
				pixel_idx = 3'b000;
		  end
    end  


always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            color <= 24'h000000;
            transparent <= 1'b1;
        end else begin
            transparent <= 1'b0; 

            case (pixel_idx)
                3'b000: transparent <= 1'b1;
                3'b001: color <= 24'hfbc336; 
                3'b010: color <= 24'h000000; 
                3'b011: color <= 24'hffffff;
                default: begin 
                    color <= 24'h000000;
                    transparent <= 1'b1;
                end
            endcase
        end
    end

endmodule
