`timescale 1ns/1ns

module TB_Countdown();
	
	reg SwitchOp, SecTimer;
	reg[11:0] init_time;
	
	wire[3:0] value_three, value_two, value_one;
	
	wire loose_control;
	
	reg reset, clk;
	
	reg[7:0] index;
	
	always begin
		clk <= 0;
		#10;
		clk <= 1;
		#10;
	end
	
	Countdown	DUT_CD(init_time, SwitchOp, SecTimer, reset, clk, value_three, value_two, value_one, loose_control);
	
	initial begin
		reset <= 0; init_time <= 12'b000110010000; SwitchOp <= 0; SecTimer <= 0;
		@(posedge clk);
		#5 reset <= 1;
		@(posedge clk);
		@(posedge clk);
		#5 SwitchOp <= 1;
		@(posedge clk);
		#5 SwitchOp <= 0;
		@(posedge clk);
		@(posedge clk);
		for (index=0; index < 25; index = index + 1)
		begin #5 SecTimer <= 0; @(posedge clk); #5 SecTimer <= 1; @(posedge clk); #5 SecTimer <= 0; end
	end
	
endmodule