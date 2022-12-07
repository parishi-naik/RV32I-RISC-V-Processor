`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2021 01:31:28 PM
// Design Name: 
// Module Name: imem
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


module imem(
    input wire clk,
    input  wire[31:0] addr,
	output reg[31:0] data
    );
    wire [1:0]ch;
    wire rd_en;
    wire[31:0]div;
    reg[31:0] rom[0:500];
    initial begin
    $readmemh("main.mem", rom);
    /*
    rom[0]=32'h00001537;
    rom[1]=32'h00001537;
    rom[2]=32'h08c0006f;
    rom[3]=32'h00008067;
    rom[4]=32'h08a98263;
    rom[5]=32'h08051063;
    rom[6]=32'h06054e63;
    rom[7]=32'h06055c63;
    rom[8]=32'h06056a63;
    rom[9]=32'h06057863;
    rom[10]=32'h00810703;
    rom[11]=32'h00811703;
    rom[12]=32'h00812703;
    rom[13]=32'h00814703;
    rom[14]=32'h00815703;
    rom[15]=32'h00e10423;
    rom[16]=32'h00e11423;
    rom[17]=32'h00e12423;
    rom[18]=32'h00198993;
    rom[19]=32'h0019a993;
    rom[20]=32'h0019b993;
    rom[21]=32'h0019c993;
    rom[22]=32'h0019e993;
    rom[23]=32'h0019f993;
    rom[24]=32'h00199993;
    rom[25]=32'h0019d993;
    rom[26]=32'h4019d993;
    rom[27]=32'h002080b3;
    rom[28]=32'h402080b3;
    rom[29]=32'h002090b3;
    rom[31]=32'h0020a0b3;
    rom[32]=32'h0020b0b3;
    rom[33]=32'h0020c0b3;
    rom[34]=32'h0020d0b3;
    rom[35]=32'h4020d0b3;
    rom[36]=32'h0020e0b3;
    rom[37]=32'h0020f0b3;
    rom[38]=32'h0ff0000f;
    rom[39]=32'h00000073;
    rom[40]=32'h00100073; */
    end
    
    assign ch = addr[1:0];
    
    // This is the address translation logic it converts the hexadecimal address into index that can be used to get elements from ROM. 
    //so the address 0x01000000 should translate to 0 , 0x01000004 should translate to 1 and so on
    assign div = (addr>>2) - 32'd4194304;
    
    assign rd_en = (ch==2'b00)?1'b1:1'b0;
    
    always @(posedge clk) begin    
        if (rd_en)begin
            data = rom[div];
        end
//        else begin
//            $display("addr not word aligned %b",ch);
//        end
		
	end

endmodule
