module Countdown(StartCount, SecTimer, reset, clk, value_three, value_two, value_one);

	input StartCount, SecTimer;
	
	output[3:0] value_three, value_two, value_one;
	reg[3:0] value_three, value_two, value_one;
	
	input reset, clk;
	
	parameter init = 0, countdown = 1;
	
	reg state;
	
	always@(posedge clk)
	begin
		if (reset == 0)
		begin
			state <= init;
			value_one = ;
			value_two = ;
			value_three = ;
			timeout = 0;
		end
		else
		begin
		if (run == 1)
		begin
			case(state)
			init:
			begin
				if (StartCount == 1)
					state <= countdown;
				else
					state <= init;
			end
			countdown:
			begin
				if (SecTimer == 1)
				begin
					if (value_one != 0)
						value_one <= value_one - 1;
					else if (value_one == 0 && (value_two != 0 || value_three!= 0))
					begin
						if (value_two == 0)
						begin
							value_three <= value_three - 1;
							value_two <= 4'b1001;
							value_one <= 4'b1001;
						end
						else if (value_three == 0)
						begin
							value_two <= value_two - 1;
							value_one <= 4'b1001;
						end
						else
						begin
							value_two <= value_two - 1;
							value_one <= 4'b1001;
						end
					end
					else if (value_one == 0 && value_two == 0 && value_three== 0)
					begin
						//DONE
					end
				end
				else
					state <= init;
			end
			endcase
		end
	end
endmodule