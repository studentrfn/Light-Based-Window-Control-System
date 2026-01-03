module enc2bcd (
    input logic clk,               
    input logic cw,                
    input logic ccw,               
    output logic [7:0] bcd         
);

    logic [7:0] binary_count;      
	 logic [1:0] pulse_count1;
	 logic [1:0] pulse_count2;
    logic [3:0] tens;              
    logic [3:0] ones;              

    always_ff @(posedge clk) begin
        
        if (cw) begin
            pulse_count1 <= pulse_count1 + 1'b1;
				pulse_count2 <= 2'b00; 
            if (pulse_count1 == 2'b11) begin     
                if (binary_count < 8'd99) begin
                    binary_count <= binary_count + 1'b1;  
						 
						  
					end
            end
        end else if (ccw) begin
            pulse_count2 <= pulse_count2 + 1'b1;
				pulse_count1 <= 2'b00; 
            if (pulse_count2 == 2'b11) begin     
                if (binary_count > 8'd0) begin
                    binary_count <= binary_count - 1'b1;  
						 
					 end
				end	 
        end

       
        if (binary_count > 8'd99) begin
            binary_count <= 8'd99;  
        end else if (binary_count < 8'd0) begin
            binary_count <= 8'd0;   
        end
    end

   
    always_comb begin
        tens = binary_count / 10;  
        ones = binary_count % 10;  
        bcd = {tens, ones};        
    end

endmodule


