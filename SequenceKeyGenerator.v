// Sequence Key Generator
// Author: Katherine Perez
// Course: ECE 5440 - Advanced Digital Design

/*
    Sequence Key Generator
    Description: Generates the puzzle pattern to be displayed on the seven
                 seven-segment display.
    Inputs:
    + game_state
    + level_state
    + clk
    + rst

    Outputs:
    + sequence_key
    + transmit
*/

module SequenceKeyGenerator(game_state, level_state, clk, rst, sequence_key, transmit);

    input [7:0] game_state;
    input [1:0] level_state;
    input clk, rst;

    wire [15:0] output_sequence;

    output [15:0] sequence_key;
    output transmit;

    // module SequenceKeyBuilder(game_state, level_state, data_in, clk, rst, sequence_key, transmit);
    SequenceKeyBuilder SequenceKeyBuilder1(game_state, level_state, output_sequence, clk, rst, sequence_key, transmit);

    // module LFSR8bit(reset, clk, output_sequence);
    LFSR8bit LFSR8bit1(rst, clk, output_sequence);

endmodule
