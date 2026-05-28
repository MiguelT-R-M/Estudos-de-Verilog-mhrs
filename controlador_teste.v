module controlador_teste(

    input clk,
    input rst,
    input atual, 
    output reg pass

);

    localparam beginning = 2'b00, middle = 2'b01, ending = 2'b10;

    reg[1:0] estado_atual, proximo_estado;
    reg passado;
    wire verdadeiro;

    assign verdadeiro = atual && !passado;

    always @(posedge clk, posedge rst)begin
        if(rst)begin
            pass <= 1'b0;
            passado <= 1'b0;
        end else begin
            proximo_estado <= estado_atual;
            passado <= atual;
        end
    end

    always @(*)begin

        proximo_estado = estado_atual;

        case(estado_atual)
            beginning:begin
                if(atual)begin
                    proximo_estado = middle;
                end
            end
            middle:begin
                if(atual)begin
                    proximo_estado = ending;
                end
            end
            ending:begin
                proximo_estado = beginning;
            end
            default:begin
                proximo_estado = beginning;
            end
        endcase
    end

    always @(*)begin
        if(estado_atual == ending)begin
            pass = 1'b1;
        end else begin
            pass = 1'b0;
        end
    end
endmodule