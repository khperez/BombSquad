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

    Outputs:
    + sequence_key
*/

module SequenceKeyGenerator(game_state, level_state, clk, rst, sequence_key, transmit);

    // module SequenceKeyDecoder(game_state, level_state, lfsr_data, enable, clk, rst, sequence_key);
    SequenceKeyBuilder SequenceKeyBuilder1(game_state, level_state, lfsr_data, enable, clk, rst, sequence_key);

    // module LFSR8bit(enable, reset, clk, output_sequence);
    LFSR8bit LFSR8bit1(enable, rst, clk, output_sequence);

endmodule
