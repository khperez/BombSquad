/*
	RAMController.v
	Description:
	Will be used to store a high score for the user which will be used to determine the starting time they will receive per level.
	After the game has completed, the final score will be displayed.  
	
	Inputs
		user_id:			The ID of the user that is currently playing the game.
		game_state:			Provided game state from the controller.
		data_in:			The data read in from the RAM. when the r_w signal is low.
		clk: 				On-board 50 Mhz clock
		reset:				active low push button
		
	Outputs
		r_w:				The signal which controlles the write/read operation of the RAM. 0 = read and 1 = write.
		address_out:		The address that will be read from or written to.
		data_out:			The data that will be written to the RAM while the r_w signal is high.
		cur_level:			The output of the read operation preformed on the RAM.
*/


module RAMController(user_id, game_state, clk, reset, data_in, r_w, address_out, data_out, cur_level);
	
	input[3:0] user_id;
	input[7:0] data_in, game_state;
	input clk, reset;
	
	output[7:0] address_out, cur_level, data_out;
	reg[7:0] address_out, cur_level, data_out;
	
	output r_w;
	reg r_w;
		
	parameter init = 0, inc = 1, write_to = 2, read_from = 3;
	
	reg[1:0] state;
	reg[2:0] location;
	
	always@(posedge clk)
	begin
		if (reset == 0)
		begin
			state <= init;
			location <= 0;
			cur_level <= 0;
		end
		else
		begin
			case(state)
				init: begin
					data_out = 0;
					address_out <= location;
					r_w <= 1;
					state <= inc;
				end
				inc: begin
					if (location === 3'b100)
					begin
						state <= write_to;
						r_w <= 0;
					end
					else
					begin
						location <= location + 1;
						state <= init;
					end
				end
				write_to: begin
					case(user_id)
						4'b1100: begin
							if (game_state == 8'h20) 
							begin
								address_out <= 0;
								r_w = 1;
								data_out = cur_level <= cur_level + 1;
							end
						end
						4'b0011: begin
							if (game_state == 8'h20)
							begin
								address_out <= 1;
								r_w = 1;
								data_out = cur_level <= cur_level + 1;
							end
						end
						4'b1101: begin
							if (game_state == 8'h20)
							begin
								address_out <= 2;
								r_w = 1;
								data_out = cur_level <= cur_level + 1;
							end
						end
						4'b0100: begin
							if (game_state == 8'h20)
							begin
								address_out <= 3;
								r_w = 1;
								data_out = cur_level <= cur_level + 1;
							end
						end
					endcase

					if (game_state == 8'h30)
						state <= read_from;
					else
						state <= write_to;

				end
				read_from:
				begin
					case(user_id)
						4'b1100: begin
							address_out <= 0;
							r_w = 0;
							cur_level <= data_in;
						end
						4'b0011: begin
							address_out <= 1;
							r_w = 0;
							cur_level <= data_in;
						end
						4'b1101: begin
							address_out <= 2;
							r_w = 0;
							cur_level <= data_in;
						end
						4'b0100: begin
							address_out <= 3;
							r_w = 0;
							cur_level <= data_in;
						end
					endcase
				end
			endcase
		end
	end
endmodule