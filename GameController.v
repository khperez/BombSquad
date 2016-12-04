// Game Controller Module
// Author: Katherine Perez
// Course: ECE 5440 - Advanced Digital Design

/*
    Game Controller Module
    Description: The brain of the entire game.
    Inputs:
    + s_auth
    + s_time
    + cur_time
    + s_results
    + clk
    + rst
    
    Outputs:
    + s_current : current game state

*/

module GameController(s_auth, s_time, cur_time, s_results, clk, rst, s_current);
    input [1:0] s_auth, s_time, s_results;
    input clk, rst;
    input [X:X] cur_time;

    /*
        s_current: current game state
            0x1: user authentication
            0x2:
    */
    output reg [6:0] s_current;

    always @(posedge clk)
        begin
            // Authentication Stage 1: Awaiting user to input credentials
            if (s_auth == 2'b00)
                begin
                    s_current <= 7'h1;
                end
            // Authentication Stage 2: User has entered correct credentials
            else if (s_auth == 2'b01)
                begin
                    s_current <= 7'h2;
                end
            // Authentication Stage 3: User has entered incorrect credentials
            else if (s_auth == 2'b10)
                begin
                    s_current <= 7'h3;
                end
        end
endmodule
