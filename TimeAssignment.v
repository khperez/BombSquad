/*
	TimeAssignment.v
	Description:
	This module will receive the current level of the user and define the time allotted for the user to complete the level.  
	
	Inputs
		game_level:			The current level of the user.
		
	Outputs
		value_one:			Contains the time for the first digit. Right most digit.
		value_two:			Contains the time for the second digit. Middle digit.
		value_three:		Contains the time for the third digit. Left most digit.
*/

module TimeAssignment(game_level, value_three, value_two, value_one);
		
		input[7:0] game_level;
		
		output[3:0] value_three, value_two, value_one;
		reg[3:0] value_three, value_two, value_one;
		
		always@(game_level)
		begin
			case(game_level)
				8'b00000000:begin
					value_three = 4'd2;
					value_two = 4'd0;
					value_one = 4'd0;
				end
				8'b00000001:begin
					value_three = 4'd1;
					value_two = 4'd0;
					value_one = 4'd0;
				end
				8'b00000010:begin
					value_three = 4'd0;
					value_two = 4'd6;
					value_one = 4'd0;
				end
				8'b00000011:begin
					value_three = 4'd0;
					value_two = 4'd5;
					value_one = 4'd5;
				end
				8'b00000100:begin
					value_three = 4'd0;
					value_two = 4'd5;
					value_one = 4'd0;
				end
				8'b00000101:begin
					value_three = 4'd0;
					value_two = 4'd4;
					value_one = 4'd5;
				end
				8'b00000110:begin
					value_three = 4'd0;
					value_two = 4'd3;
					value_one = 4'd5;
				end
				8'b00000111:begin
					value_three = 4'd0;
					value_two = 4'd3;
					value_one = 4'd0;
				end
				8'b00001000:begin
					value_three = 4'd0;
					value_two = 4'd2;
					value_one = 4'd5;
				end
				8'b00001001:begin
					value_three = 4'd0;
					value_two = 4'd2;
					value_one = 4'd0;
				end
				8'b00001010:begin
					value_three = 4'd0;
					value_two = 4'd1;
					value_one = 4'd5;
				end
				default:begin
					value_three = 4'd0;
					value_two = 4'd1;
					value_one = 4'd0;
				end
			endcase
		end
endmodule
