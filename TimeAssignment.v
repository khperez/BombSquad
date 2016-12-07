module TimeAssignment(game_level, value_three, value_two, value_one);
		
		input[7:0] game_level;
		
		output[3:0] value_three, value_two, value_one;
		reg[3:0] value_three, value_two, value_one;
		
		always@(game_level)
		begin
			case(game_level)
				8'b00000000:begin
					value_three = 4'b0011;
					value_two = 4'b0000;
					value_one = 4'b0000;
				end
				8'b00000001:begin
					value_three = 4'b0010;
					value_two = 4'b1000;
					value_one = 4'b0000;
				end
				8'b00000010:begin
					value_three = 4'b0011;
					value_two = 4'b0110;
					value_one = 4'b0000;
				end
				8'b00000011:begin
					value_three = 4'b0010;
					value_two = 4'b0100;
					value_one = 4'b0000;
				end
				8'b00000100:begin
					value_three = 4'b0010;
					value_two = 4'b0010;
					value_one = 4'b0000;
				end
				8'b00000101:begin
					value_three = 4'b0010;
					value_two = 4'b0000;
					value_one = 4'b0000;
				end
				8'b00000110:begin
					value_three = 4'b0001;
					value_two = 4'b0111;
					value_one = 4'b1001;
				end
				8'b00000111:begin
					value_three = 4'b0001;
					value_two = 4'b1001;
					value_one = 4'b0000;
				end
				8'b00001000:begin
					value_three = 4'b0001;
					value_two = 4'b0010;
					value_one = 4'b1001;
				end
				8'b00001001:begin
					value_three = 4'b0001;
					value_two = 4'b0000;
					value_one = 4'b0000;
				end
				8'b00001010:begin
					value_three = 4'b0000;
					value_two = 4'b0111;
					value_one = 4'b1001;
				end
			endcase
		end
endmodule
