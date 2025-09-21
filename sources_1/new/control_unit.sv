`timescale 1ns / 1ps


module control_unit (
    input  logic [31:0] instr_opcode,
    output logic [ 3:0] controls,
    output logic        wr_en
);
    wire [6:0] funct7 = instr_opcode[31:25];
    wire [2:0] funct3 = instr_opcode[14:12];
    wire [6:0] opcode = instr_opcode[6:0];


    always_comb begin
        case (opcode)
            7'b0110011: wr_en = 1'b1;  // R-type
            default: wr_en = 1'b0;
        endcase

    end

    always_comb begin
        case (opcode)
            7'b0110011: begin  // R-type
                case ({
                    funct7, funct3
                })
                    10'b0000000_000: controls = 4'b0000;  // ADD
                    10'b0100000_000: controls = 4'b0001;  // SUB
                    10'b0000000_001: controls = 4'b0010;  // SLL
                    10'b0000000_101: controls = 4'b0011;  // SRL
                    10'b0100000_101: controls = 4'b0100;  // SRA
                    10'b0000000_010: controls = 4'b0101;  // SLT
                    10'b0000000_011: controls = 4'b0110;  // SLTU
                    10'b0000000_100: controls = 4'b0111;  // XOR
                    10'b0000000_110: controls = 4'b1000;  // OR
                    10'b0000000_111: controls = 4'b1001;  // AND
                    default: controls = 4'bx;  // 정의되지 않은 명령어
                endcase
            end
            default: controls = 4'bx;
        endcase
    end


endmodule
