
module decode7 (
    input logic [3:0] num,  // four bits number
    output logic [7:0] leds // activation of 7 segment display
);

// combinational logic
// match the numbers (0-9) with LEDS to display


    always_comb begin
            
        case (num)
            4'd0: leds = 8'h3F; // 0
            4'd1: leds = 8'h06; // 1
            4'd2: leds = 8'h5B; // 2
            4'd3: leds = 8'h4F; // 3
            4'd4: leds = 8'h66; // 4
            4'd5: leds = 8'h6D; // 5
            4'd6: leds = 8'h7D; // 6
            4'd7: leds = 8'h07; // 7
            4'd8: leds = 8'h7F; // 8
            4'd9: leds = 8'h6F; // 9
            4'd10: leds = 8'h77; // A
            4'd11: leds = 8'h7C; // B
            4'd12: leds = 8'h39; // C
            4'd13: leds = 8'h5E; // D
            4'd14: leds = 8'h79; // E
            4'd15: leds = 8'h71; // F
            default: leds = 8'h00; // All LEDs off

        endcase
    end
endmodule
