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

    */
    output reg [6:0] s_current;

    always @(posedge clk)
        begin
            s_current <= 7'b0000001;
