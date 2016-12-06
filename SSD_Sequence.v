module SSD_Sequence(Sequence_in, display, OneSec, ButtonMove, ButtonNext, clk, reset, Sequence_out, SevSeg1, SevSeg2, SevSeg3, SevSeg4);

	input[15:0] Sequence_in;
	input display, OneSec, ButtonMove, ButtonNext;

	output[7:0] SevSeg1, SevSeg2, SevSeg3, SevSeg4;
	reg[7:0] SevSeg1, SevSeg2, SevSeg3, SevSeg4;

	output reg [3:0] Sequence_out;

	input clk, reset;

	parameter init = 0, show2Sec = 1, initialStart = 2, firstSeg = 3, secondSeg = 4, thirdSeg = 5, fourthSeg = 6;

	reg[2:0] state;
	
	reg[1:0] visabity; 

	always@(posedge clk)
	begin
		if (reset == 0)
		begin
			SevSeg1 <= 7'b1111111;
			SevSeg2 <= 7'b1111111;
			SevSeg3 <= 7'b1111111;
			SevSeg4 <= 7'b1111111;
			visabity <= 0;
			state <= init;
		end
		else
		begin
			case(state)
				init:
				begin
					SevSeg1 <= 7'b1111111;
					SevSeg2 <= 7'b1111111;
					SevSeg3 <= 7'b1111111;
					SevSeg4 <= 7'b1111111;
					visabity <= 0;
					if (display == 1)
						state <= show2Sec;
					else 
						state <= init;
				end
				show2Sec:
				begin
				
					if (visabity == 2)
						state <= initialStart;
					else if (OneSec == 1)
						visabity <= visabity + 1;
						
					case(Sequence_in[3:0])
					4'b1110 : begin SevSeg1 <= 7'b1111110; end
					4'b1101 : begin SevSeg1 <= 7'b1111001; end
					4'b1011 : begin SevSeg1 <= 7'b1110111; end
					4'b0111 : begin SevSeg1 <= 7'b1001111; end
					default : begin SevSeg1 <= 7'b0100001; end
					endcase

					case(Sequence_in[7:4])
					4'b1110 : begin SevSeg2 <= 7'b1111110; end
					4'b1101 : begin SevSeg2 <= 7'b1111001; end
					4'b1011 : begin SevSeg2 <= 7'b1110111; end
					4'b0111 : begin SevSeg2 <= 7'b1001111; end
					default : begin SevSeg2 <= 7'b0100001; end
					endcase

					case(Sequence_in[11:8])
					4'b1110 : begin SevSeg3 <= 7'b1111110; end
					4'b1101 : begin SevSeg3 <= 7'b1111001; end
					4'b1011 : begin SevSeg3 <= 7'b1110111; end
					4'b0111 : begin SevSeg3 <= 7'b1001111; end
					default : begin SevSeg3 <= 7'b0100001; end
					endcase

					case(Sequence_in[15:12])
					4'b1110 : begin SevSeg4 <= 7'b1111110; end
					4'b1101 : begin SevSeg4 <= 7'b1111001; end
					4'b1011 : begin SevSeg4 <= 7'b1110111; end
					4'b0111 : begin SevSeg4 <= 7'b1001111; end
					default : begin SevSeg4 <= 7'b0100001; end
					endcase
				end
				initialStart:
				begin
					SevSeg1 <= 7'b1111110;
					SevSeg2 <= 7'b1111110;
					SevSeg3 <= 7'b1111110;
					SevSeg4 <= 7'b1111110;
					Sequence_out <= 4'b1110;
					visabity <= 0;
					state <= firstSeg;
				end
				firstSeg:
				begin
					if (ButtonNext == 1)
						state <= secondSeg;
					else if (ButtonMove == 1)
					begin
						case(SevSeg1)
							7'b1111110 : begin SevSeg1 = 7'b1111001; Sequence_out = 4'b1101; end
							7'b1111001 : begin SevSeg1 = 7'b1110111; Sequence_out = 4'b1011; end
							7'b1110111 : begin SevSeg1 = 7'b1001111; Sequence_out = 4'b0111; end
							7'b1001111 : begin SevSeg1 = 7'b1111110; Sequence_out = 4'b1110; end
							default : begin SevSeg1 = 7'b0100001; end
						endcase
						state <= firstSeg;
					end
					else
						state <= firstSeg;
				end
				secondSeg:
				begin
					if (ButtonNext == 1)
						state <= thirdSeg;
					else if (ButtonMove == 1)
					begin
						case(SevSeg2)
							7'b1111110 : begin SevSeg1 = 7'b1111001; Sequence_out = 4'b1101; end
							7'b1111001 : begin SevSeg1 = 7'b1110111; Sequence_out = 4'b1011; end
							7'b1110111 : begin SevSeg1 = 7'b1001111; Sequence_out = 4'b0111; end
							7'b1001111 : begin SevSeg1 = 7'b1111110; Sequence_out = 4'b1110; end
							default : begin SevSeg2 = 7'b0100001; end
						endcase
						state <= secondSeg;
					end
					else
						state <= secondSeg;
				end
				thirdSeg:
				begin
					if (ButtonNext == 1)
						state <= fourthSeg;
					else if (ButtonMove == 1)
					begin
						case(SevSeg3)
							7'b1111110 : begin SevSeg1 = 7'b1111001; Sequence_out = 4'b1101; end
							7'b1111001 : begin SevSeg1 = 7'b1110111; Sequence_out = 4'b1011; end
							7'b1110111 : begin SevSeg1 = 7'b1001111; Sequence_out = 4'b0111; end
							7'b1001111 : begin SevSeg1 = 7'b1111110; Sequence_out = 4'b1110; end
							default : begin SevSeg3 = 7'b0100001; end
						endcase
						state <= thirdSeg;
					end
					else
						state <= thirdSeg;
				end
				fourthSeg:
				begin
					if (ButtonNext == 1)
						state <= init;
					else if (ButtonMove == 1)
					begin
						case(SevSeg1)
							7'b1111110 : begin SevSeg1 = 7'b1111001; Sequence_out = 4'b1101; end
							7'b1111001 : begin SevSeg1 = 7'b1110111; Sequence_out = 4'b1011; end
							7'b1110111 : begin SevSeg1 = 7'b1001111; Sequence_out = 4'b0111; end
							7'b1001111 : begin SevSeg1 = 7'b1111110; Sequence_out = 4'b1110; end
							default : begin SevSeg1 = 7'b0100001; end
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
