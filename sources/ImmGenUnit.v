`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.11.2021 18:41:20
// Design Name: 
// Module Name: ImmGenUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ImmGenUnit(
input [31:0]instr,
output reg [31:0]imm
    );

wire [31:0] immediate=31'd0;

parameter   LUI=7'b0110111, AUIPC=7'b0010111, JAL=7'b1101111, JALR=7'b1100111, 
            BRANCH=7'b1100011, LOAD=7'b0000011, STORE=7'b0100011, ARITH=7'b0010011; 

always @(instr)
begin
    case (instr[6:0])
        LUI:begin
                imm <= {instr[31:12],12'h000};
            end
        AUIPC:begin
                imm <= {instr[31:12],12'h000};
            end
        JAL:begin
                imm <= {{12{instr[20]}},instr[10:1],instr[11],instr[19:12],1'b0};
            end
        JALR:begin
                imm <= {{20{instr[11]}},instr[11:0]};
            end
        BRANCH:begin
                imm <= {{19{instr[12]}},instr[12],instr[10:5],instr[4:1],instr[11],1'b0};
            end
        LOAD:begin
                imm <= {{20{instr[11]}},instr[11:0]};
            end
        STORE:begin
                imm <= {{20{instr[11]}},instr[11:5],instr[4:0]};
            end
        ARITH:begin
                imm <= {{20{instr[11]}},instr[11:0]};
            end
        default:begin
                imm <= 32'hDEADBEEF;
            end
    endcase
end
    
endmodule
