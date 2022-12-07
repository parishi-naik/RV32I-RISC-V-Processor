`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.11.2021 20:01:23
// Design Name: 
// Module Name: ControlUnit
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


module ControlUnit(
input clk,
input rst,
input [6:0]Instr,
input [2:0]funct3,
output reg Branch,
output reg MemRead,
output reg MemToReg,
output reg MemWrite,
output reg RegWrite,
output reg PCLoad
    );

parameter Fetch=0,Decode=1,Execute=2,Mem=3,WriteBack=4,Idle=5,Start=6;    

parameter Rtype=0,Itype=1,Stype=2,Btype=3,Utype=4,UJtype=5,SBtype=6,Ltype=7,Stop=8,NOP=9;

parameter
LUI	    =7'b0110111,
AUIPC	=7'b0010111,
JAL	    =7'b1101111,
JALR	=7'b1100111,
BEQ	    =7'b1100011,
BNE	    =7'b1100011,
BLT	    =7'b1100011,
BGE	    =7'b1100011,
BLTU	=7'b1100011,
BGEU    =7'b1100011,
LB		=7'b0000011,
LH	    =7'b0000011,
LW	    =7'b0000011,
LBU	    =7'b0000011,
LHU	    =7'b0000011,
SB	    =7'b0100011,
SH	    =7'b0100011,
SW	    =7'b0100011,
ADDI	=7'b0010011,
SLTI	=7'b0010011,
SLTIU   =7'b0010011,
XORI	=7'b0010011,
ORI	    =7'b0010011,
ANDI	=7'b0010011,
SLLI	=7'b0010011,
SRLI	=7'b0010011,
SRAI	=7'b0010011,
ADD	    =7'b0110011,
SUB	    =7'b0110011,
SLL	    =7'b0110011,
SLT	    =7'b0110011,
SLTU	=7'b0110011,
XOR	    =7'b0110011,
SRL	    =7'b0110011,
SRA	    =7'b0110011,
OR	    =7'b0110011,
AND	    =7'b0110011,
FENCE	=7'b0001111,
ECALL	=7'b1110011,
EBREAK	=7'b1110011;


reg [4:0]InstrType = NOP;

reg [3:0] state = Start;

initial begin
    MemRead <= 1'b0; 
    MemToReg <= 1'b0;
    MemWrite <= 1'b0;
    RegWrite <= 1'b0;
    PCLoad <= 1'b0;
    Branch <= 1'b0;
end

always @(Instr[6:0])
begin
    case (Instr[6:0])
        LUI,             
        AUIPC:begin
                InstrType <= Utype;
            end
            
        JAL:begin
                InstrType <= UJtype;                
            end

        JALR,
        FENCE,
        ECALL,
        EBREAK,
        ADDI,
        SLTI,
        SLTIU,
        XORI,
        ORI,
        ANDI,
        SLLI,
        SRLI,
        SRAI:begin
                if(Instr[6:0]==ECALL || Instr[6:0]==EBREAK)
                    InstrType <= Stop;
                else if(Instr[6:0]==FENCE) 
                    InstrType <= NOP;
                else
                    InstrType <= Itype;         
            end   
        
        BEQ,
        BNE,
        BLT,
        BGE,
        BLTU,
        BGEU:begin
                InstrType <= SBtype;                 
            end            

        LB,
        LH,
        LW,
        LBU,
        LHU:begin
                InstrType <= Ltype;        
            end
            
        SB,
        SH,
        SW:begin
                InstrType <= Stype;             
            end

        ADD,
        SUB,
        SLL,
        SLT,
        SLTU,
        XOR,
        SRL,
        SRA,
        OR,
        AND:begin
                InstrType <= Rtype;         
            end
            
    endcase
end

always @(posedge clk)
begin
    if(rst)
        state <= Start;
    else if(InstrType == Stop)
        state <= Idle;
    else
        case(state)
            Start,
            Fetch:begin 
                state <= Decode;
                end
            Decode:begin 
                state <= Execute;
                end
            Execute:begin 
                state <= Mem;
                end
            Mem:begin 
                state <= WriteBack;
                end
            WriteBack:begin 
                state <= Fetch;
                end
            Idle:begin 
                state <= Idle;
                end
        endcase
end

always @(state)
begin 
MemRead <= 1'b0; 
MemToReg <= 1'b0;
MemWrite <= 1'b0;
RegWrite <= 1'b0;
PCLoad <= 1'b0;

    case(state)
        Fetch:begin     
                if(InstrType != Stop)
                begin
                    PCLoad <= 1'b1;
                end
            end
        Decode:begin     
                
            end
        Execute:begin     
            case(InstrType)
                Rtype:begin
                    Branch <= 1'b0;                     
                    end
                Itype:begin
                    Branch <= 1'b0;                 
                    end
                Stype:begin
                    Branch <= 1'b0;                
                    end
                Btype:begin
                    Branch <= 1'b0;                  
                    end
                Utype:begin
                    Branch <= 1'b0; 
                    if(Instr[6:0]==LUI)
                        begin
                                                 
                        end
                    else
                        begin
                                                   
                        end
                    end
                UJtype:begin
                    Branch <= 1'b0; 
                                     
                    end
                SBtype:begin
                    Branch <= 1'b0; 
                                     
                    end
                Ltype:begin
                    Branch <= 1'b0; 
                                     
                    end                       
            endcase
            end
        Mem:begin     
                case(InstrType)
                    Rtype:begin  
                        MemRead <= 1'b0;
                        MemWrite <= 1'b0;                   
                        end
                    Itype:begin  
                        MemRead <= 1'b0;
                        MemWrite <= 1'b0;    
                        if(Instr[6:0]==JALR)  
                            Branch <= 1'b1;                     
                        end
                    Stype:begin  
                        MemRead <= 1'b0; 
                        MemWrite <= 1'b1;                    
                        end
                    Btype:begin  
                        Branch <= 1'b1;                   
                        end
                    Utype:begin  
                        MemRead <= 1'b0; 
                        MemWrite <= 1'b0;                    
                        end
                    UJtype:begin  
                        MemRead <= 1'b0; 
                        MemWrite <= 1'b0;    
                        if(Instr[6:0]==JAL)  
                            Branch <= 1'b1;                                       
                        end
                    SBtype:begin
                        Branch <= 1'b1;                    
                        end
                    Ltype:begin  
                        MemRead <= 1'b1; 
                        MemWrite <= 1'b0;                       
                        end                       
                endcase
            end
        WriteBack:begin     
                case(InstrType)
                    Rtype:begin
                        RegWrite <= 1'b1;                   
                        end
                    Itype:begin
                        RegWrite <= 1'b1;                                      
                        end
                    Stype:begin
                        RegWrite <= 1'b0;                   
                        end
                    Btype:begin
                        RegWrite <= 1'b0;  
                        Branch <= 1'b1;                   
                        end
                    Utype:begin
                        RegWrite <= 1'b1;                    
                        end
                    UJtype:begin
                        RegWrite <= 1'b1;                    
                        end
                    SBtype:begin
                        RegWrite <= 1'b0;                
                        end
                    Ltype:begin
                        RegWrite <= 1'b1;   
                        MemRead <= 1'b1;       
                        MemToReg <= 1'b1;                   
                        end                       
                endcase
            end
        Start,
        Idle:begin     
                case(InstrType)
                    Rtype:begin
                    
                        end
                    Itype:begin
                    
                        end
                    Stype:begin
                    
                        end
                    Btype:begin
                    
                        end
                    Utype:begin
                    
                        end
                    UJtype:begin
                    
                        end
                    SBtype:begin
                    
                        end
                    Ltype:begin
                    
                        end                       
                endcase
            end    
        
    endcase
end    
    
endmodule
