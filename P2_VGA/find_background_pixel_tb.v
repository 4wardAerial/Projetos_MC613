module find_background_pixel_tb();
    reg [9:0] pixel_x;
    reg [9:0] pixel_y;


    wire [23:0] bg_color;

    find_background_pixel utt(
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .bg_color(bg_color)
    );

    initial begin

        #10;
        // casos de pixel preto do fundo
        pixel_x = 10'd50;
        pixel_y = 10'd50;


        #10;
        // Caso de pixel amarelo
        pixel_x = 10'd300;
        pixel_y = 10'd200;

        #10;

        // Caso de pixel preto da boca
        pixel_x = 10'd290;
        pixel_y = 10'd262;

        #10;
        $finish;
    end
    initial begin
        $monitor("Tempo: %0t | X: %0d | Y: %0d | Bg color: %h", 
                 $time, pixel_x, pixel_y, bg_color);
    end

endmodule