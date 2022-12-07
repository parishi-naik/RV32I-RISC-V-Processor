`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.12.2021 15:28:25
// Design Name: 
// Module Name: top_module_tb
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


module top_module_tb();

integer i=0;

//Temporary testbench signals
reg t_clk,t_rst=0;
wire t_Branch,t_MemRead,t_MemtoReg,t_MemWrite,t_ALUScr1,t_ALUScr2,t_RegWrite,t_PCLoad;
wire [31:0] t_instr;

//File pointer
integer fp;

//File read signals
reg [31:0] f_instr;      //used as test case number

top_module TM(  .clk(t_clk),.rst(t_rst));
//top_module TM(  .clk(t_clk),
//                .Instr(t_instr));

assign t_instr = f_instr;

always          //clock
begin
    t_clk = 0;
    forever #5 t_clk = ~t_clk;
end

initial
begin
#100 t_rst=1;
#100 t_rst=0;
end

//initial         //input
//begin
    
//    fp = $fopen("main.mem","r");
    
//    if(fp == 0)
//    begin
//        $display("main.mem does not exist!!!");
//        $finish;
//    end
    
//    while(! ($feof(fp)) )
//    begin
//        $fscanf(fp,"%h\n", f_instr);
//        #50;
//    end
    
//    #100;
//    $display("All Tests Passed");
//    $finish;
//end

endmodule
