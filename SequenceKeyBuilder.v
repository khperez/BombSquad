// Sequence Key Decoder
// Author: Katherine Perez
// Course: ECE 5440 - Advanced Digital Design

/*
    Sequence Key Decoder
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

module SequenceKeyBuilder(game_state, level_state, lfsr_data, enable, clk, rst, sequence_key, transmit);

    input [6:0] game_state;
    input [1:0] level_state;
    input [7:0] lfsr_data;
    input enable, clk, rst;

    output reg [15:0] sequence_key = 0;
    output reg transmit;

    reg [3:0] cell1 = 0, cell2 = 0, cell3 = 0, cell4 = 0;
    reg [1:0] mod_reg;
    reg [3:0] state;

    parameter s1 = 3'b001, s2 = 3'b010, s3 = 3'b011, s4 = 3'b100,
              seq_complete = 3'b101;

    always @(posedge clk)
        begin
            if (rst == 0)
                begin
                    state <= s1;
                    sequence_key <= 0;
                    cell1 <= 0;
                    cell2 <= 0;
                    cell3 <= 0;
                    cell4 <= 0;
                end
            // TODO
            else
                begin
                    case (state)
                        // Fill cell 1
                        s1: begin
                            end
                        // Fill cell 2
                        s2: begin
                            end
                end
        end
endmodule
