`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.11.2021 17:28:49
// Design Name: 
// Module Name: ProgramCounter
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


module ProgramCounter(
input clock,
input rst,
input pc_load,
input [31:0] pc_in,
output [31:0] pc_out
);

reg [31:0]pc=32'h01000000;

assign pc_out = pc;

always @(posedge clock or posedge rst)
begin
    if(rst)
        pc <= 32'h01000000;
    else if(pc_load)
        pc <= pc_in;
end
endmodule
