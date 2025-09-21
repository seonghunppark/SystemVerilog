`timescale 1ns / 1ps

module RV32I_TOP (
    input logic clk,
    input logic reset

);
    logic [31:0] instr_opcode, instr_rAddr;
    logic [3:0] controls;
    logic wr_en;

    control_unit U_Control_Unit (.*);
    datapath U_Data_Path (.*);
    instr_mem U_Instr_Mem (.*);



endmodule
