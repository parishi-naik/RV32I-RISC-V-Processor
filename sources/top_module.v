`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.12.2021 15:05:05
// Design Name: 
// Module Name: top_module
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

module top_module(
    input clk,
    input rst,
    input [16:0] sw,
    output [16:0] led
    );

wire [31:0] rs1_data, rs2_data, data;

wire [31:0] Instr;

wire [31:0]pc_out,pc_in,pc_out_alu,pc_mux_out;

wire [2:0] func3;
wire [4:0] rs1_addr,rs2_addr,rd_addr;
wire [31:0] dest_address;

wire Branch,MemRead,MemToReg,MemWrite,RegWrite,PCLoad;    

wire [31:0] result,reg_rd;

assign func3 = Instr[14:12];
assign rs1_addr = Instr[19:15];
assign rs2_addr = Instr[24:20];
assign rd_addr = Instr[11:7];

Adder32bit PC_ADD(.ip1(pc_out),
                  .ip2(4),
                  .op(pc_in));

ProgramCounter PC(.clock(clk),
               .rst(rst),
               .pc_load(PCLoad),
               .pc_in(pc_mux_out),
               .pc_out(pc_out));

Mux2x1 M2x1(.ip1(pc_in),
            .ip2(pc_out_alu),
            .sel(Branch),
            .op(pc_mux_out));

imem IMEM(  .clk(clk),
            .addr(pc_out),
	       .data(Instr));
    
ControlUnit CU(.clk(clk),
            .rst(rst),
            .Instr(Instr[6:0]),
            .Branch(Branch),
            .MemRead(MemRead),
            .MemToReg(MemToReg),
            .MemWrite(MemWrite),
            .RegWrite(RegWrite),
            .PCLoad(PCLoad));

riscv_alu ALU(.clk(clk),
              .instruction(Instr),
              .pc_in_alu(pc_out),
              .rs1_data(rs1_data),
              .rs2_data(rs2_data),
              .result(result),
              .dest_address(dest_address),
              .pc_out_alu(pc_out_alu));

riscv_reg REG(.clk(clk), 
              .rd_addr(rd_addr), 
              .func3(func3),
              .rd_data_in(reg_rd), 
              .rs1_addr(rs1_addr), 
              .rs2_addr(rs2_addr), 
              .write_enable(RegWrite), 
              .mem_wr(MemToReg),
              .rs1_data(rs1_data), 
              .rs2_data(rs2_data));

Mux2x1 M2x1_reg(.ip1(result),
                .ip2(data),
                .sel(MemToReg),
                .op(reg_rd));
              
Dmem DMEM(  .clk(clk),
            .datatype(func3 [1:0]),
            .memread(MemRead),
            .memwrite(MemWrite),
            .sw(sw),
            .led(led),
            .addr(dest_address),
            .writedata(result),
            .data(data));

endmodule
