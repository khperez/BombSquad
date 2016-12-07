// Sequence Key Builder
// Author: Katherine Perez
// Course: ECE 5440 - Advanced Digital Design

/*
    Sequence Key Builder
    Description: Generates the puzzle pattern to be displayed on the seven
                 seven-segment display.
    Inputs:
    + game_state
    + level_state
    + enable
    + lfsr_data
    + clk
    + rst

    Outputs:
    + sequence_key
*/

module SequenceKeyBuilder(game_state, level_state, data_in, clk, rst, sequence_key, transmit);

    input [6:0] game_state;
    input [1:0] level_state;
    input [7:0] data_in;
    input clk, rst;

    output reg [15:0] sequence_key = 16'h0;
    output reg transmit;

    reg [3:0] state;

    parameter s0 = 3'b000, s1 = 3'b001, s2 = 3'b010, s3 = 3'b011, s4 = 3'b100,
              seq_complete = 3'b101;

    always @(posedge clk)
        begin
            if (rst == 0)
                begin
                    state <= s1;
                    sequence_key <= 0;
                    transmit <= 0;
                end
            else
                begin
                    case (state)
                        s1: begin
                                if (game_state == 7'h10 && level_state == 2'b11)
                                    begin
                                        case (data_in[7:6])
                                            2'b00: begin
                                                        sequence_key[15:12] <= 4'b1110;
                                                   end
                                            2'b01: begin
                                                        sequence_key[15:12] <= 4'b1101;
                                                   end
                                            2'b10: begin
                                                        sequence_key[15:12] <= 4'b1011;
                                                   end
                                            2'b11: begin
                                                        sequence_key[15:12] <= 4'b0111;
                                                   end
                                        endcase
                                        case (data_in[5:4])
                                            2'b00: begin
                                                        sequence_key[11:8] <= 4'b1110;
                                                   end
                                            2'b01: begin
                                                        sequence_key[11:8] <= 4'b1101;
                                                   end
                                            2'b10: begin
                                                        sequence_key[11:8] <= 4'b1011;
                                                   end
                                            2'b11: begin
                                                        sequence_key[11:8] <= 4'b0111;
                                                   end
                                        endcase
                                        case (data_in[3:2])
                                            2'b00: begin
                                                        sequence_key[7:4] <= 4'b1110;
                                                   end
                                            2'b01: begin
                                                        sequence_key[7:4] <= 4'b1101;
                                                   end
                                            2'b10: begin
                                                        sequence_key[7:4] <= 4'b1011;
                                                   end
                                            2'b11: begin
                                                        sequence_key[7:4] <= 4'b0111;
                                                   end
                                        endcase
                                        case (data_in[1:0])
                                            2'b00: begin
                                                        sequence_key[3:0] <= 4'b1110;
                                                   end
                                            2'b01: begin
                                                        sequence_key[3:0] <= 4'b1101;
                                                   end
                                            2'b10: begin
                                                        sequence_key[3:0] <= 4'b1011;
                                                   end
                                            2'b11: begin
                                                        sequence_key[3:0] <= 4'b0111;
                                                   end
                                        endcase
                                        transmit <= 1;
                                        state <= s2;
                                    end
                                end
                        s2: begin
                                transmit <= 0;
                                state <= s1;
                            end
                    endcase
                end
        end
endmodule
