`timescale 1ns / 1ps


module datapath (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] instr_opcode,
    input  logic [ 3:0] controls,
    input  logic        wr_en,
    output logic [31:0] instr_rAddr


);

    logic [31:0] w_regfile_rd1, w_regfile_rd2, w_alu_result;
    logic [31:0] w_pc_addr;


    program_counter U_PC (
        .clk  (clk),
        .reset(reset),
        .d    (instr_rAddr),
        .pc   (instr_rAddr)
    );

    register_file U_REG_FILE (
        .clk  (clk),
        .RA1  (instr_opcode[19:15]),  // read address 1
        .RA2  (instr_opcode[24:20]),  // read address 2
        .WA   (instr_opcode[11:7]),   // write address
        .we   (wr_en),                // write enable
        .WData(w_alu_result),         // write data
        .RD1  (w_regfile_rd1),        // read data 1
        .RD2  (w_regfile_rd2)         // read data 2
    );

    ALU U_ALU (
        .a       (w_regfile_rd1),
        .b       (w_regfile_rd2),
        .controls(controls),
        .result  (w_alu_result)
    );




endmodule

module program_counter (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] d,
    output logic [31:0] pc
);
    wire [31:0] pc_4;
    assign pc_4 = d + 4;

    register U_PC_REG (
        .clk(clk),
        .reset(reset),
        .d(pc_4),
        .q(pc)
    );

endmodule


// Program counter
module register (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] d,
    output logic [31:0] q
);

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            q <= 0;
        end else begin
            q <= d;
        end
    end
endmodule


// Memory for calculate
module register_file (
    input  logic        clk,
    input  logic [ 4:0] RA1,    // read address 1
    input  logic [ 4:0] RA2,    // read address 2
    input  logic [ 4:0] WA,     // write address
    input  logic        we,     // write enable
    input  logic [31:0] WData,  // write data
    output logic [31:0] RD1,    // read data 1
    output logic [31:0] RD2     // read data 2
);

    logic [31:0] reg_file[0:31];  // 32bit 32개.

    initial begin
        reg_file[0] = 32'd0;
        reg_file[1] = 32'd1;
        reg_file[2] = 32'd2;
        reg_file[3] = 32'd3;
        reg_file[4] = 32'd4;
        reg_file[5] = 32'd5;
        reg_file[6] = 32'd6;
        reg_file[7] = 32'd7;
        reg_file[8] = 32'd8;
        reg_file[9] = 32'd9;
    end

    always_ff @(posedge clk) begin
        if (we) begin
            reg_file[WA] <= WData;
        end
    end

    assign RD1 = reg_file[RA1];
    assign RD2 = reg_file[RA2];

endmodule

module ALU (
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [ 3:0] controls,
    output logic [31:0] result
);

    enum logic [3:0] {
        ADD,
        SUB,
        SLL,   // Shift Left Logical
        SRL,   // Shift Right Logical
        SRA,   // Shift Right Arith
        SLT,   // Set Less Than
        SLTU,  // Set Less Than (U)
        XOR,
        OR,
        AND
    } alu_op;

    always_comb begin
        
        case (controls)
            ADD:     result = a + b; // 3 + 4 = 7 
            SUB:     result = a - b; // 3 - 4 = -1
            SLL:     result = a << b[4:0]; // ...0110 -> ...0110_0000
            SRL:     result = a >> b[4:0]; // ...0110 -> ...0000
            SRA:     result = $signed(a) >>> b[4:0]; // 000...0011 -> ...000
            SLT:     result = ($signed(a) < $signed(b)) ? 32'h1 : 32'h0; // result = 1
            SLTU:    result = (a < b) ? 32'h1 : 32'h0; // result = 1
            XOR:     result = a ^ b; // ...0111
            OR:      result = a | b; // ...0111
            AND:     result = a & b; // ...0000
            default: result = 32'bx;
        endcase

    end

endmodule


