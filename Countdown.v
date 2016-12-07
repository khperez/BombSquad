module Countdown(init_time, switch_op, sec_timer, reset, clk, value_three, value_two, value_one);

	input [7:0] switch_op;
	input sec_timer;
	input[11:0] init_time;

	output[3:0] value_three, value_two, value_one;
	reg[3:0] value_three, value_two, value_one;

	input reset, clk;

	parameter init = 0, countdown = 1;

	reg state;

	always@(posedge clk)
	begin
		if (reset == 0) begin state <= init; value_one = 9; value_two = 9; value_three = 9; end
		else
		begin
			case(state)
			init:
			begin
			if (switch_op == 8'h10) begin state <= countdown; value_one = 0; value_two = 0; value_three = 3; end
			else begin state <= init; value_one = 9; value_two = 9; value_three = 9; end
			end
			countdown:
			begin
				if (sec_timer == 1 && switch_op == 8'h10)
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
				else if (switch_op == 8'h20 || switch_op == 8'h30)
					begin
						state <= init;
					end
				else state <= countdown;
			end
			endcase
		end
	end
endmodule
