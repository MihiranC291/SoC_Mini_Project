`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.08.2025 18:18:31
// Design Name: 
// Module Name: tb_hybrid_montgomery
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns/1ps

module tb_hybrid_montgomery;
    parameter N = 32;  // Smaller for simulation speed
    parameter W = 8;
    parameter P = 17;  // Smaller prime for testing
    
    logic clk, rst, start, done;
    logic [N-1:0] A, B, M, Y;
    
    hybrid_montgomery #(.N(N), .W(W), .P(P)) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(done),
        .A(A),
        .B(B),
        .M(M),
        .Y(Y)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test cases
    initial begin
        // Initialize
        rst = 1;
        start = 0;
        A = 0;
        B = 0;
        M = 0;
        #20 rst = 0;
        
        // Test Case 1: Small numbers (17*19 mod 23)
        $display("\nTest Case 1: 17 * 19 mod 23");
        A = 17;
        B = 19;
        M = 23;
        #10 start = 1;
        #10 start = 0;
        
        wait(done);
        $display("Result: %0d (Expected: 8)", Y);
        if (Y !== 8) $error("Test Case 1 Failed");
        else $display("Test Case 1 Passed");
        
        // Test Case 2: Larger numbers (123*456 mod 789)
        #100;
        $display("\nTest Case 2: 123 * 456 mod 789");
        A = 123;
        B = 456;
        M = 789;
        #10 start = 1;
        #10 start = 0;
        
        wait(done);
        $display("Result: %0d (Expected: 699)", Y);
        if (Y !== 699) $error("Test Case 2 Failed");
        else $display("Test Case 2 Passed");
        
        // Finish simulation
        #100;
        $display("\nSimulation Complete");
        $finish;
    end
    
    // Monitor
    always @(posedge clk) begin
        if (start) begin
            $display($time, " Starting calculation: A=%0d, B=%0d, M=%0d", A, B, M);
        end
        if (done) begin
            $display($time, " Calculation done: Result=%0d", Y);
        end
    end
endmodule
