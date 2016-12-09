/*
	Countdown.v
	Description:
	Contains a predetermined starting value in seconds across three 4-bit internal
	registers which decrements each time a pulse is send from the OneSecTimer module. 
	
	Inputs
		init_time:			Initial time for the countdown sequence. [[4-bit third digit] [4-bit second digit] [4-bit first digit]]
		game_state:			Provided game state from the controller. 
		sec_timer:			A pulse indicating ne second has elapsed.
		clk: 				On-board 50 Mhz clock
		reset:				active low push button
		
	Outputs
		value_one:			Contains the first digit. Right most digit.
		value_two:			Contains the second digit. Middle digit.
		value_three:		Contains the third digit. Left most digit.

*/

module Countdown(init_time, game_state, sec_timer, reset, clk, value_three, value_two, value_one);

	input [7:0] game_state;
	input sec_timer;
	input[11:0] init_time;

	output[3:0] value_three, value_two, value_one;
	reg[3:0] value_three, value_two, value_one;

	input reset, clk;

	parameter init = 0, countdown = 1;

	reg state;

	always@(posedge clk)
	begin
		if (reset == 0) begin state <= init; value_one = 0; value_two = 0; value_three = 2; end
		else
		begin
			case(state)
			init:
			begin
			if (game_state == 8'h10) begin state <= countdown; value_one = 0; value_two = 0; value_three = 2; end
			else begin state <= init; value_one = 0; value_two = 0; value_three = 2; end
			end
			countdown:
			begin
				if (sec_timer == 1 && game_state == 8'h10)
					begin
						if (value_one != 0) value_one <= value_one - 1;
						else if (value_one == 0 && (value_two != 0 || value_three!= 0))
						begin
							if (value_two == 0) begin value_three <= value_three - 1; value_two <= 4'b1001; value_one <= 4'b1001; end
							else if (value_three == 0) begin value_two <= value_two - 1; value_one <= 4'b1001; end
							else begin value_two <= value_two - 1; value_one <= 4'b1001; end
						end
						else if (value_one == 0 && value_two == 0 && value_three== 0) state <= init;
					end
				else if (game_state == 8'h20 || game_state == 8'h30)
					begin
						state <= init;
					end
				else state <= countdown;
			end
			endcase
		end
	end
endmodule
