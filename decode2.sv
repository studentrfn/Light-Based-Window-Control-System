module decode2 (
    input logic [1:0] digit, // design 2-to-4 decoder
    output logic [3:0] ct);  // 4 digit on the screen

	 
// combinational logic with always
// to activate digit on the screen
// active low signal
    always_comb begin 
        case (digit)
            2'b00: ct = 4'b1110; // left most dihit
            2'b01: ct = 4'b1101; // second
            2'b10: ct = 4'b1011; // third
            2'b11: ct = 4'b0111; // right most digit
            default: ct = 4'b1111; 
        endcase
    end
endmodule