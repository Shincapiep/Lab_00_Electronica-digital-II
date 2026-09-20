`timescale 1ns / 1ps

module asm_tb;

    parameter CLKS_PER_BIT = 4;
    parameter CLK_PERIOD   = 10; // Reloj de 100 MHz (periodo de 10 ns)

    // Entradas al DUT
    reg       clk;
    reg       rst;
    reg       start;
    reg [7:0] data_in;

    // Salidas del DUT
    wire tx;
    wire busy;
    wire done;

    // Instanciación del módulo ASM
    asm #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .data_in(data_in),
        .tx(tx),
        .busy(busy),
        .done(done)
    );

    // Generación de Reloj
    always #(CLK_PERIOD / 2) clk = ~clk;

    initial begin
        // 1. Nombre exacto del archivo requerido para GTKWave
        $dumpfile("wave.vcd");
        $dumpvars(0, asm_tb);

        // Inicialización de señales
        clk     = 0;
        rst     = 1;
        start   = 0;
        data_in = 8'h00;

        // Aplicar reset inicial durante 2 ciclos de reloj
        #(CLK_PERIOD * 2);
        rst = 0;
        #(CLK_PERIOD * 2);

        // ==========================================
        // Transmisión 1: Dato 8'hA5 (10100101b)
        // ==========================================
        @(posedge clk);
        data_in <= 8'hA5;
        start   <= 1'b1; // Pulso de exactamente 1 ciclo
        @(posedge clk);
        start   <= 1'b0;

        // Esperar a que se complete la transmisión 1
        wait(done == 1'b1);
        @(posedge clk);
        #(CLK_PERIOD * 4); // Intervalo de reposo entre envíos

        // ==========================================
        // Transmisión 2: Dato 8'h3C (00111100b)
        // ==========================================
        @(posedge clk);
        data_in <= 8'h3C;
        start   <= 1'b1; // Pulso de exactamente 1 ciclo
        @(posedge clk);
        start   <= 1'b0;

        // Esperar a que se complete la transmisión 2
        wait(done == 1'b1);
        @(posedge clk);
        #(CLK_PERIOD * 4);

        $display("Simulacion completada exitosamente.");
        $finish;
    end

endmodule