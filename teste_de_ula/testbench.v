`timescale 1ns/1ps

module ula_tb;
    reg [3:0] A, B;
    reg [2:0] Seletor;
    wire [3:0] result;
    wire Zero;

    ula dut(.A(A), .B(B), .Seletor(Seletor), .result(result), .Zero(Zero));

    initial begin
        $dumpfile("simulation.vcd");
        $dumpvars(0, ula_tb);

        $dumpfile("simulation.vcd");
        $dumpvars(0, ula_tb);

        // Test Case 1: AND operation (3'b000)
        A = 4'b1101; B = 4'b1011; Seletor = 3'b000;
        #10; // Wait 10 time units

        // Test Case 2: Default/Zero check
        A = 4'b1101; B = 4'b0000; Seletor = 3'b001;
        #10;

        $finish; // End simulation
    end
endmodule