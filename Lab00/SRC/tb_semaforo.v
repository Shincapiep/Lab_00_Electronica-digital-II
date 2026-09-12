`timescale 1ns/1ns

module tb_semaforo;

    reg clk;
    reg rst;

    wire green;
    wire yellow;
    wire red;

    // Instancia del módulo a probar (DUT)
    semaforo dut (
        .clk(clk),
        .rst(rst),
        .green(green),
        .yellow(yellow),
        .red(red)
    );

    // Generación de reloj (Periodo = 10ns, Frecuencia = 100MHz)
    always #5 clk = ~clk;

    initial begin
        // Inicialización de señales
        clk = 0;
        rst = 1;

        // Pulso de Reset por 10ns
        #10;
        rst = 0;

        // Tiempo suficiente para observar más de 2 ciclos completos (110ns por ciclo)
        #300;
        
        $finish;
    end

    // Generación del archivo para ondas en GTKWave
    initial begin
        $dumpfile("semaforo.vcd");
        $dumpvars(0, tb_semaforo);
    end

endmodule