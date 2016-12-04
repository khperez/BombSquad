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

