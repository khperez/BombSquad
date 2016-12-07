module SSD_Sequence(sequence_in, display, one_sec, button_move, button_next, clk, reset, sequence_out, sevseg_1, sevseg_2, sevseg_3, sevseg_4);

	input[15:0] sequence_in;
	input one_sec, button_move, button_next;
	input [7:0] display;

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
					if (display == 8'h10)
						state <= show2Sec;
					else
						state <= init;
				end
				show2Sec:
				begin

					if (visabity == 2)
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
						case(sevseg_1)
							7'b1111110 : begin sevseg_1 = 7'b1111001; sequence_out = 4'b1101; end
							7'b1111001 : begin sevseg_1 = 7'b1110111; sequence_out = 4'b1011; end
							7'b1110111 : begin sevseg_1 = 7'b1001111; sequence_out = 4'b0111; end
							7'b1001111 : begin sevseg_1 = 7'b1111110; sequence_out = 4'b1110; end
							default : begin sevseg_1 = 7'b0100001; end
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
						case(sevseg_2)
							7'b1111110 : begin sevseg_1 = 7'b1111001; sequence_out = 4'b1101; end
							7'b1111001 : begin sevseg_1 = 7'b1110111; sequence_out = 4'b1011; end
							7'b1110111 : begin sevseg_1 = 7'b1001111; sequence_out = 4'b0111; end
							7'b1001111 : begin sevseg_1 = 7'b1111110; sequence_out = 4'b1110; end
							default : begin sevseg_2 = 7'b0100001; end
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
						case(sevseg_3)
							7'b1111110 : begin sevseg_1 = 7'b1111001; sequence_out = 4'b1101; end
							7'b1111001 : begin sevseg_1 = 7'b1110111; sequence_out = 4'b1011; end
							7'b1110111 : begin sevseg_1 = 7'b1001111; sequence_out = 4'b0111; end
							7'b1001111 : begin sevseg_1 = 7'b1111110; sequence_out = 4'b1110; end
							default : begin sevseg_3 = 7'b0100001; end
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
