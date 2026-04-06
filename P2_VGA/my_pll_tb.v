`timescale 1ns/1ps 

module my_pll_tb(); 

    reg clk = 1'b0; 
	 reg rstn;
    wire pll_clk_out_25mhz;


    my_pll my_pll_inst(
        .clk_in(clk),
        .pll_clk_out_25mhz(pll_clk_out_25mhz),
		  .rstn(rstn)
    );
						
   
    initial begin
        forever #10 clk = ~clk;
    end

   
    initial begin 
        rstn = 1'b0;
        repeat(3) @(negedge clk);
        rstn = 1'b1;
    end
    
endmodule 