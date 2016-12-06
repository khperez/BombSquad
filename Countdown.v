module Countdown(init_time, SwitchOp, SecTimer, reset, clk, value_three, value_two, value_one);

	input SwitchOp, SecTimer;
	input[11:0] init_time;
	
	output[3:0] value_three, value_two, value_one;
	reg[3:0] value_three, value_two, value_one;
	
	input reset, clk;
	
	parameter init = 0, countdown = 1;
	
	reg state;
	
	always@(posedge clk)
	begin
		if (reset == 0) begin state <= init; value_one = init_time[3:0]; value_two = init_time[7:4]; value_three = init_time[11:8]; end
		else
		begin
			case(state)
			init:
			begin 
			if (SwitchOp == 1) begin state <= countdown; value_one = init_time[3:0]; value_two = init_time[7:4]; value_three = init_time[11:8]; end
			else begin state <= init; value_one = 0; value_two = 0; value_three = 0; end
			end
			countdown:
			begin
				if (SwitchOp == 1) state <= init; //ADD correct state
				else if (SecTimer == 1)
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
				else state <= countdown;
			end
			endcase
		end
	end
endmodule