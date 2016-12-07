module RAMController(user_id, success, clk, reset, address_out, data_in, data_out, r_w);
	
	input[3:0] user_id;
	input success, clk, reset;
	input[7:0] data_in;
	
	output[7:0] address_out, data_out;
	reg[7:0] address_out, data_out;
	
	output r_w;
	reg r_w;
		
	parameter init = 0, inc = 1, monitor = 2, level_up = 3;
	
	reg[1:0] state;
	
	reg[1:0] location;
	reg[7:0] load;
	
	always@(posedge clk)
	begin
		if (reset == 0)
		begin
			state <= init;
			location <= 0;
		end
		else
		begin
			case(state)
				init: begin
					data_out <= 0;
					address_out <= location;
					r_w <= 1;
					state <= inc;
				end
				inc: begin
					if (location == 4)
					begin
						state <= monitor;
						r_w <= 0;
					end
					else
					begin
						location <= location + 1;
						state <= init;
					end
				end
				monitor: begin
					case(user_id)
						4'b1100: begin
							if (success == /*VALUE*/) //Corrct?
							begin
								address_out <= 0;
								location <= 0;
								r_w = 0;
								load <= data_in;
								state <= level_up;
							end
							else
								state <= monitor;
						end
						4'b1100: begin
							if (success == /*VALUE*/)
							begin
								address_out <= 1;
								location <= 1;
								r_w = 0;
								load <= data_in;
								state <= level_up;
							end
							else
								state <= monitor;
						end
						4'b1100: begin
							if (success == /*VALUE*/)
							begin
								address_out <= 2;
								location <= 2;
								r_w = 0;
								load <= data_in;
								state <= level_up;
							end
							else
								state <= monitor;
						end
						4'b1100: begin
							if (success == /*VALUE*/)
							begin
								address_out <= 3;
								location <= 3;
								r_w = 0;
								load <= data_in;
								state <= level_up;
							end
							else
								state <= monitor;
						end
					endcase
				end
				level_up: begin
					data_out <= load + 1;
					address_out <= location;
					r_w <= 1;
					state <= monitor;
				end
			endcase
		end
	end

endmodule