module controlador_catraca(

input clk,
input rst,
input credito,
input passou,
output reg liberar,
input we,
input[3:0] addr,
input[7:0] ID,
output reg[7:0] q

);
    localparam bloqueado_begin = 2'b00, bloqueado_mid = 2'b01, livre = 2'b10;

    reg [1:0] estado_atual, proximo_estado;

    reg credito_anterior;

    wire credito_verdadeiro;

    assign credito_verdadeiro = credito && !credito_anterior;

    reg[7:0] ram[15:0]; // ram de 16 bits, que recebe um dado de 8 bits 
    reg[3:0] addr_reg; // registro do endereço atual

    always @(posedge clk) begin // memoria
        if(we && passou)begin
            ram[addr]<=ID;
        end

        addr_reg<=addr;
    end

    always @(posedge clk, posedge rst) begin // sequencial
        if(rst)begin
            estado_atual <= bloqueado_begin;
            credito_anterior <= 1'b0;
        end else begin
            credito_anterior <= credito;
            estado_atual <= proximo_estado;
        end
    end

    always @(*)begin // combinacional
        proximo_estado = estado_atual;

        case(estado_atual)
            bloqueado_begin:begin
                if(credito_verdadeiro)
                    proximo_estado = bloqueado_mid;
            end
            bloqueado_mid:begin
                if(credito_verdadeiro)
                    proximo_estado = livre;
            end
            livre:begin
                if(passou)
                    proximo_estado = bloqueado_begin;
            end
            default:begin
                proximo_estado = bloqueado_begin;
            end
        endcase
    end

    always @(*)begin // output
        if(estado_atual == livre)begin
            liberar = 1'b1;
        end else begin
            liberar = 1'b0;
        end
    end

    always @(posedge clk) begin // output mem
        q <= ram[addr_reg];
    end

endmodule 