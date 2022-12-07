`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2021 11:30:36 PM
// Design Name: 
// Module Name: Dmem
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


module Dmem(
    input wire[0:1] datatype,
    input wire clk, // this is the clock signal, to read and write from data memory over posedge
    input wire memread,//this the memread signal, this is generated from the DECODE stage. 
                       // If this is set to 1 it's a LOAD instruction and we want to load 
                        //some data from the Data memory at a particular address into a register
    input wire memwrite, // This is the memwrite signal, this is also generated from the DECODE STAGE.
                         //if this is set to 1 it means the instruction is a store instruction, and we want to write at a address in the data memory.
    input wire[31:0] addr, // this is the 32 bit address, deducted from the instruction, which is used to read or write to data memory
    input wire[31:0] writedata,// in case of store instruction this is the data that is to be written at address ADDR
    
    input wire[16:0] sw,
    output wire[16:0] led,
    
    output reg[31:0] data // incase of LOAD instruction we want to read from the datamemory, this is the reg that stores that read value.
    );
    
    reg [16:0] led_reg;
    
    wire[31:0] trans_addr; // this is an intermediary reg which is used to store the translated address, as address that we get from addr cannot be used to index the DMEM RAM.
    wire[0:1] remainder;
    reg [31:0] READ_O[0:2];// this is the readonly memory used to store the N numbers
    
    assign led = led_reg;
    
    initial begin 
    READ_O[0] = 32'h0126077c; // N number of first members of the group converted into HEX (19269500)
    READ_O[1] = 32'h0119D87C; //// N number of second members of the group converted into HEX (18471111)
    READ_O[2] = 32'h070fb9c7; // N number of third members of the group converted into HEX (11826908)
    end
    
    reg [7:0] DMEM0[0:1000]; // we initialize the data memory with all elements as 0s except the first three. the length of the DMEM is 1000 which can hold upto 4KBytes or 1000 words.
    reg [7:0] DMEM1[0:1000];
    reg [7:0] DMEM2[0:1000];
    reg [7:0] DMEM3[0:1000];
    integer i=0;
    
    initial begin
    for(i=0;i<1000;i=i+1)
    begin
        DMEM0[i]<=0;
        DMEM1[i]<=0;
        DMEM2[i]<=0;
        DMEM3[i]<=0;
    end
    DMEM0[0] <= 8'h01;
    DMEM0[1] <= 8'h02; 
    DMEM0[2] <= 8'h03;      
    end
  
assign remainder = addr[1:0];
assign trans_addr = (addr - 32'h80000000)>>2;/*This simple logic translates the HEX address like 0x80000000 into indexes as 0.
   the value that we are subtraction from addr is nothing but 0x80000000 converted into decimal. this will give us 0x80000001 -> 1 , 0x80000002 -> 2 and so on*/

always @(posedge clk)
    begin   
        if (addr >= 32'h80000000)
        begin
            if (memwrite == 1'd1) 
            begin 
                if (remainder ==0)
                begin
                    if (datatype == 0)
                    begin
                        DMEM0[trans_addr]=writedata[7:0]; 
                    end
                    else if (datatype == 1)
                    begin
                        DMEM0[trans_addr]=writedata[7:0];
                        DMEM1[trans_addr]=writedata[15:8];
                    end
                    else
                    begin
                        DMEM0[trans_addr]=writedata[7:0];
                        DMEM1[trans_addr]=writedata[15:8];
                        DMEM2[trans_addr]=writedata[23:16];
                        DMEM3[trans_addr]=writedata[31:24]; 
                    end
                end
    
                if (remainder == 1)
                begin 
                    if (datatype == 0)
                        begin
                            DMEM1[trans_addr]=writedata[7:0]; 
                        end
                    else if (datatype == 1)
                        begin
                            DMEM1[trans_addr]=writedata[7:0];
                            DMEM2[trans_addr]=writedata[15:7];
                        end
                      
                    else 
                        begin
                        $display("error 1");
                        end
                end
       
                if (remainder == 2)
                begin 
                    if (datatype == 0)
                    begin
                        DMEM2[trans_addr]=writedata[7:0]; 
                    end
                    else if (datatype == 1)
                    begin
                        DMEM2[trans_addr]=writedata[7:0];
                        DMEM3[trans_addr]=writedata[15:7];
                    end      
                    else 
                    begin
                        $display("error 1");
                    end
                end
        
             if (remainder == 3)
                begin 
                    if (datatype == 0)
                        begin
                            DMEM3[trans_addr]=writedata[7:0]; 
                        end
                    else if (datatype == 1)
                        begin
                             $display("error 2");
                        end
                      
                    else 
                        begin
                        $display("error 2");
                        end
                end     
            end
  
            if (memread == 1'd1) 
            begin
                data = {DMEM3[trans_addr],DMEM2[trans_addr],DMEM1[trans_addr],DMEM0[trans_addr]};
            end  
        end
  
        else 
        begin
            if (memread == 1'd1)
                begin
                    case(addr)
                    32'h00100000:begin
                            data = READ_O[0];
                        end
                    32'h00100004:begin
                            data = READ_O[1];
                        end
                    32'h00100008:begin
                            data = READ_O[2];
                        end 
                    32'h00100010: begin
                            data = sw;
                        end
                    32'h00100014: begin
                            data = led_reg;
                        end
                    endcase
                end
                
            else if (memwrite == 1'd1) 
            begin
                led_reg[15:0]=writedata[15:0];
            end 
        end      
    end  
endmodule
