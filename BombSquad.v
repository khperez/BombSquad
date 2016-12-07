// Bomb Squad Top Level Module
// Author: Katherine Perez
// Course: ECE 5440 - Advanced Digital Design

/*
    Bomb Squad Module
    Description: The top level module of the game: BombSquad.
    Inputs:

    Outputs:

*/

module BombSquad(user_cred, submit_button, rotate_button, verify_button, clk, rst,
                 timer_sevseg1, timer_sevseg2, timer_sevseg3,
                 puzzle_sevseg1, puzzle_sevseg2, puzzle_sevseg3, puzzle_sevseg4,
                 lcd_on, lcd_en, lcd_flag);

    input [7:0] user_cred;

    input submit_button, rotate_button, verify_button,
          clk, rst;

    wire [7:0] game_state, rom_cred, rom_addr, ram_id;
    wire [3:0] user, cur_time3, cur_time2, cur_time1;
    wire [1:0] s_auth, verifier_result;
    wire [11:0] init_time;

    wire [15:0] sequence_key;

    wire submit, rotate, verify;
    wire one_sec;
    wire valid_key;
    wire [3:0] sequence_input;

    output lcd_on, lcd_en;
    output [9:0] lcd_flag;
    output [6:0] puzzle_sevseg1, puzzle_sevseg2, puzzle_sevseg3, puzzle_sevseg4;
    output [6:0] timer_sevseg1, timer_sevseg2, timer_sevseg3;

    // module ButtonShaper(B_in, B_out, Clk, Rst);
    ButtonShaper RotateButton(rotate_button, rotate, clk, rst);
    ButtonShaper VerifyButton(verify_button, verify, clk, rst);
    ButtonShaper SubmitButton(submit_button, submit, clk, rst);

    // module Authentication(clk, reset, State, user_cred, rom_cred, submit, s_update, rom_addr, ram_id, User);
    Authentication UserAuthentication(clk, rst, game_state, user_cred, rom_cred, submit, s_auth, rom_addr, ram_id, user);

    // module ROM_Sim(address, clock, q);
    ROM_Sim UserCredentials(rom_addr, clk, rom_cred);

    // module GameController(s_auth, cur_time, s_results, clk, rst, s_current);
    GameController MainGameController(s_auth, {cur_time3, cur_time2, cur_time1}, verifier_result, clk, rst, game_state);

    // module OneSec_Timer(clk, reset, timeout);
    OneSec_Timer OneSecondTimer(clk, rst, one_sec);

    // module Countdown(init_time, switch_op, sec_timer, reset, clk, value_three, value_two, value_one);
    Countdown CountdownTimer(init_time, game_state, one_sec, rst, clk, cur_time3, cur_time2, cur_time1);

    // module SevSegTimer(digit_reg, segment_output);
    SevSegTimer SevSegTimer1(cur_time3, timer_sevseg3);
    SevSegTimer SevSegTimer2(cur_time2, timer_sevseg2);
    SevSegTimer SevSegTimer3(cur_time1, timer_sevseg1);

    // module SequenceKeyGenerator(game_state, level_state, clk, rst, sequence_key, transmit);
    SequenceKeyGenerator PuzzleSequenceKeyGenerator(game_state, verifier_result, clk, rst, sequence_key, valid_key);

    // module SequenceVerifier(game_state, seq_key, valid_key, seq_input, verify, clk, rst, result);
    SequenceVerifier UserSequenceVerifier(game_state, sequence_key, valid_key, sequence_input, verify, clk, rst, verifier_result);

    // module SSD_Sequence(sequence_in, display, one_sec, button_move, button_next, clk, reset, sequence_out, sevseg_1, sevseg_2, sevseg_3, sevseg_4);
    SSD_Sequence SSD_Sequence1(sequence_key, game_state, one_sec, rotate, verify, clk, rst, sequence_input, puzzle_sevseg1, puzzle_sevseg2, puzzle_sevseg3, puzzle_sevseg4);

    // module LCDController(clk, reset, state, lcd_on, lcd_en, lcd_flag);
    LCDController LCDController1(clk, rst, game_state, lcd_on, lcd_en, lcd_flag);

endmodule
