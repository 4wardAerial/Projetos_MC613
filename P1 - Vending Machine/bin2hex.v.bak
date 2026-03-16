// Módulo conversor de binário para display de 7 segmentos
// Entrada: 4 bits (0-15)
// Saída: 7 bits controlando os segmentos do display
module bin2hex (
    input wire [3:0] BIN,  // Entrada: número de 0 a 15
    output reg [6:0] HEX   // Saída: 7 segmentos (cada bit controla um segmento)
);

// Lógica combinacional: sempre que BIN muda, HEX atualiza
always @(*) begin
    case(BIN)
        4'b0000: HEX = 7'b1000000; // 0
        4'b0001: HEX = 7'b1111001; // 1
        4'b0010: HEX = 7'b0100100; // 2
        4'b0011: HEX = 7'b0110000; // 3
        4'b0100: HEX = 7'b0011001; // 4
        4'b0101: HEX = 7'b0010010; // 5
        4'b0110: HEX = 7'b0000010; // 6
        4'b0111: HEX = 7'b1111000; // 7
        4'b1000: HEX = 7'b0000000; // 8
        4'b1001: HEX = 7'b0010000; // 9
        4'b1010: HEX = 7'b0001000; // A
        4'b1011: HEX = 7'b0000011; // B
        4'b1100: HEX = 7'b1000110; // C
        4'b1101: HEX = 7'b0100001; // D
        4'b1110: HEX = 7'b0000110; // E
        4'b1111: HEX = 7'b0001110; // F
        default: HEX = 7'b1111111; // Apagado (caso inconcebível)
    endcase
end

endmodule