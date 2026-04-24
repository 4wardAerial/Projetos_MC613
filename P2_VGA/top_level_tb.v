module top_level_tb();
    wire CLOCK_50;
    
	wire [1:0] SW;
	wire [7:0] VGA_R;
	wire [7:0] VGA_G;
	wire [7:0] VGA_B;
	wire VGA_HS;
	wire VGA_VS;
	wire VGA_BLANK_N;
	wire VGA_SYNC_N;
	wire VGA_CLK;

    top_level uut(
        .CLOCK_50(CLOCK_50),
        .SW(SW),
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
    initial begin
        CLOCK_50 = 0;
        SW = 2'b0; //olhos fechados

        #50000;

        $display("Mudar a chave SW para 1, e olhos se abrem");
        SW = 2'b1;

        #50000;
        $finish;
    end

endmodule