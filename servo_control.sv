module servo_control (
    input  logic clk,                    // 50 MHz system clock
    input  logic reset_n,                // active-low reset
    input  logic is_auto,                // auto/manual switch
    input  logic [3:0] chan,             // manual mode input (0–9)
    input  logic [11:0] light_lux,       // LUX input from OPT3001
    output logic servo_pwm,              // PWM signal to servo
    output logic auto_led                // LED on when auto mode is active
);

    // Internal control value (0–9)
    logic [3:0] control_value;
    logic [3:0] current_value;

    // Delay counter for auto movement (0.5s = 25M clocks @ 50MHz)
    logic [24:0] delay_counter;         // Enough bits for 25M
    logic delay_done;

    // LED control based on auto mode
    always_comb begin
        auto_led = is_auto;
    end

    // Delay logic
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            delay_counter <= 0;
        else if (!is_auto)
            delay_counter <= 0; // reset delay in manual mode
        else if (delay_done == 0)
            delay_counter <= delay_counter + 1;
        else
            delay_counter <= 0;
    end

    assign delay_done = (delay_counter >= 25_000_000);  // 0.5 sec delay

    // Servo movement with delay logic
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            current_value <= 4'd0;  // Start at 0°
        else if (is_auto) begin
            if (delay_done) begin
                if (light_lux > 39 && light_lux < 81) begin
                    current_value <= current_value; // hold
                end else if (light_lux < 40) begin
                    if (current_value > 0)
                        current_value <= current_value - 1;
							else if (current_value == 0)
							   current_value <= current_value;
								
                end else if (light_lux > 80) begin
                    if (current_value < 9)
                        current_value <= current_value + 1;
							else if (current_value == 9)
							 current_value <= current_value;
                end
            end
            // else: waiting for delay to complete → no change
        end else begin
            current_value <= chan;  // Manual override
        end
    end

    assign control_value = current_value;

    // Calculate PWM pulse width based on control_value
    logic [19:0] pulse_width;
    always_comb begin
        pulse_width = 30000 + (control_value * 11110);  // 0–9 → ~0°–180°
    end

    // 20ms PWM cycle (50 Hz)
    logic [19:0] counter;
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            counter <= 0;
        else if (counter >= 1_000_000)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    // PWM output
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            servo_pwm <= 0;
        else
            servo_pwm <= (counter < pulse_width);
    end

endmodule
