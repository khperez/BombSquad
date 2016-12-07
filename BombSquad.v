// Bomb Squad Top Level Module
// Author: Katherine Perez
// Course: ECE 5440 - Advanced Digital Design

/*
    Bomb Squad Module
    Description: The top level module of the game: BombSquad.
    Inputs:

    Outputs:

*/

module BombSquad();

    input [7:0] user_cred;

    input submit_button, rotate_button, verify_button,
          clk, rst;

    wire [7:0] address, rom_cred, rom_addr, ram_id;
    wire [3:0] user, cur_time3, cur_time2, cur_time1;
    wire [1:0] s_update;

    wire [15:0] sequence_key;

    wire submit, rotate, verify;
    wire one_sec;
    wire valid_key;

    // module ButtonShaper(B_in, B_out, Clk, Rst);
    ButtonShaper RotateButton(rotate_button, rotate);
    ButtonShaper VerifyButton(verify_button, verify);
    ButtonShaper SubmitButton(submit_button, submit);

    // module Authentication(clk, reset, State, user_cred, rom_cred, submit, s_update, rom_addr, ram_id, User);
    Authentication UserAuthentication(clk, rst, game_state, user_cred, rom_cred, submit, s_update, rom_addr, ram_id, user);

    // module ROM_Sim(address, clock, q);
    ROM_Sim UserCredentials(address, clk, rom_cred);

    // module GameController(s_auth, cur_time, s_results, clk, rst, s_current);
    GameController MainGameController(s_update, {cur_time3, cur_time2, cur_time1}, s_results, clk, rst, game_state);

    // module OneSec_Timer(clk, reset, timeout);
    OneSec_Timer OneSecondTimer(clk, rst, one_sec);

    // module Countdown(init_time, switch_op, sec_timer, reset, clk, value_three, value_two, value_one);
    Countdown CountdownTimer(init_time, game_state, one_sec, rst, clk, cur_time3, cur_time2, cur_time1);

    // module SequenceKeyGenerator(game_state, level_state, clk, rst, sequence_key, transmit);
    SequenceKeyGenerator PuzzleSequenceKeyGenerator(game_state, verifier_result, clk, rst, sequence_key, transmit);

    // module SequenceVerifier(game_state, seq_key, valid_key, seq_input, verify, clk, rst, result);
    SequenceVerifier UserSequenceVerifier(game_state, sequence_key, transmit, sequence_input, verify, clk, rst, verifier_result);

    // module SSD_Sequence(sequence_in, display, one_sec, button_move, button_next, clk, reset, sequence_out, sevseg_1, sevseg_2, sevseg_3, sevseg_4);
    SSD_Sequence SSD_Sequence1(sequence_key, )

endmodule
