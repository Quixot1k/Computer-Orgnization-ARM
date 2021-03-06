`timescale 1ns / 1ps

module ALU_barrelShifter(
    input clk,Rst,LF,S,ALU_A_s,ALU_B_s,
    input [32:1] Shift_Data,
    input [8:1] Shift_Num,
    input [3:1] SHIFT_OP,
    input [4:1] ALU_OP,
    input [31:0] A_New,PC,
    input CF,VF,
    input [23:0] imm24,
    output reg [3:0] NZCV,
    output reg [31:0] F,
    output [31:0] Shift_Out
);
    
    wire Shift_Carry_Out;
    wire [3:0] NZCV_New;
    wire [31:0] F_New,A,B;
    
    barrelShifter barrelShifter_Instance(
        .SHIFT_OP(SHIFT_OP),
        .Shift_Data(Shift_Data),
        .Shift_Num(Shift_Num),
        .Carry_flag(CF),
        .Shift_Out(Shift_Out),
        .Shift_Carry_Out(Shift_Carry_Out)
    );
    
    ALU ALU_Instance(
        .ALU_OP(ALU_OP),
        .A(A),
        .B(B),
        .Shift_Carry_Out(Shift_Carry_Out),
        .CF(CF),
        .VF(VF),
        .NZCV(NZCV_New),
        .F(F_New)
    );
    
    assign A = ALU_A_s ? PC : A_New;
    assign B = ALU_B_s ? {{6{imm24[23]}},imm24,2'b00} : Shift_Out;
    
    
    always@(negedge clk or posedge Rst)
        if (Rst)
            NZCV <= 0;
        else if (S)
            NZCV <= NZCV_New;
    
    always@(negedge clk or posedge Rst)
        if (Rst)
            F <= 0;
        else if (LF)
            F <= F_New;
    
endmodule
