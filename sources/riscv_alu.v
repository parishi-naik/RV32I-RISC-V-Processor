`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.11.2021 21:42:35
// Design Name: 
// Module Name: riscv_alu
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


module riscv_alu(   input [31:0] instruction, 
                    input clk, 
                    input [31:0] pc_in_alu, 
                    input [31:0] rs1_data, 
                    input [31:0] rs2_data, 
                    output reg [31:0] result, 
                    output [31:0] dest_address, 
                    output reg [31:0] pc_out_alu   );

wire [4:0] rs1 = instruction [19:15];
wire [4:0] rs2 = instruction [24:20];

wire signed [31:0] signed_rs1 = rs1_data;
wire signed [31:0] signed_rs2 = rs2_data;

wire [6:0] alu_opcode = instruction [6:0];

wire [2:0] funct3 = instruction [14:12];
wire [6:0] funct7 = instruction [31:25];

wire [31:0] immI = {{20{instruction[31]}}, instruction[31:20]};
wire [31:0] immU = {instruction [31:12], 12'b0};
wire [31:0] immS = {{20{instruction[31]}}, instruction [31:25], instruction [11:7]};
wire [31:0] immB = {{20{instruction[31]}}, instruction [7], instruction [30:25], instruction [11:8], 1'b0};
wire [31:0] immJ = {{12{instruction[31]}}, {instruction [19:12], instruction [20], instruction [30:21]}, 1'b0};

wire [31:0] pc_jump = (pc_in_alu + immB);
wire [31:0] pc_no_jump = (pc_in_alu + 4);

assign dest_address = (alu_opcode==7'b0000011)? (rs1_data + immI) : (rs1_data + immS);

always @ (posedge clk)
begin

case (alu_opcode)

7'b0110111: begin 
                result = immU; 
            end       //LUI

7'b0010111: begin 
                result = pc_in_alu + immU;
            end         //AUIPC

7'b1101111: begin 
                result = pc_in_alu + 4;                
                pc_out_alu = pc_in_alu + immJ; 
            end       //JAL
                  
7'b1100111: begin 
                result = pc_in_alu + 4;
                pc_out_alu = rs1_data + immI;
            end      //JALR                      

7'b1100011: begin if (funct3 == 3'b000) pc_out_alu = (rs1_data == rs2_data) ? pc_jump : pc_no_jump;       //BEQ
                  else if (funct3 == 3'b001) pc_out_alu = (rs1_data != rs2_data) ? pc_jump : pc_no_jump;       //BNE
                  else if (funct3 == 3'b100) pc_out_alu = ($signed(signed_rs1) < $signed(signed_rs2)) ? pc_jump : pc_no_jump;      //BLT - signed
                  else if (funct3 == 3'b101) pc_out_alu = ($signed(signed_rs1) >= $signed(signed_rs2)) ? pc_jump : pc_no_jump;      //BGE - signed
                  else if (funct3 == 3'b110) pc_out_alu = (rs1_data < rs2_data) ? pc_jump : pc_no_jump;        //BLTU - unsigned
                  else if (funct3 == 3'b111) pc_out_alu = (rs1_data >= rs2_data) ? pc_jump : pc_no_jump; end     //BGEU - unsigned 

7'b0000011: begin
                result = 32'h0;     //Load
            end

7'b0100011: begin
                result = rs2_data;  //Store
            end
            
7'b0010011: begin
                  if (funct3 == 3'b000) result = rs1_data + immI;        //ADDI
                  else if (funct3 == 3'b010) result = ($signed(signed_rs1) < immI) ? 1 : 0;     //SLTI - rs1 signed
                  else if (funct3 == 3'b011) result = (rs1_data < {12'b0, immI[11:0]}) ? 1 : 0;     //SLTUI - both unsigned
                  else if (funct3 == 3'b100) result = rs1_data ^ immI;       //XORI
                  else if (funct3 == 3'b110) result = rs1_data | immI;       //ORI
                  else if (funct3 == 3'b111) result = rs1_data & immI;       //ANDI
                  else if (funct3 == 3'b001) result = rs1_data << instruction [24:20];       //SLLI
                  else if (funct3 == 3'b101) begin
                                          if (funct7 == 7'b0) result = rs1_data >> instruction [24:20];       //SRLI
                                          else if (funct7 == 7'b0100000) result = $signed(signed_rs1) >>> instruction [24:20];       //SRAI - rs1 signed
                                          end
            end
            
7'b0110011: begin
                  if (funct3 == 3'b000) begin
                                     if (funct7 == 7'b0) result = (rs1_data + rs2_data);     //ADD
                                     else if (funct7 == 7'b0100000) result = rs1_data - rs2_data;      //SUB
                                     end
                  else if (funct3 == 3'b001) result = rs1_data << rs2_data[4:0];     //SLL
                  else if (funct3 == 3'b010) result = ($signed(signed_rs1) < $signed(signed_rs2)) ? 1 : 0;      //SLT - both signed
                  else if (funct3 == 3'b011) result = (rs1_data < rs2_data) ? 1 : 0;      //SLTU - both unsigned
                  else if (funct3 == 3'b100) result = rs1_data ^ rs2_data;        //XOR
                  else if (funct3 == 3'b101) begin
                                          if (funct7 == 0) result = rs1_data >> rs2_data [4:0];        //SRL
                                          else if (funct7 == 7'b0100000) result = $signed(signed_rs1) >>> rs2_data [4:0];      //SRA - both signed
                                          end
                  else if (funct3 == 3'b110) result = rs1_data | rs2_data;        //OR
                  else if (funct3 == 3'b111) result = rs1_data & rs2_data;        //AND
            end
                       
7'b0001111: result = result + 0;      //NOP
7'b1110011: begin if (immI == 0) result = result + 0;
                  else if (immI == 1) result = result + 0;
            end 

endcase
end
endmodule
