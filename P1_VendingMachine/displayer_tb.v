module displayer_tb;

reg [2:0] test_state;
reg [10:0] test_prod_value;
reg [10:0] test_prod_price;
wire [10:0] test_prod_value_bin;
wire [1:0] test_ledr;

displayer uut (
    .state(test_state),
    .val_pago(test_prod_value),
	 .prod_price(test_prod_price)
);

// Variável para o loop (deve ser integer)
integer i;

initial begin
    $display("Testando displayer...");
    
    // Loop de 0 a 5
    for (i = 0; i < 6; i = i + 1) begin
        test_state = i;
        #10;  // Aguarda para o sinal estabilizar
        $display("Estado: %b | ValorProd: %d | PrecoProd: %d | PrecoProdBin: %b | LED: %b", test_state, test_prod_value, test_prod_price, test_prod_value_bin, test_ledr);
    end
    
    $finish;
end

endmodule