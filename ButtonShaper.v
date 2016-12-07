// Button Shaper Module
// Author: Katherine Perez
// Course: ECE 5440 - Advanced Digital Design

module ButtonShaper(B_in, B_out, Clk, Rst);

    input B_in;
    output B_out;
    reg B_out;
    input Clk, Rst;

    parameter S_Off = 0, S_On = 1,
              S_Off2 = 2;

    reg [1:0] State;

    always @(posedge Clk)
        begin
            if (Rst == 0)
                State <= S_Off;
            else
                begin
                    case (State)
                        S_Off:  begin
                                    B_out <= 0;
                                    if (B_in == 0)
                                        State <= S_On;
                                    else
                                        State <= S_Off;
                                end
                        S_On:  begin
                                    B_out <= 1;
                                    if (B_in == 0)
                                        State <= S_Off2;
                                    else
                                        State <= S_Off;
                                end
                        S_Off2: begin
                                    B_out <= 0;
                                    if (B_in == 0)
                                        State <= S_Off2;
                                    else
                                        State <= S_Off;
                                 end
                        default: begin
                                    B_out <= 0;
                                    State <= S_Off;
                                 end
                    endcase
                end
        end
endmodule
