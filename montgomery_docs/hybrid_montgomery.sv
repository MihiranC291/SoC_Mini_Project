`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.08.2025 18:17:41
// Design Name: 
// Module Name: hybrid_montgomery
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

module hybrid_montgomery #(
    parameter N = 1024,        // Total bit width
    parameter W = 32,          // Word/coefficient size
    parameter P = 12289        // Prime modulus for NTT
)(
    input logic clk,
    input logic rst,
    input logic start,
    output logic done,
    input logic [N-1:0] A,
    input logic [N-1:0] B,
    input logic [N-1:0] M,    // Modulus
    output logic [N-1:0] Y
);

    // FSM states
    typedef enum logic [2:0] {
        IDLE,
        LOAD,
        NTT,
        POINTWISE,
        INTT,
        DONE_ST
    } state_t;

    state_t current_state, next_state;

    // Control signals
    logic ntt_start, ntt_done;
    logic intt_start, intt_done;
    logic pw_start, pw_done;
    logic load_en;

    // Datapath signals
    logic [W-1:0][N-1:0] ntt_out, intt_in, intt_out;
    logic [W-1:0][N-1:0] pw_out;

    // Register banks
    logic [N-1:0] A_reg, B_reg, M_reg;
    logic [N-1:0] Y_reg;

    // NTT Engine
    ntt_engine #(.N(N), .W(W), .P(P)) ntt (
        .clk(clk),
        .rst(rst),
        .start(ntt_start),
        .done(ntt_done),
        .x(A_reg),
        .y(ntt_out)
    );

    // Pointwise Multiplier
    pointwise_mult #(.N(N), .W(W), .P(P)) pw (
        .clk(clk),
        .rst(rst),
        .start(pw_start),
        .done(pw_done),
        .a(ntt_out),
        .b(B_reg),
        .y(pw_out)
    );

    // Inverse NTT Engine
    intt_engine #(.N(N), .W(W), .P(P)) intt (
        .clk(clk),
        .rst(rst),
        .start(intt_start),
        .done(intt_done),
        .x(pw_out),
        .y(intt_out)
    );

    // FSM Controller
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= IDLE;
            A_reg <= '0;
            B_reg <= '0;
            M_reg <= '0;
            Y_reg <= '0;
        end else begin
            current_state <= next_state;
            
            if (load_en) begin
                A_reg <= A;
                B_reg <= B;
                M_reg <= M;
            end
            
            if (current_state == INTT && intt_done) begin
                Y_reg <= intt_out[0] % M_reg; // Final reduction
            end
        end
    end

    // FSM Next State Logic
    always_comb begin
        next_state = current_state;
        ntt_start = 0;
        pw_start = 0;
        intt_start = 0;
        load_en = 0;
        done = 0;

        case (current_state)
            IDLE: if (start) begin
                next_state = LOAD;
                load_en = 1;
            end
            
            LOAD: next_state = NTT;
            
            NTT: begin
                ntt_start = 1;
                if (ntt_done) next_state = POINTWISE;
            end
            
            POINTWISE: begin
                pw_start = 1;
                if (pw_done) next_state = INTT;
            end
            
            INTT: begin
                intt_start = 1;
                if (intt_done) next_state = DONE_ST;
            end
            
            DONE_ST: begin
                done = 1;
                next_state = IDLE;
            end
        endcase
    end

    assign Y = Y_reg;

endmodule

// NTT Engine (simplified)
module ntt_engine #(
    parameter N = 1024,
    parameter W = 32,
    parameter P = 12289
)(
    input logic clk,
    input logic rst,
    input logic start,
    output logic done,
    input logic [N-1:0] x,
    output logic [W-1:0][N-1:0] y
);
    // Implementation would include:
    // - Butterfly units
    // - Twiddle factor ROM
    // - Modular arithmetic units
    // Simplified for example:
    always_ff @(posedge clk) begin
        if (start) begin
            // Transform would happen here
            done <= 1;
        end
        if (rst) done <= 0;
    end
endmodule

// Pointwise Multiplier
module pointwise_mult #(
    parameter N = 1024,
    parameter W = 32,
    parameter P = 12289
)(
    input logic clk,
    input logic rst,
    input logic start,
    output logic done,
    input logic [W-1:0][N-1:0] a,
    input logic [N-1:0] b,
    output logic [W-1:0][N-1:0] y
);
    // Implementation would perform element-wise multiplication
    always_ff @(posedge clk) begin
        if (start) begin
            for (int i = 0; i < W; i++) begin
                y[i] <= (a[i] * b) % P;
            end
            done <= 1;
        end
        if (rst) done <= 0;
    end
endmodule

// Inverse NTT Engine
module intt_engine #(
    parameter N = 1024,
    parameter W = 32,
    parameter P = 12289
)(
    input logic clk,
    input logic rst,
    input logic start,
    output logic done,
    input logic [W-1:0][N-1:0] x,
    output logic [W-1:0][N-1:0] y
);
    // Similar to NTT but with different twiddle factors
    always_ff @(posedge clk) begin
        if (start) begin
            // Inverse transform would happen here
            done <= 1;
        end
        if (rst) done <= 0;
    end
endmodule   
