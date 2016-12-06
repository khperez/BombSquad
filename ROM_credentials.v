module ROM_credentials(clk, rst, b_in,user_cred, User_seg);

input clk, rst, b_in;
input [7:0]user_cred;
output [6:0] User_seg;
wire [7:0]State; 
wire [7:0]rom_addr, ram_addr, Data, State_m;
wire [1:0]s_update;
wire [3:0]User;
wire time_req, b_out;

buttonShaper Mybutton(clk, rst, b_in, b_out);
State_machine Mystate(clk, State);
Authentication Mycompare(clk, rst, State, user_cred, Data, b_out, s_update, time_req, rom_addr, ram_addr, User);
ROM_Sim Myrom(rom_addr, clk, Data);
User_seg Myseg(clk, rst, User, User_seg);

endmodule
