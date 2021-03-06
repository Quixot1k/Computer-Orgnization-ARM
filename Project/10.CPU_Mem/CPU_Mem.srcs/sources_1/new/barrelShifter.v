`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module barrelShifter(    
    // INPUT
    input [31:0] Shift_Data, // Shift Data
    input [7:0] Shift_Num, // Shift bits
    // SHIFT_OP[2:1] shift function 
    // SHIFT_OP[0] decide shift bits with Shift_Num
    input [2:0] SHIFT_OP, //Shift OP
    input Carry_flag,
    // OUTPUT
    output reg [31:0] Shift_Out,
    output reg Shift_Carry_Out
);
    
    always@(*) begin
    case(SHIFT_OP[2:1])
        2'b00: begin
            if (Shift_Num == 0) begin
                Shift_Out <= Shift_Data;
                Shift_Carry_Out <= 1'bx;
            end
            else if (Shift_Num >= 1 && Shift_Num <= 32) begin
                Shift_Out <= (Shift_Data << Shift_Num);
                Shift_Carry_Out <= Shift_Data[32-Shift_Num];
            end
            else begin
                Shift_Out <= 0;
                Shift_Carry_Out <= 0;
            end
        end
            
        2'b01: begin
            if (Shift_Num == 0 && SHIFT_OP[0] == 1) begin
                    Shift_Out <= Shift_Data;
                    Shift_Carry_Out <= 1'bx;
            end
            else if (Shift_Num == 0 && SHIFT_OP[0] == 0) begin
                Shift_Out <= 0;
                Shift_Carry_Out <= Shift_Data[31];
            end
            else if (Shift_Num >= 1 && Shift_Num <= 32) begin
                Shift_Out <= (Shift_Data >> Shift_Num);
                Shift_Carry_Out <= Shift_Data[Shift_Num-1];
            end
            else begin
                Shift_Out <= 0;
                Shift_Carry_Out <= 0;
            end
        end
            
        2'b10: begin
            if (Shift_Num == 0 && SHIFT_OP[0] == 1) begin
                Shift_Out <= Shift_Data;
                Shift_Carry_Out <= 1'bx;
            end
            if (Shift_Num == 0 && SHIFT_OP[0] == 0) begin
                Shift_Out <={32{Shift_Data[31]}};
                Shift_Carry_Out <= Shift_Data[31];
            end
            else if (Shift_Num >= 1 && Shift_Num <= 31) begin
                Shift_Out <= ({{32{Shift_Data[31]}},Shift_Data}>>Shift_Num);
                Shift_Carry_Out <= Shift_Data[Shift_Num-1];
            end
            else begin
                Shift_Out <= {32{Shift_Data[31]}};
                Shift_Carry_Out <= Shift_Data[31];
            end
        end
            
        2'b11: begin
            if (Shift_Num == 0 && SHIFT_OP[0] == 1) begin
                    Shift_Out <= Shift_Data;
                    Shift_Carry_Out <= 1'bx;
            end
            else if (Shift_Num == 0 && SHIFT_OP[0] == 0) begin
                    Shift_Out <= {Carry_flag, Shift_Data[31:1]};
                    Shift_Carry_Out <= Shift_Data[0];
            end
            else if (Shift_Num >= 1 && Shift_Num <= 32) begin
                Shift_Out <= ({Shift_Data,Shift_Data}>>Shift_Num);
                Shift_Carry_Out <= Shift_Data[Shift_Num-1];
            end
            else begin
                Shift_Out <= ({{32{Shift_Data}},Shift_Data}>>Shift_Num[4:0]);
                Shift_Carry_Out <= Shift_Data[Shift_Num[4:0]-1];
            end
        end
    endcase
    end
endmodule
