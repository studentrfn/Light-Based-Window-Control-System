`timescale 1ns / 1ps

module LuxReceiver_tb;

    // Testbench signals
    logic clk;
    logic reset_n;
    logic gpio_data;
    logic gpio_ready;
    logic [11:0] lux_value;

    // Instantiate the DUT (Device Under Test)
    LuxReceiver dut (
        .clk(clk),
        .reset_n(reset_n),
        .gpio_data(gpio_data),
        .gpio_ready(gpio_ready),
        .lux_value(lux_value)
    );

    // Clock generation
    always #5 clk = ~clk; // 100 MHz clock (10ns period)

    // Test Procedure
    initial begin
        // Initialize signals
        clk = 0;
        reset_n = 0;
        gpio_data = 0;
        gpio_ready = 0;

        // Step 1: Reset
        #20;
        reset_n = 1;

        // Step 2: Send 3-digit LUX data (Example: 320)
        #20;
        gpio_ready = 1;

        // Hundreds place (3)
        gpio_data = 1; #10;
        gpio_data = 1; #10;
        gpio_data = 0; #10;
        gpio_data = 0; #10;

        // Tens place (2)
        gpio_data = 1; #10;
        gpio_data = 0; #10;
        gpio_data = 1; #10;
        gpio_data = 0; #10;

        // Ones place (0)
        gpio_data = 0; #10;
        gpio_data = 0; #10;
        gpio_data = 0; #10;
        gpio_data = 0; #10;

        // De-assert "READY"
        gpio_ready = 0;

        // Display result
        #20;
        $display("✅ Test Completed");
        $display("LUX Value (Final) = %d", lux_value);

        $stop;
    end

endmodule
