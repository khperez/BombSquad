// Game Controller Module
// Author: Katherine Perez
// Course: ECE 5440 - Advanced Digital Design

/*
    Game Controller Module
    Description: The brain of the entire game.
    Inputs:
    + s_auth : results from authentication module
    + cur_time: current time output
    + s_results : sequence verifier results
    + clk : clock
    + rst : reset

    Outputs:
    + s_current : current game state
        0x00: authentication
        0x01: authentication success
        0x02: authentication fail
        0x10: game in progress
        0x20: game success sequence begin
        0x21: game success sequence end
        0x30: game over sequence begin
        0x31: game over sequence end
*/

module GameController(s_auth, cur_time, s_results, clk, rst, s_current);
    input [1:0] s_auth, s_results;
    input clk, rst;
    input [11:0] cur_time;

    reg [2:0] game_state;

    parameter authentication = 3'b000, in_game = 3'b001,
              game_success = 3'b010, game_over = 3'b011;

    output reg [7:0] s_current;

    always @(posedge clk)
        begin
            if (rst == 0)
                begin
                    game_state <= authentication;
                    s_current <= 2'b00;
                end
            else
                begin
                    case (game_state)
                    authentication: begin
                                        // Authentication Stage 1: Awaiting user to input credentials
                                        if (s_auth == 2'b00)
                                            begin
                                                s_current <= 8'h00;
                                                game_state <= authentication;
                                            end
                                        // Authentication Stage 2: User has entered correct credentials
                                        else if (s_auth == 2'b01)
                                            begin
                                                s_current <= 8'h01;
                                                game_state <= in_game;
                                            end
                                        // Authentication Stage 3: User has entered incorrect credentials
                                        else if (s_auth == 2'b10)
                                            begin
                                                s_current <= 8'h02;
                                                game_state <= authentication;
                                            end
                                    end
                    in_game: begin
                                if (cur_time == 0)
                                    begin
                                        s_current <= 8'h12;
                                        game_state <= game_over;
                                    end
                                else
                                    begin
                                        if (s_results == 2'b00)
                                            begin
                                                s_current <= 8'h10;
                                                game_state <= in_game;
                                            end
                                        else if (s_results == 2'b01)
                                            begin
                                                s_current <= 8'h20;
                                                game_state <= game_success;
                                            end
                                        else if (s_results == 2'b10)
                                            begin
                                                s_current <= 8'h30;
                                                game_state <= game_over;
                                            end
                                        else if (s_results == 2'b11)
                                            begin
                                                s_current <= 8'h20;
                                                game_state <= in_game;
                                            end
                                    end
                             end
                    game_success: begin
                                        // Game Success Sequence begin
                                        if (s_results == 2'b01)
                                            begin
                                                s_current <= 8'h20;
                                                game_state <= game_success;
                                            end
                                        else if (s_results == 2'b11)
                                            begin
                                                s_current <= 8'h21;
                                                game_state <= s_auth;
                                            end
                                  end
                    game_over: begin
                                    // Game Over Sequence begin
                                    if (s_results == 2'b10)
                                        begin
                                            s_current <= 8'h30;
                                            game_state <= game_over;
                                        end
                                    // Game Over Sequence end
                                    else if (s_results == 2'b11)
                                        begin
                                            s_current <= 8'h31;
                                            game_state <= s_auth;
                                        end
                               end
                    endcase
                end
        end
endmodule
