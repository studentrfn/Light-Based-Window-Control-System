module adcinterface(
    input logic clk, reset_n,   // 50 MHz Clock and reset
    input logic [2:0] chan,     // ADC channel to sample
    output logic [11:0] result, // ADC result

    // LTC2308 signals
    output logic ADC_CONVST, ADC_SCK, ADC_SDI,
    input logic ADC_SDO
);

    // State Definition
    typedef enum logic [1:0] {
        START_CONV   = 2'b00,
        WAIT_CONV    = 2'b01,
        TRANSFER     = 2'b10,  // 12 cycles (6 sending config + 12 reading data)
        WAIT_CYCLE   = 2'b11
    } state_t;

    state_t state;
    logic [15:0] config_word = 16'h2200 ;    // 16-bit config word
    logic [4:0] bit_count;                  // Cycle counter
	 logic state_c;

   

    // Control ADC_SCK (active during the transfer)
    assign ADC_SCK = (state_c) ? clk : 1'b0;  

    // FSM to handle ADC conversion
    always_ff @(negedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= START_CONV;
            ADC_CONVST <= 0;
            bit_count <= 0;
				state_c <= 0;
        end else begin
            case (state)
              
                START_CONV: begin
                    ADC_CONVST <= 1; // Pulse high to start conversion
						  config_word <= {1'b1,chan[0],chan[2:1],1'b1,1'b0,1'b0,1'b0,1'b0, 1'b0}; // Set config word
                    bit_count <= 1;         
                    state <= WAIT_CONV;
                end

                WAIT_CONV: begin
                    ADC_CONVST <= 1'b0; // Pulse low to complete conversion start
						  bit_count <= 2;
                    state <= TRANSFER;  // Start the transfer (sending + receiving data)

                end

                TRANSFER: begin
					 
							state_c <=1;
							
                    if (bit_count > 1  && bit_count < 15)
						 begin 
                        bit_count <= bit_count + 1; // Increment cycle bit_count for 12 cycles
								end
                    else 
                        state <= WAIT_CYCLE; // Go to WAIT_CYCLE after 12 cycles
                end

                WAIT_CYCLE: begin
					       state_c <=0;
                    if (bit_count == 15) 
                        bit_count <=0;
                    else begin
                        bit_count <= 0;
                        state <= START_CONV; // Back to START_CoNv after one cycle pause
                    end
                end
            endcase
			end
       end
    

    // Sample ADC_SDO and store result
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            result <= 12'b0;    // Reset result on reset
        else if (bit_count>2 && bit_count <15) 
            result[14-bit_count] <=  ADC_SDO; 
        
    end

    // Send Configuration Word on Falling Edge of clock (First 6 Cycles)
    always_ff @(negedge clk or negedge reset_n) begin
        if (!reset_n)
            ADC_SDI <= 1'b0;  // Ensure initial state for SDI
        else if (bit_count>1 && bit_count <8) 
            ADC_SDI <= config_word[11 - bit_count];  // Send the config bits (start with MSB)
        else 
          ADC_SDI <= 1'b0;
		
	end
endmodule
				
