// Sequence Key Decoder
// Author: Katherine Perez
// Course: ECE 5440 - Advanced Digital Design

/*
    Sequence Key Decoder
    Description: Generates the puzzle pattern to be displayed on the seven
                 seven-segment display.
    Inputs:
    + game_state
    + level_state
    + enable
    + lfsr_data
    + clk
    + rst

    Outputs:
    + sequence_key
*/

module SequenceKeyBuilder(game_state, level_state, lfsr_data, enable, clk, rst, sequence_key, transmit);

    input [6:0] game_state;
    input [1:0] level_state;
    input [7:0] lfsr_data;
    input enable, clk, rst;

    output reg [15:0] sequence_key = 0;
    output reg transmit;

    reg [3:0] cell1 = 0, cell2 = 0, cell3 = 0, cell4 = 0;
    reg [3:0] state;

    parameter s1 = 3'b001, s2 = 3'b010, s3 = 3'b011, s4 = 3'b100,
              seq_complete = 3'b101;

    always @(posedge clk)
        begin
            if (rst == 0)
                begin
                    state <= s1;
                    sequence_key <= 0;
                    cell1 <= 0;
                    cell2 <= 0;
                    cell3 <= 0;
                    cell4 <= 0;
                    transmit <= 0;
                    lfsr_data <= 0;
                end
            // TODO
            else
                begin
                    case (state)
                        // Fill cell 1
                        s1: begin
                                transmit <= 0;
                                if ((lfsr_data % 4) == 0)
                                    begin
                                        cell1 <= 4'b1110;
                                        state <= s2;
                                    end
                                else if ((lfsr_data % 4) == 1)
                                    begin
                                        cell1 <= 4'b1101;
                                        state <= s2;
                                    end
                                else if ((lfsr_data % 4) == 2)
                                    begin
                                        cell1 <= 4'b1011;
                                        state <= s2;
                                    end
                                else if ((lfsr_data % 4) == 3)
                                    begin
                                        cell1 <= 4'b0111;
                                        state <= s2;
                                    end
                                else
                                    begin
                                        state <= s1;
                                    end
                            end
                        // Fill cell 2
                        s2: begin
                                transmit <= 0;
                                if ((lfsr_data % 4) == 0)
                                    begin
                                        cell2 <= 4'b1110;
                                        state <= s3;
                                    end
                                else if ((lfsr_data % 4) == 1)
                                    begin
                                        cell2 <= 4'b1101;
                                        state <= s3;
                                    end
                                else if ((lfsr_data % 4) == 2)
                                    begin
                                        cell2 <= 4'b1011;
                                        state <= s3;
                                    end
                                else if ((lfsr_data % 4) == 3)
                                    begin
                                        cell2 <= 4'b0111;
                                        state <= s3;
                                    end
                                else
                                    begin
                                        state <= s2;
                                    end
                            end
                        s3: begin
                                transmit <= 0;
                                if ((lfsr_data % 4) == 0)
                                    begin
                                        cell3 <= 4'b1110;
                                        state <= s4;
                                    end
                                else if ((lfsr_data % 4) == 1)
                                    begin
                                        cell3 <= 4'b1101;
                                        state <= s4;
                                    end
                                else if ((lfsr_data % 4) == 2)
                                    begin
                                        cell3 <= 4'b1011;
                                        state <= s4;
                                    end
                                else if ((lfsr_data % 4) == 3)
                                    begin
                                        cell3 <= 4'b0111;
                                        state <= s4;
                                    end
                                else
                                    begin
                                        state <= s3;
                                    end
                            end
                        s4: begin
                                transmit <= 0;
                                if ((lfsr_data % 4) == 0)
                                    begin
                                        cell4 <= 4'b1110;
                                        state <= seq_complete;
                                    end
                                else if ((lfsr_data % 4) == 1)
                                    begin
                                        cell4 <= 4'b1101;
                                        state <= seq_complete;
                                    end
                                else if ((lfsr_data % 4) == 2)
                                    begin
                                        cell4 <= 4'b1011;
                                        state <= seq_complete;
                                    end
                                else if ((lfsr_data % 4) == 3)
                                    begin
                                        cell4 <= 4'b0111;
                                        state <= seq_complete;
                                    end
                                else
                                    begin
                                        state <= s4;
                                    end
                            end
                        seq_complete: begin
                                            sequence_key[15:12] <= cell1;
                                            sequence_key[11:8] <= cell2;
                                            sequence_key[7:4] <= cell3;
                                            sequence_key[3:0] <= cell4;
                                            state <= s1;
                                            transmit <= 1;
                                      end
                end
        end
endmodule
