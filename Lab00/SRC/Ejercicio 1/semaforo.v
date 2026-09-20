
module semaforo (
    input wire clk,
    input wire rst,
    output reg verde,
    output reg amarillo,
    output reg rojo
);

    // Codificación de estados
    localparam S_VERDE = 2'b00;
    localparam S_AMARILLO1 = 2'b01;
    localparam S_ROJO = 2'b10;
    localparam S_AMARILLO2 = 2'b11;

    // Duración de cada estado en ciclos de reloj
    localparam CICLOS_VERDE = 5;
    localparam CICLOS_AMARILLO = 2;
    localparam CICLOS_ROJO = 4;

    reg [1:0] estado_actual, estado_siguiente;
    reg [3:0] contador;


    // 1. Registro de Estado y Contador (Lógica Secuencial):

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            estado_actual <= S_VERDE;
            contador      <= 4'd0;
        end else begin
            if (estado_actual != estado_siguiente) begin
                estado_actual <= estado_siguiente;
                contador      <= 4'd0;
            end else begin
                contador <= contador + 1'b1;
            end
        end
    end

    // 2. Lógica de Siguiente Estado (Lógica Combinacional):

    always @(*) begin
        estado_siguiente = estado_actual;
        case (estado_actual)
            S_VERDE: begin
                if (contador >= CICLOS_VERDE - 1)
                    estado_siguiente = S_AMARILLO1;
            end
            S_AMARILLO1: begin
                if (contador >= CICLOS_AMARILLO - 1)
                    estado_siguiente = S_ROJO;
            end
            S_ROJO: begin
                if (contador >= CICLOS_ROJO - 1)
                    estado_siguiente = S_AMARILLO2;
            end
            S_AMARILLO2: begin
                if (contador >= CICLOS_AMARILLO - 1)
                    estado_siguiente = S_VERDE;
            end
            default: estado_siguiente = S_VERDE;
        endcase
    end

    // 3. Lógica de Salidas:

    always @(*) begin
        verde    = 1'b0;
        amarillo = 1'b0;
        rojo     = 1'b0;

        case (estado_actual)
            S_VERDE:     verde    = 1'b1;
            S_AMARILLO1: amarillo = 1'b1;
            S_ROJO:      rojo     = 1'b1;
            S_AMARILLO2: amarillo = 1'b1;
            default:     verde    = 1'b1;
        endcase
    end

endmodule