// Irfan HAcioglu  16 Feb 2025
// ADC Interface Top-up Module

module lab2 (
    input logic CLOCK_50,       // 50 MHz clock
    (* altera_attribute = "-name WEAK_PULL_UP_RESISTOR ON" *) 
    input logic enc1_a, enc1_b,  // Encoder 1 pins
    (* altera_attribute = "-name WEAK_PULL_UP_RESISTOR ON" *) 
    input logic enc2_a, enc2_b,  // Encoder 2 pins
    output logic [7:0] leds,     // 7-seg LED enables
    output logic [3:0] ct,       // Digit cathodes
	 output logic spkr,           // used for servo
	 output logic s2,             // used for led
	 
	 
	 output logic ADC_CONVST, ADC_SCK, ADC_SDI, // SPI outputs
 
    
	 (* altera_attribute = "-name WEAK_PULL_UP_RESISTOR ON" *) 
input logic s1,
 (* altera_attribute = "-name WEAK_PULL_UP_RESISTOR ON" *) 
input logic ADC_SDO,
(* altera_attribute = "-name WEAK_PULL_UP_RESISTOR ON" *) 
input logic green,
 (* altera_attribute = "-name WEAK_PULL_UP_RESISTOR ON" *) 
input logic blue,
 (* altera_attribute = "-name WEAK_PULL_UP_RESISTOR ON" *) 
input logic red  

	 	 
);

	 logic [11:0] result;
    logic [1:0] digit;          // Select digit to display
    logic [3:0] disp_digit;     // Current digit of count to display
    logic [19:0] clk_div_count; // Increased count size for slower switching
    logic [31:0] chan;          // Updated to 32-bit for `enc2freq`
    logic enc1_cw, enc1_ccw, enc2_cw, enc2_ccw;  // Encoder module outputs
	 logic slow_clock;
	 logic [7:0] chanto;
	 logic [7:0] chanto1;
	 logic [11:0] lux_value;
    logic [11:0] lux_value_bcd; // 12-bit vector output

    // Instantiate display modules
    decode2 decode2_0 (
        .digit(digit), 
        .ct(ct)
    );

    decode7 decode7_0 (
        .num(disp_digit), 
        .leds(leds)
    );

    //instantiate encoder modules
    encoder encoder_1 (
        .clk(CLOCK_50), 
        .a(enc1_a), 
        .b(enc1_b), 
        .cw(enc1_cw), 
        .ccw(enc1_ccw)
    );

    encoder encoder_2 (
        .clk(CLOCK_50), 
        .a(enc2_a), 
        .b(enc2_b), 
        .cw(enc2_cw), 
        .ccw(enc2_ccw)
   );

    // Instantiate enc2freq module (Maps encoder movement to channel)
	 
	 
    enc1mode enc1mode_0 (
        .clk(CLOCK_50),
        .reset_n(s1), //  reset
        .cw(enc1_cw),
        .ccw(enc1_ccw),
        .chan(chanto1)
    );
	 
	 
	 
    enc2mode enc2mode_0 (
        .clk(CLOCK_50),
        .reset_n(s1), //  reset
        .cw(enc2_cw),
        .ccw(enc2_ccw),
        .chan(chanto)
    );
	 
	// Instantiate LuxReceiver Module
	LuxReceiver lux_receiver_inst (
    .clk(slow_clock),        // Use the slow clock for stable data reception
    .reset_n(s1),            // Active-low reset signal
    .gpio_data(blue),        // Change this to match GPIO_DATA_PIN (Pin 11)
    .gpio_ready(green),      // Change this to match GPIO_READY_PIN (Pin 12)
    .manual_clk(red), 			// Added: Manual clock pin from Tiva C (Pin 13)
    .lux_value(lux_value)    // Final 12-bit LUX value output
	);

	bcd_conversion bcd_conversion_0 (
        .lux_value(lux_value), 
        .lux_value_bcd(lux_value_bcd)
    );
	 
	 servo_control servo_control_0 (
    .clk(CLOCK_50),
    .reset_n(s1),          // active-low reset
    .chan(chanto),         // from enc2freq module (0–9)
	 .light_lux(lux_value), // LUX input from OPT3001
	 .is_auto(chanto1),
    .servo_pwm(spkr),// connect this to FPGA GPIO pin for servo
	 .auto_led(s2)
	);


    // Clock divider for 7-segment display update
    always_ff @(posedge CLOCK_50) begin
	
        clk_div_count <= clk_div_count + 1'b1;
    end

    // Assign the top two bits of count to select the digit to display
    assign digit = clk_div_count[17:16];
	 // clock divider
	 assign slow_clk = clk_div_count [19];
	 
always_comb begin
    case (digit)
        2'b00: disp_digit = lux_value_bcd[3:0];       // Ones
        2'b01: disp_digit = lux_value_bcd[7:4];       // Tens
        2'b10: disp_digit = lux_value_bcd[11:8];      // Hundreds
        2'b11: begin
            if (chanto1)
                disp_digit = 4'b1010;                 // Display "A" or fixed value
            else
                disp_digit = chanto[3:0];             // Show chanto value
        end
        default: disp_digit = 4'b0000;                // Default
    endcase
end

endmodule



