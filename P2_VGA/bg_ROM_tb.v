module bg_ROM_tb;
    reg [3:0] linha;
    reg [3:0] coluna;

    wire [3:0] data_out;

    bg_ROM uut(
        .linha(linha),
        .coluna(coluna),
        .data_out(data_out)
    );
    initial begin
        linha = 4'd0;
        coluna = 4'd0;
        
        #10;

        linha = 4'd0;
        coluna = 4'd5;
        #10;

        linha = 4'd1;
        coluna = 4'd0;
        #10;


        linha = 4'd1;
        coluna = 4'd5;
        #10;

        linha = 4'd15;
        coluna = 4'd15;
        #10;

        $finish;
        end

    initial begin
        $monitor("Tempo: %0t | Linha: %0d | Coluna: %0d | Data out: %h", 
                 $time, linha, coluna, data_out);
    end

endmodule