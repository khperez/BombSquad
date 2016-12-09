/*
	OneSec_Timer.v
	Description:
	Continuously sends single clock cycle pulses in one second intervals.
	Utilizes an internal register to count the number of clock cycles that
	has elapsed until the count is equal to 1 second.
	
	Inputs
		clk: 		On-board 50 Mhz clock
		reset:		Active low push button
		
	Outputs
		timeout:	Pulse signal indicating one second has occurred.

*/

module OneSec_Timer(clk, reset, timeout);
	
	output timeout;
	reg timeout;
	
	input clk, reset;
	
	reg [25:0] cnt;
	
	always@(posedge clk)
	begin
		if (reset == 0) begin cnt <= 26'd50000000; end
		else 
		begin
			if (cnt == 0) begin timeout <= 1'b1; cnt <= 26'd50000000; end
			else begin cnt <= cnt - 1; timeout <= 1'b0; end
		end
	end
endmodule

