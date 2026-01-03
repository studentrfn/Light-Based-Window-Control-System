`
// Irfan Hacioglu 9 Feb 2025
// Testbench for enc2freq_tb

timescale 1ms/1ms

// Testbench for enc2freq
module enc2freq_tb;

    logic cw, ccw;
    logic [31:0] freq;
    logic reset_n, clk = 0;
    
    // Instantiate the enc2freq module
    enc2freq dut (
        .cw(cw),
        .ccw(ccw),
        .freq(freq),
        .reset_n(reset_n),
        .clk(clk)
    );
    
    // Generate clock signal
    always #5 clk = ~clk;
    
    initial begin
        reset_n = 0;
        #20;
        reset_n = 1;

        // Increase frequency
        #20; cw = 1; #10; cw = 0;
        #20; cw = 1; #10; cw = 0;
        #20; cw = 1; #10; cw = 0;
        #20; cw = 1; #10; cw = 0;
        
        #20; cw = 1; #10; cw = 0;
        #20; cw = 1; #10; cw = 0;
        #20; cw = 1; #10; cw = 0;
        #20; cw = 1; #10; cw = 0;
        #20; cw = 1; #10; cw = 0;
        
        // Increase frequency
        #20; cw = 1; #10; cw = 0;
        #20; cw = 1; #10; cw = 0;
        #20; cw = 1; #10; cw = 0;
        #20; cw = 1; #10; cw = 0;
        
        #20; cw = 1; #10; cw = 0;
        #20; cw = 1; #10; cw = 0;
        #20; cw = 1; #10; cw = 0;
        #20; cw = 1; #10; cw = 0;
        #20; cw = 1; #10; cw = 0;
        
        // Decrease frequency
        #20; ccw = 1; #10; ccw = 0;
        #20; ccw = 1; #10; ccw = 0;
        #20; ccw = 1; #10; ccw = 0;
        #20; ccw = 1; #10; ccw = 0;
        
        $stop;
    end

    initial begin
        $monitor("Time=%0t | cw=%b | ccw=%b | freq=%d", $time, cw, ccw, freq);
    end
endmodule

