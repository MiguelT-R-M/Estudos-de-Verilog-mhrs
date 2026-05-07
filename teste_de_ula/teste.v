module ula(A, B, Seletor, result, Zero, Dontcare);

    input wire signed [4:0] A, B;
    input wire[2:0] Seletor;
    output reg signed [5:0] result;
    output reg Zero;
    inout wire[3:0] Dontcare;

    always @(*) begin
        case (Seletor)
            
            3'b000: result = A + B;
            3'b001: result = A - B;
            3'b010: result = ~B + 1;
            3'b011: result = (A==B)? 6'b000001: 6'b000000;
            3'b100: result = (A>B)? 6'b000001: 6'b000000;
            3'b101: result = (A<B)? 6'b000001: 6'b000000;
            3'b110: result = A & B;
            3'b111: result = A ^ B;

            default: result = 6'bxxxxxx;
        endcase
        Zero = (result == 6'b000000);
    end
endmodule