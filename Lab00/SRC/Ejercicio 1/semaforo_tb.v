
`timescale 1ns / 1ps

module tb_semaforo;

    reg clk;
    reg rst;
    wire verde;
    wire amarillo;
    wire rojo;

    // Instanciación del módulo a probar (DUT)
    semaforo dut (
        .clk(clk),
        .rst(rst),
        .verde(verde),
        .amarillo(amarillo),
        .rojo(rojo)
    );

    // Reloj con período de 10 ns:
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_semaforo.vcd");
        $dumpvars(0, tb_semaforo);

        clk = 0;
        rst = 1;

        // Liberación del Reset a los 15 ns
        #15 rst = 0;

        // Simulación durante 300 ns
        #300;

        $finish;
    end

endmodule