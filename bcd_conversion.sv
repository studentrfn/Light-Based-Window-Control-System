module bcd_conversion (
    input logic [11:0] lux_value,      // 12-bit binary input
    output logic [11:0] lux_value_bcd  // 12-bit BCD output
);

    logic [11:0] binary;
    logic [3:0] bcd_hundreds;
    logic [3:0] bcd_tens;
    logic [3:0] bcd_ones;

    always_comb begin
        binary = lux_value; // Initialize binary value
        bcd_hundreds = 4'b0;
        bcd_tens = 4'b0;
        bcd_ones = 4'b0;

        // Correct Double-Dabble Algorithm for Binary to BCD Conversion
        for (int i = 11; i >= 0; i--) begin
            // Add 3 if digit is >= 5 (Double Dabble Rule)
            if (bcd_hundreds >= 5)
                bcd_hundreds = bcd_hundreds + 3;
            if (bcd_tens >= 5)
                bcd_tens = bcd_tens + 3;
            if (bcd_ones >= 5)
                bcd_ones = bcd_ones + 3;

            // Shift BCD digits left by 1
            bcd_hundreds = {bcd_hundreds[2:0], bcd_tens[3]};
            bcd_tens = {bcd_tens[2:0], bcd_ones[3]};
            bcd_ones = {bcd_ones[2:0], binary[11]};

            // Shift binary left by 1
            binary = binary << 1;
        end
    end

    // Combine BCD digits into a 12-bit result
    assign lux_value_bcd = {bcd_hundreds, bcd_tens, bcd_ones};

endmodule
