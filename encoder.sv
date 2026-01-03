module encoder (
    input logic clk,         // Clock signal
    input logic a, b,        // Rotary encoder inputs
    output logic cw, ccw     // Clockwise and counterclockwise pulses
);

    // Store previous values of a and b
    logic [1:0] prev_state, curr_state;

    always_ff @(posedge clk) begin
        prev_state <= curr_state;
        curr_state <= {a, b};  // Capture current encoder state
    end

    always_ff @(posedge clk) begin
        cw <= 1'b0;
        ccw <= 1'b0;

        //  original clockwise (cw) logic unchanged
        if ((prev_state == 2'b00 && curr_state == 2'b01) ||  // 00 → 01
            (prev_state == 2'b01 && curr_state == 2'b11) ||  // 01 → 11
            (prev_state == 2'b11 && curr_state == 2'b10) ||  // 11 → 10
            (prev_state == 2'b10 && curr_state == 2'b00))    // 10 → 00
        begin
            ccw <= 1'b1; 
        end

        // counterclockwise (ccw) detection
        if ((prev_state == 2'b00 && curr_state == 2'b10) ||  // 00 → 10
            (prev_state == 2'b10 && curr_state == 2'b11) ||  // 10 → 11
            (prev_state == 2'b11 && curr_state == 2'b01) ||  // 11 → 01
            (prev_state == 2'b01 && curr_state == 2'b00))    // 01 → 00
        begin
            cw <= 1'b1;
        end
    end

endmodule

