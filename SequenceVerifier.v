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
    + valid_key: valid key
    + seq_input: sequence cell input from user
    + verify: sequence cell verification
    + clk: clock
    + rst: reset

    Outputs:
    + result: pass/fail sequence verification
        0: No Result
        1: Pass
        2: Fail

*/

module SequenceVerifier(game_state, seq_key, valid_key, seq_input, verify, clk, rst, result);
    input [7:0] game_state;
    input [15:0] seq_key;
    input [3:0] seq_input;
    input valid_key, verify;
    input clk, rst;

    output reg [1:0] result;

    reg [2:0] level_stage;
    reg [3:0] stage1reg = 0,
              stage1_target = 0,
              stage2reg = 0,
              stage2_target = 0,
              stage3reg = 0,
              stage3_target = 0;
    reg [2:0] stage_counter = 0;

    parameter stage0 = 3'b000,
              stage1 = 3'b001, stage2 = 3'b010,
              stage3 = 3'b011, final_stage = 3'b100,
              stage_fail = 3'b101, level_success = 3'b110;

    always @(posedge clk)
        begin
            if (rst == 0)
                begin
                    level_stage <= stage0;
                    result <= 2'b11;
                    stage1reg <= 0;
                    stage2reg <= 0;
                    stage3reg <= 0;
                    stage1_target <= 0;
                    stage2_target <= 0;
                    stage3_target <= 0;
                    stage_counter <= 0;
                end
            else
                begin
                    case (level_stage)
                        // User authentication stage
                        stage0: begin
                                    if (game_state == 8'h10)
                                        begin
                                            level_stage <= stage1;
                                            result <= 2'b11;
                                            stage1reg <= 0;
                                            stage2reg <= 0;
                                            stage3reg <= 0;
                                            stage1_target <= 0;
                                            stage2_target <= 0;
                                            stage3_target <= 0;
                                            stage_counter <= 0;
                                        end
                                    else
                                        begin
                                            level_stage <= stage0;
                                            result <= 2'b00;
                                            stage1reg <= 0;
                                            stage2reg <= 0;
                                            stage3reg <= 0;
                                            stage1_target <= 0;
                                            stage2_target <= 0;
                                            stage3_target <= 0;
                                            stage_counter <= 0;
                                        end
                                end
                        // Stage 1 of level
                        stage1: begin
                                    if (valid_key == 1)
                                        begin
                                            stage1reg <= seq_key[11:8];
                                        end
                                    else if (valid_key == 0)
                                        begin
                                            stage1reg <= stage1reg;
                                        end
                                    // Up
                                    if (stage1reg == 4'hE && stage_counter <= 4)
                                        begin
                                            stage1_target <= 4'hB;
                                            if (seq_input == stage1_target && verify == 1)
                                                begin
                                                    if (stage_counter < 3)
                                                        begin
                                                            level_stage <= stage1;
                                                            stage_counter <= stage_counter + 1;
                                                            result <= 2'b00;
                                                        end
                                                    else
                                                        begin
                                                            level_stage <= stage2;
                                                            result <= 2'b11;
                                                            stage_counter <= 0;
                                                        end
                                                end
                                            else if (seq_input != stage1_target && verify == 1)
                                                begin
                                                    result <= 2'b10;
                                                    level_stage <= stage_fail;
                                                end
                                            else
                                                begin
                                                    result <= 2'b00;
                                                    level_stage <= stage1;
                                                end
                                        end
                                    // Right
                                    else if (stage1reg == 4'hD && stage_counter <= 4)
                                        begin
                                            stage1_target <= 4'h7;
                                            if (seq_input == stage1_target && verify == 1)
                                                begin
                                                    if (stage_counter < 3)
                                                        begin
                                                            level_stage <= stage1;
                                                            stage_counter <= stage_counter + 1;
                                                            result <= 2'b00;
                                                        end
                                                    else
                                                        begin
                                                            level_stage <= stage2;
                                                            result <= 2'b11;
                                                            stage_counter <= 0;
                                                        end
                                                end
                                            else if (seq_input != stage1_target && verify == 1)
                                                begin
                                                    result <= 2'b10;
                                                    level_stage <= stage_fail;
                                                end
                                            else
                                                begin
                                                    result <= 2'b00;
                                                    level_stage <= stage1;
                                                end
                                        end
                                    // Down
                                    else if (stage1reg == 4'hB && stage_counter <= 4)
                                        begin
                                            stage1_target <= 4'hE;
                                            if (seq_input == stage1_target && verify == 1)
                                                begin
                                                    if (stage_counter < 3)
                                                        begin
                                                            level_stage <= stage1;
                                                            stage_counter <= stage_counter + 1;
                                                            result <= 2'b00;
                                                        end
                                                    else
                                                        begin
                                                            level_stage <= stage2;
                                                            result <= 2'b11;
                                                            stage_counter <= 0;
                                                        end
                                                end
                                            else if (seq_input != stage1_target && verify == 1)
                                                begin
                                                    result <= 2'b10;
                                                    level_stage <= stage_fail;
                                                end
                                            else
                                                begin
                                                    result <= 2'b00;
                                                    level_stage <= stage1;
                                                end
                                        end
                                    // Left
                                    else if (stage1reg == 4'h7 && stage_counter <= 4)
                                        begin
                                            stage1_target <= 4'hD;
                                            if (seq_input == stage1_target && verify == 1)
                                                begin
                                                    if (stage_counter < 3)
                                                        begin
                                                            level_stage <= stage1;
                                                            stage_counter <= stage_counter + 1;
                                                            result <= 2'b00;
                                                        end
                                                    else
                                                        begin
                                                            level_stage <= stage2;
                                                            result <= 2'b11;
                                                            stage_counter <= 0;
                                                    end
                                                end
                                            else if (seq_input != stage1_target && verify == 1)
                                                begin
                                                    result <= 2'b10;
                                                    level_stage <= stage_fail;
                                                end
                                            else
                                                begin
                                                    result <= 2'b00;
                                                    level_stage <= stage1;
                                                end
                                        end
                                end
                        // Stage 2 of level
                        stage2: begin
                                    if (valid_key == 1)
                                        begin
                                            stage2reg <= seq_key[3:0];
                                        end
                                    else if (valid_key == 0)
                                        begin
                                            stage2reg <= stage2reg;
                                        end
                                    // Up
                                    if (stage2reg == 4'hE)
                                        begin
                                            stage2_target <= seq_key[15:12];
                                            if (seq_input == stage2_target && verify == 1)
                                                begin
                                                    if (stage_counter < 3)
                                                        begin
                                                            level_stage <= stage2;
                                                            stage_counter <= stage_counter + 1;
                                                            result <= 2'b00;
                                                        end
                                                    else
                                                        begin
                                                            level_stage <= stage3;
                                                            result <= 2'b11;
                                                            stage_counter <= 0;
                                                        end
                                                end
                                            else if (seq_input != stage2_target && verify == 1)
                                                begin
                                                    result <= 2'b10;
                                                    level_stage <= stage_fail;
                                                end
                                            else
                                                begin
                                                    result <= 2'b00;
                                                    level_stage <= stage2;
                                                end
                                        end
                                    // Right
                                    else if (stage2reg == 4'hD)
                                        begin
                                            stage2_target <= seq_key[11:8];
                                            if (seq_input == stage2_target && verify == 1)
                                                begin
                                                    if (stage_counter < 3)
                                                        begin
                                                            level_stage <= stage2;
                                                            stage_counter <= stage_counter + 1;
                                                            result <= 2'b00;
                                                        end
                                                    else
                                                        begin
                                                            level_stage <= stage3;
                                                            result <= 2'b11;
                                                        end
                                                end
                                            else if (seq_input != stage2_target && verify == 1)
                                                begin
                                                    result <= 2'b10;
                                                    level_stage <= stage_fail;
                                                end
                                            else
                                                begin
                                                    result <= 2'b00;
                                                    level_stage <= stage2;
                                                end
                                        end
                                    // Down
                                    else if (stage2reg == 4'hB)
                                        begin
                                            stage2_target <= seq_key[7:4];
                                            if (seq_input == stage2_target && verify == 1)
                                                begin
                                                    if (stage_counter < 3)
                                                        begin
                                                            level_stage <= stage2;
                                                            stage_counter <= stage_counter + 1;
                                                            result <= 2'b00;
                                                        end
                                                    else
                                                        begin
                                                            level_stage <= stage3;
                                                            result <= 2'b11;
                                                            stage_counter <= 0;
                                                        end
                                                end
                                            else if (seq_input != stage2_target && verify == 1)
                                                begin
                                                    result <= 2'b10;
                                                    level_stage <= stage_fail;
                                                end
                                            else
                                                begin
                                                    result <= 2'b00;
                                                    level_stage <= stage2;
                                                end
                                        end
                                    // Left
                                    else if (stage2reg == 4'h7)
                                        begin
                                            stage2_target <= seq_key[15:12];
                                            if (seq_input == stage2_target && verify == 1)
                                                begin
                                                    if (stage_counter < 3)
                                                        begin
                                                            level_stage <= stage2;
                                                            stage_counter <= stage_counter + 1;
                                                            result <= 2'b00;
                                                        end
                                                    else
                                                        begin
                                                            level_stage <= stage3;
                                                            result <= 2'b11;
                                                            stage_counter <= 0;
                                                        end
                                                end
                                            else if (seq_input != stage2_target && verify == 1)
                                                begin
                                                    result <= 2'b10;
                                                    level_stage <= stage_fail;
                                                end
                                            else
                                                begin
                                                    result <= 2'b10;
                                                    level_stage <= stage2;
                                                end
                                        end
                                end

                        // Stage 3 of level
                        stage3: begin
                                    if (valid_key == 1)
                                        begin
                                            stage3reg <= seq_key[15:12];
                                        end
                                    else if (valid_key == 0)
                                        begin
                                            stage3reg <= stage3reg;
                                        end
                                    // Up
                                    if (stage3reg == 4'hE)
                                        begin
                                            case (stage_counter)
                                                2'b00: begin
                                                            stage3_target <= seq_key[3:0];
                                                       end
                                                2'b01: begin
                                                            stage3_target <= seq_key[7:4];
                                                       end
                                                2'b10: begin
                                                            stage3_target <= seq_key[11:8];
                                                       end
                                                2'b11: begin
                                                            stage3_target <= seq_key[15:12];
                                                       end
                                            endcase
                                            if (seq_input == stage3_target && verify == 1)
                                                begin
                                                    if (stage_counter < 3)
                                                        begin
                                                            level_stage <= stage3;
                                                            stage_counter <= stage_counter + 1;
                                                            result <= 2'b00;
                                                        end
                                                    else
                                                        begin
                                                            level_stage <= level_success;
                                                            result <= 2'b01;
                                                            stage_counter <= 0;
                                                        end
                                                end
                                            else if (seq_input != stage3_target && verify == 1)
                                                begin
                                                    result <= 2'b10;
                                                    level_stage <= stage_fail;
                                                end
                                            else
                                                begin
                                                    result <= 2'b00;
                                                    level_stage <= stage3;
                                                end
                                        end
                                    // Right
                                    else if (stage3reg == 4'hD)
                                        begin
                                            case (stage_counter)
                                                2'b00: begin
                                                            stage3_target <= seq_key[15:12];
                                                       end
                                                2'b01: begin
                                                            stage3_target <= seq_key[11:8];
                                                       end
                                                2'b10: begin
                                                            stage3_target <= seq_key[7:4];
                                                       end
                                                2'b11: begin
                                                            stage3_target <= seq_key[3:0];
                                                       end
                                            endcase
                                            if (seq_input == stage3_target && verify == 1)
                                                begin
                                                    if (stage_counter < 3)
                                                        begin
                                                            level_stage <= stage3;
                                                            stage_counter <= stage_counter + 1;
                                                            result <= 2'b00;
                                                        end
                                                    else
                                                        begin
                                                            level_stage <= level_success;
                                                            result <= 2'b01;
                                                            stage_counter <= 0;
                                                        end
                                                end
                                            else if (seq_input != stage3_target && verify == 1)
                                                begin
                                                    result <= 2'b10;
                                                    level_stage <= stage_fail;
                                                end
                                            else
                                                begin
                                                    result <= 2'b00;
                                                    level_stage <= stage3;
                                                end
                                        end
                                        // Down
                                        else if (stage3reg == 4'hB)
                                            begin
                                                case (stage_counter)
                                                    2'b00: begin
                                                                stage3_target <= seq_key[3:0];
                                                           end
                                                    2'b01: begin
                                                                stage3_target <= seq_key[15:12];
                                                           end
                                                    2'b10: begin
                                                                stage3_target <= seq_key[11:8];
                                                           end
                                                    2'b11: begin
                                                                stage3_target <= seq_key[7:4];
                                                           end
                                                endcase
                                                if (seq_input == stage3_target && verify == 1)
                                                    begin
                                                        if (stage_counter < 3)
                                                            begin
                                                                level_stage <= stage3;
                                                                stage_counter <= stage_counter + 1;
                                                                result <= 2'b00;
                                                            end
                                                        else
                                                            begin
                                                                level_stage <= level_success;
                                                                result <= 2'b01;
                                                                stage_counter <= 0;
                                                            end
                                                    end
                                                else if (seq_input != stage3_target && verify == 1)
                                                    begin
                                                        result <= 2'b10;
                                                        level_stage <= stage_fail;
                                                    end
                                                else
                                                    begin
                                                        result <= 2'b00;
                                                        level_stage <= stage3;
                                                    end
                                            end
                                        // Left
                                        else if (stage3reg == 4'h7)
                                            begin
                                                case (stage_counter)
                                                    2'b00: begin
                                                                stage3_target <= seq_key[11:8];
                                                           end
                                                    2'b01: begin
                                                                stage3_target <= seq_key[7:4];
                                                           end
                                                    2'b10: begin
                                                                stage3_target <= seq_key[3:0];
                                                           end
                                                    2'b11: begin
                                                                stage3_target <= seq_key[15:12];
                                                           end
                                                endcase
                                                if (seq_input == stage3_target && verify == 1)
                                                    begin
                                                        if (stage_counter < 3)
                                                            begin
                                                                level_stage <= stage3;
                                                                stage_counter <= stage_counter + 1;
                                                                result <= 2'b00;
                                                            end
                                                        else
                                                            begin
                                                                level_stage <= level_success;
                                                                result <= 2'b01;
                                                                stage_counter <= 0;
                                                            end
                                                    end
                                                else if (seq_input != stage3_target && verify == 1)
                                                    begin
                                                        result <= 2'b10;
                                                        level_stage <= stage_fail;
                                                    end
                                                else
                                                    begin
                                                        result <= 2'b00;
                                                        level_stage <= stage3;
                                                    end
                                            end
                                end

                        // Level Success
                        level_success: begin
                                            // Game success sequence end
                                            if (game_state == 8'h20)
                                                begin
                                                    level_stage <= stage1;
                                                    result <= 2'b01;
                                                end
                                            else
                                                begin
                                                    level_stage <= stage1;
                                                    result <= 2'b01;
                                                end
                                       end

                        // Failed Stage
                        stage_fail: begin
                                        result <= 2'b10;
                                        level_stage <= stage0;
                                    end
                    endcase
                end
        end
endmodule
