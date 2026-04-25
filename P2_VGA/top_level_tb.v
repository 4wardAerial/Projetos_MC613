`timescale 1ns/1ps

module top_level_tb;


    reg CLOCK_50;
    reg [1:0] SW;
    reg [3:0] KEY;

    wire [7:0] VGA_R;
    wire [7:0] VGA_G;
    wire [7:0] VGA_B;
    wire VGA_HS;
    wire VGA_VS;
    wire VGA_BLANK_N;
    wire VGA_SYNC_N;
    wire VGA_CLK;

    top_level uut (
        .CLOCK_50(CLOCK_50),
        .SW(SW),
        .KEY(KEY),
        .VGA_R(VGA_R),
        .VGA_G(VGA_G),
        .VGA_B(VGA_B),
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS),
        .VGA_BLANK_N(VGA_BLANK_N),
        .VGA_SYNC_N(VGA_SYNC_N),
        .VGA_CLK(VGA_CLK)
    );

    always #10 CLOCK_50 = ~CLOCK_50;


    //Abrir os dois olhos
    task abrir_olhos;
        begin
            SW[1:0] = 2'b11; 
            #1000;           
        end
    endtask
    //Fechar os olhos
    task fechar_olhos;
        begin
            SW[1:0] = 2'b00; 
            #1000;
        end
    endtask

    task piscar_olho_esquerdo;
        begin
            SW[1:0] = 2'b01; 
            #1000;
        end
    endtask

    task mostrar_lingua;
        begin
            KEY[0] = 1'b0; 
            #1000;
        end
    endtask

    task esconder_lingua;
        begin
            KEY[0] = 1'b1; 
            #1000;
        end
    endtask

    initial begin
        CLOCK_50 = 0;
        SW = 2'b00;
        KEY = 4'b1111; 
        
  
        #100;


        abrir_olhos;
        mostrar_lingua;
        esconder_lingua;
        piscar_olho_esquerdo;
        fechar_olhos;

 

        #50000; 

        $finish;
    end

 
    initial begin
        $monitor("Tempo: %0t | HS: %b | VS: %b | Lingua_estado: %b | SW: %b", 
                 $time, VGA_HS, VGA_VS, KEY[0], SW);
    end

endmodule