`timescale 1ns / 1ps

module asm #(
    parameter CLKS_PER_BIT = 4
)(
    input  wire       clk,
    input  wire       rst,        // Entrada de reset requerida
    input  wire       start,
    input  wire [7:0] data_in,
    output reg        tx,
    output reg        busy,
    output reg        done
);

    // Codificación de estados de la FSM
    localparam IDLE       = 3'b000; // S0
    localparam LOAD       = 3'b001; // S1
    localparam BIT_HOLD   = 3'b010; // S2
    localparam SHIFT_NEXT = 3'b011; // S3
    localparam DONE       = 3'b100; // S4

    // Registros internos (Datapath y Control)
    reg [2:0]  state;
    reg [7:0]  shift_reg;
    reg [3:0]  bit_count;
    reg [15:0] tick_cnt;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state     <= IDLE;
            shift_reg <= 8'h00;
            bit_count <= 4'd0;
            tick_cnt  <= 16'd0;
            tx        <= 1'b1;
            busy      <= 1'b0;
            done      <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    tx   <= 1'b1;
                    busy <= 1'b0;
                    done <= 1'b0;
                    if (start) begin
                        state <= LOAD;
                        busy  <= 1'b1;
                    end
                end

                LOAD: begin
                    busy      <= 1'b1;
                    tx        <= 1'b1;
                    done      <= 1'b0;
                    shift_reg <= data_in;
                    bit_count <= 4'd0;
                    tick_cnt  <= 16'd0;
                    state     <= BIT_HOLD;
                end

                BIT_HOLD: begin
                    busy <= 1'b1;
                    done <= 1'b0;
                    tx   <= shift_reg[0];

                    if (tick_cnt >= CLKS_PER_BIT - 2) begin
                        state <= SHIFT_NEXT;
                    end else begin
                        tick_cnt <= tick_cnt + 1'b1;
                    end
                end

                SHIFT_NEXT: begin
                    busy      <= 1'b1;
                    done      <= 1'b0;
                    tx        <= shift_reg[0];
                    shift_reg <= {1'b0, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                    tick_cnt  <= 16'd0;

                    if (bit_count == 4'd7) begin
                        busy  <= 1'b0;
                        state <= DONE;
                    end else begin
                        state <= BIT_HOLD;
                    end
                end

                DONE: begin
                    done  <= 1'b1;
                    tx    <= 1'b1;
                    busy  <= 1'b0;
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule