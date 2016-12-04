// Sequence Verifier Module
// Author: Katherine Perez
// Course: ECE 5440 - Advanced Digital Design

/*
    Sequence Verifier Module
    Description: Verifies the sequence that the user has entered on the seven
                 display.
    Inputs:
    + game_state: current game state
    + seq_key: sequence key
    + seq_input: sequence cell input from user
    + verify: sequence cell verification
    + sw_combo: switch combination
    + clk: clock
    + rst: reset

    Outputs:
    + result: pass/fail sequence verification
        0: No Result
        1: Pass
        2: Fail

*/

module SequenceVerifier(game_state, seq_key, seq_input, verify, sw_combo, clk, rst, result);
    input [6:0] game_state;
    input [15:0] seq_key;
    input [3:0] seq_input;
    input verify;
    input [15:0] sw_combo;
    input clk, rst;

    output reg [1:0] result;

    reg [2:0] level_stage;
    reg [3:0] stage1reg = 0,
              stage2reg = 0,
              stage3reg = 0;
    reg [2:0] stage_counter = 0;

    parameter stage0 = 3'b000,
              stage1 = 3'b001, stage2 = 3'b010,
              stage3 = 3'b011, final_stage = 3'b100;

    always @(posedge clk)
        begin
            if (rst == 0)
                begin
                    level_stage <= stage0;
                    result <= 2'b00;
                end
            else
                begin
                    case (level_stage)
                        // User authentication stage
                        stage0: begin
                                    if (game_state == 7'h10)
                                        begin
                                            stage_counter <= 0;
                                            level_stage <= stage1;
                                            result <= 2'b00;
                                        end
                                    else
                                        begin
                                            stage_counter <= 0;
                                            level_stage <= stage0;
                                            result <= 2'b00;
                                end
                        // Stage 1 of level
                        stage1: begin
                                    stage_counter <= 0;
                                    stage1reg <= seq_key;
                                    if (stage1reg != 0 && verify == 1)
                                        begin
                                            // Up
                                            if (stage1reg[8] == 0)
                                                begin
                                                    if (seq_input[2] == 0)
                                                        result <= 2'b01;
                                                    else
                                                        result <= 2'b10;
                                                end
                                            // Right
                                            else if (stage1reg[9] == 0)
                                                begin
                                                    if (seq_input[0] == 0)
                                                        result <= 2'b01;
                                                    else
                                                        result <= 2'b10;
                                                end
                                            // Down
                                            else if (stage1reg[10] == 0)
                                                begin
                                                    if (seq_input[1] == 0)
                                                        result <= 2'b01;
                                                    else
                                                        result <= 2'b10;
                                                end
                                            // Left
                                            else if (stage1reg[11] == 0)
                                                begin
                                                    if (seq_input[3] == 0)
                                                        result <= 2'b01;
                                                    else
                                                        result <= 2'b10;
                                                end
                                        end
                                end
                        // Stage 2 of level
                        stage2: begin
                                    stage_counter <= 0;
                                end
                        // Stage 3 of level
                        stage3: begin
                                end
                    endcase
                end
        end
endmodule
