`timescale 1ns/1ns

module semaforo (
    input  wire clk, 
    input  wire rst,
    output reg  green,
    output reg  yellow,
    output reg  red
);

    // Codificación de estados
    localparam S0 = 2'b00; // Verde (5 ciclos)
    localparam S1 = 2'b01; // Amarillo (2 ciclos)
    localparam S2 = 2'b10; // Rojo (4 ciclos)

    reg [1:0] state;
    reg [2:0] count;

    // Lógica secuencial: Transición de estados y contador
    always @(posedge clk) begin
        if (rst) begin
            state <= S0;  
            count <= 3'd0;
        end
        else begin
            case (state)
                S0: begin
                    if (count == 3'd4) begin
                        state <= S1;
                        count <= 3'd0;
                    end
                    else begin
                        count <= count + 1'b1;
                    end
                end

                S1: begin
                    if (count == 3'd1) begin
                        state <= S2;
                        count <= 3'd0;
                    end
                    else begin
                        count <= count + 1'b1;
                    end
                end

                S2: begin
                    if (count == 3'd3) begin
                        state <= S0; // Cliclo repetitivo: regresa a Verde
                        count <= 3'd0;
                    end
                    else begin
                        count <= count + 1'b1;
                    end
                end

                default: begin
                    state <= S0;
                    count <= 3'd0;
                end
            endcase
        end
    end

    // Lógica combinacional: Salidas según estado actual
    always @(*) begin
        green  = 1'b0;
        yellow = 1'b0;
        red    = 1'b0;

        case (state)
            S0: green  = 1'b1;
            S1: yellow = 1'b1;
            S2: red    = 1'b1;
            default: green = 1'b1;
        endcase
    end

endmodule