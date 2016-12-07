
//Bomb squad
//Author: Rafael Campos
//Course: ECE 5440

/*------------------------------------------- Authentication module -----------------------------------------------

	The authentication module receives a 8 bit string from mechanical switches and stores them in the 
	user_cred reg variable. Then a Final State Machine starts by checking if a pulse has been received 
	from the button shaper by checking the net submit input signal. In the next step the module retreives
	the credential stored in the first address of a rom file and compares it with the 8 bit input signal. 
	If the comparison succeeds, the module proceeds to send 2 signal flags to the game controller. The 
	signal flag s_update is used to inform the game controller that a user have successfully logged in. 
	The signal User is employed to identify the user by checking its input id to a mapped table of ids. 
	If a comparison fails, the module retreives the information stored in the next address to the one already 
	tested. If the module reaches the last meaningful address in the rom, it will update the signal s_update 
	to inform the game controller that the comparison failed.  

	inputs:
		clk       : clock
		rst       : reset
		State     : Game controller authentication state code
		user_cred : 8 bit sequence from onboard mechanical switches that represents the user's 
			    ID(first 4 bits from MSB) and password(last 4 bits)
		rom_cred  : 8 bit sequence retreived from rom file
		submit    : input from button shaper

	Outputs:
		rom_addr  : used to access data from the rom file. starts at value 0
		ram_id    : used to send user's id information to the ram module
		s_update  : flags the game controller if a user has logged in following the chema
				2'b00 = no log in   2'b01 = success   2'b10 = fail
		User      : used to identify a user that successfully logged in following the chema

				User			ID		Password
				Katherine Perez	       1100               1100
   				Sergio Silva           0011               0011
				Daniel Lopez           1101               0001
				Rafael Campos          0100               1110

*/

module Authentication(clk, reset, State, user_cred, rom_cred, submit, s_update, time_req, rom_addr, ram_id, User);

input clk, reset, submit;
input [7:0]State;
input [7:0]user_cred, rom_cred;
output [7:0]rom_addr;
output [1:0]s_update;
output [3:0]User, ram_id;
output time_req;
reg [7:0]user_c, rom_c, rom_a;
reg [1:0]s_update;
reg [3:0]State_m, User, ram_a; 
reg flag;
parameter Init = 0, Compare = 1, Next_id = 2;

always@(posedge clk) begin
	if(reset == 0) begin
		user_c   <= 8'b0;
		rom_c    <= 8'b0;
		rom_a    <= 8'b0;
		ram_a    <= 4'b0;
		s_update <= 2'b0;
		User     <= 4'b0;
		State_m  <= Init;
	end
	else if(State === 8'b0) begin
		case(State_m)
			
			Init : begin
				if(submit == 1) begin
					user_c  <= user_cred;
					rom_c   <= rom_cred;
					State_m <= Compare;
				end
				else if(flag == 1) begin
					rom_c   <= rom_cred;
					State_m <= Compare;
				end
				else begin
					State_m <= Init;
				end
			end

			Compare : begin
				if(user_c === rom_c) begin
					s_update <= 2'b01;
					flag     <= 0;

					if(rom_c === 8'b11001100) begin
						User   <= 4'b0001;
						ram_a <= 4'b1100;
					end
					else if(rom_c === 8'b00110011) begin
						User   <= 4'b0010;
						ram_a <= 4'b0011;
					end
					else if(rom_c === 8'b11010001) begin
						User   <= 4'b0011;
						ram_a <= 4'b1101;
					end
					else if(rom_c === 8'b01001110) begin
						User   <= 4'b0100;
						ram_a <= 4'b0100;
					end

					State_m  <= Next_id;
				end
				else if(rom_c === 8'b11111111) begin
					s_update <= 2'b10;
					ram_a   <= 8'b0;
					flag     <= 0;
					User = 4'b0000;
					State_m  <= Next_id;
				end
				else begin
					flag     <= 1;
					State_m  <= Next_id;
				end
			end

			Next_id : begin
				if(flag == 1) begin
					rom_a   <= rom_a + 1;
					State_m <= Init;
				end
				else begin
					rom_a   <= 0;
					State_m <= Init;
				end
			end

		endcase
	end
end
assign rom_addr = rom_a;
assign ram_id   = ram_a;
endmodule
