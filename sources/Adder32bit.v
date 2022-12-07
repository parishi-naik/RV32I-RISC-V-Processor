`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.11.2021 16:43:20
// Design Name: 
// Module Name: Adder32bit
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


module Adder32bit(
input [31:0]ip1,
input [31:0]ip2,
output [31:0]op
    );

assign op = ip1 + ip2;    
    
endmodule
