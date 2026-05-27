module gerenciador_alarme(

    input clk,
    input rst,
    input sensor_atual,
    output reg alarme_ativo,
    output reg[7:0] q
);

    reg[7:0] ram[7:0];
    reg[2:0] addr_reg;
    reg[2:0] addr_reg_anterior;

    wire we;
    wire[7:0] dado;

    localparam IDLE = 2'b00, GRAVA_FASE1 = 2'b01, GRAVA_FASE2 = 2'b10, ALERTA = 2'b11;

    reg[1:0] estado_atual, proximo_estado;

    reg sensor_anterior;
    wire sensor_verdadeiro;

    assign sensor_verdadeiro = sensor_atual && !sensor_anterior;

    always @(posedge clk) begin // memoria
        case (estado_atual)
            GRAVA_FASE1:begin
                ram[addr_reg] <= 8'hAA;
                addr_reg_anterior <= addr_reg;
            end 
            GRAVA_FASE2:begin
                addr_reg <= addr_reg + 3'b001;
                ram[addr_reg] <= 8'hEE;
            end
            default:begin
                
            end
        endcase
    end

    always @(posedge clk, posedge rst)begin //seq
        if(rst)begin
            estado_atual <= IDLE;
            sensor_anterior <= 1'b0;
            alarme_ativo <= 1'b0;
            addr_reg <= 3'b000;
        end else begin
            estado_atual <= proximo_estado;
            sensor_anterior <= sensor_atual;
        end
    end

    always @(*)begin // comb

        proximo_estado = estado_atual;

        case(estado_atual)
            IDLE:begin
                if(sensor_verdadeiro)begin
                    proximo_estado = GRAVA_FASE1;
                end
            end
            GRAVA_FASE1:begin
                if(alarme_ativo)begin
                    proximo_estado = GRAVA_FASE2;
                end
            end
            GRAVA_FASE2:begin
                if(alarme_ativo)begin
                    proximo_estado = ALERTA;
                end
            end
            ALERTA:begin
                if(sensor_verdadeiro)begin
                    proximo_estado = GRAVA_FASE1;
                end
            end
            default:begin
                proximo_estado = IDLE;
            end
        endcase
    end

    always @(*) begin // output

        alarme_ativo = 1'b0;

        case(estado_atual)
            GRAVA_FASE1:begin
                alarme_ativo = 1'b1;
            end
            GRAVA_FASE2:begin
                alarme_ativo = 1'b1;
            end
            ALERTA:begin
                alarme_ativo = 1'b1;
            end
            default:begin
                alarme_ativo = 1'b0;
            end
        endcase
    end

    always @(*) begin
        q <= ram[addr_reg_anterior];
    end
endmodule