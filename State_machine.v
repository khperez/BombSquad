module State_machine(clk, State_m);
input clk;
output [7:0]State_m;
reg [7:0]State_m;

always @(posedge clk) begin
	State_m <= 8'b0;
end
endmodule
