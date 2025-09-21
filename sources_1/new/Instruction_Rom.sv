`timescale 1ns / 1ps


module instr_mem (
    input  logic [31:0] instr_rAddr,
    output logic [31:0] instr_opcode
);

    logic [31:0] rom [0:63];

    // assign instr_opcode = rom[instr_rAddr];
    assign instr_opcode = rom[instr_rAddr[31:2]];

    initial begin
        rom[0] = 32'h004182B3; // add  x5, x3, x4
        rom[1] = 32'h404182B3; // sub  x5, x3, x4
        rom[2] = 32'h004192B3; // sll  x5, x3, x4
        rom[3] = 32'h0041D2B3; // srl  x5, x3, x4
        rom[4] = 32'h4041D2B3; // sra  x5, x3, x4
        rom[5] = 32'h0041A2B3; // slt  x5, x3, x4
        rom[6] = 32'h0041B2B3; // sltu x5, x3, x4
        rom[7] = 32'h0041C2B3; // xor  x5, x3, x4
        rom[8] = 32'h0041E2B3; // or   x5, x3, x4
        rom[9] = 32'h0041F2B3; // and  x5, x3, x4        
    end


endmodule






