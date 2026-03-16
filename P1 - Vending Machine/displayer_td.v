module displayer_tb;

input reg [2:0] test_state,
input reg [10:0] test_prod_value,
input reg [10:0] test_prod_price,
output wire [10:0] test_prod_value_bin,
output wire [1:0] test_ledr

displayer uut (
    .STATE(test_state),
    .PROD_VALUE(test_prod_value)
	 .PROD_PRICE(test_prod_price)
);

// Variável para o loop (deve ser integer)
integer i;

initial begin
    $display("Testando displayer...");
    
    // Loop de 0 a 5
    for (i = 0; i < 6; i = i + 1) begin
        test_input = i;
        #10;  // Aguarda para o sinal estabilizar
        $display("Entrada: %h | Saída: %b", test_input, test_output);
    end
    
    $finish;
end

endmodule