/*
	LFSR8bit.v
	Description:
	The 16-bit many-to-one LFSR will continuously iterate from which
	samples will be taken to create the game’s sequence which the user will decode.
	
	Inputs
		clk: 				On-board 50 Mhz clock
		reset:				active low push button
		
	Outputs
		output_sequence:	Output will cycle between 255 different unique states. 

*/

module LFSR8bit(reset, clk, output_sequence);

	output [7:0] output_sequence;
	reg [7:0] output_sequence;

	input reset, clk;

	reg [7:0] LFSR;

	always @(posedge clk)
	begin
		output_sequence <= LFSR;
		if (reset == 0)
			LFSR <= 8'b11111111;
		else
			begin
				LFSR[0] <= LFSR[1] ^ LFSR[2] ^ LFSR[3] ^ LFSR[7];
				LFSR[7:1] <= LFSR[6:0];
			end
	end
endmodule
