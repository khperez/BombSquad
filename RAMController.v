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


module RAMController(user_id, game_state, clk, data_in, reset, address_out, r_w, data_out, cur_level);
	
	input[3:0] user_id;
	input[7:0] data_in, game_state;
	input clk, reset;
	
	output[7:0] address_out, cur_level, data_out;
	reg[7:0] address_out, cur_level;
	
	output r_w;
	reg r_w;
		
	parameter init = 0, inc = 1, write_to = 2, read_from = 3;
	
	reg[2:0] state;
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
					//data_out = 0;
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
					if(game_state == 8'h20) begin
						case(user_id)
							4'b1100: begin
								address_out <= 8'b0;
								r_w = 1;
								//state <= read_from;
								cur_level <= cur_level + 1;
							end
							4'b0011: begin
								address_out <= 8'b00000001;
								r_w = 1;
								//state <= read_from;
								cur_level <= cur_level + 1;
							end
							4'b1101: begin
								address_out <= 8'b00000010;
								r_w = 1;
								//state <= read_from;
								cur_level <= cur_level + 1;
							end
							4'b0100: begin
								address_out <= 8'b00000011;
								r_w = 1;
								//state <= read_from;
								cur_level <= cur_level + 1;
							end
						endcase
					end
					else if(game_state == 8'h30) begin
						state <= read_from;
					end
					else begin
						state <=write_to;
					end
				end

				read_from:
				begin
					case(user_id)
						4'b1100: begin
							address_out <= 8'b0;
							r_w = 0;
							cur_level <= data_in;
							state <= read_from;
						end
						4'b0011: begin
							address_out <= 8'b00000001;
							r_w = 0;
							cur_level <= data_in;
							state <= read_from;
						end
						4'b1101: begin
							address_out <= 8'b00000010;
							r_w = 0;
							cur_level <= data_in;
							state <= read_from;
						end
						4'b0100: begin
							address_out <= 8'b00000011;
							r_w = 0;
							cur_level <= data_in;
							state <= read_from;
						end
					endcase
				end
			endcase
		end
	end
assign data_out = cur_level;
endmodule