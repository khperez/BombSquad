// BOMB SQUAD
// COURSE: ECE 5440
// AUTHOR: Sergio Silva (3232)

/*
   LCDController: Initializes and configures the on board LCD for displaying data.
   
   INPUTS:
     + clk: system clock
     + reset: resets the entire system (active low)
     + state: state of the game / state to display
        - 0x00: authentication
	- 0x01: authentication success
	- 0x02: authentication failed
        - 0x10: game in progress
        - 0x20: game success sequence begin
        - 0x21: game success sequence end
        - 0x30: game over sequence begin
        - 0x31: game over sequence end
     + user: authenticated user id
	- 1100: katherine perez
	- 0011: sergio silva
	- 1101: daniel lopez
	- 0100: rafael campos

   OUTPUTS:
     + lcd_on: lcd power control flag
     + lcd_en: lcd enable control flag
     + lcd_flag: lcd control flags (RS RW DB7 DB6 DB5 DB4 DB3 DB2 DB1 DB0)
*/

module LCDController(clk, reset, state, user, lcd_on, lcd_en, lcd_flag);
  input clk, reset;
  input [7:0] state;
  input [3:0] user;
  output lcd_on, lcd_en;
  output [9:0] lcd_flag;
  reg lcd_on, lcd_en;
  reg [9:0] lcd_flag;

  reg lcd_activate;
  reg [21:0] counter;
  reg [3:0] fsm, fsm_next;
  reg [5:0] char_cur;
  reg [7:0] data1 [0:15];
  reg [7:0] data2 [0:15];
  reg [7:0] data_user [0:5];

  parameter C_1MS = 50000, C_2MS = 100000, C_20MS = 1000000, C_45MS = 2250000;
  parameter S_POWER = 1, S_FNCTNSET = 2, S_DISPCNTRL = 3, S_DISPOFF = 4, S_DISPCLR = 5, S_ENTRYMODE = 6, S_WRITEDATA = 7, S_PUSH = 8; 

  always @(posedge clk) begin
    if (reset == 0) begin
     counter <= 0; 
     fsm <= S_POWER;
     lcd_on <= 1;
     lcd_en <= 1;
     lcd_activate <= 1;
     char_cur <= 0;
    end

    else if (lcd_activate == 1) begin

      case (user)
	8'b1100: begin
	  data_user[0] <= " ";
	  data_user[1] <= " ";
	  data_user[2] <= " ";
	  data_user[3] <= "K";
	  data_user[4] <= "A";
	  data_user[5] <= "T";
	end

	8'b0011: begin
	  data_user[0] <= "S";
	  data_user[1] <= "E";
	  data_user[2] <= "R";
	  data_user[3] <= "G";
	  data_user[4] <= "I";
	  data_user[5] <= "O";
	end

	8'b1101: begin
	  data_user[0] <= "D";
	  data_user[1] <= "A";
	  data_user[2] <= "N";
	  data_user[3] <= "I";
	  data_user[4] <= "E";
	  data_user[5] <= "L";
	end

	8'b0100: begin
	  data_user[0] <= "R";
	  data_user[1] <= "A";
	  data_user[2] <= "F";
	  data_user[3] <= "A";
	  data_user[4] <= "E";
	  data_user[5] <= "L";
	end
	
	default: begin
	  data_user[0] <= "E";
	  data_user[1] <= "R";
	  data_user[2] <= "R";
	  data_user[3] <= "O";
	  data_user[4] <= "R";
	  data_user[5] <= "!";
	end
    endcase

      case (state)
	// AUTHENTICATION PENDING
	8'h00: begin
	  // ___BOMB_SQUAD___    //
	  // ENTER_CREDENTIAL    //
	  data1[0]  <= " ";
	  data1[1]  <= " ";
	  data1[2]  <= " ";
	  data1[3]  <= "B";
	  data1[4]  <= "O";
	  data1[5]  <= "M";
	  data1[6]  <= "B";
	  data1[7]  <= " ";
	  data1[8]  <= "S";
	  data1[9]  <= "Q";
	  data1[10] <= "U";
	  data1[11] <= "A";
	  data1[12] <= "D";
	  data1[13] <= " ";
	  data1[14] <= " ";
	  data1[15] <= " ";
	  data2[0]  <= "E";
	  data2[1]  <= "N";
	  data2[2]  <= "T"; 
	  data2[3]  <= "E"; 
	  data2[4]  <= "R";
	  data2[5]  <= " "; 
	  data2[6]  <= "C"; 
	  data2[7]  <= "R"; 
	  data2[8]  <= "E"; 
	  data2[9]  <= "D";
	  data2[10] <= "E";
	  data2[11] <= "N";
	  data2[12] <= "T";
	  data2[13] <= "I";
	  data2[14] <= "A";
	  data2[15] <= "L";
	end

	// AUTHENTICATION SUCCESS
	8'h01: begin
	  // _ACCESS_GRANTED_ //
	  // ____WELCOME!____ //
	  data1[0]  <= " ";
	  data1[1]  <= "A";
	  data1[2]  <= "C";
	  data1[3]  <= "C";
	  data1[4]  <= "E";
	  data1[5]  <= "S";
	  data1[6]  <= "S";
	  data1[7]  <= " ";
	  data1[8]  <= "G";
	  data1[9]  <= "R";
	  data1[10] <= "A";
	  data1[11] <= "N";
	  data1[12] <= "T";
	  data1[13] <= "E";
	  data1[14] <= "D";
	  data1[15] <= " ";
	  data2[0]  <= " ";
	  data2[1]  <= " ";
	  data2[2]  <= " "; 
	  data2[3]  <= " "; 
	  data2[4]  <= "W";
	  data2[5]  <= "E"; 
	  data2[6]  <= "L"; 
	  data2[7]  <= "C"; 
	  data2[8]  <= "O"; 
	  data2[9]  <= "M";
	  data2[10] <= "E";
	  data2[11] <= "!";
	  data2[12] <= " ";
	  data2[13] <= " ";
	  data2[14] <= " ";
	  data2[15] <= " ";
	end

	// AUTHENTICATION FAILURE
	8'h02: begin 
	  // _____ACCESS_____ //
	  // _____DENIED_____ //
	  data1[0]  <= " ";
	  data1[1]  <= " ";
	  data1[2]  <= " ";
	  data1[3]  <= " ";
	  data1[4]  <= " ";
	  data1[5]  <= "A";
	  data1[6]  <= "C";
	  data1[7]  <= "C";
	  data1[8]  <= "E";
	  data1[9]  <= "S";
	  data1[10] <= "S";
	  data1[11] <= " ";
	  data1[12] <= " ";
	  data1[13] <= " ";
	  data1[14] <= " ";
	  data1[15] <= " ";
	  data2[0]  <= " ";
	  data2[1]  <= " ";
	  data2[2]  <= " "; 
	  data2[3]  <= " "; 
	  data2[4]  <= " ";
	  data2[5]  <= "D"; 
	  data2[6]  <= "E"; 
	  data2[7]  <= "N"; 
	  data2[8]  <= "I"; 
	  data2[9]  <= "E";
	  data2[10] <= "D";
	  data2[11] <= " ";
	  data2[12] <= " ";
	  data2[13] <= " ";
	  data2[14] <= " ";
	  data2[15] <= " ";
	end

	// GAME IN PROGRESS
	8'h10: begin 
	  // _BOMB_ACTIVATED_  //
	  // _HURRY__XXXXXX!_ //
	  data1[0]  <= " ";
	  data1[1]  <= "B";
	  data1[2]  <= "O";
	  data1[3]  <= "M";
	  data1[4]  <= "B";
	  data1[5]  <= " ";
	  data1[6]  <= "A";
	  data1[7]  <= "C";
	  data1[8]  <= "T";
	  data1[9]  <= "I";
	  data1[10] <= "V";
	  data1[11] <= "A";
	  data1[12] <= "T";
	  data1[13] <= "E";
	  data1[14] <= "D";
	  data1[15] <= " ";
	  data2[0]  <= " ";
	  data2[1]  <= "H";
	  data2[2]  <= "U"; 
	  data2[3]  <= "R"; 
	  data2[4]  <= "R";
	  data2[5]  <= "Y"; 
	  data2[6]  <= " "; 
	  data2[7]  <= " "; 
	  data2[8]  <= data_user[0];
	  data2[9]  <= data_user[1];
	  data2[10] <= data_user[2];
	  data2[11] <= data_user[3];
	  data2[12] <= data_user[4];
	  data2[13] <= data_user[5];
	  data2[14] <= "!";
	  data2[15] <= " ";
	end

	// GAME SEQUENCE: SEQUENCE BEGIN
	8'h20: begin 
	  // __GAME_SUCCESS__ //
	  // _SEQUENCE_BEGIN_ //
	  data1[0]  <= " ";
	  data1[1]  <= " ";
	  data1[2]  <= "G";
	  data1[3]  <= "A";
	  data1[4]  <= "M";
	  data1[5]  <= "E";
	  data1[6]  <= " ";
	  data1[7]  <= "S";
	  data1[8]  <= "U";
	  data1[9]  <= "C";
	  data1[10] <= "C";
	  data1[11] <= "E";
	  data1[12] <= "S";
	  data1[13] <= "S";
	  data1[14] <= " ";
	  data1[15] <= " ";
	  data2[0]  <= " ";
	  data2[1]  <= "S";
	  data2[2]  <= "E"; 
	  data2[3]  <= "Q"; 
	  data2[4]  <= "U";
	  data2[5]  <= "E"; 
	  data2[6]  <= "N"; 
	  data2[7]  <= "C"; 
	  data2[8]  <= "E"; 
	  data2[9]  <= " ";
	  data2[10] <= "B";
	  data2[11] <= "E";
	  data2[12] <= "G";
	  data2[13] <= "I";
	  data2[14] <= "N";
	  data2[15] <= " ";
	end

	// GAME SEQUENCE: SEQUENCE END
	8'h21: begin 
	  // __GAME_SUCCESS__ //
	  // __SEQUENCE_END__ //
	  data1[0]  <= " ";
	  data1[1]  <= " ";
	  data1[2]  <= "G";
	  data1[3]  <= "A";
	  data1[4]  <= "M";
	  data1[5]  <= "E";
	  data1[6]  <= " ";
	  data1[7]  <= "S";
	  data1[8]  <= "U";
	  data1[9]  <= "C";
	  data1[10] <= "C";
	  data1[11] <= "E";
	  data1[12] <= "S";
	  data1[13] <= "S";
	  data1[14] <= " ";
	  data1[15] <= " ";
	  data2[0]  <= " ";
	  data2[1]  <= " ";
	  data2[2]  <= "S"; 
	  data2[3]  <= "E"; 
	  data2[4]  <= "Q";
	  data2[5]  <= "U"; 
	  data2[6]  <= "E"; 
	  data2[7]  <= "N"; 
	  data2[8]  <= "C"; 
	  data2[9]  <= "E";
	  data2[10] <= " ";
	  data2[11] <= "E";
	  data2[12] <= "N";
	  data2[13] <= "D";
	  data2[14] <= " ";
	  data2[15] <= " ";
	end

	// GAME OVER: SEQUENCE BEGIN
	8'h30: begin 
	  // ___GAME__OVER___ //
	  // _SEQUENCE_BEGIN_ //
	  data1[0]  <= " ";
	  data1[1]  <= " ";
	  data1[2]  <= " ";
	  data1[3]  <= "G";
	  data1[4]  <= "A";
	  data1[5]  <= "M";
	  data1[6]  <= "E";
	  data1[7]  <= " ";
	  data1[8]  <= " ";
	  data1[9]  <= "O";
	  data1[10] <= "V";
	  data1[11] <= "E";
	  data1[12] <= "R";
	  data1[13] <= " ";
	  data1[14] <= " ";
	  data1[15] <= " ";
	  data2[0]  <= " ";
	  data2[1]  <= "S";
	  data2[2]  <= "E"; 
	  data2[3]  <= "Q"; 
	  data2[4]  <= "U";
	  data2[5]  <= "E"; 
	  data2[6]  <= "N"; 
	  data2[7]  <= "C"; 
	  data2[8]  <= "E"; 
	  data2[9]  <= " ";
	  data2[10] <= "B";
	  data2[11] <= "E";
	  data2[12] <= "G";
	  data2[13] <= "I";
	  data2[14] <= "N";
	  data2[15] <= " ";
	end

	// GAME OVER: SEQUENCE END
	8'h31: begin 
	  // ___GAME__OVER___ //
	  // __SEQUENCE_END__ //
	  data1[0]  <= " ";
	  data1[1]  <= " ";
	  data1[2]  <= " ";
	  data1[3]  <= "G";
	  data1[4]  <= "A";
	  data1[5]  <= "M";
	  data1[6]  <= "E";
	  data1[7]  <= " ";
	  data1[8]  <= " ";
	  data1[9]  <= "O";
	  data1[10] <= "V";
	  data1[11] <= "E";
	  data1[12] <= "R";
	  data1[13] <= " ";
	  data1[14] <= " ";
	  data1[15] <= " ";
	  data2[0]  <= " ";
	  data2[2]  <= "S"; 
	  data2[3]  <= "E"; 
	  data2[4]  <= "Q";
	  data2[5]  <= "U"; 
	  data2[6]  <= "E"; 
	  data2[7]  <= "N"; 
	  data2[8]  <= "C"; 
	  data2[9]  <= "E";
	  data2[10] <= " ";
	  data2[11] <= "E";
	  data2[12] <= "N";
	  data2[13] <= "D";
	  data2[14] <= " ";
	  data2[15] <= " ";
	end

	// UNKNOWN STATE
	default: begin 
	  // _UNKNOWN__STATE_ //
	  // ________________ //
	  data1[0]  <= " ";
	  data1[1]  <= "U";
	  data1[2]  <= "N";
	  data1[3]  <= "K";
	  data1[4]  <= "N";
	  data1[5]  <= "O";
	  data1[6]  <= "W";
	  data1[7]  <= "N";
	  data1[8]  <= " ";
	  data1[9]  <= " ";
	  data1[10] <= "S";
	  data1[11] <= "T";
	  data1[12] <= "A";
	  data1[13] <= "T";
	  data1[14] <= "E";
	  data1[15] <= " ";
	  data2[0]  <= " ";
	  data2[1]  <= " ";
	  data2[2]  <= " "; 
	  data2[3]  <= " "; 
	  data2[4]  <= " ";
	  data2[5]  <= " "; 
	  data2[6]  <= " "; 
	  data2[7]  <= " "; 
	  data2[8]  <= " "; 
	  data2[9]  <= " ";
	  data2[10] <= " ";
	  data2[11] <= " ";
	  data2[12] <= " ";
	  data2[13] <= " ";
	  data2[14] <= " ";
	  data2[15] <= " ";
	end
      endcase

      case (fsm) 
        S_POWER: begin
          lcd_on <= 1;
          lcd_en <= 1;
	  lcd_flag <= 10'b00_0011_1000; // 10'b00_001D_NF**
	  fsm <= S_PUSH;
          fsm_next <= S_FNCTNSET;
	end

        S_FNCTNSET: begin
          lcd_en <= 1;
          lcd_flag <= 10'b00_0011_1000; // 10'b00_001D_NF**
	  fsm <= S_PUSH;
	  fsm_next <= S_DISPOFF;
        end

	S_DISPOFF: begin
          lcd_en <= 1;
          lcd_flag <= 10'b00_0000_1000; // DISPLAY & CURSOR OFF
	  fsm <= S_PUSH;
	  fsm_next <= S_DISPCLR;
	end

	S_DISPCLR: begin
          lcd_en <= 1;
          lcd_flag <= 10'b00_0000_0001; // CLEAR DISPLAY & CURSOR OFF
	  fsm <= S_PUSH;
	  fsm_next <= S_DISPCNTRL;
	end

        S_DISPCNTRL: begin
          lcd_en <= 1;
          lcd_flag <= 10'b00_0000_1100; // 10'b00_0000_1DCB
	  fsm <= S_PUSH;
	  fsm_next <= S_ENTRYMODE;
        end

        S_ENTRYMODE: begin
          lcd_en <= 1;
          lcd_flag <= 10'b00_0000_0110; // 10'b00_0000_01IS
	  fsm <= S_PUSH;
	  fsm_next <= S_WRITEDATA;
        end

        S_WRITEDATA: begin
          lcd_en <= 1;
	  fsm <= S_PUSH;
	  
	  case (char_cur)
            0:  begin lcd_flag <= {2'b10, data1[0]}; end
            1:  begin lcd_flag <= {2'b10, data1[1]}; end
            2:  begin lcd_flag <= {2'b10, data1[2]}; end
            3:  begin lcd_flag <= {2'b10, data1[3]}; end
            4:  begin lcd_flag <= {2'b10, data1[4]}; end
            5:  begin lcd_flag <= {2'b10, data1[5]}; end
            6:  begin lcd_flag <= {2'b10, data1[6]}; end
            7:  begin lcd_flag <= {2'b10, data1[7]}; end
            8:  begin lcd_flag <= {2'b10, data1[8]}; end
            9:  begin lcd_flag <= {2'b10, data1[9]}; end
	    10: begin lcd_flag <= {2'b10, data1[10]}; end
            11: begin lcd_flag <= {2'b10, data1[11]}; end
            12: begin lcd_flag <= {2'b10, data1[12]}; end
            13: begin lcd_flag <= {2'b10, data1[13]}; end
            14: begin lcd_flag <= {2'b10, data1[14]}; end
            15: begin lcd_flag <= {2'b10, data1[15]}; end
	    16: begin lcd_flag <= 10'b00_1100_0000; end // LINE 2
            17: begin lcd_flag <= 10'b00_1100_0000; end // LINE 2
            18: begin lcd_flag <= {2'b10, data2[0]}; end
            19: begin lcd_flag <= {2'b10, data2[1]}; end
            20: begin lcd_flag <= {2'b10, data2[2]}; end
            21: begin lcd_flag <= {2'b10, data2[3]}; end
            22: begin lcd_flag <= {2'b10, data2[4]}; end
            23: begin lcd_flag <= {2'b10, data2[5]}; end
            24: begin lcd_flag <= {2'b10, data2[6]}; end
            25: begin lcd_flag <= {2'b10, data2[7]}; end
            26: begin lcd_flag <= {2'b10, data2[8]}; end
            27: begin lcd_flag <= {2'b10, data2[9]}; end
	    28: begin lcd_flag <= {2'b10, data2[10]}; end
            29: begin lcd_flag <= {2'b10, data2[11]}; end
            30: begin lcd_flag <= {2'b10, data2[12]}; end
            31: begin lcd_flag <= {2'b10, data2[13]}; end
            32: begin lcd_flag <= {2'b10, data2[14]}; end
            33: begin lcd_flag <= {2'b10, data2[15]}; end
            34: begin lcd_flag <= 10'b00_1000_0000; end // LINE 1
	    35: begin lcd_flag <= 10'b00_1000_0000; end // LINE 1
            default: begin lcd_flag <= {2'b10, "*"}; end // DEFAULT: '*'
          endcase

	  if (char_cur == 35) begin
	    fsm_next <= S_WRITEDATA;
	    char_cur <= 0;
	  end
	  else begin
	    fsm_next <= S_WRITEDATA;
	    char_cur <= char_cur + 1;
	  end

        end
        
	S_PUSH: begin
	  if (counter == C_2MS) begin
	    lcd_en <= 1;
	    counter <= 0;
	    fsm <= fsm_next;
	  end
	  else if (counter == 1) begin
	    lcd_en <= 0;
	    counter <= counter + 1;
	  end
          else begin
 	    counter <= counter + 1;
	  end
	end

        default: begin end
      endcase
    end

    else lcd_activate <= 0;
  end
endmodule
