`timescale 1ns/1ps

module controlador_vga_tb;

    reg pixel_clk;
    reg reset_n;
    reg [7:0] r_in;
    reg [7:0] g_in;
    reg [7:0] b_in;

    wire [9:0] pixel_x;
    wire [9:0] pixel_y;
    wire video_active;
    wire [7:0] VGA_R;
    wire [7:0] VGA_G;
    wire [7:0] VGA_B;
    wire VGA_HS;
    wire VGA_VS;
    wire VGA_BLANK_N;
    wire VGA_SYNC_N;
    wire VGA_CLK;

    controlador_vga uut (
        .pixel_clk(pixel_clk),
        .reset_n(reset_n),
        .r_in(r_in),
        .g_in(g_in),
        .b_in(b_in),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .video_active(video_active),
        .VGA_R(VGA_R),
        .VGA_G(VGA_G),
        .VGA_B(VGA_B),
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS),
        .VGA_BLANK_N(VGA_BLANK_N),
        .VGA_SYNC_N(VGA_SYNC_N),
        .VGA_CLK(VGA_CLK)
    );

    always #20 pixel_clk = ~pixel_clk;

    initial begin
        pixel_clk = 0;
        reset_n = 0;
        r_in = 8'hFF;
        g_in = 8'h00;
        b_in = 8'hAA;

        #100;
        reset_n = 1;

        #17000000;

        $finish;
    end

endmodule