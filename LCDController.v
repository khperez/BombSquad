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
        - 0x11: level 1 success
        - 0x12: level 1 failed
        - 0x13: level 2 success
        - 0x14: level 2 failed
        - 0x16: level 3 failed
        - 0x20: game success sequence begin
        - 0x21: game success sequence end
        - 0x30: game over sequence begin
        - 0x31: game over sequence end

   OUTPUTS:
     + lcd_on: lcd power control flag
     + lcd_en: lcd enable control flag
     + lcd_flag: lcd control flags (RS RW DB7 DB6 DB5 DB4 DB3 DB2 DB1 DB0)
*/

module LCDController(clk, reset, state, lcd_on, lcd_en, lcd_flag);
  input clk, reset;
  input [7:0] state;
  output lcd_on, lcd_en;
  output [9:0] lcd_flag;
  reg lcd_on, lcd_en;
  reg [9:0] lcd_flag;

  reg lcd_activate;
  reg [7:0] temp_state, prev_state;
  reg [21:0] counter;
  reg [5:0] char;
  reg [3:0] fsm, next;
  reg [7:0] data1 [0:15];
  reg [7:0] data2 [0:15];

  parameter C_1MS = 50000, C_20MS = 1000000, C_45MS = 2250000;
  parameter S_POWER = 1, S_FNCTNSET = 2, S_DISPCNTRL = 3, S_ENTRYMODE = 4, S_WRITEDATA = 5;
  parameter S_HOME = 6, S_PUSH = 7, S_DISPOFF = 8, S_DISPCLR = 9;

  parameter L__ = 8'h20, L_EX = 8'h21;
  parameter L_0 = 8'h30, L_1 = 8'h31, L_2 = 8'h32, L_3 = 8'h33;
  parameter L_4 = 8'h34, L_5 = 8'h35, L_6 = 8'h36, L_7 = 8'h37;
  parameter L_8 = 8'h38, L_9 = 8'h39;
  parameter L_A = 8'h41, L_B = 8'h42, L_C = 8'h43, L_D = 8'h44;
  parameter L_E = 8'h45, L_F = 8'h46, L_G = 8'h47, L_H = 8'h48;
  parameter L_I = 8'h49, L_J = 8'h4A, L_K = 8'h4B, L_L = 8'h4C;
  parameter L_M = 8'h4D, L_N = 8'h4E, L_O = 8'h4F, L_P = 8'h50;
  parameter L_Q = 8'h51, L_R = 8'h52, L_S = 8'h53, L_T = 8'h54;
  parameter L_U = 8'h55, L_V = 8'h56, L_W = 8'h57, L_X = 8'h58;
  parameter L_Y = 8'h59, L_Z = 8'h5A;

  always @(posedge clk) begin
    if (reset == 0) begin
     counter <= 0;
     fsm <= S_POWER;
     lcd_on <= 1;
     lcd_en <= 1;
     lcd_activate <= 1;
     char <= 0;
     prev_state <= state;
    end

    else if (lcd_activate == 1) begin
      case (state)
	8'h00: begin // AUTHENTICATION PENDING
	  // ___BOMB_SQUAD___ //
	  // ENTER_CREDENTIAL //
	  data1[0]  <= L__; data1[1]  <= L__; data1[2]  <= L__; data1[3]  <= L_B; data1[4]  <= L_O;
	  data1[5]  <= L_M; data1[6]  <= L_B; data1[7]  <= L__; data1[8]  <= L_S; data1[9]  <= L_Q;
	  data1[10] <= L_U; data1[11] <= L_A; data1[12] <= L_D; data1[13] <= L__; data1[14] <= L__; data1[15] <= L__;
	  data2[0]  <= L_E; data2[1]  <= L_N; data2[2]  <= L_T; data2[3]  <= L_E; data2[4]  <= L_R;
	  data2[5]  <= L__; data2[6]  <= L_C; data2[7]  <= L_R; data2[8]  <= L_E; data2[9]  <= L_D;
	  data2[10] <= L_E; data2[11] <= L_N; data2[12] <= L_T; data2[13] <= L_I; data2[14] <= L_A; data2[15] <= L_L;
	
	  prev_state <= state;
	end

	8'h01: begin // AUTHENTICATION SUCCESS
	  // _ACCESS_GRANTED_ //
	  // ____WELCOME!____ //
	  data1[0]  <= L__; data1[1]  <= L_A; data1[2]  <= L_C; data1[3]  <= L_C; data1[4]  <= L_E;
	  data1[5]  <= L_S; data1[6]  <= L_S; data1[7]  <= L__; data1[8]  <= L_G; data1[9]  <= L_R;
	  data1[10] <= L_A; data1[11] <= L_N; data1[12] <= L_T; data1[13] <= L_E; data1[14] <= L_D; data1[15] <= L__;
	  data2[0]  <= L__; data2[1]  <= L__; data2[2]  <= L__; data2[3]  <= L__; data2[4]  <= L_W;
	  data2[5]  <= L_E; data2[6]  <= L_L; data2[7]  <= L_C; data2[8]  <= L_O; data2[9]  <= L_M;
	  data2[10] <= L_E; data2[11] <= L_EX; data2[12] <= L__; data2[13] <= L__; data2[14] <= L__; data2[15] <= L__;

	  prev_state <= state;
	end

	8'h02: begin // AUTHENTICATION FAILED
	  // _____ACCESS_____ //
	  // _____DENIED_____ //
	  data1[0]  <= L__; data1[1]  <= L__; data1[2]  <= L__; data1[3]  <= L__; data1[4]  <= L__;
	  data1[5]  <= L_A; data1[6]  <= L_C; data1[7]  <= L_C; data1[8]  <= L_E; data1[9]  <= L_S;
	  data1[10] <= L_S; data1[11] <= L__; data1[12] <= L__; data1[13] <= L__; data1[14] <= L__; data1[15] <= L__;
	  data2[0]  <= L__; data2[1]  <= L__; data2[2]  <= L__; data2[3]  <= L__; data2[4]  <= L__;
	  data2[5]  <= L_D; data2[6]  <= L_E; data2[7]  <= L_N; data2[8]  <= L_I; data2[9]  <= L_E;
	  data2[10] <= L_D; data2[11] <= L__; data2[12] <= L__; data2[13] <= L__; data2[14] <= L__; data2[15] <= L__;

	  prev_state <= state;
	end

	default: begin // UNKNOWN STATE
	  // UNKNOWN_STATE___ //
	  // ________________ //
	  data1[0]  <= L_U; data1[1]  <= L_N; data1[2]  <= L_K; data1[3]  <= L_N; data1[4]  <= L_O;
	  data1[5]  <= L_W; data1[6]  <= L_N; data1[7]  <= L__; data1[8]  <= L_S; data1[9]  <= L_T;
	  data1[10] <= L_A; data1[11] <= L_T; data1[12] <= L_E; data1[13] <= L__; data1[14] <= L__; data1[15] <= L__;
	  data2[0]  <= L__; data2[1]  <= L__; data2[2]  <= L__; data2[3]  <= L__; data2[4]  <= L__;
	  data2[5]  <= L__; data2[6]  <= L__; data2[7]  <= L__; data2[8]  <= L__; data2[9]  <= L__;
	  data2[10] <= L__; data2[11] <= L__; data2[12] <= L__; data2[13] <= L__; data2[14] <= L__; data2[15] <= L__;

	  prev_state <= state;
	end
      endcase

      case (fsm) 
        S_POWER: begin
          lcd_on <= 1;
          lcd_en <= 1;
	  lcd_flag <= 10'b00_0011_1000; // 10'b00_001D_NF**
	  fsm <= S_PUSH;
          next <= S_FNCTNSET;
	end

        S_FNCTNSET: begin
          lcd_en <= 1;
          lcd_flag <= 10'b00_0011_1000; // 10'b00_001D_NF**
	  fsm <= S_PUSH;
	  next <= S_DISPOFF;
        end

	S_DISPOFF: begin
          lcd_en <= 1;
          lcd_flag <= 10'b00_0000_1000; // Turn off Display and Turn off cursor
	  fsm <= S_PUSH;
	  next <= S_DISPCLR;
	end

	S_DISPCLR: begin
          lcd_en <= 1;
          lcd_flag <= 10'b00_0000_0001; // Clear Display and Turn off cursor
	  fsm <= S_PUSH;
	  next <= S_DISPCNTRL;
	end

        S_DISPCNTRL: begin
          lcd_en <= 1;
          lcd_flag <= 10'b00_0000_1100; // 10'b00_0000_1DCB
	  fsm <= S_PUSH;
	  next <= S_ENTRYMODE;
        end

        S_ENTRYMODE: begin
          lcd_en <= 1;
          lcd_flag <= 10'b00_0000_0110; // 10'b00_0000_01IS
	  fsm <= S_PUSH;
	  next <= S_WRITEDATA;
        end

        S_WRITEDATA: begin
          lcd_en <= 1;
	  fsm <= S_PUSH;
	  
	  case (char)
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
	    16: begin lcd_flag <= 10'b00_1100_0000; end // NEXT LINE
            17: begin lcd_flag <= 10'b00_1100_0000; end // NEXT LINE
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
            34: begin lcd_flag <= 10'b00_1000_0000; end // HOME
            default: begin lcd_flag <= 10'b10_0010_0000; end // ' '
          endcase

	  if (char == 34) next <= S_HOME;
	  else begin
	    next <= S_WRITEDATA;
	    char = char + 1;
	  end

        end
        
        S_HOME: begin
          lcd_en <= 1;
          lcd_flag <= 10'b00_1000_0000;  // 10'b00_0000_001*
	  fsm <= S_PUSH;
	  next <= S_WRITEDATA;
        end

	S_PUSH: begin
	  if (counter == 100000) begin
	    lcd_en <= 1;
	    counter <= 0;
	    fsm <= next;
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
