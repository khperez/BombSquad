// Sequence Verifier Module
// Author: Katherine Perez
// Course: ECE 5440 - Advanced Digital Design

/*
    Sequence Verifier Module
    Description: Verifies the sequence that the user has entered on the seven
                 display.
    Inputs:
    + state: current game state
    + seq_key: sequence key
    + verify: sequence cell verification
    + sw_combo: switch combination
    + clk: clock
    + rst: reset

    Outputs:
    + result: pass/fail sequence verification

*/

module SequenceVerifier(state, seq_key, verify, sw_combo, clk, rst, result);
    input [6:0] state;
    input [15:0] seq_key;
    input verify;
    input [15:0] sw_combo;
    input clk, rst;

    always @(posedge clk)
        begin
        end
endmodule
