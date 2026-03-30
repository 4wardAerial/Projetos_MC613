module ppu_fsm (
    input wire clk,
    input wire rst_n,
    input wire oam_ready,
    input wire [8:0] pixel_x,
    input wire [8:0] pixel_y,
    output reg [1:0] state
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 2'b00; 
        end 
        
        else if (state == 2'b00 && oam_ready) begin
            state <= 2'b01; 
        end

        else if (state == 2'b01 && pixel_x == 640) begin
            state <= 2'b10; 
        end        
            
        else if (state == 2'b10) begin
            if (pixel_x == 800) begin
                if (pixel_y == 480) begin
                    state <= 2'b11; 
                end else begin
                    state <= 2'b01; 
                end 
            end
        end

        else if (state == 2'b11) begin
            if (pixel_y == 525) begin
                state <= 2'b00; 
            end
        end
    end

endmodule