module acumulador (
    input  wire       clk,
    input  wire       rst,
    input  wire       start,
    input  wire [3:0] x,

    output reg  [5:0] acc,
    output reg        done
);

    // =====================================================
    // SELECCION DE VARIANTE
    // =====================================================
    // 1 = Sumar x 3 veces
    // 2 = Sumar x 4 veces
    // 3 = Sumar x hasta que acc >= 20

    localparam VARIANTE = 3;


    // =====================================================
    // ESTADOS DE LA FSM
    // =====================================================

    localparam IDLE = 2'b00;
    localparam ADD  = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state;
    reg [1:0] next_state;


    // =====================================================
    // CONTADOR
    // =====================================================

    reg [2:0] count;


    // =====================================================
    // REGISTRO DE ESTADO
    // =====================================================

    always @(posedge clk or posedge rst) begin

        if (rst)
            state <= IDLE;
        else
            state <= next_state;

    end


    // =====================================================
    // LOGICA DE SIGUIENTE ESTADO
    // =====================================================

    always @(*) begin

        // Valor por defecto
        next_state = IDLE;

        case (state)

            // -------------------------------------------------
            // IDLE
            // -------------------------------------------------

            IDLE: begin

                if (start)
                    next_state = ADD;
                else
                    next_state = IDLE;

            end


            // -------------------------------------------------
            // ADD
            // -------------------------------------------------

            ADD: begin

                case (VARIANTE)

                    // =========================================
                    // VARIANTE 1
                    // Sumar x 3 veces
                    // =========================================

                    1: begin

                        if (count == 2)
                            next_state = DONE;
                        else
                            next_state = ADD;

                    end


                    // =========================================
                    // VARIANTE 2
                    // Sumar x 4 veces
                    // =========================================

                    2: begin

                        if (count == 3)
                            next_state = DONE;
                        else
                            next_state = ADD;

                    end


                    // =========================================
                    // VARIANTE 3
                    // Sumar x hasta que acc >= 20
                    // =========================================

                    3: begin

                        if (acc >= 20)
                            next_state = DONE;
                        else
                            next_state = ADD;

                    end


                    // =========================================
                    // OPCION NO VALIDA
                    // =========================================

                    default: begin

                        next_state = IDLE;

                    end

                endcase

            end


            // -------------------------------------------------
            // DONE
            // -------------------------------------------------

            DONE: begin

                // Después de mostrar el resultado,
                // regresar a IDLE

                next_state = IDLE;

            end


            // -------------------------------------------------
            // ESTADO NO VALIDO
            // -------------------------------------------------

            default: begin

                next_state = IDLE;

            end

        endcase

    end


    // =====================================================
    // DATAPATH
    // =====================================================

    always @(posedge clk or posedge rst) begin

        if (rst) begin

            acc   <= 6'd0;
            count <= 3'd0;

        end

        else begin

            case (state)

                // -------------------------------------------------
                // IDLE
                // -------------------------------------------------

                IDLE: begin

                    if (start) begin

                        // Primera suma directamente
                        acc   <= x;
                        count <= 3'd1;

                    end

                    else begin

                        // No hay operación:
                        // limpiar resultado anterior

                        acc   <= 6'd0;
                        count <= 3'd0;

                    end

                end


                // -------------------------------------------------
                // ADD
                // -------------------------------------------------

                ADD: begin

                    // Acumular x

                    acc   <= acc + x;
                    count <= count + 1'b1;

                end


                // -------------------------------------------------
                // DONE
                // -------------------------------------------------

                DONE: begin

                    // Mantener el resultado durante
                    // este ciclo solamente

                    acc   <= acc;
                    count <= count;

                end


                // -------------------------------------------------
                // ESTADO NO VALIDO
                // -------------------------------------------------

                default: begin

                    acc   <= 6'd0;
                    count <= 3'd0;

                end

            endcase

        end

    end


    // =====================================================
    // SALIDA DONE
    // =====================================================

    always @(*) begin

        if (state == DONE)
            done = 1'b1;
        else
            done = 1'b0;

    end

endmodule