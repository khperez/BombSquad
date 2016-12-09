// BOMB SQUAD
// COURSE: ECE 5440
// AUTHOR: Sergio Silva (3232)

/*
   LEDDriver: Animates the onboard green and red LED's depending on the current game state
   
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

   OUTPUTS:
     + led_g: green led array
     + led_r: red led array
*/

module LEDDriver(clk, reset, state, led_g, led_r);
  input clk, reset;
  input [7:0] state;
  output [7:0] led_g;
  output [17:0] led_r;
  reg [7:0] led_g;
  reg [17:0] led_r;
  reg [21:0] counter;

  reg direction; // 0:left 1:right

  always @(posedge clk) begin
    if (reset == 0) begin
	led_g <= 0;
	led_r <= 0;
	direction <= 0;
    end
    
    else begin
      case(state)
        8'h10: begin
	  if (counter == 1000000) begin
	    counter <= 0;

	    if      (led_r == 18'b100000000000000000) direction <= 1;
	    else if (led_r == 18'b000000000000000001) direction <= 0;

	    if      (direction == 0) led_r <= led_r << 1;
	    else if (direction == 1) led_r <= led_r >> 1;
	  end
	
	  else begin
	    counter <= counter + 1;
	  end
	end

        default: begin
	  led_g <= 18'b111111111111111111;
	  led_r <= 18'b11111111;
        end
      endcase
    end
  end
endmodule
	
      