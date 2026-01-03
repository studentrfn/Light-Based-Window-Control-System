module LuxReceiver (
    input logic clk,             // System clock (50 MHz)
    input logic reset_n,         // Active-low reset
    input logic gpio_data,       // Incoming data from Tiva
    input logic manual_clk,      // Manual Clock signal
    input logic gpio_ready,      // "READY" signal from Tiva
    output logic [11:0] lux_value // 12-bit LUX value
);

    logic [11:0] shift_reg;     // Single 12-bit shift register
    logic [3:0] bit_count;      // Track total received bits (0-11)

    always_ff @(posedge manual_clk or negedge reset_n) begin
        if (!reset_n) begin
            shift_reg <= 12'b0;
            lux_value <= 12'b0;
            bit_count <= 0;
        end 
        else if (gpio_ready) begin
            shift_reg <= {shift_reg[10:0], gpio_data};  // Shift in data
            
            if (bit_count == 11) begin
                lux_value <= {shift_reg[10:0], gpio_data};  // Capture last bit in value
                bit_count <= 0;         
                shift_reg <= 12'b0;     // Reset shift register
            end 
            else begin
                bit_count <= bit_count + 1;
            end
        end
    end
endmodule


