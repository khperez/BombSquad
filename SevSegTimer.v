/*
	SevSegTimer.v 
	Description:			
	Maps a 4-bit bus to its corresponding integer expression on the seven segment display.
	
	Inputs
		digit_reg:			A binary value representative of its decimal value.
		
	Outputs
		segment_output:		The mapped value to produce the corresponding decimal value on the seven segment display.

*/

module SevSegTimer(digit_reg, segment_output);
	input [3:0] digit_reg;
	output [6:0] segment_output;
	reg [6:0] segment_output;
	
	always@(digit_reg)
	begin
		case(digit_reg)
			4'b0000 : begin segment_output = 7'b1000000; end
			4'b0001 : begin segment_output = 7'b1111001; end
			4'b0010 : begin segment_output = 7'b0100100; end
			4'b0011 : begin segment_output = 7'b0110000; end
			4'b0100 : begin segment_output = 7'b0011001; end
			4'b0101 : begin segment_output = 7'b0010010; end
			4'b0110 : begin segment_output = 7'b0000010; end
			4'b0111 : begin segment_output = 7'b1111000; end
			4'b1000 : begin segment_output = 7'b0000000; end
			4'b1001 : begin segment_output = 7'b0011000; end
			default : begin segment_output = 7'b0100001; end
		endcase
	end
endmodule