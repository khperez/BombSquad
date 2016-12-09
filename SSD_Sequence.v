/*
	SSD_Sequence.v
	Description:
	Will map the sequence provided by the controller to the correct encoded sequence and game started to the user for 3 seconds.
	After the encoded sequence is game started, the module will then enter a FSM to manipulate the seven segment game state in order
	for the user to input their response.  
	
	Inputs
		sequence_in:		Value used to generate the encoded sequence.
		game_state:			Provided game state from the controller.
		one_sec:			Pulse indicating ne second has elapsed.
		button_move:		Push button used to rotate the user input displayed on the seven segment display.
		button_next:		Push button used to validate the response entered from the user as well to move to the next seven segment if applicable.
		clk: 				On-board 50 Mhz clock
		reset:				active low push button
		
	Outputs
		sequence_out:		Contains the submitted information from the user.
		sevseg_1:			Contains the first digit. Right most digit.
		sevseg_2:			Contains the second digit. Second from the right digit.
		sevseg_3:			Contains the third digit. Second from the left digit.
		sevseg_4:			Contains the fourth digit. Left most digit.
		
*/


module SSD_Sequence(sequence_in, game_state, one_sec, button_move, button_next, clk, reset, sequence_out, sevseg_1, sevseg_2, sevseg_3, sevseg_4);

	input[15:0] sequence_in;
	input one_sec, button_move, button_next;
	input [7:0] game_state;

	output[6:0] sevseg_1, sevseg_2, sevseg_3, sevseg_4;
	reg[6:0] sevseg_1, sevseg_2, sevseg_3, sevseg_4;

	output reg [3:0] sequence_out;

	input clk, reset;

	parameter init = 0, show2Sec = 1, initialStart = 2, firstSeg = 3, secondSeg = 4, thirdSeg = 5, fourthSeg = 6;

	reg[2:0] state;

	reg[1:0] visabity;

	always@(posedge clk)
	begin
		if (reset == 0)
		begin
			sevseg_1 <= 7'b1111111;
			sevseg_2 <= 7'b1111111;
			sevseg_3 <= 7'b1111111;
			sevseg_4 <= 7'b1111111;
			visabity <= 0;
			state <= init;
		end
		else
		begin
			case(state)
				init:
				begin
					sevseg_1 <= 7'b1111111;
					sevseg_2 <= 7'b1111111;
					sevseg_3 <= 7'b1111111;
					sevseg_4 <= 7'b1111111;
					visabity <= 0;
					if (game_state == 8'h10)
						state <= show2Sec;
					else
						state <= init;
				end
				show2Sec:
				begin

					if (visabity == 3)
						state <= initialStart;
					else if (one_sec == 1)
						visabity <= visabity + 1;

					case(sequence_in[3:0])
					4'b1110 : begin sevseg_1 <= 7'b1111110; end
					4'b1101 : begin sevseg_1 <= 7'b1111001; end
					4'b1011 : begin sevseg_1 <= 7'b1110111; end
					4'b0111 : begin sevseg_1 <= 7'b1001111; end
					default : begin sevseg_1 <= 7'b0100001; end
					endcase

					case(sequence_in[7:4])
					4'b1110 : begin sevseg_2 <= 7'b1111110; end
					4'b1101 : begin sevseg_2 <= 7'b1111001; end
					4'b1011 : begin sevseg_2 <= 7'b1110111; end
					4'b0111 : begin sevseg_2 <= 7'b1001111; end
					default : begin sevseg_2 <= 7'b0100001; end
					endcase

					case(sequence_in[11:8])
					4'b1110 : begin sevseg_3 <= 7'b1111110; end
					4'b1101 : begin sevseg_3 <= 7'b1111001; end
					4'b1011 : begin sevseg_3 <= 7'b1110111; end
					4'b0111 : begin sevseg_3 <= 7'b1001111; end
					default : begin sevseg_3 <= 7'b0100001; end
					endcase

					case(sequence_in[15:12])
					4'b1110 : begin sevseg_4 <= 7'b1111110; end
					4'b1101 : begin sevseg_4 <= 7'b1111001; end
					4'b1011 : begin sevseg_4 <= 7'b1110111; end
					4'b0111 : begin sevseg_4 <= 7'b1001111; end
					default : begin sevseg_4 <= 7'b0100001; end
					endcase
				end
				initialStart:
				begin
					sevseg_1 <= 7'b1111110;
					sevseg_2 <= 7'b1111110;
					sevseg_3 <= 7'b1111110;
					sevseg_4 <= 7'b1111110;
					sequence_out <= 4'b1110;
					visabity <= 0;
					state <= firstSeg;
				end
				firstSeg:
				begin
					if (button_next == 1)
						state <= secondSeg;
					else if (button_move == 1)
					begin
						case(sevseg_4)
							7'b1111110 : begin sevseg_4 = 7'b1111001; sequence_out = 4'b1101; end
							7'b1111001 : begin sevseg_4 = 7'b1110111; sequence_out = 4'b1011; end
							7'b1110111 : begin sevseg_4 = 7'b1001111; sequence_out = 4'b0111; end
							7'b1001111 : begin sevseg_4 = 7'b1111110; sequence_out = 4'b1110; end
							default : begin sevseg_4 = 7'b0100001; end
						endcase
						state <= firstSeg;
					end
					else
						state <= firstSeg;
				end
				secondSeg:
				begin
					if (button_next == 1)
						state <= thirdSeg;
					else if (button_move == 1)
					begin
						case(sevseg_3)
							7'b1111110 : begin sevseg_3 = 7'b1111001; sequence_out = 4'b1101; end
							7'b1111001 : begin sevseg_3 = 7'b1110111; sequence_out = 4'b1011; end
							7'b1110111 : begin sevseg_3 = 7'b1001111; sequence_out = 4'b0111; end
							7'b1001111 : begin sevseg_3 = 7'b1111110; sequence_out = 4'b1110; end
							default : begin sevseg_3 = 7'b0100001; end
						endcase
						state <= secondSeg;
					end
					else
						state <= secondSeg;
				end
				thirdSeg:
				begin
					if (button_next == 1)
						state <= fourthSeg;
					else if (button_move == 1)
					begin
						case(sevseg_2)
							7'b1111110 : begin sevseg_2 = 7'b1111001; sequence_out = 4'b1101; end
							7'b1111001 : begin sevseg_2 = 7'b1110111; sequence_out = 4'b1011; end
							7'b1110111 : begin sevseg_2 = 7'b1001111; sequence_out = 4'b0111; end
							7'b1001111 : begin sevseg_2 = 7'b1111110; sequence_out = 4'b1110; end
							default : begin sevseg_2 = 7'b0100001; end
						endcase
						state <= thirdSeg;
					end
					else
						state <= thirdSeg;
				end
				fourthSeg:
				begin
					if (button_next == 1)
						state <= init;
					else if (button_move == 1)
					begin
						case(sevseg_1)
							7'b1111110 : begin sevseg_1 = 7'b1111001; sequence_out = 4'b1101; end
							7'b1111001 : begin sevseg_1 = 7'b1110111; sequence_out = 4'b1011; end
							7'b1110111 : begin sevseg_1 = 7'b1001111; sequence_out = 4'b0111; end
							7'b1001111 : begin sevseg_1 = 7'b1111110; sequence_out = 4'b1110; end
							default : begin sevseg_1 = 7'b0100001; end
						endcase
						state <= fourthSeg;
					end
					else
						state <= fourthSeg;
				end
			endcase
		end
	end
endmodule
