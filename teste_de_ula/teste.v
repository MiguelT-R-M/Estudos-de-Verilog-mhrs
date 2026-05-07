module ula(input wire[3:0] A, input wire[3:0] B, input wire[2:0] Seletor, output reg[3:0] result, output reg Zero, inout wire[3:0] useless);

    always @(*) begin
        case (Seletor)
            
            3'b000: result = A & B;
            3'b001: result = A | B;

            default: result = 4'b0000;
        endcase
        Zero = (result == 4'b0000);
    end
endmodule